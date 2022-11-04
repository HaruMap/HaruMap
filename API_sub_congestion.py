import requests
import json
import sys
import os

sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))
import API.api

# SKopenAPI 지하철 혼잡도
# stationCode: 역사코드
# dow: 요일
# hh: 시간
# updn: 상행/내선:0 or 하행/외선:1
# mm: 분 (10분 단위)

def sub_congestion(stationCode, dow, hh, updn, mm):

    url = "https://apis.openapi.sk.com/puzzle/congestion-car/stat/stations/"+str(stationCode)+"?dow="+str(dow)+"&hh="+str(hh)

    headers = {
        "accept": "application/json",
        "appkey": API.api.sub_congestion_key()
    }

    response = requests.get(url, headers=headers)

    r_dict = json.loads(response.text)
    r_contents = r_dict.get("contents")

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

    return fin_avg