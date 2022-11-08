# 요일 가져오기
def what_day_is_it(date):
    days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']
    day = date.weekday()
    #print(days[day])
    return str(days[day])

# wait_t: get_sub_wt()값
def change_to_day(wait_t):
    date_time = wait_t[0][-2]
    Day = what_day_is_it(date(date_time.year, date_time.month, date_time.day))

    return Day

# !!pip install pytimekr 필요!!
# current = datetime.datetime.now()
# print(current) -> 2022-11-08 11:53:22.783901

from pytimekr import pytimekr
from datetime import date

def is_holiday(current):
    holiday = pytimekr.holidays() # holidays 메소드는 리스트 형태로 관련값 반환
    for i in range(len(holiday)):
        if holiday[i] == current:
            datedate = 3
        else:
            ddd = str(what_day_is_it(date(current.year, current.month, current.day)))
            if ddd == 'SAT': datedate = 2
            elif ddd == 'SUN': datedate = 3
            else: datedate = 1

    return datedate


# 필요.. 없을수도..?