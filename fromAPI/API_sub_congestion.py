import requests
import json
import sys
import os

sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))
from fromAPI.API import api

# SKopenAPI 지하철 혼잡도
# station_id: 역사코드
# dow: 요일
# hh: 시간
# updown: 1 : 상행, 2: 하행
# updn: 상행/내선 : 0 or 하행/외선 : 1
# mm: 분 (10분 단위)

# input: sub_congestion(555, 'MON', 7, 1, 48) # 광화문
# output: [3, 9, 18, 10, 7, 10, 7, 3]

def sub_congestion(station_id, dow, hh, updown, mm):
    stationCode = station_id
    mm = 10*(mm // 10)
    updn = updown
    if mm == 0:
        mm = '00'
    
    if hh == 5:
        hh = '05'
    elif hh == 6:
        hh = '06'
    elif hh == 7:
        hh = '07'
    elif hh == 8:
        hh = '08'
    elif hh == 9:
        hh = '09'

    url = "https://apis.openapi.sk.com/puzzle/congestion-car/stat/stations/"+str(stationCode)+"?dow="+str(dow)+"&hh="+str(hh)

    headers = {
        "accept": "application/json",
        "appkey": api.sub_congestion_key()
    }

    response = requests.get(url, headers=headers)

    r_dict = json.loads(response.text)
    r_contents = r_dict.get("contents")
    
    # 현재 지하철이 운행하지 않을 경우 (혼잡도 정보가 없을 경우) -> return [0]
    if r_contents == None:
        return [0]

    r_rrr = []
    r_stat = r_contents['stat']
    new_5 = []
    new_5 = list(
    filter(lambda x: x.get('updnLine') == int(updn), r_stat)
    )

    for i in range(len(new_5)):
        r_rrr.append(new_5[i].get('data'))
    

    r_kkk = []
    r_pp = []

    for i in range(len(r_rrr)):
        r_kkk = list(
        filter(lambda x: x.get('mm') == str(mm), r_rrr[i])
        )
        for i in range(len(r_kkk)):
            r_pp.append(r_kkk[i].get('congestionCar'))


    r_pt = []

    subcan = len(r_pp[0])
    dell = [0 for i in range(subcan)]
    dell
    for i in range(len(r_pp)):
        if r_pp[i] != dell:
            r_pt.append(r_pp[i])

    fin_avg = [0 for _ in range(len(r_pt[0]))]

    for i in range(len(r_pt)):
        for j in range(len(r_pt[0])):
            fin_avg[j] += r_pt[i][j]

    for i in range(len(fin_avg)):
        fin_avg[i] = int(fin_avg[i] / len(r_pt))

    return fin_avg # 지하철 칸 혼잡도 리스트 (grading X)