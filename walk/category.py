def obs_val(obj, time): # 0.5:9.5 / 1분에 10개를 5점으로 기준 처리
    score = 0.5*obj/time
    if score > 9.5:
        score = 9.5
    if score < 0.5:
        score = 0.5
    return round(score,2)

def slope_val(slopeCat): #input 경사도, tenover
    if slopeCat[0] == 0:
        return 0.5
    elif slopeCat[0] == 1:
        return 3
    elif slopeCat[0] == 2:
        return 5
    elif slopeCat[0] == 3 and slopeCat[1]<30:
        return 7
    elif slopeCat[0] == 3 and slopeCat[1] >= 30:
        return 9.5

def roadtype_val(list):
    list_exc0=[]
    count=0
    res=0
    sum=0
    #0 아닌 원소를 새 list에 append
    for j in range(len(list)):
        if list[j]!=0:
            list_exc0.append(list[j])
            # 24인 원소를 새기
            if list[j]==24:
                count+=1
    
    # 0빼고도 24인 원소가 반 이상이면 9.5 취급
    if count>(len(list_exc0)/2):
            res=9.5
            return res

    for k in range(len(list_exc0)):
        if list_exc0[k]==23:
            sum=sum+0.5       #these values can be changed.
        elif list_exc0[k]==21:
            sum=sum+1.5
        elif list_exc0[k]==22:
            sum=sum+5
        elif list_exc0[k]==24:
            sum=sum+14
    res=sum/len(list_exc0)
    return round(res,3)

def time_val(time):
    if time>=0 and time<5:
        return 0.5
    elif time>=5 and time<9:
        return 3
    elif time>=9 and time<13:
        return 5
    elif time>=13 and time<17:
        return 7
    elif time>=17:
        return 9.5

# def time_val(time):
#     if time>=0 and time<:
#         return 0.5
#     elif time>=2 and time<6:
#         return 3
#     elif time>=6 and time<10:
#         return 5
#     elif time>=10 and time<13:
#         return 7
#     elif time>=13:
#         return 9.5

# =================================================================================================

'''
전체 거리:  ['1.44', '1.44', '1.43', '1.43'] km
전체 소요시간:  ['20', '20', '21', '21'] min
전체 노면 정보:  [[0, 24, 24, 24, 21, 21, 21, 21, 21, 21], [0, 24, 24, 24, 21, 21, 21, 21, 21, 21], [0, 24, 24, 24, 21, 21, 21, 21, 21, 21, 21, 21], [0, 24, 24, 24, 21, 21, 21, 21, 21, 21, 21, 21]]
총 장애물 수:  [89, 125, 154, 154]
'''
#sample data
slope=(1, 11.9)
time='20'
roadtype=[0, 24, 24, 24, 21, 21, 21, 21, 21, 21]
obs=125

wheel={'time':0.0667, 'slope':0.5333, 'roadtype':0.1333, 'obs':0.2667}

#print('weight :', wheel['slope']*time_val(float(time)))
print('weight :', wheel['time']*time_val(float(time))+wheel['slope']*slope_val(slope)+wheel['roadtype']*roadtype_val(roadtype)+wheel['obs']*obs_val(obs,float(time)))
