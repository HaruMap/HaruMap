from Geo import geoCoding
from avg_slope import getSlope
from roadView import getImage

import requests
import json
import re
from json import loads
from geopy.geocoders import Nominatim

# =============================== 1. 도보 경로 얻기 ===============================

# TMAP 보행자 경로
url = 'https://apis.openapi.sk.com/tmap/routes/pedestrian?version={version}&callback={callback}'
headers = {
    "appkey" : "",
    "version" : "1",
    "callback" : ""
}

# geo_local = Nominatim(user_agent='South Korea') # 도로명 주소 위경도로 변환

depart = input('출발지: ')
dest = input('도착지: ')

depart_coor = geoCoding(depart)
dest_coor = geoCoding(dest)

# searchOption {- 0: 추천 (기본값), - 4: 추천+대로우선, - 10: 최단,  - 30: 최단거리+계단제외}
payload = { "startX" : depart_coor[0],    "startY" : depart_coor[1],    "angle" : 359,    "speed" : 60,    "endPoiId" : "334852",
            "endX" : dest_coor[0],    "endY" : dest_coor[1],    "reqCoordType" : "WGS84GEO",    "startName" : "%EC%B6%9C%EB%B0%9C",
            "endName" : "%EB%B3%B8%EC%82%AC",    "searchOption" : 4,    "resCoordType" : "WGS84GEO"}

# 호출 : request (format = .json)
r = requests.post(url, json=payload, headers=headers)
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

# 소요시간
print(coordi,'\n\n')
print(    
  '------------------------------------------\n',
  # 전체 거리 출력
  "전체 거리 : " + str(round(int(json_obj['features'][0]['properties']['totalDistance']) / 1000, 3)) + ' [km]\n',

  # 전체 소요 시간 출력
  "전체 소요 시간 : " + str(round(int(json_obj['features'][0]['properties']['totalTime']) / 60)) + ' [min]',
  )
  
print('노면 정보 : ', roadtype)
print('전체 경로 좌표 수: ', len(coordi))


# =============================== 2. 전체 경로 경사도 얻기 ===============================
# slope =[]
# for i in range(len(coordi)):
#     slope.append(getSlope(coordi[i][1],coordi[i][0]))
#     #결과(평균 경사도, 경사도 class) 출력
#     #print(result)
# print('전체 경로 경사도 :', slope)


# =============================== 3. 카카오 로드뷰 불러오기 ===============================
i = 0
while 5*i<len(coordi):
    getImage(coordi[5*i][0], coordi[5*i][1])
    i += 1
