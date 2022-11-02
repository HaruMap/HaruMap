import geocoding
import path_time
import path_description 
import API_transport_poi
import API_path_walk
import API_path_transport

import sys
import os

sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))
import API.api

# ================================================ 출발지/도착지 입력 ================================================

# 출발지/도착지 주소 입력
'''
s_address = input('출발지를 입력하세요 : ')
e_address = input('도착지를 입력하세요 : ')

# geocoding
sx = geocoding.geocoding(s_address)[0]
sy = geocoding.geocoding(s_address)[1]
# sx, sy = 126.9463175, 37.5654184
ex = geocoding.geocoding(e_address)[0]
ey = geocoding.geocoding(e_address)[1]
# print(sx, sy, ex, ey)
'''
# -> 지도에서 클릭 후 각 위경도 받아오는 식으로 추후 수정
# 출발지, 도착지 샘플
w_sx, w_sy = 126.94687065007022, 37.5635841072725  # 이대 포스코관
w_ex, w_ey = 126.92382953492177, 37.52679721577862 # 여의도공원

# ================================================ 주변 정류소 POI ================================================

# 주변 transport poi
# 출발지
s_poi = API_transport_poi.get_transport_poi(str(w_sx), str(w_sy), '1:2')
# 도착지
e_poi = API_transport_poi.get_transport_poi(str(w_ex), str(w_ey), '1:2')

# 출발지, 도착지 정류소명 확인
print('출발지 :', s_poi)
print('도착지 :', e_poi)
print()

# ================================================ geocoding (대중교통 출발지/도착지) ================================================

# geocoding -> 경로 수 : s_poi * e_poi 로 추후 수정
# for s in s_poi: 
    # for e in e_poi: 
        # sx = geocoding.geocoding(s)[0]
sx = geocoding.geocoding(s_poi[0])[0]
sy = geocoding.geocoding(s_poi[0])[1]
# sx, sy = 126.9463175, 37.5654184
ex = geocoding.geocoding(e_poi[0])[0]
ey = geocoding.geocoding(e_poi[0])[1]

# ================================================ 도보 경로 검색 ================================================

s_t, s_d, s_coor, s_descrip, s_roadType = API_path_walk.path_walk(w_sx, w_sy, sy, sx, op=30) # 출발지 -> 인근 출발 정류소 경로
e_t, e_d, e_coor, e_descrip, e_roadType = API_path_walk.path_walk(ey, ex, w_ex, w_ey, op=30) # 인근 도착 정류소 -> 도착지 경로

# ================================================ 대중교통 경로 검색 ================================================

# 대중교통 경로 반환 (버스, 지하철, 버스+지하철)
path_transport = API_path_transport.path_transport(sy, sx, ey, ex)
# print(path_transport)
print('지하철 경로 수 :', path_transport['result']['subwayCount'])
print('버스 경로 수 :', path_transport['result']['busCount'])
print('버스 + 지하철 경로 수 :', path_transport['result']['subwayBusCount'])
print()

# 가능한 대중교통 경로
path_transport_list = path_transport['result']['path']
# 1) 지하철
path_subway = [subway for subway in path_transport_list if subway['pathType'] == 1]
# 2) 버스
path_bus = [bus for bus in path_transport_list if bus['pathType'] == 2]
# 3) 버스 + 지하철
path_subbus = [subbus for subbus in path_transport_list if subbus['pathType'] == 3]

# ================================================ 경로 유형 선택 ================================================

# 대중교통 유형 택1
op_transport = int(input('대중교통 유형 택1 (1:지하철, 2:버스, 3:지하철+버스) : '))
print()

# ================================================ 모든 경로 담은 리스트 생성 (추후 이동불편지수 반영) ======================

total_path_description = {} # description
total_path_coor = [] # coordinates

# ================================================ 경로 description 생성 ================================================

# 대중교통 경로 정보
trans_descrip = []
trans_t = []
if op_transport == 1:
    for idx, path in enumerate(path_subway):
        trans_description = path_description.description_transport(path) # 각 path 별 이동 description
        trans_descrip.append(trans_description)
        # print('{0}) subway totalTime :'.format(idx), path_time.totaltime(path))
        sub_t, bus_t, walk_t = path_time.subtime(path)
        # print('sub_t, bus_t, walk_t :', (sub_t, bus_t, walk_t))
        trans_t.append(sub_t + bus_t + walk_t)
elif op_transport == 2:
    for idx, path in enumerate(path_bus):
        trans_description = path_description.description_transport(path) # 각 path 별 이동 description
        trans_descrip.append(trans_description)
        # print('{0}) bus totalTime :'.format(idx), path_time.totaltime(path))
        sub_t, bus_t, walk_t = path_time.subtime(path)
        # print('sub_t, bus_t, walk_t :', (sub_t, bus_t, walk_t))
        trans_t.append(sub_t + bus_t + walk_t)
elif op_transport == 3:
    for idx, path in enumerate(path_subbus):
        trans_description = path_description.description_transport(path) # 각 path 별 이동 description
        trans_descrip.append(trans_description)
        # print('{0}) subbus totalTime :'.format(idx + 1), path_time.totaltime(path))
        sub_t, bus_t, walk_t = path_time.subtime(path)
        # print('sub_t, bus_t, walk_t :', (sub_t, bus_t, walk_t))
        trans_t.append(sub_t + bus_t + walk_t)

# 도보 (출발) 경로 정보 전달
path_description.description_ws(s_descrip, s_poi[0])
print()
# print(f'이동거리 : {s_d}, 소요시간 : {s_t}')
# print()

# 대중교통 경로 정보 전달
trans_idx = 0 # 사용자가 선택한 경로 idx, 예 - 0
for text in trans_descrip[trans_idx]:
    print(text)
print()

# 도보 (도착) 경로 정보 전달
path_description.description_we(e_descrip, e_poi[0])
print()
# print(f'이동거리 : {e_d}, 소요시간 : {e_t}')
# print()

print('===================================================', '\n')

print(f'총 이동시간 : {round((s_t + e_t) / 60) + trans_t[trans_idx]} 분, 도보 이동거리 : {s_d + e_d} m')
print()

