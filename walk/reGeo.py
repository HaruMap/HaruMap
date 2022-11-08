import pandas as pd
import requests 
import json
import sys
import os
import datetime 
import folium
from folium.plugins import MarkerCluster
from folium.plugins import MiniMap

sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))
sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))))
import API.api

def reGeo_function():
    x=input('위도 : ')
    y=input('경도 : ')

    url =  'https://dapi.kakao.com/v2/local/geo/coord2address.json?x={0}&y={1}&input_coord=WGS84'.format(x, y)
    headers = {
        "Authorization": '{0}'.format(API.api.path_walk_key()),
    }
    places = requests.get(url, headers = headers).json()['documents']

    print(places[0]['address']['address_name'])

def getReGeo(x, y):
    
    # print('Done. (getReGeo)')

    url =  'https://dapi.kakao.com/v2/local/geo/coord2address.json?x={0}&y={1}&input_coord=WGS84'.format(x, y)
    headers = {
        "Authorization": '{0}'.format(API.api.getReGeo_key()),
    }

    # print('Done. (url)')
    # print(requests.get(url, headers=headers).json())

    places = requests.get(url, headers=headers).json()['documents']

    # print('Done. (places)')

    return(places[0]['address']['address_name'])