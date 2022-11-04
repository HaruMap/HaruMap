# 도착 예정 시간(초)에 따른 weight
# wait_t는 get_bus_wt()나 get_sub_wt() 리턴값(리스트)

def weight_time(wait_t):
    wait_weight = []
    for i in range(len(wait_t)):
        if int(wait_t[i][-1]) <= 120:
            wait_weight.append(9.5)
        elif int(wait_t[i][-1]) > 120 and int(wait_t[i][-1]) <= 300:
            wait_weight.append(5)
        elif int(wait_t[i][-1]) > 300 and int(wait_t[i][-1]) <= 660:
            wait_weight.append(0.5)
        elif int(wait_t[i][-1]) > 660 and int(wait_t[i][-1]) <= 1320:
            wait_weight.append(3)
        else:
            wait_weight.append(7)

    return wait_weight

# 버스 혼잡도 (대형 버스 기준)
# 사람 수?가 input인가용??

def weight_bus(wait_c):
    bcon_weight = []
    if int(wait_c) <= 25: # 여유
        bcon_weight.append(0.5)
    elif int(wait_c) > 25 and int(wait_c) <= 40: # 보통
        bcon_weight.append(3)
    elif int(wait_c) > 40 and int(wait_c) <= 55: # 혼잡
        bcon_weight.append(7)
    else: # 매우 혼잡
        bcon_weight.append(9.5)

    return bcon_weight

# 지하철 혼잡도
# 칸마다 % input

def weight_sub(wait_c):
    scon_weight = []
    for i in range(len(wait_c)):
    if int(wait_c[i]) <= 80: # 여유
        scon_weight.append(0.5)
    elif int(wait_c[i]) > 80 and int(wait_c[i]) <= 130: # 보통
        scon_weight.append(3)
    elif int(wait_c[i]) > 130 and int(wait_c[i]) <= 150: # 주의
        scon_weight.append(5)
    elif int(wait_c[i]) > 150 and int(wait_c[i]) <= 170: # 혼잡1
        scon_weight.append(7)
    else: # 혼잡2
        scon_weight.append(9.5)
    
    return scon_weight