from rest_framework import serializers
from .models import Quiz

class PathDetail:
    def __init__(self,totaltime, totalwalk,description):
        self.totaltime = totaltime
        self.totalwalk = totalwalk
        self.description = description


class QuizSerializer(serializers.ModelSerializer):
    class Meta:
        model = Quiz
        fields =  '__all__'

class PathDetailSerializer(serializers.Serializer):
    totaltime = serializers.IntegerField()
    totalwalk = serializers.IntegerField()
    description = serializers.ListField()