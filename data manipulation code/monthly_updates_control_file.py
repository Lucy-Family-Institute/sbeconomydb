#%% Control file for Monthly Updates
import subprocess
import shutil
from selenium_indiana_stats import stats_in_scrape
from selenium_career_connect_monthly import get_monthly_msa_data

#%%
rscript_location = "C:/Program Files/R/R-4.3.0/bin/Rscript.exe"
copy_paste_location ="./automated_copy_paste_monthly.R"
data_manipulation_location = "./data_manipulation_monthly_v5.R"
downloads_location = "C:/Users/mhauenst/Downloads"
git_bash_location = "C:/Program Files/Git/git-bash.exe"
shiny_app_location = "C:/Users/mhauenst/Documents/shiny-apps"
main_repo_location = "C:/Users/mhauenst/Documents/sbeconomydb/"

copy_paste_args = [rscript_location, copy_paste_location]
data_manipulation_args = [rscript_location, data_manipulation_location]

#%% 1) Git pull the main repo
subprocess.call([git_bash_location, "git_pull.sh", main_repo_location])

#%% 2) Scrape the Indiana Career Connect Webpage
get_monthly_msa_data(msa='South Bend-Mishawaka, IN-MI Metropolitan Statistical Area')

get_monthly_msa_data(msa='Elkhart-Goshen, IN Metropolitan Statistical Area')

#%% 3) Copy and Paste the Monthly Data
subprocess.call(copy_paste_args)

#%% 4) Scrape the Stats Indiana Page
stats_in_scrape(downloads=downloads_location)

#%% 5) Run the Monthly Manipulation Code
subprocess.call(data_manipulation_args, shell=True)

# %% 6) Push to main repo on GitHub
subprocess.call([git_bash_location, "git_commit.sh", main_repo_location])

#%% 7) Git pull the shiny-apps repo
subprocess.call([git_bash_location, "git_pull.sh", shiny_app_location])

# %% 7) Copy data to shiny-apps to update
source = "app/data"
shutil.copytree(src=main_repo_location+ source, dst=shiny_app_location + "/sbeconomydb/data", dirs_exist_ok=True)

#%% 8) Push shiny-apps to GitHub
subprocess.call([git_bash_location, "git_commit.sh", shiny_app_location])# %%
