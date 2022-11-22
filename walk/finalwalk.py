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

#####################################
#coor = [(3, 126.94692120208904, 37.5636933354527), (3, 126.94649623721354, 37.56382109076003), (3, 126.94649623721354, 37.56382109076003), (3, 126.94649623721354, 37.56382109076003), (3, 126.94640180844371, 37.563571118137624), (3, 126.94637126383876, 37.56328226229252), (3, 126.94629349903855, 37.563073951790315), (3, 126.94612685297993, 37.562882304424654), (3, 126.94612685297993, 37.562882304424654), (3, 126.94612685297993, 37.562882304424654), (3, 126.94607962917323, 37.5630906126879), (3, 126.94609351334162, 37.563212820947314), (3, 126.94613517236343, 37.56334891697819), (3, 126.94605739853407, 37.56346001377649), (3, 126.94605739853407, 37.56346001377649), (3, 126.94605739853407, 37.56346001377649), (3, 126.94602128474712, 37.56367109969338), (3, 126.94606849818989, 37.56382941546195), (3, 126.9462018139529, 37.56402106223035), (3, 126.9462018139529, 37.56402106223035), (3, 126.9462018139529, 37.56402106223035), (3, 126.94601016192908, 37.5641210471694), (3, 126.94601016192908, 37.5641210471694), (3, 126.94601016192908, 37.5641210471694), (3, 126.94606293277644, 37.56419603939392), (3, 126.94606293277644, 37.56419603939392), (3, 126.94606293277644, 37.56419603939392)]
#url = roadview(coor) # url은 카카오로드뷰 url을 담은 리스트
#count = obD(url) # count는 경로에서 마주치는 장애물 개수 