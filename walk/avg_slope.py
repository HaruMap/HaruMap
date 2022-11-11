from selenium import webdriver
import time
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.alert import Alert
from reGeo import getReGeo

def getSlope(x, y):
    query_txt = getReGeo(x, y)

    option = Options()
    option.add_argument("disable-infobars")
    option.add_argument("disable-extensions")
    option.add_argument('disable-gpu')
    option.add_argument("headless")     # background 실행
    option.add_experimental_option("detach", True)
    option.add_experimental_option('excludeSwitches',['enable-logging'])
    driver = webdriver.Chrome('./chromedriver.exe', options=option)

    driver.get("https://webgis.neins.go.kr/popup/searchGCadastralPopup.do")
    time.sleep(1)

    try: 
        driver.find_element(By.ID, "queryText").click()
        element = driver.find_element(By.ID, "queryText")
        element.send_keys(query_txt)
        element.send_keys("\n")
        time.sleep(1)

        # 담기 버튼
        adress = driver.find_element(By.XPATH, '//*[@id="popupRatepoint"]/div[2]/div[3]/ul/li/a')
        driver.execute_script("arguments[0].click();", adress)
        time.sleep(0.5)

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

        # 결과(평균 경사도, 경사도 class) 출력
        #print(result)
        return(slope_class)

    except:
        return("x")

# a = [[37.5629489890138, 126.9475600537903], [37.56304897395293, 126.94736840176604], [37.562296279226665, 126.94711844582949], [37.56219073161583, 126.94687680417238], [37.56061866593298, 126.94541031561539], [37.55998818498755, 126.94548254907482], [37.55993541493839, 126.94557143135383], [37.55984098023148, 126.94550199590753], [37.55712185978877, 126.94593814411803], [37.556969108231414, 126.94641032762054]]
# slope = []

# for i in range(len(a)):
#     print(i+1,'/',len(a), end=' ')
#     slope.append(getSlope(a[i][1], a[i][0]))

# print(slope)