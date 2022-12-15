from selenium import webdriver
import time
import sys
import os
import requests
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.alert import Alert

sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))
sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))))
import API.api

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

def getSlope(walkpath_list):
    
    option = Options()
    option.add_argument("disable-infobars")
    option.add_argument("disable-extensions")
    option.add_argument('disable-gpu')
    option.add_argument("headless")     # background 실행
    option.add_experimental_option("detach", True)
    option.add_experimental_option('excludeSwitches',['enable-logging'])
    # s = Service(ChromeDriverManager().install())
    # driver = webdriver.Chrome(service=s, options=option)
    driver = webdriver.Chrome(executable_path='chromedriver.exe', options=option)

    driver.get("https://webgis.neins.go.kr/popup/searchGCadastralPopup.do")
    time.sleep(0.2)
    
    new_addr = []
    for i in range(len(walkpath_list)):
        query_txt = getReGeo(walkpath_list[i][1], walkpath_list[i][2])
        new_addr.append(query_txt)
    
    new_addr = set(new_addr) # 주소 중복 제거
    new_addr = list(new_addr)
    
    try:
        for i in range(len(new_addr)):
            query_txt = new_addr[i]
            
            driver.find_element(By.ID, "queryText").click()
            element = driver.find_element(By.ID, "queryText")
            element.send_keys(query_txt)
            element.send_keys("\n")
            time.sleep(0.4)
            
            # 담기 버튼
            adress = driver.find_element(By.XPATH, '//*[@id="popupRatepoint"]/div[2]/div[3]/ul/li/a')
            driver.execute_script("arguments[0].click();", adress)
            time.sleep(0.2)

            driver.find_element(By.ID, "queryText").clear()

        # 분석 버튼
        driver.find_element(By.CLASS_NAME, 'popup_submit').click()

        # 
        try:
            alert = Alert(driver)
            alert.accept()
            
        except:
            "There is no alert"

        time.sleep(0.2)
        driver.switch_to.window(driver.window_handles[-1])
        time.sleep(0.2)

        #표 받기
        temp=[]
        table = driver.find_element(By.CLASS_NAME, "result_box1")
        tbody = table.find_element(By.XPATH, '//*[@id="popupPointdetail"]/div[2]/div[3]/div/div[2]/div/table/tbody[1]')
        rows = tbody.find_elements(By.TAG_NAME, "tr")

        for indx, value in enumerate(rows):
            body=value.find_elements(By.TAG_NAME, "td")[2]
            temp.append(body.text.strip("%"))

        driver.quit()

        temp_int = list(map(float, temp))

        slope = [0, 2.5, 7.5, 12.5, 17.5, 22.5, 27.5, 30]
        avg_slope = 0
        for i in range(len(temp_int)):
            avg_slope += 0.01 * temp_int[i] * slope[i]

        result = round(avg_slope,3)

        # 경사도 class 구분
        slope_class = 0
        if result >= 0 and result < 3:
            slope_class = 0
        elif result >=3 and result < 7:
            slope_class = 1
        elif result >= 7 and result < 10:
            slope_class = 2
        elif result >= 10:
            slope_class = 3

        ten_over = 0
        for i in range(5):
            if temp_int[i+3] > 0:
                ten_over += temp_int[i+3]
        
        return slope_class, ten_over
    
    except:
        return("x")
    
def getSlope_wheelCat(slopeCat):
    if slopeCat[0] == 0:
        return 0.5
    elif slopeCat[0] == 1:
        return 3
    elif slopeCat[0] == 2:
        return 5
    elif slopeCat[0] == 3 and slopeCat[1]<30:
        return 7
    elif slopeCat[0] == 3 and slopeCat[1] >= 30:
        return 99999


def getSlope_wheelCat(slopeCat):
    if slopeCat[0] == 0:
        return 0.5
    elif slopeCat[0] == 1:
        return 3
    elif slopeCat[0] == 2:
        return 5
    elif slopeCat[0] == 3 and slopeCat[1]<30:
        return 7
    elif slopeCat[0] == 3 and slopeCat[1] >= 30:
        return 99999
