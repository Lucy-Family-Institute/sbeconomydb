library(tidyverse)
library(lubridate)
library(here)

#setwd("C:/Users/smotghar/") # laptop
downloads<-"C:/Users/mhauenst/Downloads"
root <- here()

jobs_func <- function() {
  file.copy(from = paste0(downloads, "/ExportExcel.xls"),
            to   = paste0(root, "/raw data/",curr_msa,"/Jobs/Jobs Available/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
  
  file.copy(from = paste0(downloads, "/ExportExcel(1).xls"),
            to   = paste0(root, "/raw data/",curr_msa,"/Jobs/Industries by Advertised Jobs/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
  
  file.copy(from = paste0(downloads, "/ExportExcel(2).xls"),
            to   = paste0(root, "/raw data/",curr_msa,"/Jobs/Occupations by Advertised Jobs/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
  
  file.copy(from = paste0(downloads, "/ExportExcel(3).xls"),
            to   = paste0(root, "/raw data/",curr_msa,"/Jobs/Jobs by Occupation Group/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
  
  file.copy(from = paste0(downloads, "/ExportExcel(4).xls"),
            to   = paste0(root, "/raw data/",curr_msa,"/Jobs/Employers by Number of Job Openings/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
  
  file.remove("Downloads/ExportExcel.xls")
  file.remove("Downloads/ExportExcel(1).xls")
  file.remove("Downloads/ExportExcel(2).xls")
  file.remove("Downloads/ExportExcel(3).xls")
  file.remove("Downloads/ExportExcel(4).xls")
}
cand_func <- function() {
  file.copy(from = paste0(downloads, "/ExportExcel.xls"),
            to   = paste0(root, "/raw data/",curr_msa,"/Candidates/Candidates Available/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
  
  file.copy(from = paste0(downloads, "/ExportExcel(1).xls"),
            to   = paste0(root, "/raw data/",curr_msa,"/Candidates/Occupations by Candidates Available/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
  
  file.copy(from = paste0(downloads, "/ExportExcel(2).xls"),
            to   = paste0(root, "/raw data/",curr_msa,"/Candidates/Candidates By Occupation Group/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
  
  file.remove("Downloads/ExportExcel.xls")
  file.remove("Downloads/ExportExcel(1).xls")
  file.remove("Downloads/ExportExcel(2).xls")
}
demand_supply_func <- function() {
  file.copy(from = paste0(downloads, "/ExportExcel.xls"),
            to   = paste0(root, "/raw data/",curr_msa,"/Demand and Supply/Jobs and Candidates Available/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
  
  file.copy(from = paste0(downloads, "/ExportExcel(1).xls"),
            to   = paste0(root, "/raw data/",curr_msa,"/Demand and Supply/Number of Candidates and Openings for Jobs by Occupation/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
  
  file.copy(from = paste0(downloads, "/ExportExcel(2).xls"),
            to   = paste0(root, "/raw data/",curr_msa,"/Demand and Supply/Jobs and Candidates by Occupation Group/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
  
  file.remove("Downloads/ExportExcel.xls")
  file.remove("Downloads/ExportExcel(1).xls")
  file.remove("Downloads/ExportExcel(2).xls")
}
educ_exper_func <- function() {
  file.copy(from = paste0(downloads, "/ExportExcel.xls"),
            to   = paste0(root, "/raw data/",curr_msa,"/Education, Training and Experience/Education Level of Jobs and Candidates/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
  
  file.copy(from = paste0(downloads, "/ExportExcel(1).xls"),
            to   = paste0(root, "/raw data/",curr_msa,"/Education, Training and Experience/Work Experience of Jobs and Candidates/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
  
  file.remove("Downloads/ExportExcel.xls")
  file.remove("Downloads/ExportExcel(1).xls")
}


#curr_msa <- "South Bend MSA"
curr_msa <- "Elkhart Goshen MSA"

jobs_func()

cand_func()

demand_supply_func()

educ_exper_func()
