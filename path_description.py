# 경로 description 정보

# 도보 (출발)
def description_ws(s_description, s_name):
    for descrip in s_description:
        print(descrip)
    # print(s_name, '도착')

# 도보 (도착)
def description_we(e_description, e_name):
    for descrip in e_description:
        print(descrip)
    # print(e_name[0], '도착')

# 대중교통
def description_transport(path):

    description = []
    # print(path['subPath'])
    # print()

    # 이동 경로에서 각 구간마다 description 생성 후 return
    for p in path['subPath']:
        
        # print(p)

        if p['trafficType'] == 1:
            descrip = '지하철 {0} 호선 {1} 역 탑승 {2} 역 하차'.format(str(p['lane'][0]['subwayCode']), p['startName'], p['endName'])
            # print(descrip); print()
            description.append(descrip)
            
        elif p['trafficType'] == 2:
            bus_list = [bus['busNo'] for bus in p['lane']]
            descrip = '버스 {0} 번 {1} 정류소 탑승 {2} 정류소 하차'.format(bus_list, p['startName'], p['endName'])
            # print(descrip); print()
            description.append(descrip)

        elif p['trafficType'] == 3:
            descrip = '도보 {0} m 이동'.format(p['distance'])
            # print(descrip); print()
            description.append(descrip)

    return description