from avg_slope_upgrade import getSlope
from finalwalk import roadview,obD
import torch
from category import *


coor = [(126.94692120208904, 37.5636933354527), (126.94649623721354, 37.56382109076003), (126.94649623721354, 37.56382109076003), (126.94649623721354, 37.56382109076003),
 (126.94640180844371, 37.563571118137624), (126.94637126383876, 37.56328226229252), (126.94629349903855, 37.563073951790315) ]
 
people={'time':0.0667, 'slope':0.5333, 'roadtype':0.1333, 'obs':0.2667}

def get_walkscore(coor, people):
    # 경사도
    slope = getSlope(coor) 

    # 장애물
    model = torch.load("model.pt")
    url = roadview(coor) # url은 카카오로드뷰 url을 담은 리스트
    obscount = obD(model,url) # count는 경로에서 마주치는 장애물 개수 
    # 카테고리 변수
    slopecat = slope_val(slope) # 경사도
    obscat = obs_val(obscount,len(coor)) # 장애물
    timecat = time_val(len(coor)) # 이동시간

    # 이동 불편 지수
    discomfort = people['time']*timecat+people['slope']*slopecat+people['obs']*obscat

    return discomfort

# 이동 불편지수 계산
print("weight: ", get_walkscore(coor,people))

