library(tidyverse)
library(lubridate)
library(here)
library(rvest)

#setwd("C:/Users/smotghar/") # laptop
downloads<-"C:/Users/mhauenst/Downloads"
root <- here()

jobs_func <- function(downloads,files) {
  curr_msa<- files[1, "msa"]
  
  file.copy(from = files[1,1],
            to   = paste0(root, "/raw data/",curr_msa,"/Jobs/Jobs Available/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
  
  file.copy(from = files[2,1],
            to   = paste0(root, "/raw data/",curr_msa,"/Jobs/Industries by Advertised Jobs/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
  
  file.copy(from = files[3,1],
            to   = paste0(root, "/raw data/",curr_msa,"/Jobs/Occupations by Advertised Jobs/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
  
  file.copy(from = files[4,1],
            to   = paste0(root, "/raw data/",curr_msa,"/Jobs/Jobs by Occupation Group/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
  
  file.copy(from = files[5,1],
            to   = paste0(root, "/raw data/",curr_msa,"/Jobs/Employers by Number of Job Openings/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
}

cand_func <- function(downloads, files) {
  curr_msa<- files[1, "msa"]
  
  file.copy(from = files[1,1],
            to   = paste0(root, "/raw data/",curr_msa,"/Candidates/Candidates Available/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
  
  file.copy(from = files[2,1],
            to   = paste0(root, "/raw data/",curr_msa,"/Candidates/Occupations by Candidates Available/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
  
  file.copy(from = files[3,1],
            to   = paste0(root, "/raw data/",curr_msa,"/Candidates/Candidates By Occupation Group/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
}


demand_supply_func <- function(downloads, files) {
  curr_msa<- files[1, "msa"]
  file.copy(from = files[1,1],
            to   = paste0(root, "/raw data/",curr_msa,"/Demand and Supply/Jobs and Candidates Available/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
  
  file.copy(from = files[2,1],
            to   = paste0(root, "/raw data/",curr_msa,"/Demand and Supply/Number of Candidates and Openings for Jobs by Occupation/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
  
  file.copy(from = files[3,1],
            to   = paste0(root, "/raw data/",curr_msa,"/Demand and Supply/Jobs and Candidates by Occupation Group/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
}

educ_exper_func <- function(downloads, files) {
  curr_msa<- files[1, "msa"]
  
  file.copy(from = files[1,1],
            to   = paste0(root, "/raw data/",curr_msa,"/Education, Training and Experience/Education Level of Jobs and Candidates/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
  
  file.copy(from = files[2,1],
            to   = paste0(root, "/raw data/",curr_msa,"/Education, Training and Experience/Work Experience of Jobs and Candidates/",format(today(),"%m.%d.%y"),".xls"),
            overwrite = T)
}

full_copy_paste<-function(downloads){
  
  file_info = file.info(list.files(downloads, pattern="ExportExcel", full.names = T))
  
  #Break if wrong number
  if (nrow(file_info)!=26){
    stop("Incorrect number ExportExcel.xls files in Downloads Folder - requires exactly 26")
  }
  file_info <- file_info %>%
    arrange(mtime) %>%
    rownames_to_column() %>%
    dplyr::select(rowname) %>%
    mutate(msa = c(rep("South Bend MSA", 13), rep("Elkhart Goshen MSA", 13)))
  
  
  #For now just do all of them in the order they come down - will match if the selenium file is run correctly
  #Future version should parse the header and match it against to the path to allow for errors
  #Note: MSA inherited from file list assuming SB run first
  
  #South Bend
  jobs_func(downloads=downloads, files=file_info[1:5,])
  cand_func(downloads=downloads, files=file_info[6:8,])
  demand_supply_func(downloads=downloads, files=file_info[9:11,])
  educ_exper_func(downloads=downloads, files=file_info[12:13,])
  
  #Elkhart
  jobs_func(downloads=downloads, files=file_info[14:18,])
  cand_func(downloads=downloads, files=file_info[19:21,])
  demand_supply_func(downloads=downloads, files=file_info[22:24,])
  educ_exper_func(downloads=downloads, files=file_info[25:26,])
  
  #Clean up
  file.remove(file_info[,1])

}

full_copy_paste(downloads)
