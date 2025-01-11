import json
from channels.generic.websocket import AsyncWebsocketConsumer
from asgiref.sync import sync_to_async
from django.shortcuts import get_object_or_404
from django.template.loader import render_to_string
from background_task import background
from scholarapp.utils.common import send_email_notification
from datetime import datetime, timezone
from .models import Conversation, CustomUser, Message


class ChatConsumer(AsyncWebsocketConsumer):

    @sync_to_async
    def get_user_avatar(self, user_id: int):
        user = get_object_or_404(CustomUser, id=user_id)
        return user.avatar

    async def connect(self):
        self.room_name = self.scope["url_route"]["kwargs"]["room_slug"]
        self.room_group_name = f"chat_{self.room_name}"
        await self.channel_layer.group_add(self.room_group_name, self.channel_name)  # type: ignore
        await self.accept()

    @sync_to_async
    def save_message(self, room, user_from, message):
        user_from = CustomUser.objects.get(id=user_from)
        room = Conversation.objects.get(room_slug=room)
        Message.objects.create(
            parent_conversation=room,
            user_from=user_from,
            message=message,
        )

    @sync_to_async
    def send_email_to_users(self, sender_id: int, message: str):
        room = Conversation.objects.get(room_slug=self.room_name)
        last_message = room.message_set.latest("time_sent")  # type: ignore
        diff = datetime.now(timezone.utc) - last_message.time_sent
        minute_diff = int(diff.total_seconds()) // 60
        if minute_diff > 5:
            inactive_users = [
                user for user in room.users.all() if not user.profile.online()
            ]

            sender_user_instance = CustomUser.objects.get(id=sender_id)
            for user in inactive_users:
                send_email_notification(
                    sender_user_instance.name, user.name, message, room.title
                )

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(self.room_group_name, self.channel_name)  # type: ignore

    async def receive(self, text_data):
        text_data_json = json.loads(text_data)
        message = text_data_json["message"]
        sender = text_data_json["user_id_from"]
        room = self.room_name
        # Save the message on recieving
        await self.save_message(room, sender, message)
        # send inactive users emails about chats
        await self.send_email_to_users(sender, message)
        await self.channel_layer.group_send(  # type: ignore
            self.room_group_name,
            {
                "type": "chat_message",
                "message": message,
                "user_id": sender,
            },
        )

    @sync_to_async
    def prepare_message(self, message: str, user_id: int):
        return render_to_string(
            "components/chat_message.html",
            context={"message": message, "user_id": user_id, "is_user_message": False},
        )

    async def chat_message(self, event):
        message = event["message"]
        user_id = event["user_id"]
        message_html = await self.prepare_message(message, user_id)
        await self.send(
            text_data=json.dumps({"message": message_html, "user_id": user_id})
        )
