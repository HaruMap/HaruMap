import geocoding
import path_time
import wait_time
import path_description 
import score
import classification
import path_loop
import coordinate
import sort_path_by_score
import API_transport_poi
import API_path_walk
import API_path_transport
import API_sub_congestion

import sys
import os
import numpy as np

from walk import avg_slope_upgrade

sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))
import API.api

def main(w_sx, w_sy, w_ex, w_ey):

    # ================================================ 출발지/도착지 입력 ================================================

    # 출발지/도착지 주소 입력
    # 출발지, 도착지 샘플
    w_sx, w_sy = 126.9458512336349, 37.5567946331233 # 이대역
    w_ex, w_ey = 127.02944282002197, 37.55740704697605 # 행당역

    # ================================================ 주변 정류소 POI ================================================

    # 주변 transport poi
    # 출발지
    s_poi = API_transport_poi.get_transport_poi(str(w_sx), str(w_sy), '1:2')
    # 도착지
    e_poi = API_transport_poi.get_transport_poi(str(w_ex), str(w_ey), '1:2')

    # 출발지, 도착지 정류소명 확인
    print('출발 정류소 :', s_poi)
    print('도착 정류소 :', e_poi, '\n')

    # ================================================ 모든 경로 담은 리스트 생성 (추후 이동불편지수 반영) ======================

    total_path_sub = {} # 경로 초기화
    total_path_bus = {}
    total_path_subbus = {}
    cnt_path_sub, cnt_path_bus, cnt_path_subbus = 0, 0, 0 # 경로 수 초기화

    # ================================================ geocoding (대중교통 출발지/도착지) ================================================

    # geocoding -> 경로 수 : s_poi * e_poi 로 추후 수정
            
    # 대중교통 유형별 모든 경로 저장
    pathdetails_subbus = []
    pathdetails_sub = []
    pathdetails_bus = []

    '''
    print(geocoding.geocoding('이대역'))
    print(geocoding.geocoding('강남역'))
    s_poi = ['이대역']
    e_poi = ['강남역']
    '''

    for s in s_poi:
        for e in e_poi:
            print(f's : {s} / e : {e}')

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

            # 도보 (출발) description 형태 수정
            s_descrip = path_description.description_ws(s_descrip)
            # 도보 (도착) description 형태 수정
            e_descrip = path_description.description_we(e_descrip)

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
            pathdetails = []
            for idx, path in enumerate(path_subway):

                trans_descrip = []
                trans_t = []
                # updown = [] # 1 : 상행, 2 : 하행 

                # coordinate (출발 도보, 대중교통, 도착 도보, type : list)
                coor_transport = coordinate.coor_transport(path['subPath'])
                coor_walk = s_coor + e_coor

                trans_description, total_bus_info, total_sub_stationID, total_linenum, updown = path_description.description_transport(path) # 각 path 별 이동 description
                # trans_descrip.append(trans_description)
                trans_descrip += trans_description
                # print('{0}) subway totalTime :'.format(idx), path_time.totaltime(path))
                sub_t, bus_t, walk_t, resp_t = path_time.subtime(path)
                # print('sub_t, bus_t, walk_t :', (sub_t, bus_t, walk_t))
                trans_t.append(sub_t + bus_t + walk_t)

                # 도보 (출발) + 대중교통 + 도보 (도착)
                # fin_descrip = s_descrip + trans_descrip + e_descrip
                fin_descrip = s_descrip + trans_description + e_descrip

                total_path_sub[cnt_path_sub] = {
                    'info' : {
                        'totaltime' : round((s_t + e_t) / 60) + (sub_t + bus_t + walk_t), # 총 이동시간 (대기시간 아직 미포함)
                        'totaldescription' : [],
                        'description' : fin_descrip,
                        'coordinate' : s_coor + coor_transport + e_coor,
                        'summary' : []
                    },
                    'subway' : {
                        'congestion' : [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5], # classification.classification_sub(avg_sub_congestion), # min value 만 추출?
                        'waittime' : 0, # (wait_time.get_sub_wt()), # (단위 : sec)
                        'pathtime' : classification.path_time(sub_t), # (단위 : min)
                        'service' : 0
                    },
                    'walk' : {
                        'pathtime' : classification.path_time_walk(round((s_t + e_t) / 60) + walk_t), # (단위 : min)
                        'pathd' : s_d + e_d, # + walk_d 총 도보거리 (단위 : m)
                        'slope' : 0, # avg_slope_upgrade.getSlope_wheelCat(avg_slope_upgrade.getSlope(coor_walk)),
                        'roadtype' : 0,
                        'obstruction' : 0
                    },
                    'score' : 0 # 추후 이동불편지수 산출 후 값 넣기 & sort
                }

                # =============================================================================
                # drf 전달 데이터
                totaldescription = []
                totaldescription.append(('도보', round(s_t / 60)))

                sub_linenum_cnt = 0
                for t in resp_t:
                    # print(t)
                    if t[0] == 1:
                        totaldescription.append(('지하철', t[1], int(total_linenum[sub_linenum_cnt])))
                        sub_linenum_cnt += 1
                    elif t[0] == 2:
                        totaldescription.append(('버스', t[1]))

                totaldescription.append(('도보', round(e_t / 60)))

                in_pathdetails = {}
                in_pathdetails = {
                    'totaltime' : round((s_t + e_t) / 60) + (sub_t + bus_t + walk_t), # (단위 : min)
                    'totaldescription' : totaldescription,
                    'description' : fin_descrip,
                    'coor' : s_coor + coor_transport + e_coor,
                    # 'score' : 0
                }
                pathdetails.append(in_pathdetails)
                pathdetails_sub.append(in_pathdetails)
                # print(pathdetails); print(); break
                # =============================================================================

                cnt_path_sub += 1

                
                # ========= API 요금 방지 ==========
                break
                # =================================
                

            # =============================================================
            # 버스
            # =============================================================
            pathdetails = []
            for idx, path in enumerate(path_bus):
                
                trans_descrip = []
                trans_t = []

                # coordinate (출발 도보, 대중교통, 도착 도보, type : list)
                coor_transport = coordinate.coor_transport(path['subPath'])
                coor_walk = s_coor + e_coor

                trans_description, total_bus_info, total_sub_stationID, total_linenum, updown = path_description.description_transport(path) # 각 path 별 이동 description
                # trans_descrip.append(trans_description)
                trans_descrip += trans_description
                # print('{0}) bus totalTime :'.format(idx), path_time.totaltime(path))
                sub_t, bus_t, walk_t, resp_t = path_time.subtime(path)
                # print('sub_t, bus_t, walk_t :', (sub_t, bus_t, walk_t))
                trans_t.append(sub_t + bus_t + walk_t)

                # 도보 (출발) + 대중교통 + 도보 (도착)
                # fin_descrip = s_descrip + trans_descrip + e_descrip
                fin_descrip = s_descrip + trans_description + e_descrip

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

                    for bus in bus_num_list:

                        try:
                            check_bus_wt = wait_time.get_bus_wt(bus_stID_wt, '0')
                            for wt in check_bus_wt:
                                if bus == wt[0]: # 버스 대기시간 리스트 [(버스번호, 대기시간1, 대기시간2), ...] 에서 일치하는 버스번호의 대기시간 정보를 가져옴
                                    bus_wait_time.append(wt[1])
                        except:
                            continue
                        
                        bus_wait_time_classification = classification.classification_time_bus(bus_wait_time)

                total_path_bus[cnt_path_bus] = {

                    'info' : {
                        'totaltime' : round((s_t + e_t) / 60) + (sub_t + bus_t + walk_t), # (단위 : min)
                        'totaldescription' : [],
                        'description' : fin_descrip,
                        'coordinate' : s_coor + coor_transport + e_coor,
                        'summary' : []
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

                # =============================================================================
                # drf 전달 데이터
                totaldescription = []
                totaldescription.append(('도보', round(s_t / 60)))

                sub_linenum_cnt = 0
                for t in resp_t:
                    # print(t)
                    if t[0] == 1:
                        totaldescription.append(('지하철', t[1], int(total_linenum[sub_linenum_cnt])))
                        sub_linenum_cnt += 1
                    elif t[0] == 2:
                        totaldescription.append(('버스', t[1]))

                totaldescription.append(('도보', round(e_t / 60)))

                in_pathdetails = {}
                in_pathdetails = {
                    'totaltime' : round((s_t + e_t) / 60) + (sub_t + bus_t + walk_t), # (단위 : min)
                    'totaldescription' : totaldescription,
                    'description' : fin_descrip,
                    'coor' : s_coor + coor_transport + e_coor,
                    # 'score' : 0
                }
                pathdetails.append(in_pathdetails)
                pathdetails_bus.append(in_pathdetails)
                # print(pathdetails); print(); break
                # =============================================================================

                cnt_path_bus += 1

                
                # ========= API 요금 방지 ==========
                break
                # =================================
                

            # =============================================================
            # 지하철 + 버스
            # =============================================================
            pathdetails = []
            for idx, path in enumerate(path_subbus):
                
                trans_descrip = []
                trans_t = []

                # coordinate (출발 도보, 대중교통, 도착 도보, type : list)
                coor_transport = coordinate.coor_transport(path['subPath'])
                coor_walk = s_coor + e_coor
                # print(coor_walk)

                '''
                path_loop.sub_avg_congestion(path['subPath'])
                '''

                trans_description, total_bus_info, total_sub_stationID, total_linenum, updown = path_description.description_transport(path) # 각 path 별 이동 description
                # trans_descrip.append(trans_description)
                trans_descrip += trans_description
                # print('{0}) subbus totalTime :'.format(idx + 1), path_time.totaltime(path))
                sub_t, bus_t, walk_t, resp_t = path_time.subtime(path)
                # print('sub_t, bus_t, walk_t :', (sub_t, bus_t, walk_t))
                trans_t.append(sub_t + bus_t + walk_t)

                ''' 지하철 상하행 & 역코드 '''
                '''
                print(updown) # 상하행
                print(total_linenum) # 노선
                print(total_sub_stationID) # 역코드
                '''

                # 도보 (출발) + 대중교통 + 도보 (도착)
                # fin_descrip = s_descrip + trans_descrip + e_descrip
                fin_descrip = s_descrip + trans_description + e_descrip

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

                    for bus in bus_num_list:

                        try:
                            check_bus_wt = wait_time.get_bus_wt(bus_stID_wt, '0')
                            for wt in check_bus_wt:
                                if bus == wt[0]: # 버스 대기시간 리스트 [(버스번호, 대기시간1, 대기시간2), ...] 에서 일치하는 버스번호의 대기시간 정보를 가져옴
                                    bus_wait_time.append(wt[1])
                        except:
                            continue
                        
                        bus_wait_time_classification = classification.classification_time_bus(bus_wait_time)

                # ===================================================================
                # 이동불편지수 산출 데이터
                total_path_subbus[cnt_path_subbus] = {
                    'info' : {
                        'totaltime' : round((s_t + e_t) / 60) + (sub_t + bus_t + walk_t), # (단위 : min)
                        'totaldescription' : [],
                        'description' : fin_descrip,
                        'coordinate' : s_coor + coor_transport + e_coor,
                        'summary' : []
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
                        'slope' : 0, # avg_slope_upgrade.getSlope_wheelCat(avg_slope_upgrade.getSlope(coor_walk)),
                        'roadtype' : 0,
                        'obstruction' : 0
                    },
                    'score' : 0
                }
                # ===================================================================

                # ===================================================================
                # drf 전달 데이터
                totaldescription = []
                totaldescription.append(('도보', round(s_t / 60)))

                sub_linenum_cnt = 0
                for t in resp_t:
                    # print(t) # -> 예 : (2, 11)
                    if t[0] == 1:
                        totaldescription.append(('지하철', t[1], int(total_linenum[sub_linenum_cnt]))) # , sub_linenum))
                        sub_linenum_cnt += 1
                    elif t[0] == 2:
                        totaldescription.append(('버스', t[1]))

                totaldescription.append(('도보', round(e_t / 60)))

                in_pathdetails = {}
                in_pathdetails = {
                    'totaltime' : round((s_t + e_t) / 60) + (sub_t + bus_t + walk_t), # (단위 : min)
                    'totaldescription' : totaldescription,
                    'description' : fin_descrip,
                    'coor' : s_coor + coor_transport + e_coor,
                    # 'score' : 0
                }

                pathdetails.append(in_pathdetails)
                pathdetails_subbus.append(in_pathdetails)
                # print(pathdetails); print() # ; break
                # print(len(pathdetails))
                # print(len(pathdetails_subbus))
                # =============================================================================

                cnt_path_subbus += 1

                '''
                # ========= API 요금 방지 ==========
                break
                # =================================
                '''
                

        
        # ========= API 요금 방지 ==========
            break
        break
        # =================================
        
        

    # ================================================ 샘플 경로 확인 ================================================
    '''
    if op_transport == 1: # '지하철만' 선택
        print('유형 : 지하철')
        print(total_path_sub[0]) # sample
    elif op_transport == 2: # '버스만' 선택
        print('유형 : 버스')
        print(total_path_bus[0]) # sample
    elif op_transport == 3: # '지하철+버스' 선택
        print('유형 : 지하철 + 버스')
        print(total_path_subbus[0]) # sample
    '''
    # ================================================ 이동불편지수 산출 ================================================

    # 일단 휠체어 이용자로 가정함 (추후 받아온 사용자 정보 & 정렬 기준 기반 재산출)
    # 1) 지하철
    for idx in range(len(total_path_sub)):
        total_path_sub[idx]['score'] = score.score_type1(total_path_sub[idx], 1)

    # 2) 버스
    for idx in range(len(total_path_bus)):
        total_path_bus[idx]['score'] = score.score_type1(total_path_bus[idx], 2)

    # 3) 지하철 + 버스
    for idx in range(len(total_path_subbus)):
        total_path_subbus[idx]['score'] = score.score_type1(total_path_subbus[idx], 3)

    # ================================================ 사용자 지정 유형/순서로 정렬 ================================================

    print()
    print('지하철 경로 수 :', len(total_path_sub))
    print('버스 경로 수 :', len(total_path_bus))
    print('버스 + 지하철 경로 수 :', len(total_path_subbus))
    print()

    '''
    # 대중교통 유형 택1
    op_transport = int(input('대중교통 유형 택1 (1:지하철, 2:버스, 3:지하철+버스) : '))
    print()
    '''

    # 정렬 기준 택1 (1:이동불편지수, 2:시간 등)
    # op_sort = int(input('정렬 순서 택1 (1:이동불편지수, 2:시간, 3:도보, 4:환승) : '))
    op_sort = 1
    print()

    # 최종 반환 경로
    send_drf = []
    fin_total_drf_path = {}

    # 일단 샘플은 subbus 경로를 보여줌!
    if op_sort == 1:

        # 이동불편지수 낮은 순 (subbus)
        if total_path_subbus == None or pathdetails_subbus == None:
            pass
        else:
            fin_view_path_subbus, fin_drf_path_subbus = sort_path_by_score.sort_score(total_path_subbus, pathdetails_subbus)
        # 이동불편지수 낮은 순 (sub)
        if total_path_sub == None or pathdetails_sub == None:
            pass
        else:
            fin_view_path_sub, fin_drf_path_sub = sort_path_by_score.sort_score(total_path_sub, pathdetails_sub)
        # 이동불편지수 낮은 순 (bus)
        if total_path_bus == None or pathdetails_bus == None:
            pass
        else:
            fin_view_path_bus, fin_drf_path_bus = sort_path_by_score.sort_score(total_path_bus, pathdetails_bus)
        # 이동불편지수 낮은 순 (전체)
        total_path = sort_path_by_score.dict_to_list(total_path_subbus, total_path_sub, total_path_bus)
        total_pathdetails = pathdetails_subbus + pathdetails_sub + pathdetails_bus

        # print('len :', len(total_path))
        # print('len :', len(total_pathdetails))
        if total_path == None or total_pathdetails == None:
            pass
        else:
            fin_view_path, fin_drf_path = sort_path_by_score.sort_score(total_path, total_pathdetails)

        # drf 데이터 전달
        '''
        [0] fin_drf_path
        [1] fin_drf_path_subbus
        [2] fin_drf_path_sub
        [3] fin_drf_path_bus
        '''
        fin_total_drf_path['tot'] = fin_drf_path
        fin_total_drf_path['sub'] = fin_drf_path_sub
        fin_total_drf_path['bus'] = fin_drf_path_bus
        fin_total_drf_path['subbus'] = fin_drf_path_subbus # -> 이동불편지수 [전체, 지하철, 버스, 버스 + 지하철]

        ''' final data '''
        send_drf.append(fin_total_drf_path) # 최종 drf 전달 데이터
        # print(send_drf[0])

        return send_drf

    elif op_sort == 2:

        # 최소 시간 순

        # subbus
        if total_path_subbus == None or pathdetails_subbus == None:
            pass
        else:
            fin_view_path_subbus, fin_drf_path_subbus = sort_path_by_score.sort_time(total_path_subbus, pathdetails_subbus)

        # sub
        if total_path_sub == None or pathdetails_sub == None:
            pass
        else:
            fin_view_path_sub, fin_drf_path_sub = sort_path_by_score.sort_time(total_path_sub, pathdetails_sub)

        # bus
        if total_path_bus == None or pathdetails_bus == None:
            pass
        else:
            fin_view_path_bus, fin_drf_path_bus = sort_path_by_score.sort_time(total_path_bus, pathdetails_bus)

        # total
        total_path = sort_path_by_score.dict_to_list(total_path_subbus, total_path_sub, total_path_bus)
        total_pathdetails = pathdetails_subbus + pathdetails_sub + pathdetails_bus
        if total_path == None or total_pathdetails == None:
            pass
        else:
            fin_view_path, fin_drf_path = sort_path_by_score.sort_time(total_path, total_pathdetails)

        # drf 데이터 전달
        '''
        [0] fin_drf_path
        [1] fin_drf_path_subbus
        [2] fin_drf_path_sub
        [3] fin_drf_path_bus
        '''
        fin_total_drf_path['tot'] = fin_drf_path
        fin_total_drf_path['sub'] = fin_drf_path_sub
        fin_total_drf_path['bus'] = fin_drf_path_bus
        fin_total_drf_path['subbus'] = fin_drf_path_subbus # -> 이동불편지수 [전체, 지하철, 버스, 버스 + 지하철]

        ''' final data '''
        send_drf.append(fin_total_drf_path) # 최종 drf 전달 데이터
        # print(send_drf)

        return send_drf

    elif op_sort == 3:

        # 최소 도보 순

        # subbus
        if total_path_subbus == None or pathdetails_subbus == None:
            pass
        else:
            fin_view_path_subbus, fin_drf_path_subbus = sort_path_by_score.sort_walk(total_path_subbus, pathdetails_subbus)

        # sub
        if total_path_sub == None or pathdetails_sub == None:
            pass
        else:
            fin_view_path_sub, fin_drf_path_sub = sort_path_by_score.sort_walk(total_path_sub, pathdetails_sub)

        # bus
        if total_path_bus == None or pathdetails_bus == None:
            pass
        else:
            fin_view_path_bus, fin_drf_path_bus = sort_path_by_score.sort_walk(total_path_bus, pathdetails_bus)

        # total
        total_path = sort_path_by_score.dict_to_list(total_path_subbus, total_path_sub, total_path_bus)
        total_pathdetails = pathdetails_subbus + pathdetails_sub + pathdetails_bus
        if total_path == None or total_pathdetails == None:
            pass
        else:
            fin_view_path, fin_drf_path = sort_path_by_score.sort_walk(total_path, total_pathdetails)

        # drf 데이터 전달
        '''
        [0] fin_drf_path
        [1] fin_drf_path_subbus
        [2] fin_drf_path_sub
        [3] fin_drf_path_bus
        '''
        fin_total_drf_path['tot'] = fin_drf_path
        fin_total_drf_path['sub'] = fin_drf_path_sub
        fin_total_drf_path['bus'] = fin_drf_path_bus
        fin_total_drf_path['subbus'] = fin_drf_path_subbus # -> 이동불편지수 [전체, 지하철, 버스, 버스 + 지하철]

        ''' final data '''
        send_drf.append(fin_total_drf_path) # 최종 drf 전달 데이터
        # print(send_drf)

        return send_drf

    elif op_sort == 4:

        # 최소 환승 순
        fin_view_path_subbus = sort_path_by_score.sort_transfer(total_path_subbus)

    '''
    print('sample path results :')
    print(total_path_subbus[0])
    print()
    '''

    # [전체, 지하철, 버스, 버스 + 지하철]

    print('Done.')


main(126.94700645685643, 37.5636066932157, 127.032734543897, 37.483588810333)