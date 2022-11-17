import API_path_walk

from avg_slope import getSlope
from getRoadview import getImg
from detect import detect

'''[{'address_name': '서울 서대문구 대현동 11-1',
  'category_group_code': '',
  'category_group_name': '',
  'category_name': '교육,학문 > 학교부속시설',
  'distance': '',
  'id': '1716999305',
  'phone': '02-3277-2114',
  'place_name': '이화여자대학교 연구협력관',
  'place_url': 'http://place.map.kakao.com/1716999305',
  'road_address_name': '서울 서대문구 이화여대길 52',
  'x': '126.9497992174468',
  'y': '37.56796693225186'},

  [{'address_name': '서울 마포구 염리동 8-85',
  'category_group_code': 'SW8',
  'category_group_name': '지하철역',
  'category_name': '교통,수송 > 지하철,전철 > 수도권2호선',
  'distance': '',
  'id': '21160628',
  'phone': '02-6110-2411',
  'place_name': '이대역 2호선',
  'place_url': 'http://place.map.kakao.com/21160628',
  'road_address_name': '서울 마포구 신촌로 지하 180',
  'x': '126.94642954546576',
  'y': '37.556814718869'},

[{'address_name': '서울 용산구 동자동 43-205',
  'category_group_code': '',
  'category_group_name': '',
  'category_name': '교통,수송 > 기차,철도 > 기차역 > KTX정차역',
  'distance': '',
  'id': '9113903',
  'phone': '1544-7788',
  'place_name': '서울역',
  'place_url': 'http://place.map.kakao.com/9113903',
  'road_address_name': '서울 용산구 한강대로 405',
  'x': '126.970606917394',
  'y': '37.5546788388674'}
[{'address_name': '서울 중구 남대문로5가 541',
  'category_group_code': 'PO3',
  'category_group_name': '공공기관',
  'category_name': '사회,공공기관 > 외국기관 > 대사관,영사관,외국공관',
  'distance': '',
  'id': '588112976',
  'phone': '02-748-4114',
  'place_name': '주한독일대사관',
  'place_url': 'http://place.map.kakao.com/588112976',
  'road_address_name': '서울 중구 한강대로 416',
  'x': '126.97398152773339',
  'y': '37.5552094173624'}, '''

# op 경로탐색 옵션 { 0: 추천 (기본값), 4: 추천+대로우선, 10: 최단, 30: 최단거리+계단제외}
s_t, s_d, s_coor, s_descrip, s_roadType = API_path_walk.path_walk(126.9497992174468,37.56796693225186,126.94642954546576 ,37.556814718869, op=30) # 출발지 -> 인근 출발 정류소 경로
e_t, e_d, e_coor, e_descrip, e_roadType = API_path_walk.path_walk(126.970606917394,37.5546788388674,126.97398152773339,37.5552094173624, op=30) # 인근 도착 정류소 -> 도착지 경로

'''
try:
    s_t, s_d, s_coor, s_descrip, s_roadType = API_path_walk.path_walk(w_sx, w_sy, sy, sx, op=30) # 출발지 -> 인근 출발 정류소 경로
    e_t, e_d, e_coor, e_descrip, e_roadType = API_path_walk.path_walk(ey, ex, w_ex, w_ey, op=30) # 인근 도착 정류소 -> 도착지 경로
except:
    continue # 위/경도로 도보 경로가 반환되지 않는다면 cotinue (: 다음 경로 탐색)
'''

# 도로타입 정보 : 21: 차도와 인도가 분리되어 있으며 정해진 횡단구역으로만 횡단 가능한 보행자 도로, 
#                 22: 차도와 인도가 분리되어 있지 않거나, 보행자 횡단에 제약이 없는 보행자도로, 
#                 23: 차량 통행이 불가능한 보행자도로,
#                 24: 쾌적하지 않은 도로

print("-------------------------------- 출발지-근처 정류장까지의 정보 --------------------------------")
print("전체 보행좌표: ", s_coor)
print('전체 노면 정보: ', s_roadType)
print('전체 거리: ', s_d, 'km')
print('전체 소요시간: ', s_t,'min')
print('길 안내 정보: ',s_descrip)

print("\n\n-------------------------------- 근처 정류장-도착지까지의 정보 --------------------------------")
print("전체 보행좌표: ", e_coor)
print('전체 노면 정보: ', e_roadType)
print('전체 거리: ', e_d, 'km')
print('전체 소요시간: ', e_t,'min')
print('길 안내 정보: ',e_descrip)
print('\n')

# =============================== 1. 전체 경로 경사도 얻기 ===============================
s_slope, e_slope = [], []

def coor2slope(coor, slopeList):
  for i in range(len(coor)):
    print(i+1,'/',len(coor), end=' ')
    slope = getSlope(coor[i][1], coor[i][0])
    if type(slope) == int: 
      slopeList.append(slope)

coor2slope(s_coor, s_slope)
coor2slope(e_coor, e_slope)

# 경사도 = 3인 경우, 보행 어려움
print("\n\n출발지-근처 정류장까지의 경사도\n", s_slope)
print("\n근처 정류장-도착지까지의 경사도\n", e_slope)


# # =============================== 2. 카카오 로드뷰 불러오기 ===============================
s_image, e_image = [], [] #이미지 저장
def coor2img(coor, imglist):
  for j in range(len(coor)):
        try:
            left, right = getImg(coor[j][0], coor[j][1])
            imglist.append(left)
            imglist.append(right)
        except:
            continue

coor2img(s_coor, s_image)
coor2img(e_coor, e_image)

print("\n출발지-근처 정류장까지의 로드뷰 이미지\n",s_image)
print("\n근처 정류장-도착지까지의 로드뷰 이미지\n",e_image)

# =============================== 3. Object Detection ===============================
totalObs = 0
e_obs,s_obs = {},{}

xlist = ['traffic_sign', 'traffic_light', 'table', 'stop', 'potted_plant', 'chair', 'barricade']

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

getObj(s_image, s_obs)
getObj(e_image, e_obs)


print("\n출발지-근처 정류장까지의 총 장애물: ", s_obs)
print("\n근처 정류장-도착지까지의 총 장애물: ", e_obs)

def objCount(dict):
    count = 0
    for keys in list(dict.keys()):
        count += dict[keys]
    return count

print("출발지-근처 정류장 경로에서 마주치는 총 장애물 개수: ", objCount(s_obs))
print("근처 정류장-도착지 경로에서 마주치는 총 장애물 개수: ", objCount(e_obs))

totalObs = objCount(s_obs) + objCount(e_obs)

