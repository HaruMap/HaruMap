import requests
import sys
import os

sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))
from fromAPI.API import api

# 실시간 버스 도착정보 (특정 정류장의 운행 버스 도착정보를 리턴)
# stationID : 버스 정류장 코드
# lowBus : 저상버스 필터링 (0 : 전체 버스, 1 : 저상버스만)

# print('== 실시간 버스 도착정보 ==')

def get_bus_real_time(stationID, lowBus):

    url = 'https://api.odsay.com/v1/api/realtimeStation?lang=0&stationID={0}&lowBus={1}&apiKey={2}'.format(stationID, lowBus, api.get_bus_real_time_key())
    
    return requests.get(url).json()

# print(get_bus_real_time(102155, 0)['result']['real'])