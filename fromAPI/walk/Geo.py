# import pandas as pd
import requests 
# import sys
# import json
# import datetime 
# import folium
# from folium.plugins import MarkerCluster
# from folium.plugins import MiniMap


def geoCoding(searching):
    
    coord = [] 
    url = 'https://dapi.kakao.com/v2/local/search/keyword.json?query={}'.format(searching)
    headers = {
        "Authorization": "KakaoAK KEY값"
    }
    places = requests.get(url, headers = headers).json()['documents']
    coord.append(places[0]['x'])
    coord.append(places[0]['y'])
    return(coord)