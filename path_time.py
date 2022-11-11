# 대중교통 총 이동시간 (단위 : min)
def totaltime(json):
    return json['info']['totalTime']

# 대중교통 각 이동시간 (지하철, 버스, 환승도보시간)
def subtime(json):

    trans_type = []
    trans_t = []
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
    
    # 1) 지하철, 2) 버스, 3) 도보 각 이동시간 반환 (순서 반영)
    sub_t_seq, bus_t_seq, walk_t_seq, cnt = 0, 0, 0, 0
    for subpath in subpaths:
        if subpath['trafficType'] == 1:
            trans_type.append(1)
        elif subpath['trafficType'] == 2:
            trans_type.append(2)
        elif subpath['trafficType'] == 3:
            trans_type.append(3)
    # print(trans_type)

    for idx, trans_type in enumerate(trans_type):
        if trans_type == 3:
            continue
        if trans_type == 1:
            # print((1, subpaths[idx]['sectionTime']))
            trans_t.append((1, subpaths[idx]['sectionTime']))
        elif trans_type == 2:
            # print((2, subpaths[idx]['sectionTime']))
            trans_t.append((2, subpaths[idx]['sectionTime']))

    return sub_t, bus_t, walk_t, trans_t