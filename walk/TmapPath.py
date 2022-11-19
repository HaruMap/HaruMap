from path import getPath
from getRoadview import getImg
from detect import detect
from avg_slope import getSlope

# import requests
# import json
# import re
# from json import loads
# from geopy.geocoders import Nominatim



# ========== Tmap API로 출발지, 도착지 입력 ==============

def coor2img(coor, imglist):
    for j in range(len(coor)):
        try:
            left, right = getImg(coor[j][0], coor[j][1])
            if j == 0:
                imglist.append(left)
                imglist.append(right)
            else:
                #중복제거
                for existurl in imglist:
                    if left[25:-9] not in existurl:
                        leftflag = 'True'
                    else:
                        leftflag = 'False'

                    if right[25:-9] not in existurl:
                        rightflag = 'True'
                    else:
                        rightflag = 'False'

                if leftflag == 'True':
                    imglist.append(left)
                if rightflag == 'True':
                    imglist.append(right)
        except:
            print('shit')
            continue
                

def getObj(imglist, obj):
    for url in imglist:
        obj_dict = detect(url) #로드뷰에서 물체정보 dict 받아옴
        for keys in obj_dict.keys(): #obs에 추가하여 정리
            if keys in xlist:
                continue
            else:
                if keys in obj:
                    obj[keys] += obj_dict[keys]
                else:
                    obj[keys] = obj_dict[keys]

def objCount(dict):
    count = 0
    for keys in list(dict.keys()):
        count += dict[keys]
    return count

# =============================== 1. 도보 경로 얻기 ===============================
depart = input('출발지: ')
dest = input('도착지: ')
# searchOpt = input('[추천 : 0, 추천+대로우선 : 4, 최단 : 10, 최단거리+계단제외 : 30] 선택: ') 
# searchOption = {0: '추천', 4: '추천+대로우선', 10:'최단', 30: '최단거리+계단제외'}
searchOpt = [0, 4, 10, 30]

totalTime, totalDist, totalCoord, totalDescrip, totalRoad, totalImage, totalObj, totalSlope = [], [], [], [], [], [], [], []

for i in searchOpt:
    Time, Dist, Coord, Descrip, Road = getPath(depart, dest, i)
    totalTime.append(Time)
    totalDist.append(Dist)
    totalCoord.append(Coord)
    totalDescrip.append(Descrip)
    totalRoad.append(Road)

# =============================== 2. 카카오 로드뷰 불러오기 ===============================
    image = [] #이미지 저장

    coor2img(Coord,image)
    print("경로상 로드뷰 이미지\n",image)
    totalImage.append(image)


# =============================== 3. Object Detection ===============================
    totalObs = 0
    obs = {}

    xlist = ['traffic_sign', 'traffic_light', 'table', 'stop', 'potted_plant','barricade']

    getObj(image, obs)
    print("\n총 장애물: ", obs)

    obj = objCount(obs)
    print("경로에서 마주치는 총 장애물 개수: ", obj)
    totalObj.append(obj)

    # totalObs = s_obj + e_obj

# =============================== 4. 전체 경로 경사도 얻기 ===============================
    slope = []
    totalSlope.append(getSlope(Coord))
    # totalSlope.append(slope)

list = ['추천', '추천+대로우선','최단', '최단거리+계단제외']

print(f'\n================ {depart}부터 {dest}까지의 경로 ================')
for i in range(len(list)):
    print('전체 거리: ', totalDist[i], 'km')
    print('전체 소요시간: ', totalTime[i],'min')
    print('전체 노면 정보: ', totalRoad[i])
    print('전체 좌표: ', totalCoord[i],)
    print('경로 설명: ', totalDescrip[i])
    print('총 장애물 수: ', totalObj[i])
    print('총 경사도: ', totalSlope[i])
    print('================================================================\n')

