#%%
from selenium import webdriver
from selenium.webdriver.support.ui import Select
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
import time

# Function to get all monthly data for MSA
def get_monthly_msa_data(msa):
    # Navigate to Data Page
    url = "http://www.indianacareerconnect.com"
    driver = webdriver.Firefox()
    driver.get(url)
    driver.find_element("link text", "Find Labor Market Data").click()
    driver.find_element(By.XPATH, "//*[starts-with(@id, 'ctl00_Main_content_MenuLandingPage_hlAreaProfile')]").click()
    select = Select(WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#ctl00_Main_content_ucLocation_ctlInternalLocationSelection_ddlAreatype"))))
    select.select_by_visible_text('Metropolitan Statistical Area (2013)')
    time.sleep(30)
    select_area = Select(WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#ctl00_Main_content_ucLocation_ctlInternalLocationSelection_ddlArea"))))
    select_area.select_by_visible_text(msa)
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#ctl00_Main_content_btnContinue"))).click()

    #### Jobs
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#jobsCategory > a:nth-child(1)"))).click()
    time.sleep(60)

    # Monthly Job Count
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "div.analyzerTextRight:nth-child(6) > div:nth-child(1) > button:nth-child(1)"))).click()
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "ul.show > li:nth-child(1) > a:nth-child(1)"))).click()
    time.sleep(60)

    # Advertised Job Skills
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#optionsToggleLink3"))).click()
    select_100_adskill = Select(WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR,"#ctl00_Main_content_ucSectionAdvJobSkills_ucDisplayOptions_ctl03_ddlDataAnalysis"))))
    select_100_adskill.select_by_visible_text("Top 100 Job Skills")
    time.sleep(30)
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#ctl00_Main_content_ucSectionAdvJobSkills_divTable > div:nth-child(4) > div:nth-child(4) > div:nth-child(1) > button:nth-child(1)"))).click()
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "ul.show > li:nth-child(1) > a:nth-child(1)"))).click()
    time.sleep(60)

    # Advertised Job Technologies
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#optionsToggleLink4"))).click()
    select_100_adtech = Select(WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR,"#ctl00_Main_content_ucSectionAdvJobTools_ucDisplayOptions_ctl03_ddlDataAnalysis"))))
    select_100_adtech.select_by_visible_text("Top 100 Tools and Technology")
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#ctl00_Main_content_ucSectionAdvJobTools_divTable > div:nth-child(4) > div:nth-child(4) > div:nth-child(1) > button:nth-child(1)"))).click()
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "ul.show > li:nth-child(1) > a:nth-child(1)"))).click()
    time.sleep(60)

    #### Education and Training
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#eduTrainingExperience > a:nth-child(1)"))).click()
    time.sleep(60)

    # Advertised Job Certifications
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#optionsToggleLink2"))).click()
    select_100_adcert = Select(WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR,"#ctl00_Main_content_ucSectionAdvJobCerts_ucDisplayOptions_ctl03_ddlDataAnalysis"))))
    select_100_adcert.select_by_visible_text("Top 100 Certifications")
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#ctl00_Main_content_ucSectionAdvJobCerts_divTable > div:nth-child(4) > div:nth-child(4) > div:nth-child(1) > button:nth-child(1) > span:nth-child(1)"))).click()
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "ul.show > li:nth-child(1) > a:nth-child(1)"))).click()
    time.sleep(10)

    # Get Unemployed Per Job Openings Distribution for South Bend only
    # When it gets pulled is irrelevant - but can only be once
    if msa == 'South Bend-Mishawaka, IN-MI Metropolitan Statistical Area':
            #### Supply and Demand
            WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#supplyDemandCategory > a:nth-child(1)"))).click()
            time.sleep(60)

            # Unemployed Per Job Opening Distribution
            WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#optionsToggleLink4"))).click()
            select_all_dist = Select(WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR,"#ctl00_Main_content_ucSectionUnempforJobsDist_ucDisplayOptions_ddlRecordCount"))))
            time.sleep(60)
            select_all_dist.select_by_visible_text("All")
            WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#ctl00_Main_content_ucSectionUnempforJobsDist_divTable > div:nth-child(4) > div:nth-child(4) > div:nth-child(1) > button:nth-child(1)"))).click()
            WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "ul.show > li:nth-child(1) > a:nth-child(1)"))).click()
            time.sleep(60)
        

    driver.quit()

# %%
