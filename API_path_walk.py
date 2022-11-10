# T Map API 보행자 경로 안내

import requests
import json
import re

from json import loads
from geopy.geocoders import Nominatim

import sys
import os

sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))
import API.api

def path_walk(walk_sx, walk_sy, walk_ex, walk_ey, op):
    
    # url
    url = 'https://apis.openapi.sk.com/tmap/routes/pedestrian?version={version}&callback={callback}' # 보행자 경로 안내 url

    # 요청 : headers = 요청을 위한 필수값 입력
    headers = {
        "appkey" : '{0}'.format(API.api.path_walk_key()),
        "version" : "1",
        "callback" : ""
    }

    # 요청 : payload = 출발지, 경유지에 대한 정보 입력
    payload = {
        
        # 출발지
        "startX" : walk_sx, # 126.94693854866031, # 예 - 이화 포스코관
        "startY" : walk_sy, # 37.563602157733705,
        "angle" : 359,
        "speed" : 60,

        # 도착지
        # "endPoiId" : "334852",
        "endX" : walk_ex, # 126.94589082871869, # 예 - 이대역
        "endY" : walk_ey, # 37.55681717620876,

        # 경유지
        # passList : 126.92774822,37.55395475 # : 경유지

        # 그 외 파라미터
        "reqCoordType" : "WGS84GEO",
        "startName" : "%EC%B6%9C%EB%B0%9C",
        "endName" : "%EB%B3%B8%EC%82%AC",
        "searchOption" : op, # 30, # 경로 탐색 옵션 (예 : 30 = 최단 + 계단 제외)
        "resCoordType" : "WGS84GEO" # 위경도로 return 
    }

    # 호출 : request (format = .json)
    r = requests.post(url, json=payload, headers=headers)
    json_obj = json.loads(r.text)

    # print(json_obj['features'])
    
    # type = total : totalDistance, totalTime
    # type = LineString : coordinates, description, distance, time, roadType
    # type = Point : coordinates, description
    coor = []
    descrip = []
    d = 0
    t = 0
    roadType = []

    # print(json_obj)

    for idx, obj in enumerate(json_obj['features'][1:]):

        # print(obj)

        if obj['geometry']['type'] == 'Point':
            
            x = obj['geometry']['coordinates'][0]
            y = obj['geometry']['coordinates'][1]
            coor.append((3, x, y))

            descrip.append(obj['properties']['description'])

        elif obj['geometry']['type'] == 'LineString':
            
            for xy in obj['geometry']['coordinates']:
                x = xy[0]
                y = xy[1]
                coor.append((3, x, y))
            
            d += int(obj['properties']['distance'])
            t += int(obj['properties']['time'])
            roadType.append(obj['properties']['roadType'])

    # 총 도보 이동시간 & 이동거리
    '''
    print(json_obj['features'][0]['properties']['totalDistance']) # = d
    print(json_obj['features'][0]['properties']['totalTime']) # = t
    print()

    # 도보 이동 경로 정보
    print(len(coor))
    print(coor)
    print()
    print(len(descrip))
    print(descrip)
    print()
    # print(d) # = totalDistance
    # print(t) # = totalTime
    # print()
    print(len(roadType))
    print(roadType)
    '''

    # print(coor)

    return t, d, coor, descrip[:-1], roadType

# path_walk(126.94693854866031, 37.563602157733705, 126.94589082871869, 37.55681717620876, 30)