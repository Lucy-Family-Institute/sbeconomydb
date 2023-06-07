# South Bend Economy Dashboard Automatic Updates
This document describes the automated data collection and manipulation process.

## Requirements

Currently, the R scripts R Shiny app have their own preambles with necessary imports.  These need to be installed locally R Shiny app cannot be updated with pacman, but manipulation files will be.

"requirements.txt" in the data manpulation folder will create the virtual environment to run the Python scripts.

## Weekly Updates
Initial Set-up
- Open "data_manipulation_v24.R"
    - Change working directory to root for the sbeconomydb project
    - Note: here() will not work because it requires the project to be launched to set the root. I will look into launching the project from the API, then calling here() to avoid hard paths
    - Run the preamble to ensure all packages are installed
    - To do: automate package install/load with pacman
- Open "automated_copy_paste_v1.R"
    - Change the download folder to user's location
    - Run the preamble to ensure all packages are installed
    - To do: automate package install/load with pacman
- Create a virtual environment using requirements.txt to run the Python scripts
- Open "weekly_updates_control_file.py" 
    - Change rscript_location to the location of the R script executable on your system

Weekly Schedulable Tasks
- Run "weekly_updates_control_file.py" This performs the following tasks:
    1. Imports the following function
         - Python function get_weekly_msa_data() from "selenium_career_connect_monthly.py" for scraping weekly data from indianacareerconnect.com
    
    2. Scrapes the 26 data files from indiannacareerconnect.com (refer to full documentation)
    3. Runs "automated_copy_paste_monthly.R" - takes the 26 data files and moves them from downloads to the relevant folders in raw data.
    4. Runs "data_manipulation_weekly_v24.R" - processes the raw data

- Optionally, run "sbeconomytracker.R" to check the app locally


## Monthly Updates
Initial Set-up
- Open "data_manipulation_monthly_v5.R"
    - Change working directory to root for the sbeconomydb project
    - Note: here() will not work because it requires the project to be launched to set the root. I will look into launching the project from the API, then calling here() to avoid hard paths
    - Run the preamble to ensure all packages are installed
    - To do: automate package install/load with pacman
- Open "automated_copy_paste_monthly.R"
    - Change the download folder to users location
    - Run the preamble to ensure all packages are installed
    - To do: automate package install/load with pacman
- Create a virtual environment using requirements.txt to run the Python scripts
- Open "selenium_stats_indiana.py"
    - Provide your download folder locaction on line 79
    - To do: use import to define the function, call the function from control file so user doesn't have to dig for calls
- Open "monthly_updates_control_file.py" 
    - Change rscript_location to the location of the R script executable on your system
    - Change donwloads_location to the location of your downloads folder

Monthly Schedulable Tasks
- Run "monthly_updates_control_file.py, which performs the following tasks:
    1. Imports the following functions
        - Python function get_monthly_msa_data() from "selenium_career_connect_monthly.py" for scraping monthly data from indianacareerconnect.com
        - Python function stats_in_scrape() from "selenium_indiana_stats.py" for scraping SNAP and TANF data from stats.indiana.edu
    2. Scrapes the 9 data files from indiannacareerconnect.com (refer to full documentation)
    3. Runs "automated_copy_paste_monthly.R" - takes the 9 data files and moves them from downloads to the relevant folders in raw data.
    3. Scrapes the SNAP and TANF data from stats.indiana.edu (refer to full documentation)
    4. Runs "data_manipulation_monthly_v5.R" - processes the raw data

- Optionally, run "sbeconomytracker.R" to check the app locally
