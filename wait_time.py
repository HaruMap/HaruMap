import API_bus_arrival

# 지하철 대기시간 (단위 : sec)
def get_sub_wt():
    return

# 버스 대기시간 (단위 : sec)
def get_bus_wt(stationID, lowBus):
    
    bus_arrival = API_bus_arrival.get_bus_real_time(stationID, lowBus)
    
    busnum_and_wt = []
    bus_list = bus_arrival['result']['real']

    # print(bus_list)

    for idx, bus in enumerate(bus_list):
        try:
            # print(bus['arrival1'])
            # print(bus['arrival2'])
            busnum_and_wt.append((bus['arrival1']['busPlateNo'], bus['arrival1']['arrivalSec']))
            busnum_and_wt.append((bus['arrival2']['busPlateNo'], bus['arrival2']['arrivalSec']))
        except:
            try:
                # print(bus['arrival1'])
                busnum_and_wt.append((bus['arrival1']['busPlateNo'], bus['arrival1']['arrivalSec']))
            except:
                # print(bus['arrival2'])
                busnum_and_wt.append((bus['arrival2']['busPlateNo'], bus['arrival2']['arrivalSec']))

    return list(set(busnum_and_wt))

# print(get_bus_wt('103948', '0')) # 파라미터 예 : stationID 102155 & 일반버스/저상버스 모두 포함