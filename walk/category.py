def cateObj(obj, time): # 0.5:9.5 / 1분에 10개를 5점으로 기준 처리
    score = 0.5*obj/time
    if score > 9.5:
        score = 9.5
    if score < 0.5:
        score = 0.5
    return round(score,2)

def getSlope_wheelCat(slopeCat): #input 경사도, tenover
    if slopeCat[0] == 0:
        return 0.5
    elif slopeCat[0] == 1:
        return 3
    elif slopeCat[0] == 2:
        return 5
    elif slopeCat[0] == 3 and slopeCat[1]<30:
        return 7
    elif slopeCat[0] == 3 and slopeCat[1] >= 30:
        return 99999

# =================================================================================================

'''
전체 거리:  ['1.44', '1.44', '1.43', '1.43'] km
전체 소요시간:  ['20', '20', '21', '21'] min
전체 노면 정보:  [[0, 24, 24, 24, 21, 21, 21, 21, 21, 21], [0, 24, 24, 24, 21, 21, 21, 21, 21, 21], [0, 24, 24, 24, 21, 21, 21, 21, 21, 21, 21, 21], [0, 24, 24, 24, 21, 21, 21, 21, 21, 21, 21, 21]]
총 장애물 수:  [89, 125, 154, 154]
'''