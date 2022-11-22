# 지하철 빠른하차

# station_id: 도착역코드
# updn: 상행/내선 : 0 or 하행/외선 : 1  오디세이: 1 : 상행, 2: 하행
# exit_no: 출구 번호

import pandas as pd
from pandasql import sqldf

def fast_getout(station_id, updn, exit_no):
    getout = pd.read_csv(r'C:\Users\user\Desktop\4-2\capstone\code\HaruMap\HaruMap\sub_fast.csv', encoding='UTF-8')
    # print(getout.shape)
    
    sql = f"select 빠른하차 from getout where 역코드={station_id} and 상하행={updn} and 출구 like '%{exit_no}번출구%'"
    df = sqldf(sql)

    final_gtot = []
    
    for i in range(len(df)):
        final_gtot.append((df['빠른하차'][i]))
    
    return final_gtot

# output 예시: fast_getout(140, 0, 3) -> fast_getout(140, 0, 3)

# =======================================================================================

# 지하철 승강기 유무

# station_id: 역코드

def lift_yn(station_id):
    y_or_no = pd.read_csv('HaruMap\sub_lifts.csv', encoding='euc-kr')
    sql = f"select * from y_or_no where 역코드={station_id}"
    df = sqldf(sql)

    final_gtot = []
    
    for i in range(len(df)):
        final_gtot.append((df['승강기명'][i], df['운행구간'][i], df['설치위치'][i]))
    
    return final_gtot

# output 예시: lift_yn(223) -> [('승강기)에스컬레이터 1', 'F1-B1', '6번 출입구'),
#  ('승강기)에스컬레이터 2', 'B1-F1', '6번 출입구'),
#  ('승강기)엘리베이터 내부#1', 'B2-B1', '외선 8-4'),
#  ('승강기)엘리베이터 내부#2', 'B2-B1', '내선 3-1'),
#  ('승강기)엘리베이터 외부#1', 'B1-1F', '5번 출구측')]