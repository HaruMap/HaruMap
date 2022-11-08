from django.shortcuts import render, redirect
from rest_framework.views import APIView
# Create your views here.
from rest_framework.response import Response
from rest_framework.decorators import api_view
from .serializers import PathDetail,PathDetailSerializer
import random
from urllib.parse import quote

# Create your views here.


@api_view(['GET'])
def getPathes(request):
    totaldescription = ['도보 1: 100','버스 1: 7','도보 2: 11','지하철 1: 29 3','도보 3: 15']
    description = ['도보: null, 좌회전,111m,10,보행자도로를 따라', '도보: null, 우회전, 67m, 8, 보행자도로를 따라', '도보: null, 우회전, 66m, 8, 보행자도로를 따라','도보: null, 좌회전, 20m, 5, 보행자도로를 따라', '도보: null, 우회전, 10m, 3, 보행자도로를 따라', '도보: null, 좌회전, 22m, 6, 보행자도로를 따라',
         '도보: 이화여자대학교 인문관, 우회전, 41m 7,보행자도로를 따라', '도보: null, 좌회전, 33m, 7, 보행자도로를 따라', '도보: null, 우회전, 190m, 20, null', '도보: null, 좌측 횡단보도, null, null, null','도보: null, 직진, 9m, 3, null',
      '도보: null, 직진, 22m, 6, null', '도보: null, 횡단보도, null, null, null' ,
      '도보: null, 직진, 5m, 1, 보행자 도로를 따라', '도보: null, 직진, 172m 15, null', 
      "버스: 이대부고 정류소, 서울경찰청.경복궁역 정류소, 7, (2: 사직단/서울경찰청.경복궁), ['272',5,혼잡 / '606',3, 여유]", 
      '도보: null, 직진, 233m, 11,null', 
      '지하철: 경복궁역, 양재역, x, 29, 수서행, 3, (3-3/7-4), (5/4), (15: 안국/종로3가/을지로3가/충무로/동대입구/약수/금호/옥수/압구정/신사/잠원/고속터미널/교대/남부터미널/양재)', 
      '도보: null, 직진, 319m,15, null']
    #dict로 그냥 보내면 어플에서 못받아옴 => dict 감싸는 list를 보내야함 
    # => json 형식: pathdetail: [
      # {totaltime: ~~~, 
      # totaldescription: ~~, ~~~}
      # {totaltime: ~~~,
      # totaldescription: ~~~~~ }
    # ]
    path1 = PathDetail([{"totaltime": 70, "totaldescription":totaldescription,"description":description,"score":100}])


    #쿼리 받아오는거 => runserver했을때 url: http://localhost:8000/haruapp/getPathes?deplat=38.7&deplng=127.5&arrvlat=37.8&arrvlng=128.5 
    dep_lat = request.GET['deplat']
    dep_lng = request.GET['deplng']
    arrv_lat = request.GET['arrvlat']
    arrv_lng = request.GET['arrvlng']
    print(dep_lat,dep_lng,arrv_lat,arrv_lng)

    serial = PathDetailSerializer(path1)

    return Response(serial.data)


        

