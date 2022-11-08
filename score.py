# 이동불편지수 산출

# 휠체어 이용자
def score_type1(path_detail, op):

    # 이동불편지수 산출

    # feature & weight
    '''
    1) 지하철 혼잡도
    2) 지하철 대기시간
    3) 지하철 이동시간
    1) 버스 혼잡도
    2) 버스 대기시간
    3) 버스 이동시간
    1) 도보 이동시간
    -) 도보 경사도/장애물/이용시설/노면
    '''
    # print(path_detail)

    # 1) 지하철만
    if op == 1:

        sub_cong = path_detail['subway']['congestion'] # 반영
        sub_wait = path_detail['subway']['waittime'] 
        sub_path = path_detail['subway']['pathtime'] # 반영
        walk_path = path_detail['walk']['pathtime'] # 반영

        sub_cong_w = 3.49
        sub_wait_w = 3.6
        sub_path_w = 2.0
        walk_path_w = (2.66 + 2.83) / 2
        
        # transport type weight
        '''
        sub, bus, walk = 0.688, 0.886, 0.477
        '''
        sub_w = 0.688
        walk_w = 0.447

        # respective scores
        sub_score = min(sub_cong) * sub_cong_w + sub_wait * sub_wait_w + sub_path * sub_path_w
        walk_score = walk_path * walk_path_w

        score = sub_w * (sub_score) + walk_w * (walk_score)

        # print(sub_score, bus_score, walk_score)
        # print(score)

        return round(score, 2)

    # 2) 버스만
    if op == 2:

        bus_cong = path_detail['bus']['congestion']
        bus_wait = path_detail['bus']['waittime'] # 반영
        bus_path = path_detail['bus']['pathtime'] # 반영
        walk_path = path_detail['walk']['pathtime'] # 반영

        bus_cong_w = 3.49
        bus_wait_w = 3.6
        bus_path_w = 2.0
        walk_path_w = (2.66 + 2.83) / 2
        
        # transport type weight
        '''
        sub, bus, walk = 0.688, 0.886, 0.477
        '''
        bus_w = 0.886
        walk_w = 0.447

        # respective scores
        bus_score = bus_cong * bus_cong_w + min(bus_wait) * bus_wait_w + bus_path * bus_path_w
        walk_score = walk_path * walk_path_w

        score = bus_w * (bus_score) + walk_w * (walk_score)

        # print(sub_score, bus_score, walk_score)
        # print(score)

        return round(score, 2)

    # 3) 지하철 + 버스
    if op == 3:

        sub_cong = path_detail['subway']['congestion'] # 반영
        sub_wait = path_detail['subway']['waittime'] 
        sub_path = path_detail['subway']['pathtime'] # 반영
        bus_cong = path_detail['bus']['congestion']
        bus_wait = path_detail['bus']['waittime'] # 반영
        bus_path = path_detail['bus']['pathtime'] # 반영
        walk_path = path_detail['walk']['pathtime'] # 반영

        sub_cong_w = 3.49
        sub_wait_w = 3.6
        sub_path_w = 2.0
        bus_cong_w = 3.49
        bus_wait_w = 3.6
        bus_path_w = 2.0
        walk_path_w = (2.66 + 2.83) / 2
        
        # transport type weight
        '''
        sub, bus, walk = 0.688, 0.886, 0.477
        '''
        sub_w = 0.688
        bus_w = 0.886
        walk_w = 0.447

        # respective scores
        sub_score = min(sub_cong) * sub_cong_w + sub_wait * sub_wait_w + sub_path * sub_path_w
        bus_score = bus_cong * bus_cong_w + min(bus_wait) * bus_wait_w + bus_path * bus_path_w
        walk_score = walk_path * walk_path_w

        score = sub_w * (sub_score) + bus_w * (bus_score) + walk_w * (walk_score)

        # print(sub_score, bus_score, walk_score)
        # print(score)

        return round(score, 2)

# 유아차 이용자, 다리 다친 사람 등
def score_type2(path_detail):

    score = 0

    return score
