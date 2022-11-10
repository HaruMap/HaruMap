import re

# 경로 description 정보

# 도보 (출발)
def description_ws(descrip_ws):

    fin_descrip_ws = []

    for descrip in descrip_ws:
        fin_text = ''
        target = descrip.split()

        if '좌회전' in target or '우회전' in target or '직진' in target:

            for text in target:
                if text == '좌회전' or text == '우회전' or text == '직진':
                    fin_text += '도보 : {0}'.format(text)
                elif text == '보행자도로':
                    fin_text += ' 보행자도로'
                elif list(text)[-1] == 'm':
                    fin_text += ' {0}'.format(text)

            fin_descrip_ws.append(fin_text)

    return fin_descrip_ws
    

# 도보 (도착)
def description_we(descrip_we):

    fin_descrip_we = []

    for descrip in descrip_we:
        fin_text = ''
        target = descrip.split()

        if '좌회전' in target or '우회전' in target or '직진' in target:

            for text in target:
                if text == '좌회전' or text == '우회전' or text == '직진':
                    fin_text += '도보 : {0}'.format(text)
                elif text == '보행자도로':
                    fin_text += ' 보행자도로'
                elif list(text)[-1] == 'm':
                    fin_text += ' {0}'.format(text)

            fin_descrip_we.append(fin_text)
    
    return fin_descrip_we

# 대중교통
def description_transport(path):

    description = []
    # print(path['subPath'])
    # print()
    total_bus_info = []

    # 이동 경로에서 각 구간마다 description 생성 후 return
    for p in path['subPath']:
        
        # print(p)

        if p['trafficType'] == 1:
            descrip = '지하철 : {0}, {1} 역, {2} 역'.format(str(p['lane'][0]['subwayCode']), p['startName'], p['endName'])
            # print(descrip); print()
            description.append(descrip)
            
        elif p['trafficType'] == 2:
            bus_list = [bus['busNo'] for bus in p['lane']]
            descrip = '버스 : {0}, {1} 정류소, {2} 정류소'.format(bus_list, p['startName'], p['endName'])
            # print(descrip); print()
            description.append(descrip)
            # startArsID : congestion parameter
            # startID : wait time parameter
            total_bus_info.append((bus_list, p['startName'], p['startArsID'], p['startID']))

        elif p['trafficType'] == 3:
            descrip = '도보 : {0}m'.format(p['distance'])
            # print(descrip); print()
            description.append(descrip)

    return description, total_bus_info