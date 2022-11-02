import requests
import numpy as np
import sys
import os
from haversine import haversine

sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))
import API.api

# 반경 내 대중교통 POI 검색
# stationClass : 정류장 종류 (1 : 버스정류장, 2 : 지하철역, 3 : 기차역, 4 : 고속버스터미널, 5 : 공항, 6 : 시외버스터미널, 7 : 항만)
print('== 반경 내 대중교통 POI 검색 ==')

def get_transport_poi(x, y, stationClass):

    # radius = 200 으로 설정함
    url = f'https://api.odsay.com/v1/api/pointSearch?lang=0&x={0}&y={1}&stationClass={2}&radius=200&&apiKey={API.api.get_transport_poi_key()}'.format(x, y, stationClass)
    target = requests.get(url).json()
    print(target)

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

# get_transport_poi('126.9459597', '37.5570497', '1:2')
get_transport_poi('126.94697252670568', '37.56357063812909', '1:2')

print()



# 버스 정류장 코드 : stationName => stationID
print('== 버스 정류장 코드 ==')

def get_station_id(stationName):

    url = f'https://api.odsay.com/v1/api/searchStation?lang=0&stationName={0}&&apiKey={API.api.get_station_id_key()}'.format(stationName)
    print(requests.get(url).json())

get_station_id('이대부고')

print()



# 실시간 버스 도착정보 (특정 정류장의 운행 버스 도착정보를 리턴)
# stationID : 버스 정류장 코드
# lowBus : 저상버스 필터링 (0 : 전체 버스, 1 : 저상버스만)
print('== 실시간 버스 도착정보 ==')

def get_bus_wt(stationID, lowBus):

    url = f'https://api.odsay.com/v1/api/realtimeStation?lang=0&stationID={0}&lowBus={1}&apiKey={API.api.get_bus_wt_key()}'.format(stationID, lowBus)
    print(requests.get(url).json())

get_bus_wt('102155', '0')

print()



# 출발지, 도착지 위경도 기반 대중교통 경로 확인
# -> 버스 이동 시간 (경로에서 확인)
# SearchPathType : 도시 내 경로수단 지정 (0 : 모두, 1 : 지하철, 2 : 버스)
# 총 소요 시간은 나오지만 각 구간 별 시간은 제공하지 않음
print('== 출발지, 도착지 위경도 기반 대중교통 경로 확인 ==')

def path_transport(SX, SY, EX, EY):

    url = f'https://api.odsay.com/v1/api/searchPubTransPathT?SX={0}&SY={1}&EX={2}&EY={3}&apiKey={API.api.path_transport_key()}'.format(SX, SY, EX, EY)
    print(requests.get(url).json())

path_transport('126.9018223', '37.5339457', '126.9429', '37.55813')