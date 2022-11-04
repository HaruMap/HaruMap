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


# 필요.. 없을수도..?