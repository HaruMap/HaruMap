from haversine import haversine
import requests
import numpy as np
import sys
import os

sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))
from fromAPI.API import api

def get_transport_poi(x, y, stationClass):

    # radius = 200 으로 설정함
    url = 'https://api.odsay.com/v1/api/pointSearch?lang=0&x={0}&y={1}&stationClass={2}&radius=200&&apiKey={3}'.format(x, y, stationClass, api.get_transport_poi_key())
    target = requests.get(url).json()
    # print(target)

    station_id_list = []
    station_name_list = []
    distance_list = []

    # 가장 가까운 정류장 순으로 반환
    for idx in range(target['result']['count']):
        
        # 사용자 위치 기반 거리 계산 (위경도 기반, 참고 : https://gaussian37.github.io/python-etc-%EC%9C%84%EB%8F%84,%EA%B2%BD%EB%8F%84-%EA%B0%84-%EA%B1%B0%EB%A6%AC/)
        user_x = x
        user_y = y
        station_x = target['result']['station'][idx]['x']
        station_y = target['result']['station'][idx]['y']
        user = (float(user_y), float(user_x))
        station = (float(station_y), float(station_x))
        distance = haversine(user, station)

        station_id_list.append(target['result']['station'][idx]['stationID'])
        station_name_list.append(target['result']['station'][idx]['stationName'])
        distance_list.append(distance)

    # sort (추후 도로 기반 거리로 변경할 수 있으면 하기)
    distance_list_sorted = np.sort(distance_list)
    distance_list_idx = np.argsort(distance_list)
    # print(distance_list_idx)
    station_id_list_sorted = [station_id_list[i] for i in distance_list_idx]
    station_name_list_sorted = [station_name_list[i] for i in distance_list_idx]

    return list(set(station_name_list_sorted))

# get_transport_poi('126.9459597', '37.5570497', '1:2')
# print(get_transport_poi('126.94697252670568', '37.56357063812909', '1:2'))