from django.shortcuts import render

# Create your views here.
from rest_framework.response import Response
from rest_framework.decorators import api_view
from .models import Quiz
from .serializers import QuizSerializer, PathDetail,PathDetailSerializer
import random

# Create your views here.

@api_view(['GET'])
def helloAPI(request):
    path = PathDetail(20,10,["a","b"])
    path2 = PathDetail(120,10,["a","b"])
    for i in [path,path2]:
        serializer = PathDetailSerializer(i)
    print(serializer.data)
    return Response(serializer.data)

@api_view(['GET'])
def randomQuiz(request, id):
    totalQuizs = Quiz.objects.all()
    randomQuizs = random.sample(list(totalQuizs), id)
    QuizSerializer()
    serializer = QuizSerializer(randomQuizs, many=True) #many 부분을 통해 다량의 데이터도 직렬화 진행
    return Response(serializer.data)