import json
from channels.generic.websocket import AsyncWebsocketConsumer
from asgiref.sync import sync_to_async
from .models import Conversation, Message


class ChatConsumer(AsyncWebsocketConsumer):

    async def connect(self):
        self.room_name = self.scope["url_route"]["kwargs"]["room_slug"]
        self.room_group_name = f"chat_{self.room_name}"
        self.user = self.scope["user"]

        await self.channel_layer.group_add(self.room_group_name, self.channel_name)  # type: ignore
        await self.accept()

    @sync_to_async
    def save_message(self, room, user, message):
        room = Conversation.objects.get(room_slug=room)
        Message.objects.create(room=room, user=user, message=message)

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(self.room_group_name, self.channel_name)  # type: ignore

    async def receive(self, text_data):
        text_data_json = json.loads(text_data)
        message = text_data_json["message"]
        user = self.user
        username = user.name
        room = self.room_name

        # Save the message on recieving
        await self.save_message(room, user, message)

        await self.channel_layer.group_send(  # type: ignore
            self.room_group_name,
            {
                "type": "chat_message",
                "message": message,
                "username": username,
            },
        )

    async def chat_message(self, event):
        message = event["message"]
        username = event["username"]
        message_html = f"<div hx-swap-oob='beforeend:#messages'><p><b>{username}</b>: {message}</p></div>"
        await self.send(
            text_data=json.dumps({"message": message_html, "username": username})
        )
