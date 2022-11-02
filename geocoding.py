from geopy.geocoders import Nominatim

geo_local = Nominatim(user_agent='South Korea') # 도로명 주소 위경도로 변환

# 위경도 반환 함수
def geocoding(address):

    try:
        geo = geo_local.geocode(address) # 입력된 주소에 대해
        x_y = [geo.latitude, geo.longitude]
        return x_y # 적절한 위경도 반환

    except:
        return [0, 0] # 주소가 올바르지 않으면 [0, 0] 반환