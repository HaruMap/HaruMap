# 대중교통 총 이동시간 (단위 : min)
def totaltime(json):
    return json['info']['totalTime']

# 대중교통 각 이동시간 (지하철, 버스, 환승도보시간)
def subtime(json):

    subpaths = json['subPath']
    bus_t = 0
    sub_t = 0
    walk_t = 0

    # print(subpaths)

    # 1) 지하철, 2) 버스, 3) 도보 각 이동시간 반환
    for subpath in subpaths:
        if subpath['trafficType'] == 1: # 1) 지하철
            sub_t += subpath['sectionTime']
        elif subpath['trafficType'] == 2: # 2) 버스
            bus_t += subpath['sectionTime']
        elif subpath['trafficType'] == 3: # 3) 도보
            walk_t += subpath['sectionTime']

    return sub_t, bus_t, walk_t 