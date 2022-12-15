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

result = []
sort_path = {}
@api_view(['GET'])
def getPathes(request):
    dep_lat = request.GET['deplat']
    dep_lng = request.GET['deplng']
    arrv_lat = request.GET['arrvlat']
    arrv_lng = request.GET['arrvlng']
    user = request.GET['user']
    opt_sort = request.GET['orders']

    print('start.')
    print(dep_lat, dep_lng, arrv_lat, arrv_lng)
    print()

    result= main.main(dep_lng, dep_lat, arrv_lng, arrv_lat,user, opt_sort)
    print(result)
    sort_path = result[1]
    path1 = PathDetail([result[0]])

    serial = PathDetailSerializer(path1)

    return Response(serial.data)


