from Geo import geoCoding
from avg_slope import getSlope
from roadView import getImage

import requests
import json
import re
from json import loads
from geopy.geocoders import Nominatim
from YOLOv3 import Yolo

# =============================== 1. 도보 경로 얻기 ===============================

# TMAP 보행자 경로
url = 'https://apis.openapi.sk.com/tmap/routes/pedestrian?version={version}&callback={callback}'
headers = {
    "appkey" : "APP KEY",
    "version" : "1",
    "callback" : ""
}

depart = input('출발지: ')
dest = input('도착지: ')

depart_coor = geoCoding(depart)
dest_coor = geoCoding(dest)

searchOption = ['추천', '추천+대로우선', '최단', '최단거리+계단제외']
payload = [{"startX" : depart_coor[0], "startY" : depart_coor[1], "angle" : 359, "speed" : 60, "endPoiId" : "334852",
            "endX" : dest_coor[0], "endY" : dest_coor[1], "reqCoordType" : "WGS84GEO", 
            "startName" : "%EC%B6%9C%EB%B0%9C", "endName" : "%EB%B3%B8%EC%82%AC", "searchOption" : 0, "resCoordType" : "WGS84GEO"}, 
           {"startX" : depart_coor[0], "startY" : depart_coor[1], "angle" : 359, "speed" : 60, "endPoiId" : "334852",
            "endX" : dest_coor[0], "endY" : dest_coor[1], "reqCoordType" : "WGS84GEO", 
            "startName" : "%EC%B6%9C%EB%B0%9C", "endName" : "%EB%B3%B8%EC%82%AC", "searchOption" : 4, "resCoordType" : "WGS84GEO"}, 
           {"startX" : depart_coor[0], "startY" : depart_coor[1], "angle" : 359, "speed" : 60, "endPoiId" : "334852",
            "endX" : dest_coor[0], "endY" : dest_coor[1], "reqCoordType" : "WGS84GEO", 
            "startName" : "%EC%B6%9C%EB%B0%9C", "endName" : "%EB%B3%B8%EC%82%AC", "searchOption" : 10, "resCoordType" : "WGS84GEO"}, 
           {"startX" : depart_coor[0], "startY" : depart_coor[1], "angle" : 359, "speed" : 60, "endPoiId" : "334852",
            "endX" : dest_coor[0], "endY" : dest_coor[1], "reqCoordType" : "WGS84GEO", 
            "startName" : "%EC%B6%9C%EB%B0%9C", "endName" : "%EB%B3%B8%EC%82%AC", "searchOption" : 30, "resCoordType" : "WGS84GEO"}]

# 호출 : request (format = .json)
totalCoord, totalDist, totalTime, totalRoad  = [], [], [], []

for k in range(4):
  r = requests.post(url, json=payload[k], headers=headers)
  json_obj = json.loads(r.text)
  roadtype = []
  for i in range(len(json_obj['features'])):
    if json_obj['features'][i]['geometry']['type']=='LineString' :
      roadtype.append(json_obj['features'][i]['properties']['roadType'])

    coordi=[]
    json_obj['features'][i]['geometry']['coordinates']
    for i in range(len(json_obj['features'])):
      change_coordinate=[]
      if json_obj['features'][i]['geometry']['type']=='Point' :
        reverse_coordinate=[json_obj['features'][i]['geometry']['coordinates'][1],json_obj['features'][i]['geometry']['coordinates'][0]]
        coordi.append(reverse_coordinate)

      if json_obj['features'][i]['geometry']['type']=='LineString' :
        for j in range(len(json_obj['features'][i]['geometry']['coordinates'])):
          reverse_coordinate=[json_obj['features'][i]['geometry']['coordinates'][j][1],json_obj['features'][i]['geometry']['coordinates'][j][0]]
          coordi.append(reverse_coordinate)
    
    totalCoord.append(coordi)
    totalDist.append(str(round(int(json_obj['features'][0]['properties']['totalDistance']) / 1000, 3)))
    totalTime.append(str(round(int(json_obj['features'][0]['properties']['totalTime']) / 60)))
    totalRoad.append(roadtype)

# 최종 결과
for i in range(4):
  print('================ ', searchOption[i], ' 경로 ================')
  print('전체 거리: ', totalDist[i], 'km')
  print('전체 소요시간: ', totalTime[i],'min')
  print('전체 노면 정보: ', totalRoad[i])
  print('전체 좌표: ', totalCoord[i],'\n')


# =============================== 2. 전체 경로 경사도 얻기 ===============================
totalSlope = []
for j in range(4):
  slope = []
  for i in range(len(totalCoord[j])):
    coor = totalCoord[k]
    slope.append(getSlope(coor[i][1],coor[i][0]))
  totalSlope.append(slope)
  print(searchOption[j], ' 경사도 :', totalSlope[j])


# =============================== 3. 카카오 로드뷰 불러오기 ===============================
coor = totalCoord[3] #최단거리+계단제외 경로만
Image = [] #이미지 저장
i = 0
while 5*i<len(coor): #전체 로드 x 5좌표당 1개씩 
    Image.append(getImage(coor[5*i][0], coor[5*i][1]))
    i += 1
print('\n')
print(Image)


# =============================== 4. Object Detection ===============================
totalObs = 0
for i in range(len(Image)):
  url = Image[i]
  for j in range(len(url)):
    totalObs += Yolo(url[j])

print("경로에서 마주치는 총 장애물 개수: ", totalObs)