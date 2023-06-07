# South Bend Economy Dashboard Automate Updates

## Requirements

Currently, the R scripts R Shiny app have their own preambles with necessary imports.  These need to be installed locally (pacman does not work).

"requirements.txt" in the data manpulation folder will create the virtual environment to run the python scripts.
## Weekly Updates
(WIP)

## Monthly Updates
Initial Set-up
- Open "data_manipulation_monthly_v5.R"
    - Change working directory to root for the sbeconomydb project
    - Note: here() will not work because it requires the project to be launched to set the root. I will look into launching the project from the API, then calling here()to avoid hard paths
    - Run the preamble to ensure all packages are installed
    - To do: automate package install/load with pacman
- Open "automated_copy_past_monthly.R"
    - Change the download folder to users location
    - Run the preamble to ensure all packages are installed
    - To do: automate package install/load with pacman
- Create a virtual environment using requirements.txt to run the Python scripts
- Open "selenium_stats_indiana.py"
    - Provide your download folder locaction on line 79
    - To do: use import to define the function, call the function from control file so user doesn't have to dig for calls
- Open "monthly_updates_control_file.py" 
    - Change rscript_location to the location of the R script executable on your system

Monthly Schedulable Tasks
- Run "monthly_updates_control_file.py: This runs in order:
    1. "selenium_career_connect_monthly.py" - scrapes the 9 data files from indiannacareerconnect.com (refer to full documentation)
    2. "automated_copy_paste_monthly.R" - takes the 9 data files and moves them from downloads to the relevant folders in raw data.
    3. "selenium_indiana_stats.py" - scrapes the TANF and SNAP data from stats.indiana.edu
    4. "data_manipulation_monthly_v5.R" - processes the raw data

- Optionally, run "sbeconomytracker.R" to check the app locally
