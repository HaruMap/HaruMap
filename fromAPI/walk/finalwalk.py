from walk.getRoadview import getImg
from walk.detect import detect
    
# =============================== 카카오 로드뷰 불러오기 =========================
def coor2img(coor, imglist):
    for j in range(len(coor)):
        try:
            left, right = getImg(coor[j][2], coor[j][1])
            if j == 0:
                imglist.append(left)
                imglist.append(right)

            else:
                #중복제거
                leftflag, rightflag = 'True', 'True'
                for existurl in imglist:
                    if left[25:-9] in existurl:
                        leftflag = 'False'

                    if right[25:-9] in existurl:
                        rightflag = 'False'

                if leftflag == 'True':
                    imglist.append(left)
                if rightflag == 'True':
                    imglist.append(right)
        except:
            continue
            
### main ### 
def roadview(coor): #input은 위와 같음
    url = [] #이미지 저장
    coor2img(coor,url)
    print("경로상 로드뷰 이미지\n",url)
    return url

def getmodel(model):
    return model
# =============================== Object Detection ===============================
def getObj(model,imglist, obj):
    for url in imglist:
        obj_dict = detect(model,url) #로드뷰에서 물체정보 dict 받아옴
        for keys in obj_dict.keys(): #obs에 추가하여 정리
            if keys in ['traffic_sign', 'traffic_light', 'table', 'stop', 'potted_plant','barricade']:
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

### main ### 
def obD(model,url): #input은 위의 카카오로드뷰로 얻은 url 리스트
    obs = {}
    getObj(model, url, obs)
    print("\n총 장애물: ", obs)
    obj = objCount(obs)
    print("경로에서 마주치는 총 장애물 개수: ", obj)
    return obj

