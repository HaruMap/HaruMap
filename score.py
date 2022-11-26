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

        try:
            # sub feature
            sub_cong = path_detail['subway']['congestion']
            sub_wait = path_detail['subway']['waittime'] 
            sub_path = path_detail['subway']['pathtime']
            # walk feature
            walk_path = path_detail['walk']['pathtime'] 
            walk_slope = path_detail['walk']['slope']
            walk_roadtype = path_detail['walk']['roadtype']
            walk_obj = path_detail['walk']['obstruction']

            # sub
            sub_cong_w = 0.5714
            sub_wait_w = 0.2857
            sub_path_w = 0.1429
            # walk
            walk_path_w = 0.0667
            walk_slope_w = 0.5333
            walk_roadtype_w = 0.1333
            walk_obj_w = 0.2667
            
            # transport type weight
            sub_w = 0.5714
            walk_w = 0.1429

            # respective scores
            sub_score = min(sub_cong) * sub_cong_w + sub_wait * sub_wait_w + sub_path * sub_path_w
            walk_score = walk_path * walk_path_w # + walk_slope * walk_slope_w + walk_roadtype * walk_roadtype_w + walk_obj * walk_obj_w

            score = sub_w * (sub_score) + walk_w * (walk_score)

            # print(sub_score, bus_score, walk_score)
            # print(score)

            return round(score, 4)

        except:
            return 10000 # score 계산 불가

    # 2) 버스만
    if op == 2:

        try:
            # bus feature
            bus_cong = path_detail['bus']['congestion']
            bus_wait = path_detail['bus']['waittime']
            bus_path = path_detail['bus']['pathtime']
            # walk feature
            walk_path = path_detail['walk']['pathtime'] 
            walk_slope = path_detail['walk']['slope']
            walk_roadtype = path_detail['walk']['roadtype']
            walk_obj = path_detail['walk']['obstruction']

            # bus
            bus_cong_w = 0.5714
            bus_wait_w = 0.2857
            bus_path_w = 0.1429
            # walk
            walk_path_w = 0.0667
            walk_slope_w = 0.5333
            walk_roadtype_w = 0.1333
            walk_obj_w = 0.2667
            
            # transport type weight
            bus_w = 0.2857
            walk_w = 0.1429

            # respective scores
            bus_score = bus_cong * bus_cong_w + min(bus_wait) * bus_wait_w + bus_path * bus_path_w
            walk_score = walk_path * walk_path_w # + walk_slope * walk_slope_w + walk_roadtype * walk_roadtype_w + walk_obj * walk_obj_w

            score = bus_w * (bus_score) + walk_w * (walk_score)

            # print(sub_score, bus_score, walk_score)
            # print(score)

            return round(score, 4)

        except:
            return 10000

    # 3) 지하철 + 버스
    if op == 3:

        try:
            # sub feature
            sub_cong = path_detail['subway']['congestion'] 
            sub_wait = path_detail['subway']['waittime']
            sub_path = path_detail['subway']['pathtime']
            # bus feature
            bus_cong = path_detail['bus']['congestion']
            bus_wait = path_detail['bus']['waittime'] 
            bus_path = path_detail['bus']['pathtime'] 
            # walk feature
            walk_path = path_detail['walk']['pathtime'] 
            walk_slope = path_detail['walk']['slope']
            walk_roadtype = path_detail['walk']['roadtype']
            walk_obj = path_detail['walk']['obstruction']

            # sub
            sub_cong_w = 0.5714
            sub_wait_w = 0.2857
            sub_path_w = 0.1429
            # bus
            bus_cong_w = 0.5714
            bus_wait_w = 0.2857
            bus_path_w = 0.1429
            # walk
            walk_path_w = 0.0667
            walk_slope_w = 0.5333
            walk_roadtype_w = 0.1333
            walk_obj_w = 0.2667
            
            # transport type weight
            sub_w = 0.5714
            bus_w = 0.2857
            walk_w = 0.1429

            # respective scores
            sub_score = min(sub_cong) * sub_cong_w + sub_wait * sub_wait_w + sub_path * sub_path_w
            bus_score = bus_cong * bus_cong_w + min(bus_wait) * bus_wait_w + bus_path * bus_path_w
            walk_score = walk_path * walk_path_w # + walk_slope * walk_slope_w + walk_roadtype * walk_roadtype_w + walk_obj * walk_obj_w

            score = sub_w * (sub_score) + bus_w * (bus_score) + walk_w * (walk_score)

            # print(sub_score, bus_score, walk_score)
            # print(score)

            return round(score, 4)
        
        except:
            return 10000

# 유아차 이용자, 다리 다친 사람 등
def score_type2(path_detail):

    score = 0

    return score
