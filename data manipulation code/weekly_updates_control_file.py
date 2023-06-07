#%% Control file for Weekly Updates
import subprocess
from selenium_career_connect import get_weekly_msa_data

#%%
rscript_location = "C:/Program Files/R/R-4.2.1/bin/Rscript.exe"
copy_paste_location ="./automated_copy_paste_v1.R"
data_manipulation_location = "./data_manipulation_for_app_v24.R"

copy_paste_args = [rscript_location, copy_paste_location]
data_manipulation_args = [rscript_location, data_manipulation_location]


#%% 1) Scrape the Indiana Career Connect Webpage
get_weekly_msa_data(msa='South Bend-Mishawaka, IN-MI Metropolitan Statistical Area')

get_weekly_msa_data(msa='Elkhart-Goshen, IN Metropolitan Statistical Area')

#%% 2) Copy and Paste the Weekly Data
subprocess.call(copy_paste_args, shell=True)

#%% 3) Run the Monthly Manipulation Code
subprocess.call(data_manipulation_args, shell=True)

