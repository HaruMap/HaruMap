import os
import sys
import requests
from bs4 import BeautifulSoup
import time

sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))
sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))))


def getConBus_DT(arsId, busType): #시내 버스 busType = 1
    client_id = '8e058fc8-c48c-4450-b7e1-bfc5b6558f70'
    client_secret = '4764122a-4e57-4954-ad7f-2706a3100d44'
    con_url = 'https://apigw.tmoney.co.kr:5556/gateway/saStationByArsIdGet/v1/stationinfo/getStationByUidCon?serviceKey=01234567890&arsId={0}&busRouteType={1}'.format(arsId, busType)
    headers = {
        "Accept": "application/xml",
        "Authorization": 'APIKEY',
        "x-Gateway-APIKey": "APIKEY",
        "Content-Type": 'application/x-www-form-urlencoded',
        "client_id": client_id,
        'client_secret': client_secret,
        "grant_type": "client_credentials"
    }
    
    cong = requests.get(con_url, headers = headers)

    return cong.text


def getConBus_T(arsId, busType): #마을 버스 busType = 2
    client_id = 'f1bb0c84-f119-4aa1-b6d4-e5639ea42fb5'
    client_secret = '961aa817-7c0c-4e50-be9b-635abc9b00d4'
    con_url = 'https://apigw.tmoney.co.kr:5556/gateway/szStationByArsIdGet/v1/stationinfo/getStationByUidCon?serviceKey=01234567890&arsId={0}&busRouteType={1}'.format(arsId, busType)
    headers = {
        "Accept": "application/xml",
        "Authorization": 'APIKEY',
        "x-Gateway-APIKey": "APIKEY",
        "Content-Type": 'application/x-www-form-urlencoded',
        "client_id": client_id,
        'client_secret': client_secret,
        "grant_type": "client_credentials"
    }
    
    cong = requests.get(con_url, headers = headers)

    return cong.text


def busCon_result(arsId):
    cong_DT_text=getConBus_DT(arsId, '1')
    cong_T_text=getConBus_T(arsId, '2')
    xml_DT_cong = BeautifulSoup(cong_DT_text, "xml")
    xml_T_cong = BeautifulSoup(cong_T_text, "xml")
    bus_DT_list = xml_DT_cong.find_all("itemList")
    bus_T_list = xml_T_cong.find_all("itemList")
    bus_list = bus_DT_list + bus_T_list
    #print(bus_list)
    bus_con_list = [arsId]
    bus_con_list.append(bus_list[0].find('stNm').text)
    for i in range(len(bus_list)):
        try:
            div1 = int(bus_list[i].find('rerdie_Div1').text)
            div2 = int(bus_list[i].find('rerdie_Div2').text)
            bus1_num = int(bus_list[i].find('reride_Num1').text)
            bus2_num = int(bus_list[i].find('reride_Num2').text)
            list_part = [bus_list[i].find('rtNm').text, div1, bus1_num, div2, bus2_num]
            bus_con_list.append(list_part)
        except:
            pass
    
    return bus_con_list


def getBusCon_all(arsId):
    bus_list = busCon_result(arsId)
    bs_arsId = bus_list[0]  #정류소 고유번호(str)
    bs_name = bus_list[1]   #정류소 명(str)
    print('<', bs_arsId,'-', bs_name,'>')
    for i in range(len(bus_list)-2):
        bus_name = bus_list[i+2][0]
        div1 = bus_list[i+2][1]
        con1 = bus_list[i+2][2]
        div2 = bus_list[i+2][3]
        con2 = bus_list[i+2][4]
        print(bus_name)
        if div1 == 0:
            print('첫번째 버스: 정보미제공')
        elif div1 == 1 or div1 == 2:
            print('첫번째 버스 승차인원:', con1, '명')
        elif div1 == 3:
            print('첫번째 버스: 만차')
        else:
            if con1 == 3:
                bus1_con = '여유'
            elif con1 ==4:
                bus1_con = '보통'
            elif con1 == 5:
                bus1_con = '혼잡'
            print('첫번째 버스 혼잡도:', bus1_con)

        if div2 == 0:
            print('두번째 버스: 정보미제공')
        elif div2 == 1 or div2 == 2:
            print('두번째 버스 승차인원:', con2, '명')
        elif div2 == 3:
            print('두번째 버스: 만차')
        else:
            if con2 == 3:
                bus2_con = '여유'
            elif con2 ==4:
                bus2_con = '보통'
            elif con2 == 5:
                bus2_con = '혼잡'
            print('두번째 버스 혼잡도:', bus2_con)


def getBusCon_cb(arsId, bus_name):
    bus_list = busCon_result(arsId)
    bs_arsId = bus_list[0]  #정류소 고유번호(str)
    bs_name = bus_list[1]   #정류소 명(str)
    print('<', bs_arsId,'-', bs_name,'>')
    print(bus_name)
    for i in range(len(bus_list)-2):
        if bus_name in bus_list[i+2][0]:
            div1 = bus_list[i+2][1]
            con1 = bus_list[i+2][2]
            div2 = bus_list[i+2][3]
            con2 = bus_list[i+2][4]

            if div1 == 0:
                print('첫번째 버스: 정보미제공')
            elif div1 == 1 or div1 == 2:
                print('첫번째 버스 승차인원:', con1, '명')
            elif div1 == 3:
                print('첫번째 버스: 만차')
            else:
                if con1 == 3:
                    bus1_con = '여유'
                elif con1 ==4:
                    bus1_con = '보통'
                elif con1 == 5:
                    bus1_con = '혼잡'
                print('첫번째 버스 혼잡도:', bus1_con)

            if div2 == 0:
                print('두번째 버스: 정보미제공')
            elif div2 == 1 or div2 == 2:
                print('두번째 버스 승차인원:', con2, '명')
            elif div2 == 3:
                print('두번째 버스: 만차')
            else:
                if con2 == 3:
                    bus2_con = '여유'
                elif con2 ==4:
                    bus2_con = '보통'
                elif con2 == 5:
                    bus2_con = '혼잡'
                print('두번째 버스 혼잡도:', bus2_con)
                

def bus_cong(arsId, bus_name):
    bus_list = busCon_result(arsId)
    bus1_con = int
    con_score_dict = dict
    for i in range(len(bus_list)-2):
        if bus_name in bus_list[i+2][0]:
            div1 = bus_list[i+2][1]
            con1 = bus_list[i+2][2]
            if div1 == 0:
                bus1_con = 0
            elif div1 == 1 or div1 == 2:
                if con1 < 15:
                    bus1_con = 1    #여유
                elif con1 >= 15 and con1 < 20:
                    bus1_con = 2    #보통
                elif con1 >=20:
                    bus1_con = 3    #혼잡
            elif div1 == 3:
                bus1_con = 4    #만차
            else:
                if con1 == 3:
                    bus1_con = 1
                elif con1 == 4:
                    bus1_con = 2
                elif con1 == 5:
                    bus1_con = 3

    return bus1_con

