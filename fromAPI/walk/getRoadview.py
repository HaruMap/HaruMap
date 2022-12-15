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
driver = webdriver.Chrome(executable_path='./chromedriver.exe', options=options)

def getImg(x,y):

    ## 로드뷰 가져올 위경도
    lat,lng = [x,y]
    ## url에 접근한다.
    url = './roadview.html' + "?lat="+str(lat)+"&lng="+str(lng) 
    driver.get(url)
    # driver.implicitly_wait(3)
    time.sleep(0.5)
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
