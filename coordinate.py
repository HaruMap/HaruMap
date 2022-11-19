def coor_transport(paths):

    coor = []

    # 경로 내에서 모든 대중교통 (환승 포함) 의 coordinate 받아오기
    for path in paths: # 하나의 경로 내 각각의 환승 point 확인

        # 지하철
        if path['trafficType'] == 1:
            for station in path['passStopList']['stations']:
                coor.append((1, float(station['x']), float(station['y'])))

        # 버스
        elif path['trafficType'] == 2:
            for station in path['passStopList']['stations']:
                coor.append((2, float(station['x']), float(station['y'])))

    return coor