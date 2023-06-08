#%% Control file for Monthly Updates
import subprocess
from selenium_indiana_stats import stats_in_scrape
from selenium_career_connect_monthly import get_monthly_msa_data

#%%
rscript_location = "C:/Program Files/R/R-4.2.1/bin/Rscript.exe"
copy_paste_location ="./automated_copy_paste_monthly.R"
data_manipulation_location = "./data_manipulation_monthly_v5.R"
downloads_location = "C:/Users/mhauenst/Downloads"
copy_paste_args = [rscript_location, copy_paste_location]
data_manipulation_args = [rscript_location, data_manipulation_location]

#%% 1) Scrape the Indiana Career Connect Webpage
get_monthly_msa_data(msa='South Bend-Mishawaka, IN-MI Metropolitan Statistical Area')

get_monthly_msa_data(msa='Elkhart-Goshen, IN Metropolitan Statistical Area')

#%% 2) Copy and Paste the Monthly Data
subprocess.call(copy_paste_args, shell=True)

#%% 3) Scrape the Stats Indiana Page
stats_in_scrape(downloads=downloads_location)

#%% 4) Run the Monthly Manipulation Code
subprocess.call(data_manipulation_args, shell=True)

# %% 5) Push to GitHub
subprocess.call(['sh', "git_commit.sh"])
# %%
