import re
import sub_extra_descrpt

# 경로 description 정보

# 도보 (출발)
def description_ws(descrip_ws):

    fin_descrip_ws = []

    for descrip in descrip_ws:
        fin_text = []
        fin_text.append('도보')
        target = descrip.split()

        if '좌회전' in target or '우회전' in target or '직진' in target:

            for text in target:
                if text == '좌회전' or text == '우회전' or text == '직진':
                    fin_text.append(text)
                elif text == '보행자도로' or text == '횡단보도':
                    fin_text.append('보행자도로')
                elif list(text)[-1] == 'm':
                    fin_text.append(text)

            fin_descrip_ws.append(tuple(fin_text))

    return fin_descrip_ws
    

# 도보 (도착)
def description_we(descrip_we):

    fin_descrip_we = []

    for descrip in descrip_we:
        fin_text = []
        fin_text.append('도보')
        target = descrip.split()

        if '좌회전' in target or '우회전' in target or '직진' in target:

            for text in target:
                if text == '좌회전' or text == '우회전' or text == '직진':
                    fin_text.append(text)
                elif text == '보행자도로' or text == '횡단보도':
                    fin_text.append('보행자도로')
                elif list(text)[-1] == 'm':
                    fin_text.append(text)

            fin_descrip_we.append(tuple(fin_text))
    
    return fin_descrip_we

# 대중교통
def description_transport(path):

    description = []
    # print(path['subPath'])
    # print()
    total_bus_info = []
    total_sub_stationID = []

    total_linenum = []
    updown = []
    end_exit_num = []
    transfer_num = []
    end_end = []
    upupdndn = []

    new_2 = list(
            filter(lambda x: x.get('trafficType') == 1, path['subPath'])
            )
    for n in new_2:
        end_end.append(n['endID'])
        upupdndn.append(n['wayCode'])
        try:
            end_exit_num.append(n['endExitNo'])
        except:
            pass

    # 이동 경로에서 각 구간마다 description 생성 후 return
    for p in path['subPath']:

        # print(p)
        
        # subway
        if p['trafficType'] == 1:

            # print(p['wayCode'])
            # subway station ID 
            '''
            print(p['startID'])
            print(p['endID'])
            '''
            startId = p['startID']
            endID = p['endID']
            total_sub_stationID.append((startId, endID))

            # 지하철 출구 번호
            # try:
            #     end_exit_num.append(p['endExitNo'])
            # except:
            #     pass

            # 빠른 환승
            door = p['door']
            if door != 'null':
                transfer_num.append(door)
            
            # 상하행
            updown.append(p['wayCode'])

            # 이동시간
            t = p['sectionTime']
            # 경유수
            cnt = p['stationCount']
            list_station = []
            # 경유역
            stations = p['passStopList']['stations']
            list_station.append(len(stations))
            for station in stations:
                list_station.append(station['stationName'])

            # 빠른하차
            sub_fast_getout_list = [] # 지하철 빠른 하차칸 (예 - 4-1)
            sub_fast_getout_list.append(sub_extra_descrpt.fast_getout(end_end[-1], upupdndn[-1] - 1, end_exit_num[0]))

            # 승강기 위치 (출발역/환승역)
            sub_lift_loc_start = [] 
            sub_lift_loc_start.append(sub_extra_descrpt.lift_yn(p['startID']))

            # 승강기 위치 (환승역/도착역)
            sub_lift_loc_end = []
            sub_lift_loc_end.append(sub_extra_descrpt.lift_yn(p['endID']))


            descrip = []
            descrip.append('지하철')
            descrip.append(p['lane'][0]['subwayCode'])
            descrip.append(p['startName'])
            descrip.append(p['endName'])
            descrip.append(t)
            descrip.append(tuple(list_station))
            descrip.append(tuple(sub_fast_getout_list))
            descrip.append(tuple(transfer_num))
            descrip.append(tuple(sub_lift_loc_start))
            descrip.append(tuple(sub_lift_loc_end))
            # descrip = '지하철 : {0}, {1} 역, {2} 역, {3}, ({4})'.format(str(p['lane'][0]['subwayCode']), p['startName'], p['endName'], t, list_station)
            # print(descrip); print()

            description.append(tuple(descrip))

            total_linenum.append(str(p['lane'][0]['subwayCode']))
            
            

        # bus 
        elif p['trafficType'] == 2:

            # print(p)

            # 이동시간
            t = p['sectionTime']
            # 경유수
            cnt = p['stationCount']
            list_station = []
            # 경유역
            stations = p['passStopList']['stations']
            list_station.append(len(stations))
            for station in stations:
                list_station.append(station['stationName'])

            bus_list = [(bus['busNo'], '') for bus in p['lane']]

            descrip = []
            descrip.append('버스')
            descrip.append(tuple(bus_list))
            descrip.append(p['startName'])
            descrip.append(p['endName'])
            descrip.append(t)
            descrip.append(tuple(list_station))

            # descrip = '버스 : {0}, {1} 정류소, {2} 정류소, {3}, ({4})'.format(bus_list, p['startName'], p['endName'], t, str_station)
            # print(descrip); print()

            description.append(tuple(descrip))

            # startArsID : congestion parameter
            # startID : wait time parameter
            total_bus_info.append((bus_list, p['startName'], p['startArsID'], p['startID']))

        elif p['trafficType'] == 3:

            descrip = []
            descrip.append('도보')
            descrip.append('{0} m'.format(p['distance']))

            # descrip = '도보 : {0}m'.format()
            # print(descrip); print()

            description.append(tuple(descrip))

    # print(total_linenum)
    
    return description, total_bus_info, total_sub_stationID, total_linenum, updown