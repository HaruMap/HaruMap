import datetime
from fromAPI import API_sub_congestion, day
from datetime import date
import scoring.classification

now = datetime.datetime.now()
# print(now)

d = str(day.what_day_is_it(date(now.year, now.month, now.day))) # 요일
h = int(now.hour)
m = 10 * (int(now.minute) // 10)
# print(d, h, m)

# path를 loop 하면서 지하철 혼잡도 avg
def sub_avg_congestion(paths):

    global d, h, m
    sum_congestion = []
    cnt = 0

    for idx, path in enumerate(paths):
        # print(path)

        if path['trafficType'] == 1: # 지하철
            # print(path['lane'])

            stationCode = path['passStopList']['stations'][0]['stationID']

            if path['wayCode'] == 1: # 상행
                updown = 0
            elif path['wayCode'] == 2: # 하행
                updown = 1

            congestion_ = API_sub_congestion.sub_congestion(stationCode, d, h, updown, m) # 추후 대기시간 반영
            cnt += 1
            
            min_cong = min(congestion_)
            sum_congestion.append(min_cong)
            # print(congestion_)

    max_cong = max(sum_congestion)
    # print(avg_congestion)

    return max_cong
        

