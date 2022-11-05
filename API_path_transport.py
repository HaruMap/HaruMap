from haversine import haversine
import requests
import numpy as np
import sys
import os

sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))
import API.api

# 사용자 위치 키워드 검색 (예 : 이대부고) -> 사용자 선택 -> 해당 지역 위경도 받아오기
# 사용자 현위치 검색 -> 위경도 받아오기

# 출발지, 도착지 위경도 기반 대중교통 경로 확인

# -> 버스 이동 시간 (경로에서 확인)
# SearchPathType : 도시 내 경로수단 지정 (0 : 모두, 1 : 지하철, 2 : 버스)
# 총 소요 시간은 나오지만 각 구간 별 시간은 제공하지 않음

def path_transport(SX, SY, EX, EY):

    url = 'https://api.odsay.com/v1/api/searchPubTransPathT?SX={0}&SY={1}&EX={2}&EY={3}&apiKey={4}'.format(SX, SY, EX, EY, API.api.path_transport_key())
    
    return requests.get(url).json()

# print(path_transport('126.94687065007022', '37.5635841072725', '126.92382953492177', '37.52679721577862')['result']['path'][0])