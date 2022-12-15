import pandas as pd
from pandasql import sqldf

# 지하철 스케쥴 검색할때 필요한 역코드로 변환
# [(출발역코드,도착역코드)]
# input: total_sub_stationID = [(327, 342), (326, 343), (327, 342)]
# output: [('0317', '0332'), ('0316', '0333'), ('0317', '0332')]

def st_id_change(total_sub_stationID):

    change_ID = pd.read_csv('sub_info.csv', encoding='euc-kr')

    a = []
    b = []
    for i in range(len(total_sub_stationID)):
        a.append(str(total_sub_stationID[i][0]))
        b.append(str(total_sub_stationID[i][1]))

    stations_list = pd.DataFrame(zip(a, b), columns = ['startID', 'endID'])
    
    start_list = []

    for i in range(len(stations_list)):
        for_sql_1 = stations_list['startID'][i]
        sql1 = f"select 전철역명 from change_ID where 외부코드 = {for_sql_1}"

        beta1 = sqldf(sql1)
        value = beta1['전철역명'][0]
        start_list.append(str(value))

    end_list = []

    for i in range(len(stations_list)):
        for_sql_2 = stations_list['endID'][i]
        sql2 = f"select 전철역명 from change_ID where 외부코드 = {for_sql_2}"

        beta2 = sqldf(sql2)
        value = beta2['전철역명'][0]
        end_list.append(str(value))

    final_stcd = []
    
    for i in range(len(end_list)):
        final_stcd.append((start_list[i], end_list[i]))
    
    return final_stcd