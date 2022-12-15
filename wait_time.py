import API_bus_arrival
import API_sub_arrival
import pandas as pd
from pandasql import sqldf
from datetime import datetime, date
from dateutil.relativedelta import relativedelta

# 지하철 호선, 상행/하행 바꾸기
def change_subway(df):
    df = df.replace({'지하철호선ID' : '1063'}, '경의중앙선')
    df = df.replace({'지하철호선ID' : '1065'}, '공항철도')
    df = df.replace({'지하철호선ID' : '1075'}, '수인분당선')
    df = df.replace({'지하철호선ID' : '1092'}, '우이신설선')
    df = df.replace({'지하철호선ID' : '1001'}, '1호선')
    df = df.replace({'지하철호선ID' : '1002'}, '2호선')
    df = df.replace({'지하철호선ID' : '1003'}, '3호선')
    df = df.replace({'지하철호선ID' : '1004'}, '4호선')
    df = df.replace({'지하철호선ID' : '1005'}, '5호선')
    df = df.replace({'지하철호선ID' : '1006'}, '6호선')
    df = df.replace({'지하철호선ID' : '1007'}, '7호선')
    df = df.replace({'지하철호선ID' : '1008'}, '8호선')
    df = df.replace({'지하철호선ID' : '1009'}, '9호선')

    if df['지하철호선ID'][0] == '2호선':
        df = df.replace({'상하행선구분' : 0}, '내선')
        df = df.replace({'상하행선구분' : 1}, '외선')
    
    else:
        df = df.replace({'상하행선구분' : 0}, '상행')
        df = df.replace({'상하행선구분' : 1}, '하행')
    
    return df


# 호선 변경
def sub_line(total_linenum):
    if total_linenum == '1':
        subLine = '1001'
    elif total_linenum == '2':
        subLine = '1002'
    elif total_linenum == '3':
        subLine = '1003'
    elif total_linenum == '4':
        subLine = '1004'
    elif total_linenum == '5':
        subLine = '1005'
    elif total_linenum == '6':
        subLine = '1006'
    elif total_linenum == '7':
        subLine = '1007'
    elif total_linenum == '8':
        subLine = '1008'
    elif total_linenum == '9':
        subLine = '1009'
    elif total_linenum == '경의중앙선':
        subLine = '1063'
    elif total_linenum == '공항철도':
        subLine = '1065'
    elif total_linenum == '수인분당선':
        subLine = '1075'
    elif total_linenum == '우이신설선':
        subLine = '1092'
    
    return subLine

# 지하철 대기시간 (단위 : sec)
def get_sub_wt(stationName, total_linenum, updn): # ('이대', '2', 1 or 2)

    wait_sub = []
    
    for st in range(len(stationName)):
        sub_arrival = API_sub_arrival.get_sub_real_time(stationName[st][0])

        statnId = []
        subwayId = []
        statnNm = []
        updnLine = []
        barvlDt = []
        recptnDt = []
        arvlMsg2 = []
        arvlMsg3 = []
        arvlCd = [] # (0:진입, 1:도착, 2:출발, 3:전역출발, 4:전역진입, 5:전역도착, 99:운행중)

        for u in sub_arrival['realtimeArrivalList']:
            statnId.append(u['statnId'])
            subwayId.append(u['subwayId'])
            statnNm.append(u['statnNm'])
            updnLine.append(u['updnLine'])
            barvlDt.append(u['barvlDt'])
            recptnDt.append(u['recptnDt'])
            arvlMsg2.append(u['arvlMsg2'])
            arvlMsg3.append(u['arvlMsg3'])
            arvlCd.append(u['arvlCd'])

        df2 = pd.DataFrame({'지하철역ID':statnId, '지하철호선ID':subwayId, '지하철역명':statnNm, '상하행선구분': updnLine, '열차도착예정시간 (초)': barvlDt, '열차도착정보를 생성한 시각': recptnDt, '첫번째도착메세지': arvlMsg2, '두번째도착메세지': arvlMsg3, '도착코드': arvlCd})

        df2 = df2.replace({'상하행선구분' : '상행'}, 0)
        df2 = df2.replace({'상하행선구분' : '하행'}, 1)
        df2 = df2.replace({'상하행선구분' : '내선'}, 0)
        df2 = df2.replace({'상하행선구분' : '외선'}, 1)

        subid = sub_line(total_linenum[st])

        sql = "select * from df2 where 지하철호선ID="+str(subid)+" and 상하행선구분=\'"+str(updn[st]-1)+"\'"
        # f_data = sqldf("select * from df2 where 지하철호선ID=1006 and 상하행선구분='상행'")
        f_data = sqldf(sql) # dataframe

        date_time_str = f_data['열차도착정보를 생성한 시각'][0][:-2]

        date_time = datetime.strptime(date_time_str, '%Y-%m-%d %H:%M:')

        second_eta = []
        eeta = []

        for i in range(len(f_data)):
            eta = f_data['열차도착예정시간 (초)'][i]
            eta = int(eta)

            arrival_time = date_time + relativedelta(seconds=eta)
            second_eta.append(arrival_time)
            eeta.append(i+1)
        
        ETA = pd.DataFrame({'지하철':eeta, '도착시간':second_eta})
        arrival_time = ETA['도착시간'].apply(lambda dt: datetime(dt.year, dt.month, dt.day, dt.hour,10*(dt.minute // 10)))

        f_data = change_subway(f_data)

        wait_time = f_data['열차도착예정시간 (초)']
        wait_line = list(f_data['지하철호선ID'])
        wait_updn = list(f_data['상하행선구분'])
        wait_time = list(wait_time)

        wait_Time = []

        for i in range(len(wait_time)):
            wait_Time.append(int(wait_time[i]))
        
        for i in range(len(wait_Time)):
            wait_sub.append( wait_Time[i])

    return sum(wait_sub) # [('2호선', '내선', Timestamp('2022-11-04 16:00:00'), 169), ('2호선', '내선', Timestamp('2022-11-04 16:00:00'), 410)] 이런 식으로 결과 나옴!

# 버스 대기시간 (단위 : sec)
def get_bus_wt(stationID, lowBus):
    
    bus_arrival = API_bus_arrival.get_bus_real_time(stationID, lowBus)
    
    cnt = 0
    busnum_and_wt = []
    bus_list = bus_arrival['result']['real']

    # print(bus_list)
    # print(len(bus_list))

    for bus in bus_list:
        
        # print(cnt)
        # print(bus)
        # cnt += 1
        # print()
        # break

        try:
            # print(bus['arrival1'])
            # print(bus['arrival2'])
            busnum_and_wt.append((bus['routeNm'], bus['arrival1']['arrivalSec'], bus['arrival2']['arrivalSec']))

        except:
            try:
                # print(bus['arrival1'])
                busnum_and_wt.append((bus['routeNm'], bus['arrival1']['arrivalSec']))
            except:
                    try:
                        # print(bus['arrival2'])
                        busnum_and_wt.append((bus['routeNm'], bus['arrival2']['arrivalSec']))
                    except:
                        continue

    # print(busnum_and_wt)

    return list(set(busnum_and_wt))

# print(get_bus_wt('103891', '0')) # 파라미터 예 : stationID 102155 & 일반버스/저상버스 모두 포함