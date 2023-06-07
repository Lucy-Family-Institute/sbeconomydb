#%%
from selenium import webdriver
from selenium.webdriver.support.ui import Select
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
import time

# Function to get all weekly data for MSA

def get_weekly_msa_data(msa):
# Navigate to Data Page
    url = "http://www.indianacareerconnect.com"
    driver = webdriver.Firefox()
    driver.get(url)
    driver.find_element("link text", "Find Labor Market Data").click()
    driver.find_element(By.XPATH, "//*[starts-with(@id, 'ctl00_Main_content_MenuLandingPage_hlAreaProfile')]").click()
    select = Select(WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#ctl00_Main_content_ucLocation_ctlInternalLocationSelection_ddlAreatype"))))
    select.select_by_visible_text('Metropolitan Statistical Area (2013)')
    select_area = Select(WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#ctl00_Main_content_ucLocation_ctlInternalLocationSelection_ddlArea"))))
    select_area.select_by_visible_text(msa)
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#ctl00_Main_content_btnContinue"))).click()

    #### Jobs
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#jobsCategory > a:nth-child(1)"))).click()
    time.sleep(60)

    # Jobs Available
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#ctl00_Main_content_ucSectionJobsAvail_divTable > div:nth-child(4) > div:nth-child(4) > div:nth-child(1) > button:nth-child(1)"))).click()
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "ul.show > li:nth-child(1) > a:nth-child(1)"))).click()
    time.sleep(30)

    # Industires by Advertised Job
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#optionsToggleLink5"))).click()
    select_100_adjob = Select(WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#ctl00_Main_content_ucSectionIndJobs_ucDisplayOptions_ddlRecordCount"))))
    select_100_adjob.select_by_visible_text("100")
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#ctl00_Main_content_ucSectionIndJobs_divTable > div:nth-child(4) > div:nth-child(4) > div:nth-child(1) > button:nth-child(1)"))).click()
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "ul.show > li:nth-child(1) > a:nth-child(1)"))).click()
    time.sleep(10)

    # Occupation by Advertised Job
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#optionsToggleLink6"))).click()
    select_100_ocjob = Select(WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#ctl00_Main_content_ucSectionAdvJobs_ucDisplayOptions_ddlRecordCount"))))
    select_100_ocjob.select_by_visible_text("100")
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "div.analyzerTextRight:nth-child(5) > div:nth-child(1) > button:nth-child(1)"))).click()
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "ul.show > li:nth-child(1) > a:nth-child(1)"))).click()
    time.sleep(10)

    # Jobs by Occupation Group
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#ctl00_Main_content_ucSectionoccjobs_divTable > div:nth-child(4) > div:nth-child(4) > div:nth-child(1) > button:nth-child(1)"))).click()
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "ul.show > li:nth-child(1) > a:nth-child(1)"))).click()
    time.sleep(10)

    # Employers by Job Openings
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#optionsToggleLink8"))).click()
    select_100_empop = Select(WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#ctl00_Main_content_ucSectionLargestEmps_ucDisplayOptions_ddlRecordCount"))))
    select_100_empop.select_by_visible_text("100")
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#ctl00_Main_content_ucSectionLargestEmps_divTable > div:nth-child(4) > div:nth-child(4) > div:nth-child(1) > button:nth-child(1)"))).click()
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "ul.show > li:nth-child(1) > a:nth-child(1)"))).click()
    time.sleep(10)

    #### Candidates
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#candidatesCategory > a:nth-child(1)"))).click()
    time.sleep(60)

    # Available Candidates
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#ctl00_Main_content_ucSectionCandidatesAvail_divTable > div:nth-child(4) > div:nth-child(4) > div:nth-child(1) > button:nth-child(1)"))).click()
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "ul.show > li:nth-child(1) > a:nth-child(1)"))).click()
    time.sleep(10)

    # Occupation by Candidate
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#optionsToggleLink3 > span:nth-child(1)"))).click()
    select_100_candoc = Select(WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#ctl00_Main_content_ucSectionOccsByCandsAvail_ucDisplayOptions_ddlRecordCount"))))
    select_100_candoc.select_by_visible_text("100")
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "div.analyzerTextRight:nth-child(5) > div:nth-child(1) > button:nth-child(1) > span:nth-child(1)"))).click()
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "ul.show > li:nth-child(1) > a:nth-child(1)"))).click()
    time.sleep(10)

    # Candidates by Occupation
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#ctl00_Main_content_ucSectioncandsoccgroup_divTable > div:nth-child(4) > div:nth-child(4) > div:nth-child(1) > button:nth-child(1)"))).click()
    WebDriverWait(driver, 90).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "ul.show > li:nth-child(1) > a:nth-child(1)"))).click()
    time.sleep(10)

    #### Demand and Supply
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#supplyDemandCategory > a:nth-child(1)"))).click()
    time.sleep(60)

    # Jobs and Candidates Available
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#ctl00_Main_content_ucSectionJobsCandsAvail_divTable > div:nth-child(4) > div:nth-child(4) > div:nth-child(1) > button:nth-child(1)"))).click()
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "ul.show > li:nth-child(1) > a:nth-child(1)"))).click()
    time.sleep(30)

    # Number of Candidate and Openings
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#optionsToggleLink5 > span:nth-child(1)"))).click()
    select_100_candandop = Select(WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, 
    "#ctl00_Main_content_ucSectionCandidateforJobsOcc_ucDisplayOptions_ddlRecordCount"))))
    time.sleep(15)
    select_100_candandop.select_by_visible_text("100")
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#ctl00_Main_content_ucSectionCandidateforJobsOcc_divTable > div:nth-child(4) > div:nth-child(4) > div:nth-child(1) > button:nth-child(1)"))).click()
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "ul.show > li:nth-child(1) > a:nth-child(1)"))).click()
    time.sleep(10)

    # Candidates by Occupation Group
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#ctl00_Main_content_ucSectionjobscandsoccgroup_divTable > div:nth-child(4) > div:nth-child(4) > div:nth-child(1) > button:nth-child(1)"))).click()
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "ul.show > li:nth-child(1) > a:nth-child(1)"))).click()
    time.sleep(10)

    #### Education and Training
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#eduTrainingExperience > a:nth-child(1)"))).click()
    time.sleep(30)

    # Education Level
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "div.analyzerTextRight:nth-child(5) > div:nth-child(1) > button:nth-child(1) > span:nth-child(1)"))).click()
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "ul.show > li:nth-child(1) > a:nth-child(1)"))).click()
    time.sleep(30)

    # Work Experience
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "#ctl00_Main_content_ucSectionWorkExpReqsJobsCandidates_divTable > div:nth-child(4) > div:nth-child(4) > div:nth-child(1) > button:nth-child(1)"))).click()
    WebDriverWait(driver, 60).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "ul.show > li:nth-child(1) > a:nth-child(1)"))).click()

    time.sleep(60)

    driver.quit()
