#%%
from selenium import webdriver
from selenium.webdriver.support.ui import Select
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.action_chains import ActionChains
import time
import datetime
import os
import shutil
import glob
#%%
def stats_in_scrape(downloads):
    # Break if downloads has an old file
    if len(glob.glob(downloads + "/stats_data_*.xls")) != 0:
         return("Remove old Stats Indiana downloads before running 'selenium_indiana_stats.py")
    
    # Navigate to site
    url = "http://www.stats.indiana.edu/fssa_m/index.html"
    driver = webdriver.Firefox()
    driver.get(url)
    
    # Select the frame
    iframe = driver.find_element(By.CSS_SELECTOR, "html frameset frame")
    driver.switch_to.frame(iframe)
    
    #Select General Area
    select_general = Select(WebDriverWait(driver, 30).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#queryBar > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(1) > p:nth-child(1) > select:nth-child(2)"))))
    select_general.select_by_visible_text("Metro/Micro/Combined Areas")
    
    #Select Current Year
    cur_year = datetime.datetime.now().year
    select_year = Select(WebDriverWait(driver, 30).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#queryBar > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(2) > p:nth-child(1) > select:nth-child(2)"))))
    select_year.select_by_visible_text(str(cur_year))

    #Select All Months
    select_month = Select(WebDriverWait(driver, 30).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#queryBar > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(2) > p:nth-child(2) > select:nth-child(2)"))))
    select_month.select_by_visible_text("All")
    
    #Select All Indicators
    select_ind = Select(WebDriverWait(driver, 30).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#queryBar > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(3) > p:nth-child(1) > select:nth-child(2)"))))
    select_ind.select_by_visible_text("All items")

    #Select Group Counties
    #Sometimes it loads checked, need to check if not
    is_selected = driver.find_element(By.CSS_SELECTOR, ".small > input:nth-child(5)").is_selected()

    if not is_selected:
        driver.find_element(By.CSS_SELECTOR, ".small > input:nth-child(5)").click()

    #Select Excel Output
    #For safety do within an if as well
    is_selected_excel= driver.find_element(By.CSS_SELECTOR, "#Checkbox1").is_selected()

    if not is_selected_excel:
        driver.find_element(By.CSS_SELECTOR, "#Checkbox1").click()

    #Click Download
    WebDriverWait(driver, 30).until(EC.element_to_be_clickable((By.XPATH, "/html/body/form/table/tbody/tr/td[3]/p[2]/input[1]"))).click()

    #Make sure to wait until download completes
    time.sleep(60)

    driver.quit()

    #Send it to the rigth place with a new name
    #Find variable path - stats indiana appends numbers to download file name
    source = glob.glob(downloads + "/stats_data_*.xls")[0]
    dest = "../raw data/poverty/snap and tanf" + "/in_metros_" + str(cur_year) + ".xls"
    shutil.copy2(source, dest)
    
    #Delete download
    os.remove(source)



#%%
stats_in_scrape("C:/Users/mhauenst/Downloads")
# %%
