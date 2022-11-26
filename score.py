# 이동불편지수 산출

wheel={
    "bus": {
        "bus" : 0.2857,
        "travel_time" : 0.1429,
        "congestion": 0.5714,
        "wait_time": 0.2857,
    },
    "subway": {
        "subway" : 0.5714,
        "travel_time" : 0.1429,
        "congestion": 0.5714,
        "wait_time": 0.2857,
    },
    "walk": {
        "walk" : 0.1429,
        "travel_time" : 0.0667,
        "slope" : 0.5333,
        "roadtype" : 0.1333,
        "objects" : 0.2667,
    },
}

norm ={
    "bus": {
        "bus" : 0.2857,
        "travel_time" : 0.2857,
        "congestion": 0.1429,
        "wait_time": 0.5714,
    },
    "subway": {
        "subway" : 0.5714,
        "travel_time" : 0.5714,
        "congestion": 0.1429,
        "wait_time": 0.2857,
    },
    "walk": {
        "walk" : 0.1429,
        "travel_time" : 0.5333,
        "slope" : 0.2667,
        "roadtype" : 0.1333,
        "objects" : 0.0667,
    },
}
etc ={
    "bus": {
        "bus" : 0.2857,
        "travel_time" : 0.1429,
        "congestion": 0.2857,
        "wait_time": 0.5714,
    },
    "subway": {
        "subway" : 0.5714,
        "travel_time" : 0.1429,
        "congestion": 0.2857,
        "wait_time": 0.5714,
    },
    "walk": {
        "walk" : 0.1429,
        "travel_time" : 0.5333,
        "slope" : 0.2667,
        "roadtype" : 0.1333,
        "objects" : 0.0667,
    },
}

user_weight = [etc,etc,wheel,etc,norm,wheel]
# 휠체어 이용자
def score_type(path_detail, op, user):

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
            sub_cong_w = user_weight[user]["subway"]["congestion"]
            sub_wait_w = user_weight[user]["subway"]["wait_time"]
            sub_path_w = user_weight[user]["subway"]["travel_time"]
            # walk
            walk_path_w = user_weight[user]["walk"]["travel_time"]
            walk_slope_w = user_weight[user]["walk"]["slope"]
            walk_roadtype_w = user_weight[user]["walk"]["roadtype"]
            walk_obj_w = user_weight[user]["walk"]["objects"]
            
            # transport type weight
            sub_w = user_weight[user]["subway"]["subway"]
            walk_w = user_weight[user]["walk"]["walk"]

            # respective scores
            sub_score = min(sub_cong) * sub_cong_w + sub_wait * sub_wait_w + sub_path * sub_path_w
            walk_score = walk_path * walk_path_w  + walk_slope * walk_slope_w + walk_roadtype * walk_roadtype_w + walk_obj * walk_obj_w

            score = sub_w * (sub_score) + walk_w * (walk_score)


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
            bus_cong_w = user_weight[user]["bus"]['congestion']
            bus_wait_w = user_weight[user]["bus"]["wait_time"]
            bus_path_w = user_weight[user]["bus"]["travel_time"]
            # walk
            walk_path_w = user_weight[user]["walk"]["travel_time"]
            walk_slope_w = user_weight[user]["walk"]["slope"]
            walk_roadtype_w = user_weight[user]["walk"]["roadtype"]
            walk_obj_w = user_weight[user]["walk"]["objects"]
            
            # transport type weight
            bus_w = user_weight[user]['bus']['bus']
            walk_w = user_weight[user]["walk"]["walk"]

            # respective scores
            bus_score = bus_cong * bus_cong_w + min(bus_wait) * bus_wait_w + bus_path * bus_path_w
            walk_score = walk_path * walk_path_w  + walk_slope * walk_slope_w + walk_roadtype * walk_roadtype_w + walk_obj * walk_obj_w

            score = bus_w * (bus_score) + walk_w * (walk_score)

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
            sub_cong_w = user_weight[user]["subway"]["congestion"]
            sub_wait_w = user_weight[user]["subway"]["wait_time"]
            sub_path_w = user_weight[user]["subway"]["travel_time"]
            # walk
            walk_path_w = user_weight[user]["walk"]["travel_time"]
            walk_slope_w = user_weight[user]["walk"]["slope"]
            walk_roadtype_w = user_weight[user]["walk"]["roadtype"]
            walk_obj_w = user_weight[user]["walk"]["objects"]
            # walk
            walk_path_w = user_weight[user]["walk"]["travel_time"]
            walk_slope_w = user_weight[user]["walk"]["slope"]
            walk_roadtype_w = user_weight[user]["walk"]["roadtype"]
            walk_obj_w = user_weight[user]["walk"]["objects"]
            
            # transport type weight
            sub_w = user_weight[user]["subway"]["subway"]
            bus_w = user_weight[user]['bus']['bus']
            walk_w = user_weight[user]["walk"]["walk"]

            # respective scores
            sub_score = min(sub_cong) * sub_cong_w + sub_wait * sub_wait_w + sub_path * sub_path_w
            bus_score = bus_cong * bus_cong_w + min(bus_wait) * bus_wait_w + bus_path * bus_path_w
            walk_score = walk_path * walk_path_w + walk_slope * walk_slope_w + walk_roadtype * walk_roadtype_w + walk_obj * walk_obj_w

            score = sub_w * (sub_score) + bus_w * (bus_score) + walk_w * (walk_score)


            return round(score, 4)
        
        except:
            return 10000

