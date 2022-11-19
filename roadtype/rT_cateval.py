def roadType_val(list):
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

    return res



#main
#list=[0, 23, 23, 0, 0, 22, 22, 23, 23, 0, 22, 22]
#list=[0,0,0,0,22,22,22,22,22,22,24,24,24,24]
#list=[21, 22, 23, 0,  0, 22, 23, 22, 24, 24, 0, 0, 0]
list=[23,23,23,23,23,23,0,23,0]

roadType_val(list)

print(roadType_val(list))

