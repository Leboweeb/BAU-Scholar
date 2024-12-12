from rest_framework import serializers


class ImportUserSerializer(serializers.Serializer):
    name = serializers.CharField()
    backend = serializers.CharField()
