from selenium import webdriver
import time
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.alert import Alert
from reGeo import getReGeo

# ex : x, y = 126, 37
def getSlope(x, y):

    print('Done. (func)')

    query_txt = getReGeo(x, y)

    print('Done. (query)')

    option = Options()
    option.add_argument("disable-infobars")
    option.add_argument("disable-extensions")
    option.add_argument('disable-gpu')
    option.add_argument("headless") # background 실행
    option.add_experimental_option("detach", True)
    option.add_experimental_option('excludeSwitches',['enable-logging'])
    driver = webdriver.Chrome('C:\chromedriver.exe', options=option)

    print('Done.')

    driver.get("https://webgis.neins.go.kr/popup/searchGCadastralPopup.do")
    time.sleep(1)

    print('Done. (driver)')

    driver.find_element(By.ID, "queryText").click()
    element = driver.find_element(By.ID, "queryText")
    element.send_keys(query_txt)
    element.send_keys("\n")
    time.sleep(1)

    print('Done. (element)')

    # 담기 버튼
    adress = driver.find_element(By.XPATH, '//*[@id="popupRatepoint"]/div[2]/div[3]/ul/li/a')
    driver.execute_script("arguments[0].click();", adress)
    time.sleep(0.5)

    # 분석 버튼
    driver.find_element(By.CLASS_NAME, 'popup_submit').click()

    try:
        alert = Alert(driver)
        alert.accept()
        
    except:
        "There is no alert"

    time.sleep(1)
    driver.switch_to.window(driver.window_handles[-1])
    time.sleep(1)

    # 표 받기
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

    result = round(avg_slope, 3)

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
    # print(result)

    print(slope_class)

    return slope_class

getSlope(126.94687065007022, 37.5635841072725)