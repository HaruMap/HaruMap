from django.shortcuts import render, redirect
# from rest_framework.views import APIView
# Create your views here.
from rest_framework.response import Response
from rest_framework.decorators import api_view
from .serializers import PathDetail,PathDetailSerializer
import random
from urllib.parse import quote

import main

# Create your views here.


@api_view(['GET'])
def getPathes(request):

    # 쿼리 받아오는거 => runserver했을때 url: http://localhost:8000/haruapp/getPathes?deplat=38.7&deplng=127.5&arrvlat=37.8&arrvlng=128.5

    dep_lat = request.GET['deplat']
    dep_lng = request.GET['deplng']
    arrv_lat = request.GET['arrvlat']
    arrv_lng = request.GET['arrvlng']

    print(dep_lat, dep_lng, arrv_lat, arrv_lng)

    result = main.main(dep_lng, dep_lat, arrv_lng, arrv_lat)
    path1 = PathDetail([result])

    serial = PathDetailSerializer(path1)

    return Response(serial.data)


        

