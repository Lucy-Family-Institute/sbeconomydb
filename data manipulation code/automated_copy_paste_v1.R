#### South Bend MSA ####
jobs_func <- function() {
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel.xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/South Bend MSA/Jobs/Jobs Available/",format(today(),"%m.%d.%y"),".xls"))
  
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel (1).xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/South Bend MSA/Jobs/Industries by Advertised Jobs/",format(today(),"%m.%d.%y"),".xls"))
  
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel (2).xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/South Bend MSA/Jobs/Occupations by Advertised Jobs/",format(today(),"%m.%d.%y"),".xls"))
  
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel (3).xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/South Bend MSA/Jobs/Jobs by Occupation Group/",format(today(),"%m.%d.%y"),".xls"))
  
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel (4).xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/South Bend MSA/Jobs/Employers by Number of Job Openings/",format(today(),"%m.%d.%y"),".xls"))
  
  
  file.remove("C:/Users/LOANER/Downloads/ExportExcel.xls")
  file.remove("C:/Users/LOANER/Downloads/ExportExcel (1).xls")
  file.remove("C:/Users/LOANER/Downloads/ExportExcel (2).xls")
  file.remove("C:/Users/LOANER/Downloads/ExportExcel (3).xls")
  file.remove("C:/Users/LOANER/Downloads/ExportExcel (4).xls")
}
cand_func <- function() {
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel.xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/South Bend MSA/Candidates/Candidates Available/",format(today(),"%m.%d.%y"),".xls"))
  
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel (1).xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/South Bend MSA/Candidates/Occupations by Candidates Available/",format(today(),"%m.%d.%y"),".xls"))
  
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel (2).xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/South Bend MSA/Candidates/Candidates By Occupation Group/",format(today(),"%m.%d.%y"),".xls"))
  
  file.remove("C:/Users/LOANER/Downloads/ExportExcel.xls")
  file.remove("C:/Users/LOANER/Downloads/ExportExcel (1).xls")
  file.remove("C:/Users/LOANER/Downloads/ExportExcel (2).xls")
}
demand_supply_func <- function() {
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel.xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/South Bend MSA/Demand and Supply/Jobs and Candidates Available/",format(today(),"%m.%d.%y"),".xls"))
  
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel (1).xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/South Bend MSA/Demand and Supply/Number of Candidates and Openings for Jobs by Occupation/",format(today(),"%m.%d.%y"),".xls"))
  
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel (2).xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/South Bend MSA/Demand and Supply/Jobs and Candidates by Occupation Group/",format(today(),"%m.%d.%y"),".xls"))
  
  file.remove("C:/Users/LOANER/Downloads/ExportExcel.xls")
  file.remove("C:/Users/LOANER/Downloads/ExportExcel (1).xls")
  file.remove("C:/Users/LOANER/Downloads/ExportExcel (2).xls")
}
educ_exper_func <- function() {
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel.xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/South Bend MSA/Education, Training and Experience/Education Level of Jobs and Candidates/",format(today(),"%m.%d.%y"),".xls"))
  
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel (1).xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/South Bend MSA/Education, Training and Experience/Work Experience of Jobs and Candidates/",format(today(),"%m.%d.%y"),".xls"))
  
  file.remove("C:/Users/LOANER/Downloads/ExportExcel.xls")
  file.remove("C:/Users/LOANER/Downloads/ExportExcel (1).xls")
}
educ_exper_func()

#### SElkhart Goshen MSA ####
jobs_func_elk <- function() {
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel.xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/Elkhart Goshen MSA/Jobs/Jobs Available/",format(today(),"%m.%d.%y"),".xls"))
  
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel (1).xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/Elkhart Goshen MSA/Jobs/Industries by Advertised Jobs/",format(today(),"%m.%d.%y"),".xls"))
  
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel (2).xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/Elkhart Goshen MSA/Jobs/Occupations by Advertised Jobs/",format(today(),"%m.%d.%y"),".xls"))
  
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel (3).xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/Elkhart Goshen MSA/Jobs/Jobs by Occupation Group/",format(today(),"%m.%d.%y"),".xls"))
  
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel (4).xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/Elkhart Goshen MSA/Jobs/Employers by Number of Job Openings/",format(today(),"%m.%d.%y"),".xls"))
  
  
  file.remove("C:/Users/LOANER/Downloads/ExportExcel.xls")
  file.remove("C:/Users/LOANER/Downloads/ExportExcel (1).xls")
  file.remove("C:/Users/LOANER/Downloads/ExportExcel (2).xls")
  file.remove("C:/Users/LOANER/Downloads/ExportExcel (3).xls")
  file.remove("C:/Users/LOANER/Downloads/ExportExcel (4).xls")
}
jobs_func_elk()

cand_func_elk <- function() {
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel.xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/Elkhart Goshen MSA/Candidates/Candidates Available/",format(today(),"%m.%d.%y"),".xls"))
  
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel (1).xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/Elkhart Goshen MSA/Candidates/Occupations by Candidates Available/",format(today(),"%m.%d.%y"),".xls"))
  
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel (2).xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/Elkhart Goshen MSA/Candidates/Candidates By Occupation Group/",format(today(),"%m.%d.%y"),".xls"))
  
  file.remove("C:/Users/LOANER/Downloads/ExportExcel.xls")
  file.remove("C:/Users/LOANER/Downloads/ExportExcel (1).xls")
  file.remove("C:/Users/LOANER/Downloads/ExportExcel (2).xls")
}
cand_func_elk()

demand_supply_func_elk <- function() {
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel.xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/Elkhart Goshen MSA/Demand and Supply/Jobs and Candidates Available/",format(today(),"%m.%d.%y"),".xls"))
  
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel (1).xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/Elkhart Goshen MSA/Demand and Supply/Number of Candidates and Openings for Jobs by Occupation/",format(today(),"%m.%d.%y"),".xls"))
  
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel (2).xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/Elkhart Goshen MSA/Demand and Supply/Jobs and Candidates by Occupation Group/",format(today(),"%m.%d.%y"),".xls"))
  
  file.remove("C:/Users/LOANER/Downloads/ExportExcel.xls")
  file.remove("C:/Users/LOANER/Downloads/ExportExcel (1).xls")
  file.remove("C:/Users/LOANER/Downloads/ExportExcel (2).xls")
}
demand_supply_func_elk()

educ_exper_func_elk <- function() {
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel.xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/Elkhart Goshen MSA/Education, Training and Experience/Education Level of Jobs and Candidates/",format(today(),"%m.%d.%y"),".xls"))
  
  file.copy(from = "C:/Users/LOANER/Downloads/ExportExcel (1).xls",
            to   = paste0("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/Elkhart Goshen MSA/Education, Training and Experience/Work Experience of Jobs and Candidates/",format(today(),"%m.%d.%y"),".xls"))
  
  file.remove("C:/Users/LOANER/Downloads/ExportExcel.xls")
  file.remove("C:/Users/LOANER/Downloads/ExportExcel (1).xls")
}
educ_exper_func_elk()