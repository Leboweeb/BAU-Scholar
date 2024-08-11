import json
from channels.generic.websocket import AsyncWebsocketConsumer
from asgiref.sync import sync_to_async
from .models import Conversation, CustomUser, Message


class ChatConsumer(AsyncWebsocketConsumer):

    async def connect(self):
        self.room_name = self.scope["url_route"]["kwargs"]["room_slug"]
        self.room_group_name = f"chat_{self.room_name}"
        await self.channel_layer.group_add(self.room_group_name, self.channel_name)  # type: ignore
        await self.accept()

    @sync_to_async
    def save_message(self, room, user_from, user_to, message):
        user_from = CustomUser.objects.get(id=user_from)
        user_to = CustomUser.objects.get(id=user_to)
        room = Conversation.objects.get(room_slug=room)
        Message.objects.create(
            parent_conversation=room,
            user_from=user_from,
            user_to=user_to,
            message=message,
        )

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(self.room_group_name, self.channel_name)  # type: ignore

    async def receive(self, text_data):
        text_data_json = json.loads(text_data)
        message = text_data_json["message"]
        sender = text_data_json["user_id_from"]
        receiver = text_data_json["user_id_to"]
        room = self.room_name
        # Save the message on recieving
        await self.save_message(room, sender, receiver, message)
        await self.channel_layer.group_send(  # type: ignore
            self.room_group_name,
            {
                "type": "chat_message",
                "message": message,
                "user_id": sender,
            },
        )

    async def chat_message(self, event):
        message = event["message"]
        user_id = event["user_id"]
        message_html = f"<div><p><b>{user_id}</b>: {message}</p></div>"
        await self.send(
            text_data=json.dumps({"message": message_html, "user_id": user_id})
        )
