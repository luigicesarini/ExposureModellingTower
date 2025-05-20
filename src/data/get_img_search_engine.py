#!/home/lcesarini/project/repo_power/env/bin/python


import os
import time  
import argparse
import requests
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options

from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys 
from selenium.webdriver.common.action_chains import ActionChains

parser = argparse.ArgumentParser()
parser.add_argument("-e","--engine", type=str, default='Google', help="research engine to look on")

args = parser.parse_args()

engine=args.engine
os.chdir("../")
print(os.getcwd())

options = Options()
options.add_argument('--no-sandbox')  

driver = webdriver.Chrome(service=Service("/usr/local/bin/chromedriver"), options=options)

if engine=='bing':


    driver.get('https://www.bing.com/')

    # cookie_button = driver.find_elements_by_xpath('//*[@id="L2AGLb"]')
    # cookie_button.click()
    box = driver.find_element(By.XPATH,'//*[@id="sb_form_q"]')
    box.send_keys('power grid tower')
    
    box.send_keys(Keys.ENTER)
    time.sleep(8) 

    images_button = driver.find_element(By.XPATH,'//*[@id="b-scopeListItem-images"]/a')
    images_button.click()

    #Will keep scrolling down the webpage until it cannot scroll no more
    last_height = driver.execute_script('return document.body.scrollHeight')
    while True:
        driver.execute_script('window.scrollTo(0,document.body.scrollHeight)')
        time.sleep(5)
        new_height = driver.execute_script('return document.body.scrollHeight')
        try:
            driver.find_element(By.XPATH,'//*[@id="islmp"]/div/div/div/div/div[5]/input').click()
            time.sleep(5)
        except:
            pass
        if new_height == last_height:
            break
        last_height = new_height


    for i in range(1,1000):
        try:
            src = driver.find_element(By.XPATH,f'//*[@id="mmComponent_images_2"]/ul[1]/li[{i}]/div/div/a/div/img').get_attribute('src')
            r   = requests.get(src, allow_redirects=True)
            with open(f'data/pic_bing_{i}.jpg', 'wb') as f:
                f.write(r.content)
        except:
            pass

elif engine=='google':
    driver.get('https://www.google.com/imghp')
    try:
        cookie_button = driver.find_elements(By.XPATH,'//*[@id="W0wltc"]/div')[0]
        cookie_button.click()
        time.sleep(3)
    except:
        pass
    box = driver.find_element(By.XPATH,'//*[@id="APjFqb"]')
    # box = driver.find_element('/html/body/div[1]/div[3]/form/div[1]/div[1]/div[1]/div/div[2]/input')
    

    box.send_keys('torre degli asinelli')
    time.sleep(2)

    box.send_keys(Keys.ENTER)
    time.sleep(2)

    # images_button = driver.find_element(By.XPATH,'//*[@id="hdtb-msb"]/div[1]/div/div[2]/a')
    # images_button.click()
    # time.sleep(5)

    #Will keep scrolling down the webpage until it cannot scroll no more
    last_height = driver.execute_script('return document.body.scrollHeight')
    while True:
        driver.execute_script('window.scrollTo(0,document.body.scrollHeight)')
        time.sleep(2)
        new_height = driver.execute_script('return document.body.scrollHeight')
        try:
            driver.find_element(By.XPATH,'//*[@id="islmp"]/div/div/div/div/div[5]/input').click()
            time.sleep(2)
        except:
            pass
        if new_height == last_height:
            break
        last_height = new_height


    for i in range(1, 2):
        print(i)
        try:
            # driver.find_element(By.XPATH,'//*[@id="islrg"]/div[1]/div['+str(i)+']/a[1]/div[1]/img').screenshot(f'data/pgt_{i}.png')
            driver.find_element(By.XPATH,'//*[@id="Sva75c"]/div[2]/div[2]/div/div[2]/c-wiz/div/div[2]/div[1]/a/img[1]').screenshot(f'data/pgt_{i}.png')
               
        except:
            pass

   