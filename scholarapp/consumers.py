from channels.generic.websocket import WebsocketConsumer
from asgiref.sync import async_to_sync


class ChatConsumer(WebsocketConsumer):
    def connect(self):
        self.accept()

    def disconnect(self, close_code):
        print("Closing...")
        pass

    def receive(self, text_data):
        self.send(text_data=text_data)
