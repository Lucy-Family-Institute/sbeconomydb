library(tidyverse)
library(lubridate)
library(here)
library(rvest)

#setwd("C:/Users/smotghar/") # laptop
downloads<-"C:/Users/mhauenst/Downloads"
#root <- here()
root <- "C:/Users/mhauenst/Documents/sbeconomydb"

jobs_func_monthly <- function(downloads,files) {
  curr_msa<- files[1, "msa"]
  
  #The Elkhart and SB folders have differing numbers of year digits for same
  #jobs folder
  
  if (curr_msa =="South Bend MSA"){
    #If SB use 4 digit year
    file.copy(from = files[1,1],
            to   = paste0(root, "/raw data/",curr_msa,"/Jobs/update once a month/Monthly Job Count/",format(today(),"%m.%Y"),".xls"),
            overwrite = T)
  }
  else {
    #If not copy 2 digit year for Elkhart
    file.copy(from = files[1,1],
              to   = paste0(root, "/raw data/",curr_msa,"/Jobs/update once a month/Monthly Job Count/",format(today(),"%m.%y"),".xls"),
              overwrite = T)
  }
  
  file.copy(from = files[2,1],
            to   = paste0(root, "/raw data/",curr_msa,"/Jobs/update once a month/Advertised Job Skills/",format(today(),"%m.%y"),".xls"),
            overwrite = T)
  
  file.copy(from = files[3,1],
            to   = paste0(root, "/raw data/",curr_msa,"/Jobs/update once a month/Advertised Tools and Technology/",format(today(),"%m.%y"),".xls"),
            overwrite = T)
}

educ_exper_func_monthly <- function(downloads, files) {
  curr_msa<- files[1, "msa"]
  
  file.copy(from = files[1,1],
            to   = paste0(root, "/raw data/",curr_msa,"/Education, Training and Experience/update once a month/Advertised Job Certifications/",format(today(),"%m.%Y"),".xls"),
            overwrite = T)
}

full_copy_paste_monthly<-function(downloads){
  
  file_info = file.info(list.files(downloads, pattern="ExportExcel", full.names = T))
  
  #Break if wrong number
  if (nrow(file_info)!=9){
    stop("Incorrect number ExportExcel.xls files in Downloads Folder - requires exactly 9")
  }
  
  #Get rid of the Supply and Demand file first
  file_info <- file_info %>%
    arrange(mtime) %>%
    rownames_to_column() %>%
    dplyr::select(rowname)
  
  file.copy(from = file_info[5,],
            to   = paste0(root, "/raw data/other MSAs/Number of Unemployed per Job Opening Distribution/",format(today(),"%m.%y"),".xls"),
            overwrite = T)
  
  file.remove(file_info[5,])
  
  #Move on to 8 remaining files that match pattern
  file_info = file.info(list.files(downloads, pattern="ExportExcel", full.names = T))
  
  file_info <- file_info %>%
    arrange(mtime) %>%
    rownames_to_column() %>%
    dplyr::select(rowname) %>%
    mutate(msa = c(rep("South Bend MSA", 4), rep("Elkhart Goshen MSA", 4)))
  
  
  #For now just do all of them in the order they come down - will match if the selenium file is run correctly
  #Future version should parse the header and match it against to the path to allow for errors
  #Note: MSA inherited from file list assuming SB run first
  
  #South Bend
  jobs_func_monthly(downloads=downloads, files=file_info[1:3,])
  educ_exper_func_monthly(downloads=downloads, files=file_info[4,])
  
  #Elkhart
  jobs_func_monthly(downloads=downloads, files=file_info[5:7,])
  educ_exper_func_monthly(downloads=downloads, files=file_info[8,])
  
  #Clean up
  file.remove(file_info[,1])
  
}

full_copy_paste_monthly(downloads)
