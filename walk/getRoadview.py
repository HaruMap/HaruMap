from selenium import webdriver
from bs4 import BeautifulSoup
import time
from urllib import request
from io import BytesIO
from PIL import Image
import matplotlib.pyplot as plt
import numpy as np

# 옵션 생성
options = webdriver.ChromeOptions()
# 창 숨기는 옵션 추가
options.add_argument("headless")
# driver = webdriver.Chrome(executable_path='C:\Project\haruzido\HaruMap\walk\chromedriver.exe', options=options)
driver = webdriver.Chrome(executable_path='C:\Project\haruzido\HaruMap\chromedriver.exe', options=options)

def getImg(x,y):

    ## 로드뷰 가져올 위경도
    lat,lng = [x,y]
    ## url에 접근한다.
    url = 'file:///C:/Project/haruzido/HaruMap/walk/roadview.html' + "?lat="+str(lat)+"&lng="+str(lng) #roadview.html과 이 파일이 같은 경로에 있어야 함
    driver.get(url)
    driver.implicitly_wait(3)
    time.sleep(3)
    html = driver.page_source
    soup = BeautifulSoup(html, 'html.parser')
    result = soup.findAll('img')

    if result != []: 
        try:
            img_left= result[0].get("src")
            img_right= result[2].get("src")
            return img_left, img_right
        except:
            return 0
    else:
        return 0

    driver.quit()
