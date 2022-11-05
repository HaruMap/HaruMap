import requests
import json
import sys
import os

sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))
import API.api

# 공공데이터 포털 버스 혼잡도 API
def bus_congestion(stId):

    url = 'http://ws.bus.go.kr/api/rest/arrive/getLowArrInfoByStId'
    params = {'serviceKey' : '{0}'.format(API.api.bus_congestion_key()), 'stId' : f'{stId}'}

    response = requests.get(url, params=params)
    print(response.content)

# bus_congestion(100000001)