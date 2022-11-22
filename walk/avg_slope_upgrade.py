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
    driver = webdriver.Chrome(executable_path='C:\Project\haruzido\HaruMap\walk\chromedriver.exe', options=option)

    driver.get("https://webgis.neins.go.kr/popup/searchGCadastralPopup.do")
    time.sleep(1)
    
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
            time.sleep(1)
            
            # 담기 버튼
            adress = driver.find_element(By.XPATH, '//*[@id="popupRatepoint"]/div[2]/div[3]/ul/li/a')
            driver.execute_script("arguments[0].click();", adress)
            time.sleep(0.5)

            driver.find_element(By.ID, "queryText").clear()

        # 분석 버튼
        driver.find_element(By.CLASS_NAME, 'popup_submit').click()

        # 
        try:
            alert = Alert(driver)
            alert.accept()
            
        except:
            "There is no alert"

        time.sleep(1)
        driver.switch_to.window(driver.window_handles[-1])
        time.sleep(1)

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

# a = [(3, 126.94692120208904, 37.5636933354527), (3, 126.94649623721354, 37.56382109076003), (3, 126.94649623721354, 37.56382109076003), (3, 126.94649623721354, 37.56382109076003), (3, 126.94640180844371, 37.563571118137624), (3, 126.94637126383876, 37.56328226229252), (3, 126.94629349903855, 37.563073951790315), (3, 126.94612685297993, 37.562882304424654), (3, 126.94612685297993, 37.562882304424654), (3, 126.94612685297993, 37.562882304424654), (3, 126.94607962917323, 37.5630906126879), (3, 126.94609351334162, 37.563212820947314), (3, 126.94613517236343, 37.56334891697819), (3, 126.94605739853407, 37.56346001377649), (3, 126.94605739853407, 37.56346001377649), (3, 126.94605739853407, 37.56346001377649), (3, 126.94602128474712, 37.56367109969338), (3, 126.94606849818989, 37.56382941546195), (3, 126.9462018139529, 37.56402106223035), (3, 126.9462018139529, 37.56402106223035), (3, 126.9462018139529, 37.56402106223035), (3, 126.94601016192908, 37.5641210471694), (3, 126.94601016192908, 37.5641210471694), (3, 126.94601016192908, 37.5641210471694), (3, 126.94606293277644, 37.56419603939392), (3, 126.94606293277644, 37.56419603939392), (3, 126.94606293277644, 37.56419603939392), (3, 126.94592405403407, 37.56428491545918), (3, 126.94587405733506, 37.564329353840094), (3, 126.94587405733506, 37.564329353840094), (3, 126.94587405733506, 37.564329353840094), (3, 126.94614346889784, 37.56462376887335), (3, 126.94614346889784, 37.56462376887335), (3, 
# 126.94614346889784, 37.56462376887335), (3, 126.94591848571525, 37.5647543052178), (3, 126.94583793608868, 37.564804297960926), (3, 126.94583793608868, 37.564804297960926), (3, 126.94583793608868, 37.564804297960926), (3, 126.94619066726419, 37.565315355959555), (3, 126.94644341210815, 37.565665319789645), (3, 126.94689057574182, 37.56629581003532), (3, 126.94689057574182, 37.56629581003532), (3, 126.94689057574182, 37.56629581003532), (3, 126.94679336159587, 37.566323582841484), (3, 126.94679336159587, 37.566323582841484), (3, 126.94679336159587, 37.566323582841484), (3, 126.94656838021938, 37.56639023772557), (3, 126.94656838021938, 37.56639023772557), (3, 126.94656838021938, 37.56639023772557), (3, 126.94651005173182, 37.566406901409266), (3, 126.94651005173182, 37.566406901409266), (3, 127.03470435396251, 37.483826414002316), (3, 127.0341960525166, 37.484334679177095), (3, 127.03407383568474, 37.48453743121163), (3, 127.03407383568474, 37.48453743121163), (3, 127.03407383568474, 37.48453743121163), (3, 127.03381274943163, 37.484498542152764), (3, 127.03381274943163, 37.484498542152764), (3, 127.03381274943163, 37.484498542152764), (3, 127.03376553927804, 37.48422357324242), (3, 127.03376553927804, 37.48422357324242), (3, 127.03376553927804, 37.48422357324242), (3, 127.03357111111336, 37.484273563945905), (3, 127.03354055967263, 37.48422634665944), (3, 127.03354055967263, 37.48422634665944), (3, 127.03354055967263, 37.48422634665944), (3, 127.03356555747634, 37.48422356965295), (3, 127.03356555747634, 37.48422356965295), (3, 127.03356555747634, 37.48422356965295), (3, 127.03357111417493, 37.484165243193864), (3, 127.03357111417493, 37.484165243193864), (3, 127.03357111417493, 37.484165243193864), (3, 127.0334489029169, 37.48417079591068), (3, 127.0331961523788, 37.48402080879431), (3, 127.03312949248475, 37.48399581050123), (3, 127.03292395531902, 37.48400691663289), (3, 127.03256565553309, 37.48397358073988), (3, 127.03256565553309, 37.48397358073988), (3, 127.03256565553309, 37.48397358073988), (3, 127.03262676940427, 37.48367917158745), (3, 127.03262676940427, 37.48367917158745)]
# print(getSlope(a))

# 결과: (3, 47.9)
