#%% Control file for Weekly Updates
import subprocess
import shutil
from selenium_career_connect import get_weekly_msa_data

#%%
rscript_location = "C:/Program Files/R/R-4.2.1/bin/Rscript.exe"
git_bash_location = "C:/Program Files/Git/git-bash.exe"
copy_paste_location ="./automated_copy_paste_v1.R"
data_manipulation_location = "./data_manipulation_for_app_v24.R"
shiny_app_location = "C:/Users/mhauenst/Documents/shiny-apps"
main_repo_location = "C:/Users/mhauenst/Documents/sbeconomydb/"
copy_paste_args = [rscript_location, copy_paste_location]
data_manipulation_args = [rscript_location, data_manipulation_location]

#%% 1) Git pull the main repo
subprocess.call([git_bash_location, "git_pull.sh", main_repo_location])

#%% 2) Scrape the Indiana Career Connect Webpage
get_weekly_msa_data(msa='South Bend-Mishawaka, IN-MI Metropolitan Statistical Area')

get_weekly_msa_data(msa='Elkhart-Goshen, IN Metropolitan Statistical Area')

#%% 3) Copy and Paste the Weekly Data
subprocess.call(copy_paste_args)

#%% 4) Run the Monthly Manipulation Code
subprocess.call(data_manipulation_args)

#%% 5) Push to main repo on GitHub
subprocess.call([git_bash_location, "git_commit.sh", main_repo_location])

#%% 6) Git pull the shiny-apps repo
subprocess.call([git_bash_location, "git_pull.sh", shiny_app_location])

# %% 7) Copy data to shiny-apps to update
source = "app/data"
shutil.copytree(src=main_repo_location+ source, dst=shiny_app_location + "/sbeconomydb/data", dirs_exist_ok=True)

#%% 6) Push shiny-apps to GitHub
subprocess.call([git_bash_location, "git_commit.sh", shiny_app_location])
