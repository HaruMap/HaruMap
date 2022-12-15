import requests
import json
import sys
import os

sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))
import API.api

# 서울시 역코드로 지하철역별 열차 시간표 정보 검색
# https://data.seoul.go.kr/dataList/OA-101/A/1/datasetView.do
# 외부코드를 역코드로 바꿔야함..! 예) 광화문: 533 -> 2534

import requests
import pandas as pd
import math
from datetime import timedelta
from datetime import datetime
from pandasql import sqldf

# station_cd: 역코드
# today: 평일:1, 토요일:2, 휴일/일요일:3
# updown: 상행,내선:1, 하행,외선:2
# current: 시간

# today = datetime.datetime.now()
# current = today.strftime("%X")
# today = is_holiday(today)
# sub_schedule(1007, today, 2, current)

def sub_schedule(station_cd, today, updown, current):

    if len(str(station_cd))==3:
        station_cd = '0'+str(station_cd)
    API_KEY = API.api.get_sub_schedule_key()
    url = f"http://openapi.seoul.go.kr:8088/{API_KEY}/json/SearchSTNTimeTableByIDService/1/2/{station_cd}/{today}/{updown}/"
    re = requests.get(url)
    rjson = re.json()
    total_num = int(rjson['SearchSTNTimeTableByIDService']['list_total_count'])
    total_num

    station_nm = []
    arrivetime = []
    lefttime = []
    subwaysname = []
    subwayename = []

    for i in range(1, math.ceil(total_num/1000)+1):
        end = i*1000
        start = end-1000+1

        if end > total_num:
            end = total_num
        
        url = f"http://openapi.seoul.go.kr:8088/{API_KEY}/json/SearchSTNTimeTableByIDService/{start}/{end}/{station_cd}/{today}/{updown}/"
        re = requests.get(url)
        rjson = re.json()

        for u in rjson['SearchSTNTimeTableByIDService']['row']:
            station_nm.append(u['STATION_NM'])
            arrivetime.append(u['ARRIVETIME'])
            lefttime.append(u['LEFTTIME'])
            subwaysname.append(u['SUBWAYSNAME'])
            subwayename.append(u['SUBWAYENAME'])

        df = pd.DataFrame({'도착시간': arrivetime})

        sql = f"select * from df where 도착시간>'{current}'"
        print(sql)

        df = sqldf(sql)

    for i in range(len(df)):
        ttttt = df['도착시간'][i]
        ttttt = ttttt.split(":")
        Hhour = ttttt[0]
        Mminute = ttttt[1]
        Ssecond = ttttt[-1]
        hour = '00'
        if Hhour == '24':
            ttttt = hour + ":" + Mminute + ":" + Ssecond
        else: ttttt = Hhour + ":" + Mminute + ":" + Ssecond
        df['도착시간'][i] = ttttt

    for i in range(len(df)):
        df['도착시간'][i] = datetime.datetime.strptime(df['도착시간'][i], '%H:%M:%S')
        df['도착시간'][i] = df['도착시간'][i].strftime("%X")
    

    return df