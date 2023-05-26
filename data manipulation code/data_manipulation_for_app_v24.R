# this code does the data manipulation and saves the csv files in the Shiny app folder
# so that the app can be updated easily

library(tidyverse)
library(plotly)
library(readxl)
library(rvest)
library(lubridate)
library(readxl)
library(tidycensus)

setwd("C:/Users/mhauenst/Documents/sbeconomydb")

# Data manipulation
#### Jobs ####
total_openings_1 <- lapply(list.files("./raw data/South Bend MSA/Jobs/Jobs Available", full.names = T), function(x) {
  print(x)
  read_html(x) %>%
    html_table(header = T) %>% .[[1]] %>%
    transmute(dt=str_remove(x,".xls"),
           `Job Openings`=as.numeric(str_remove(`Job Openings`,","))) 
}) %>% bind_rows() %>% tibble() %>% mutate(msa="South Bend - Mishawaka")

total_openings_2 <- lapply(list.files("./raw data/Elkhart Goshen MSA/Jobs/Jobs Available", full.names = T), function(x) {
  print(x)
  read_html(x) %>%
    html_table(header = T) %>% .[[1]] %>%
    transmute(dt=str_remove(x,".xls"),
           `Job Openings`=as.numeric(str_remove(`Job Openings`,",")))
}) %>% bind_rows() %>% tibble() %>% mutate(msa="Elkhart - Goshen")

total_openings <- bind_rows(total_openings_1,total_openings_2)
rm(total_openings_1,total_openings_2)

df0 <- total_openings %>% select(dt,`Job Openings`,msa) %>% mutate(indicator="Total Openings") %>%
  group_by(msa) %>%
  mutate(max_dt=max(mdy(dt)),
         comp_month=month(max_dt-years(1)),
         comp_yr=year(max_dt-years(1)),
         avg_last_yr=mean(`Job Openings`[month(mdy(dt))==comp_month & year(mdy(dt))==comp_yr]),
         per_change=(`Job Openings`-avg_last_yr)/avg_last_yr) %>%
  ungroup() %>% mutate(var="Total Openings")


openings_industries_1 <- lapply(list.files("./raw data/South Bend MSA/Jobs/Industries by Advertised Jobs", full.names = T), function(x) {
  print(x)
  read_html(x) %>%
    html_table(header = T) %>% .[[1]] %>%
    mutate(dt=str_remove(x,".xls"),
           `Job Openings`=as.numeric(str_remove(`Job Openings`,",")))
}) %>% bind_rows()%>% tibble() %>% mutate(msa="South Bend - Mishawaka")

openings_industries_2 <- lapply(list.files("./raw data/Elkhart Goshen MSA/Jobs/Industries by Advertised Jobs", full.names = T), function(x) {
  print(x)
  read_html(x) %>%
    html_table(header = T) %>% .[[1]] %>%
    mutate(dt=str_remove(x,".xls"),
           `Job Openings`=as.numeric(str_remove(`Job Openings`,",")))
}) %>% bind_rows()%>% tibble()%>% mutate(msa="Elkhart - Goshen")

openings_industries <- bind_rows(openings_industries_1,openings_industries_2)
rm(openings_industries_1,openings_industries_2)

df1 <- openings_industries %>% select(var=Industry,dt,`Job Openings`,msa) %>% mutate(indicator="industry") %>%
  group_by(var,msa) %>%
  mutate(max_dt=max(mdy(dt)),
         comp_month=month(max_dt-years(1)),
         comp_yr=year(max_dt-years(1)),
         avg_last_yr=mean(`Job Openings`[month(mdy(dt))==comp_month & year(mdy(dt))==comp_yr]),
         per_change=(`Job Openings`-avg_last_yr)/avg_last_yr) %>%
  ungroup()

#### Education Level of Jobs and Candidates ####
educ_1 <- lapply(list.files("./raw data/South Bend MSA/Education, Training and Experience/Education Level of Jobs and Candidates", full.names = T), function(x) {
  print(x)
  read_html(x) %>%
    html_table(header = T) %>%
    .[[1]] %>%
    mutate(dt=str_remove(x,".xls"),
           `Potential Candidates`=as.numeric(str_remove(`Potential Candidates`,",")),
           `Job Openings`=as.numeric(str_remove(`Job Openings`,",")))
}) %>% bind_rows() %>% tibble()%>% mutate(msa="South Bend - Mishawaka")

educ_2 <- lapply(list.files("./raw data/Elkhart Goshen MSA/Education, Training and Experience/Education Level of Jobs and Candidates", full.names = T), function(x) {
  print(x)
  read_html(x) %>%
    html_table(header = T) %>%
    .[[1]] %>%
    mutate(dt=str_remove(x,".xls"),
           `Potential Candidates`=as.numeric(str_remove(`Potential Candidates`,",")),
           `Job Openings`=as.numeric(str_remove(`Job Openings`,",")))
}) %>% bind_rows() %>% tibble() %>% mutate(msa="Elkhart - Goshen")

educ <- bind_rows(educ_1,educ_2)
rm(educ_1,educ_2)

df_educ <- educ %>% select(var=`Education Level`,dt,`Job Openings`,msa) %>% mutate(indicator="education") %>%
  group_by(var,msa) %>%
  mutate(max_dt=max(mdy(dt)),
         comp_month=month(max_dt-years(1)),
         comp_yr=year(max_dt-years(1)),
         avg_last_yr=mean(`Job Openings`[month(mdy(dt))==comp_month & year(mdy(dt))==comp_yr]),
         per_change=(`Job Openings`-avg_last_yr)/avg_last_yr) %>%
  ungroup()


df <- bind_rows(df0,df1,df_educ)%>%
  mutate(dt=mdy(dt)) %>%
  arrange(dt) # arrange seems to be important to avoid an additional line connecting first and last observations

write_rds(df,"app/data/df.Rds")

rm(df,df0,df1,df_educ)

#### Candidate level data ####
#### Total Candidates ####
total_candidates_1 <- lapply(list.files("./raw data/South Bend MSA/Candidates/Candidates Available", full.names = T), function(x) {
  print(x)
  read_html(x) %>%
    html_table(header = T) %>%
    .[[1]] %>%
    mutate(dt=str_remove(x,".xls"),
           Candidates=as.numeric(str_remove(Candidates,",")))
}) %>% bind_rows() %>% tibble() %>% mutate(msa="South Bend - Mishawaka")

total_candidates_2 <- lapply(list.files("./raw data/Elkhart Goshen MSA/Candidates/Candidates Available", full.names = T), function(x) {
  print(x)
  read_html(x) %>%
    html_table(header = T) %>%
    .[[1]] %>%
    mutate(dt=str_remove(x,".xls"),
           Candidates=as.numeric(str_remove(Candidates,",")))
}) %>% bind_rows() %>% tibble() %>% mutate(msa="Elkhart - Goshen")

total_candidates <- bind_rows(total_candidates_1,total_candidates_2)
rm(total_candidates_1,total_candidates_2)

#### Candidates By Occupation Group ####
candidate_occ_grp_1 <- lapply(list.files("./raw data/South Bend MSA/Candidates/Candidates By Occupation Group", full.names = T), function(x) {
  print(x)
  read_html(x) %>%
    html_table(header = T) %>%
    .[[1]] %>%
    mutate(dt=str_remove(x,".xls"),
           Candidates=as.numeric(str_remove(Candidates,",")))
}) %>% bind_rows() %>% tibble() %>% mutate(msa="South Bend - Mishawaka")

candidate_occ_grp_2 <- lapply(list.files("./raw data/Elkhart Goshen MSA/Candidates/Candidates By Occupation Group", full.names = T), function(x) {
  print(x)
  read_html(x) %>%
    html_table(header = T) %>%
    .[[1]] %>%
    mutate(dt=str_remove(x,".xls"),
           Candidates=as.numeric(str_remove(Candidates,",")))
}) %>% bind_rows() %>% tibble() %>% mutate(msa="Elkhart - Goshen")

candidate_occ_grp <- bind_rows(candidate_occ_grp_1,candidate_occ_grp_2)
rm(candidate_occ_grp_1,candidate_occ_grp_2)

df0_cand <- total_candidates %>% select(dt,`Candidates`,msa) %>% mutate(indicator="Total Candidates") %>%
  group_by(msa) %>%
  mutate(max_dt=max(mdy(dt)),
         comp_month=month(max_dt-years(1)),
         comp_yr=year(max_dt-years(1)),
         avg_last_yr=mean(Candidates[month(mdy(dt))==comp_month & year(mdy(dt))==comp_yr]),
         per_change=(Candidates-avg_last_yr)/avg_last_yr) %>%
  mutate(var="Total Candidates")%>%
  ungroup()

df2_cand <- candidate_occ_grp %>% select(var=`Occupation Group`,dt,`Candidates`,msa) %>% mutate(indicator="Occupation Group") %>%
  group_by(var,msa) %>%
  mutate(max_dt=max(mdy(dt)),
         comp_month=month(max_dt-years(1)),
         comp_yr=year(max_dt-years(1)),
         avg_last_yr=mean(Candidates[month(mdy(dt))==comp_month & year(mdy(dt))==comp_yr]),
         per_change=(Candidates-avg_last_yr)/avg_last_yr) %>%
  ungroup()

# education level of candidates
df_educ_cand <- educ %>% select(var=`Education Level`,dt,Candidates=`Potential Candidates`,msa) %>% mutate(indicator="education") %>%
  group_by(var,msa) %>%
  mutate(max_dt=max(mdy(dt)),
         comp_month=month(max_dt-years(1)),
         comp_yr=year(max_dt-years(1)),
         avg_last_yr=mean(Candidates[month(mdy(dt))==comp_month & year(mdy(dt))==comp_yr]),
         per_change=(Candidates-avg_last_yr)/avg_last_yr) %>%
  ungroup()


df_cand <- bind_rows(df0_cand,df2_cand,df_educ_cand)%>%
  mutate(dt=lubridate::mdy(dt)) %>%
  arrange(dt)

write_rds(df_cand,"./app/data/df_cand.Rds")

rm(df_cand,df0_cand,df2_cand,df_educ_cand)


####employers - South Bend ####

latest_date <- list.files("./raw data/South Bend MSA/Jobs/Employers by Number of Job Openings") %>% mdy() %>% max()

file_name <- paste0("./raw data/South Bend MSA/Jobs/Employers by Number of Job Openings/",str_pad(month(latest_date),width=2,pad=0),".",str_pad(day(latest_date),width=2,pad=0),".",substr(year(latest_date),3,4),".xls")

employers_jobs_sb <- read_html(file_name) %>%
  html_table(header = T) %>% .[[1]] %>%
  mutate(`Job Openings`=as.numeric(str_remove(`Job Openings`,","))) %>%
  mutate(freq=log(`Job Openings`)) %>%
  select(word=`Employer Name`,freq) %>%
  mutate(msa="South Bend - Mishawaka")

latest_date <- list.files("./raw data/Elkhart Goshen MSA/Jobs/Employers by Number of Job Openings") %>% mdy() %>% max()

file_name <- paste0("./raw data/Elkhart Goshen MSA/Jobs/Employers by Number of Job Openings/",str_pad(month(latest_date),width=2,pad=0),".",str_pad(day(latest_date),width=2,pad=0),".",substr(year(latest_date),3,4),".xls")

employers_jobs_eg <- read_html(file_name) %>%
  html_table(header = T) %>% .[[1]] %>%
  mutate(`Job Openings`=as.numeric(str_remove(`Job Openings`,","))) %>%
  mutate(freq=log(`Job Openings`)) %>%
  select(word=`Employer Name`,freq) %>%
  mutate(msa="Elkhart - Goshen")


bind_rows(employers_jobs_sb,employers_jobs_eg)%>%
  write_rds("./app/data/employers_jobs.Rds")

rm(employers_jobs_sb,employers_jobs_eg)

#### occupations ####
# South bend
latest_date <- list.files("./raw data/South Bend MSA/Jobs/Occupations by Advertised Jobs",pattern = ".xls") %>% mdy() %>% max()

file_name <- paste0("./raw data/South Bend MSA/Jobs/Occupations by Advertised Jobs/",str_pad(month(latest_date),width=2,pad=0),".",str_pad(day(latest_date),width=2,pad=0),".",substr(year(latest_date),3,4),".xls")

jobs_occupations_sb <- read_html(file_name)%>%
  html_table(header = T) %>% .[[1]]%>%
  select(Occupation,`Job Openings`) %>%
  mutate(msa="South Bend - Mishawaka", dt=latest_date)%>%
  slice_head(n=10)

latest_date <- list.files("./raw data/Elkhart Goshen MSA/Jobs/Occupations by Advertised Jobs",pattern = ".xls") %>% mdy() %>% max()

file_name <- paste0("./raw data/Elkhart Goshen MSA/Jobs/Occupations by Advertised Jobs/",str_pad(month(latest_date),width=2,pad=0),".",str_pad(day(latest_date),width=2,pad=0),".",substr(year(latest_date),3,4),".xls")

jobs_occupations_eg <- read_html(file_name)%>%
  html_table(header = T) %>% .[[1]]%>%
  select(Occupation,`Job Openings`) %>%
  mutate(msa="Elkhart - Goshen", dt=latest_date)%>%
  slice_head(n=10)

bind_rows(jobs_occupations_sb,jobs_occupations_eg)%>%
  write_rds("./app/data/jobs_occupations.Rds")
rm(jobs_occupations_sb,jobs_occupations_eg)



# business licenses
sb_businesses_upto_2018 <- read_csv("raw data/SB business licences/Business_Licenses.csv")

sb_businesses_post_2019 <- read_excel("raw data/SB business licences/BusinessLicenseReport2019-2020.xlsx", 
                                      sheet = "Reader Friendly")

# total licenses (new+renewal) over time

sb_business_licenses <- bind_rows(sb_businesses_upto_2018 %>%
                             mutate(mnth=mdy(paste0(month(ymd_hms(Issue_Date)),"-1-",year(ymd_hms(Issue_Date))))) %>%
                             group_by(mnth) %>%
                             summarise(issues=n()),
                           sb_businesses_post_2019 %>%
                             mutate(mnth=mdy(paste0(month(mdy(`Issued Date`)),"-1-",`Issued Year`))) %>%
                             group_by(mnth) %>%
                             summarise(issues=n()))

write_rds(sb_business_licenses,"app/data/sb_business_licenses.Rds")

rm(sb_businesses_upto_2018,sb_businesses_post_2019,sb_business_licenses)


# occupational wage growth 
read_rds("C:/Users/LOANER/OneDrive - nd.edu/Data/OES/oes data manipualtion/sb_oes.Rds") %>%
  write_rds("app/data/sb_oes.Rds")



#### Industry Structure
area_titles <- blscrapeR::area_titles %>% mutate(area_fips=as.character(area_fips))%>%
  mutate(area_title=str_remove(area_title," MSA"))
cleaned_industry_titles <- blscrapeR::naics %>% mutate(industry_title=str_remove(industry_title,"NAICS [0-9]+ ")) %>%
  mutate(industry_title=str_remove(industry_title,"NAICS [0-9]+-[0-9]+ "))

msa_qcew_2019_q4 <- read_csv("C:/Users/Swapnil PC/OneDrive - nd.edu/Data/QCEW/msa/msa_qcew_2019_q4.csv")

sb_naics_sector <- msa_qcew_2019_q4 %>%
  select(area_fips,own_code,industry_code,agglvl_code,size_code,year,qtr,month3_emplvl) %>%
  filter(agglvl_code==44) %>% # MSA, Private, by NAICS Sector
  group_by(area_fips,industry_code, year,qtr) %>% 
  summarise(bls_employment=sum(month3_emplvl, na.rm = T)) %>% # aggregate over own_code
  ungroup() %>%
  filter(industry_code!=9999) %>% # remove undefined industry
  left_join(area_titles, by="area_fips") %>%
  left_join(cleaned_industry_titles, by="industry_code")  %>% # lets keep this to emphasise these are MSAs
  select(msa_fips=area_fips,msa_name=area_title,industry_code,industry_title,bls_employment,year,qtr) %>%
  filter(msa_name=="South Bend-Mishawaka, IN-MI") # the total employment numbers are very low. checj that

write_csv(sb_naics_sector,"C:/Users/Swapnil PC/OneDrive - nd.edu/Data/Job postings/Job Postings App/sb_naics_sector.csv")

### Occupations
sb_oes <- read_excel("C:/Users/Swapnil PC/OneDrive - nd.edu/Data/OES/oesm19ma/oesm19ma/MSA_M2019_dl.xlsx") %>%
  filter(area_title=="South Bend-Mishawaka, IN-MI", o_group=="major") %>%
  mutate(tot_emp=as.numeric(tot_emp))

write_csv(sb_oes,"C:/Users/Swapnil PC/OneDrive - nd.edu/Data/Job postings/Job Postings App/sb_oes.csv")

