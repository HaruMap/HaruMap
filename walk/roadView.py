from selenium import webdriver
from bs4 import BeautifulSoup
import time
from urllib import request
from io import BytesIO
from PIL import Image
import matplotlib.pyplot as plt
import numpy as np

def getImage(x,y):
    # 옵션 생성
    options = webdriver.ChromeOptions()
    # 창 숨기는 옵션 추가
    options.add_argument("headless")
    driver = webdriver.Chrome('./chromedriver.exe',options=options) #크롬드라이버와 이 파일이 같은 경로에 있어야 함

    ## 로드뷰 가져올 위경도
    lat,lng = [x, y]
    ## url에 접근한다.
    url = 'http://localhost:8080/roadview.html' + "?lat="+str(lat)+"&lng="+str(lng) #roadview.html과 이 파일이 같은 경로에 있어야 함
    driver.get(url)
    driver.implicitly_wait(3)
    time.sleep(3)
    html = driver.page_source
    soup = BeautifulSoup(html, 'html.parser')
    result = soup.findAll('img')

    print(result)
    for i in range(6):
        #left,front,right,back,top,bottom
        imgurl = result[i].get("src")
        res = request.urlopen(imgurl).read()
        img = Image.open(BytesIO(res))
        image = np.array(img)
        plt.imshow(image)
        plt.show()

    driver.quit()