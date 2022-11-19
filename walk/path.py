import requests 
import json
import re
from json import loads
from geopy.geocoders import Nominatim

# TMAP API 보행자 경로
url = 'https://apis.openapi.sk.com/tmap/routes/pedestrian?version={version}&callback={callback}'
headers = {
    "appkey" : "KEY",
    "version" : "1",
    "callback" : ""
}

# 카카오 API 이용 좌표 얻기
def geoCoding(searching):
    
    coord = [] 
    url = 'https://dapi.kakao.com/v2/local/search/keyword.json?query={}'.format(searching)
    headers = {
        "Authorization": "KakaoAK KEY"
    }
    places = requests.get(url, headers = headers).json()['documents']
    coord.append(places[0]['x'])
    coord.append(places[0]['y'])
    return(coord)


# 길찾기 경로 얻기
def getPath(depart, dest, searchOpt): 
  depart_coor = geoCoding(depart)
  dest_coor = geoCoding(dest)
  searchOption = ['추천', '추천+대로우선', '최단', '최단거리+계단제외'] #순서대로 searchOption 0, 4, 10, 30
  payload = {"startX" : depart_coor[0], "startY" : depart_coor[1], "angle" : 359, "speed" : 60, "endPoiId" : "334852",
              "endX" : dest_coor[0], "endY" : dest_coor[1], "reqCoordType" : "WGS84GEO", 
              "startName" : "%EC%B6%9C%EB%B0%9C", "endName" : "%EB%B3%B8%EC%82%AC", "searchOption" : searchOpt, "resCoordType" : "WGS84GEO"}
  totalCoord, totalDist, totalTime, totalRoad  = [], [], [], []

 
  r = requests.post(url, json=payload, headers=headers)
  json_obj = json.loads(r.text)

  descrip = []
  
  for idx, obj in enumerate(json_obj['features'][1:]):

      if obj['geometry']['type'] == 'Point':
          descrip.append(obj['properties']['description'])

  totalRoad = []
  totalCoord =[]

  for i in range(len(json_obj['features'])):
      if json_obj['features'][i]['geometry']['type']=='LineString' :
          totalRoad.append(json_obj['features'][i]['properties']['roadType'])

      if json_obj['features'][i]['geometry']['type']=='Point' :
          reverse_coordinate=[json_obj['features'][i]['geometry']['coordinates'][1],json_obj['features'][i]['geometry']['coordinates'][0]]
          if reverse_coordinate in totalCoord:
              break
          else:
              totalCoord.append(reverse_coordinate)

      elif json_obj['features'][i]['geometry']['type']=='LineString' :
          for j in range(len(json_obj['features'][i]['geometry']['coordinates'])):
              reverse_coordinate=[json_obj['features'][i]['geometry']['coordinates'][j][1],json_obj['features'][i]['geometry']['coordinates'][j][0]]
              if reverse_coordinate in totalCoord:
                  break
              else:
                  totalCoord.append(reverse_coordinate)
      
  totalDist = str(round(int(json_obj['features'][0]['properties']['totalDistance']) / 1000, 3)) # [km]
  totalTime = str(round(int(json_obj['features'][0]['properties']['totalTime'])/60,2)) # [min]
  totalDist = str(round(int(json_obj['features'][0]['properties']['totalDistance']) / 1000, 3)) # [km]
  totalTime = str(round(int(json_obj['features'][0]['properties']['totalTime']) / 60)) # [min]

  return totalTime, totalDist, totalCoord, descrip[:-1], totalRoad
