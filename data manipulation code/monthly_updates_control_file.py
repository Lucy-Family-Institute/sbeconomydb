#%% Control file for Monthly Updates
import subprocess

#%%
rscript_location = "C:/Program Files/R/R-4.2.1/bin/Rscript.exe"
copy_paste_location ="./automated_copy_paste_monthly.R"
data_manipulation_location = "./data_manipulation_monthly_v5.R"

copy_paste_args = [rscript_location, copy_paste_location]
data_manipulation_args = [rscript_location, data_manipulation_location]


#%% 1) Scrape the Indiana Carrer Connect Webpage
import selenium_career_connect_monthly

#%% 2) Copy and Paste the Monthly Data
subprocess.call(copy_paste_args, shell=True)
#subprocess.call([rscript_location, "./automated_copy_paste_monthly.R"], executable=rscript_location)

#%% 3) Scrape the Stats Indiana Page
import selenium_indiana_stats

#%% 4) Run the Monthly Manipulation Code
subprocess.call(data_manipulation_args, shell=True)

# %%
