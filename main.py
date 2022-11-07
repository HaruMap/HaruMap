import geocoding
import path_time
import wait_time
import path_description 
import score
import classification
import path_loop
import API_transport_poi
import API_path_walk
import API_path_transport
import API_sub_congestion

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
w_ex, w_ey = 127.03257402230341, 37.483659133375106 # 서초구청

# ================================================ 주변 정류소 POI ================================================

# 주변 transport poi
# 출발지
s_poi = API_transport_poi.get_transport_poi(str(w_sx), str(w_sy), '1:2')
# 도착지
e_poi = API_transport_poi.get_transport_poi(str(w_ex), str(w_ey), '1:2')

# 출발지, 도착지 정류소명 확인
print('출발 정류소 :', s_poi)
print('도착 정류소 :', e_poi)
print()

# ================================================ 모든 경로 담은 리스트 생성 (추후 이동불편지수 반영) ======================

total_path_sub = {} # 경로 초기화
total_path_bus = {}
total_path_subbus = {}
cnt_path_sub, cnt_path_bus, cnt_path_subbus = 0, 0, 0 # 경로 수 초기화

# ================================================ geocoding (대중교통 출발지/도착지) ================================================

# geocoding -> 경로 수 : s_poi * e_poi 로 추후 수정
for s in s_poi:
    for e in e_poi:
        sx = geocoding.geocoding(s)[0]
        sy = geocoding.geocoding(s)[1]
        ex = geocoding.geocoding(e)[0]
        ey = geocoding.geocoding(e)[1]
        # print(sx, sy, ex, ey)

        # ================================================ 도보 경로 검색 ================================================

        try:
            s_t, s_d, s_coor, s_descrip, s_roadType = API_path_walk.path_walk(w_sx, w_sy, sy, sx, op=30) # 출발지 -> 인근 출발 정류소 경로
            e_t, e_d, e_coor, e_descrip, e_roadType = API_path_walk.path_walk(ey, ex, w_ex, w_ey, op=30) # 인근 도착 정류소 -> 도착지 경로
        except:
            continue # 위/경도로 도보 경로가 반환되지 않는다면 cotinue (: 다음 경로 탐색)

        # ================================================ 대중교통 경로 검색 ================================================

        # 대중교통 경로 반환 (버스, 지하철, 버스+지하철)
        path_transport = API_path_transport.path_transport(sy, sx, ey, ex)
        # print(path_transport)

        # 가능한 대중교통 경로
        path_transport_list = path_transport['result']['path']
        # 1) 지하철
        path_subway = [subway for subway in path_transport_list if subway['pathType'] == 1]
        # 2) 버스
        path_bus = [bus for bus in path_transport_list if bus['pathType'] == 2]
        # 3) 버스 + 지하철
        path_subbus = [subbus for subbus in path_transport_list if subbus['pathType'] == 3]

        # ================================================ 경로 정보 저장 ================================================

        # 지하철
        for idx, path in enumerate(path_subway):

            trans_descrip = []
            trans_t = []

            trans_description, total_bus_info = path_description.description_transport(path) # 각 path 별 이동 description
            trans_descrip.append(trans_description)
            # print('{0}) subway totalTime :'.format(idx), path_time.totaltime(path))
            sub_t, bus_t, walk_t = path_time.subtime(path)
            # print('sub_t, bus_t, walk_t :', (sub_t, bus_t, walk_t))
            trans_t.append(sub_t + bus_t + walk_t)

            # 도보 (출발) + 대중교통 + 도보 (도착)
            fin_descrip = s_descrip + trans_descrip + e_descrip

            total_path_sub[cnt_path_sub] = {
                'info' : {
                    'totaltime' : round((s_t + e_t) / 60) + (sub_t + bus_t + walk_t), # 총 이동시간 (대기시간 아직 미포함)
                    'description' : fin_descrip # 이동경로 description = [도보 출발 경로, [대중교통 경로], 도보 도착 경로] 형태
                },
                'subway' : {
                    'congestion' : 0,
                    'waittime' : 0,
                    'pathtime' : 0,
                    'service' : 0
                },
                'walk' : {
                    'pathtime' : 0,
                    'pathd' : s_d + e_d, # + walk_d 총 도보거리 (단위 : m)
                    'slope' : 0,
                    'roadtype' : 0,
                    'obstruction' : 0
                },
                'score' : 0 # 추후 이동불편지수 산출 후 값 넣기 & sort
            }

            cnt_path_sub += 1

            # ========= API 요금 방지 ==========
            break
            # =================================

        # 버스
        for idx, path in enumerate(path_bus):
            
            trans_descrip = []
            trans_t = []

            trans_description, total_bus_info = path_description.description_transport(path) # 각 path 별 이동 description
            trans_descrip.append(trans_description)
            # print('{0}) bus totalTime :'.format(idx), path_time.totaltime(path))
            sub_t, bus_t, walk_t = path_time.subtime(path)
            # print('sub_t, bus_t, walk_t :', (sub_t, bus_t, walk_t))
            trans_t.append(sub_t + bus_t + walk_t)

            # 도보 (출발) + 대중교통 + 도보 (도착)
            fin_descrip = s_descrip + trans_descrip + e_descrip

            total_path_bus[cnt_path_bus] = {
                'info' : {
                    'totaltime' : round((s_t + e_t) / 60) + (sub_t + bus_t + walk_t),
                    'description' : fin_descrip
                },
                'bus' : {
                    'congestion' : 0,
                    'waittime' : 0,
                    'pathtime' : 0
                },
                'walk' : {
                    'pathtime' : 0,
                    'pathd' : s_d + e_d, # + walk_d 총 도보거리 (단위 : m)
                    'slope' : 0,
                    'roadtype' : 0,
                    'obstruction' : 0
                },
                'score' : 0
            }

            cnt_path_bus += 1


            # ========= API 요금 방지 ==========
            break
            # =================================


        # 지하철 + 버스
        for idx, path in enumerate(path_subbus):
            
            trans_descrip = []
            trans_t = []

            # print(path['subPath'])
            '''
            path_loop.sub_avg_congestion(path['subPath'])
            '''

            trans_description, total_bus_info = path_description.description_transport(path) # 각 path 별 이동 description
            trans_descrip.append(trans_description)
            # print('{0}) subbus totalTime :'.format(idx + 1), path_time.totaltime(path))
            sub_t, bus_t, walk_t = path_time.subtime(path)
            # print('sub_t, bus_t, walk_t :', (sub_t, bus_t, walk_t))
            trans_t.append(sub_t + bus_t + walk_t)

            # 도보 (출발) + 대중교통 + 도보 (도착)
            fin_descrip = s_descrip + trans_descrip + e_descrip

            # 지하철 혼잡도 평균 산출
            '''
            avg_sub_congestion = path_loop.sub_avg_congestion(path['subPath'])
            '''

            # 버스 대기시간 누적 (환승 과정) 산출
            # total_bus_info = [(버스 번호 리스트, 버스 출발 정류소명)]
            # print('-')
            for bus_tup in total_bus_info:

                bus_wait_time = []
                bus_wait_time_classification = [] # 버스 대기시간 가중치

                # print(bus_tup)
                bus_num_list = bus_tup[0] # 탑승 가능한 버스 번호 리스트
                bus_station = bus_tup[1]  # 버스 정류소명
                bus_stID_congestion = bus_tup[2] # 버스 정류소 ID, congestion parameter (예 : 13-120)
                bus_stID_congestion = bus_stID_congestion.replace('-', '') # 버스 정류소 ID, congestion parameter (예 : 13120)
                bus_stID_wt = bus_tup[3]
                # print(bus_station, bus_num_list, bus_stID_congestion, bus_stID_wt)
                # print()

                # 탈 수 있는 버스들의 대기시간 중 가장 대기시간이 짧은 값 확인
                for bus in bus_num_list:

                    try:
                        check_bus_wt = wait_time.get_bus_wt(bus_stID_wt, '0')
                        for wt in check_bus_wt:
                            if bus == wt[0]: # 버스 대기시간 리스트 [(버스번호, 대기시간1, 대기시간2), ...] 에서 일치하는 버스번호의 대기시간 정보를 가져옴
                                bus_wait_time.append(wt[1])
                    except:
                        continue
                    
                    # print(bus_wait_time)
                    bus_wait_time_classification = classification.classification_time_bus(bus_wait_time)
                    if len(bus_wait_time_classification) == 0: 
                        bus_wait_time_classification = None
                    else: # 추후 대기시간 수정 (해당 지점까지 도착하는 시간보다 작은 값을 제외 후, 그중 min value)
                        bus_wait_time_classification = [min(bus_wait_time_classification)]
                    # print(bus_wait_time_classification)
                    # print()

            total_path_subbus[cnt_path_subbus] = {
                'info' : {
                    'totaltime' : round((s_t + e_t) / 60) + (sub_t + bus_t + walk_t), # (단위 : min)
                    'description' : fin_descrip
                },
                'subway' : {
                    'congestion' : [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5], # classification.classification_sub(avg_sub_congestion), # min value 만 추출?
                    'waittime' : 0, # (wait_time.get_sub_wt()), # (단위 : sec)
                    'pathtime' : classification.path_time(sub_t), # (단위 : min)
                    'service' : 0
                },
                'bus' : {
                    'congestion' : 0, # 현재 정보가 없음
                    'waittime' : bus_wait_time_classification, # min value only! (단위 : sec)
                    'pathtime' : classification.path_time(bus_t) # (단위 : min)
                },
                'walk' : {
                    'pathtime' : classification.path_time_walk(round((s_t + e_t) / 60) + walk_t), # (단위 : min)
                    'pathd' : s_d + e_d, # + walk_d 총 도보거리 (단위 : m)
                    'slope' : 0,
                    'roadtype' : 0,
                    'obstruction' : 0
                },
                'score' : 0
            }

            cnt_path_subbus += 1

            # ========= API 요금 방지 ==========
            break
            # =================================

    # ========= API 요금 방지 ==========
        break
    break
    # =================================

# ================================================ 경로 유형 선택 ================================================

print('지하철 경로 수 :', len(total_path_sub))
print('버스 경로 수 :', len(total_path_bus))
print('버스 + 지하철 경로 수 :', len(total_path_subbus))
print()

# 대중교통 유형 택1
op_transport = int(input('대중교통 유형 택1 (1:지하철, 2:버스, 3:지하철+버스) : '))
print()

# 정렬 기준 택1 (1:이동불편지수, 2:시간 등)

# ================================================ 샘플 경로 확인 ================================================

if op_transport == 1: # '지하철만' 선택
    print('유형 : 지하철')
    print(total_path_sub[0]) # sample
elif op_transport == 2: # '버스만' 선택
    print('유형 : 버스')
    print(total_path_bus[0]) # sample
elif op_transport == 3: # '지하철+버스' 선택
    print('유형 : 지하철 + 버스')
    print(total_path_subbus[0]) # sample

# ================================================ 이동불편지수 산출 ================================================



# ================================================ 이동불편지수가 낮은 순으로 정렬 ================================================

