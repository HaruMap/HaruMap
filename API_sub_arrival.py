import requests
import sys
import os

sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))
import API.api

# 실시간 지하철 도착정보 (특정 지하철 역의 지하철 도착정보를 리턴)
# stationName : 지하철 역 이름

# print('== 실시간 지하철 도착정보 ==')

def get_sub_real_time(stationName):

    station = stationName

    url = "http://swopenAPI.seoul.go.kr/api/subway/{0}/json/realtimeStationArrival/0/100/{1}".format(API.api.get_sub_real_time_key(),str(station))

    print(url)
    
    return requests.get(url).json()