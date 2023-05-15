# this script should be run each month


library(tidyverse)
library(plotly)
library(readxl)
library(rvest)
library(lubridate)
library(readxl)
library(tidycensus)

#### Job skills in demand ####
setwd("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/South Bend MSA/Jobs/update once a month/Advertised Job Skills/")

latest_date <- list.files() %>% my() %>% max()

file_name <- paste0(str_pad(month(latest_date),width=2,pad=0),".",substr(year(latest_date),3,4),".xls")

skills_jobs_sb <- read_html(file_name) %>%
  html_table(header = T) %>% .[[1]] %>%
  select(`Advertised Detailed Job Skill`,`Job Opening Match Count`) %>%
  mutate(`Job Opening Match Count`=as.numeric(str_remove(`Job Opening Match Count`,","))) %>%
  mutate(msa="South Bend - Mishawaka", dt=latest_date) 

setwd("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/Elkhart Goshen MSA/Jobs/update once a month/Advertised Job Skills/")

latest_date <- list.files() %>% my() %>% max()

file_name <- paste0(str_pad(month(latest_date),width=2,pad=0),".",substr(year(latest_date),3,4),".xls")

skills_jobs_eg <- read_html(file_name) %>%
  html_table(header = T) %>% .[[1]] %>%
  select(`Advertised Detailed Job Skill`,`Job Opening Match Count`) %>%
  mutate(`Job Opening Match Count`=as.numeric(str_remove(`Job Opening Match Count`,","))) %>%
  mutate(msa="Elkhart - Goshen", dt=latest_date)

bind_rows(skills_jobs_sb,skills_jobs_eg)%>%
  write_rds("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/app/data/skills_jobs.Rds")

rm(skills_jobs_sb,skills_jobs_eg,file_name,latest_date)

#### Tools and Technologies in demand ####
setwd("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/South Bend MSA/Jobs/update once a month/Advertised Tools and Technology/")

latest_date <- list.files() %>% my() %>% max()

file_name <- paste0(str_pad(month(latest_date),width=2,pad=0),".",substr(year(latest_date),3,4),".xls")

tools_jobs_sb <- read_html(file_name) %>%
  html_table(header = T) %>% .[[1]] %>%
  select(`Advertised Detailed Tool or Technology`,`Job Opening Match Count`) %>%
  mutate(`Job Opening Match Count`=as.numeric(str_remove(`Job Opening Match Count`,","))) %>%
  mutate(msa="South Bend - Mishawaka", dt=latest_date) 

setwd("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/Elkhart Goshen MSA/Jobs/update once a month/Advertised Tools and Technology/")

latest_date <- list.files() %>% my() %>% max()

file_name <- paste0(str_pad(month(latest_date),width=2,pad=0),".",substr(year(latest_date),3,4),".xls")

tools_jobs_eg <- read_html(file_name) %>%
  html_table(header = T) %>% .[[1]] %>%
  select(`Advertised Detailed Tool or Technology`,`Job Opening Match Count`) %>%
  mutate(`Job Opening Match Count`=as.numeric(str_remove(`Job Opening Match Count`,","))) %>%
  mutate(msa="Elkhart - Goshen", dt=latest_date)

bind_rows(tools_jobs_sb,tools_jobs_eg)%>%
  write_rds("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/app/data/tools_jobs.Rds")

rm(tools_jobs_sb,tools_jobs_eg,file_name,latest_date)

#### Job Certifications ####
setwd("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/South Bend MSA/Education, Training and Experience/update once a month/Advertised Job Certifications/")

latest_date <- list.files() %>% my() %>% max()

file_name <- paste0(str_pad(month(latest_date),width=2,pad=0),".",year(latest_date),".xls")

certifications_jobs_sb <- read_html(file_name) %>%
  html_table(header = T) %>% .[[1]] %>%
  select(`Advertised Certification Group`,`Job Opening Match Count`) %>%
  mutate(`Job Opening Match Count`=as.numeric(str_remove(`Job Opening Match Count`,","))) %>%
  mutate(msa="South Bend - Mishawaka", dt=latest_date) %>%
  slice_head(n=10)

setwd("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/Elkhart Goshen MSA/Education, Training and Experience/update once a month/Advertised Job Certifications/")

latest_date <- list.files() %>% my() %>% max()

file_name <- paste0(str_pad(month(latest_date),width=2,pad=0),".",year(latest_date),".xls")

certifications_jobs_eg <- read_html(file_name) %>%
  html_table(header = T) %>% .[[1]] %>%
  select(`Advertised Certification Group`,`Job Opening Match Count`) %>%
  mutate(`Job Opening Match Count`=as.numeric(str_remove(`Job Opening Match Count`,","))) %>%
  mutate(msa="Elkhart - Goshen", dt=latest_date) %>%
  slice_head(n=10)

bind_rows(certifications_jobs_sb,certifications_jobs_eg)%>%
  write_rds("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/app/data/certifications_jobs.Rds")

rm(certifications_jobs_sb,certifications_jobs_eg,file_name,latest_date)

#### monthly change in unemployed and jobs ####
library(rvest)

setwd("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/South Bend MSA/Demand and Supply/update once a month/Number of Unemployed per Job Opening")

unemp_job_openings_sb <- lapply(list.files(), function(x) {
  print(x)
  read_html(x) %>%
    html_table(header = T) %>% .[[1]] %>%
    mutate(dt=my(str_remove(x,".xls")),
           Unemployed=as.numeric(str_remove(Unemployed,",")),
           `Job Openings`=as.numeric(str_remove(`Job Openings`,",")),
           `Number of Unemployed per Job Opening`=as.numeric(str_remove(`Number of Unemployed per Job Opening`,",")))
}) %>% bind_rows() %>% tibble()

setwd("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/Elkhart Goshen MSA/Demand and Supply/update once a month/Number of Unemployed per Job Opening")

unemp_job_openings_elk <- lapply(list.files(pattern=".xls"), function(x) {
  print(x)
  read_html(x) %>%
    html_table(header = T) %>% .[[1]] %>%
    mutate(dt=my(str_remove(x,".xls")),
           Unemployed=as.numeric(str_remove(Unemployed,",")),
           `Job Openings`=as.numeric(str_remove(`Job Openings`,",")),
           `Number of Unemployed per Job Opening`=as.numeric(str_remove(`Number of Unemployed per Job Opening`,",")))
}) %>% bind_rows() %>% tibble()

setwd("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/raw data/other MSAs/Number of Unemployed per Job Opening Distribution/")

unemp_job_openings_oth <- lapply(list.files(pattern=".xls"), function(x) {
  print(x)
  read_html(x) %>%
    html_table(header = T) %>% .[[1]] %>%
    mutate(dt=my(str_remove(x,".xls")),
           Unemployed=as.numeric(str_remove(Unemployed,",")),
           `Job Openings`=as.numeric(str_remove(`Job Openings`,",")),
           `Number of Unemployed per Job Opening`=as.numeric(str_remove(`Number of Unemployed per Job Opening`,",")))
}) %>% bind_rows() %>% tibble() %>% select(-Rank)

# bind al MSAs together
emp <- bind_rows(unemp_job_openings_sb,unemp_job_openings_elk, unemp_job_openings_oth) %>%
  separate(Area, into = c("msa_name","st"), sep=", ") %>% mutate(msa_name=str_replace(msa_name,"-"," - ")) %>%
  select(-st,-Preliminary) %>%
  gather(measure,value,-msa_name,-dt) %>%
  group_by(msa_name,measure) %>%
  arrange(dt) %>%
  mutate(last_yr_value=lag(value,12),yoy_change=(value-last_yr_value)/last_yr_value,
         last_qtr_value=lag(value,3),qtr_change=(value-last_qtr_value)/last_qtr_value,
         last_mnth_value=lag(value,1),mnth_change=(value-last_mnth_value)/last_mnth_value
  )


# clean version for display
emp %>%
  filter(dt==max(dt)) %>%
  ungroup() %>%
  select(msa_name,Measure=measure,Current=value,dt, # keep date used to show the latest month 
         `Previous 30 days`=mnth_change,`Previous 90 days`=qtr_change,`Previous Year`=yoy_change) %>%
  write_rds("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/app/data/emp_change.Rds")


rm(unemp_job_openings_sb,unemp_job_openings_elk,emp,unemp_job_openings_oth)

setwd("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb") # get back to original working directory

#### Current Employment Survey ####
# all series for indiana
in_series <- read_delim("https://download.bls.gov/pub/time.series/sm/sm.data.15.Indiana", 
                        "\t", escape_double = FALSE, trim_ws = TRUE) %>%
  mutate(value=value*1000) # values are in thousands

selected_series_sb_elk_msa <- read_csv("raw data/selected_ces_series_sb_elk_msa.csv")

# keep only series we want
sb_elk_ces_supersectors <- in_series %>%
  filter(series_id %in% selected_series_sb_elk_msa$series_id) %>%
  filter(period!="M13") %>% # annual average
  mutate(dt=mdy(paste0(substr(period,2,3),"-01-",year))) %>%
  left_join(selected_series_sb_elk_msa, by="series_id") %>% # add text
  select(state_code,area_code,supersector_code,industry_code,industry_name,area_name,dt,total_employment=value)

sb_elk_ces_supersectors$dt %>% max() # "2022-09-01" # latest date

rm(in_series,selected_series_sb_elk_msa)

pre_covid_dt=ymd(paste0("2019-",month(max(sb_elk_ces_supersectors$dt)),"-01"))

sb_elk_ces_sup <- sb_elk_ces_supersectors %>%
  filter(year(dt)>=2000) %>%
  separate(area_name, into = c("msa_name","st"), sep=", ") %>%
  group_by(msa_name,industry_code) %>%
  mutate(last_yr_emp=lag(total_employment,12),yoy_change=(total_employment-last_yr_emp)/last_yr_emp,
         last_qtr_emp=lag(total_employment,3),qtr_change=(total_employment-last_qtr_emp)/last_qtr_emp,
         last_mnth_emp=lag(total_employment,1),mnth_change=(total_employment-last_mnth_emp)/last_mnth_emp,
         rel_covid_emp=total_employment[dt==pre_covid_dt],rel_covid_change=(total_employment-rel_covid_emp)/rel_covid_emp
  ) %>%
  mutate(change=total_employment-last_yr_emp,per_change=(change)/last_yr_emp, # these are for value boxes
         msa_name=str_replace(msa_name,"-"," - ")) %>%
  ungroup()

write_rds(sb_elk_ces_sup,"app/data/sb_elk_ces_sup.Rds")

# create a clean version for display

sb_elk_ces_sup %>%
  filter(dt==max(dt)) %>%
  filter(as.numeric(supersector_code)>8 | industry_name=="Total Nonfarm") %>%
  arrange(desc(total_employment)) %>%
  select(msa_name,Industry=industry_name,dt,`Total Employment`=total_employment,
         `Previous 30 days`=mnth_change,`Previous 90 days`=qtr_change,`Previous Year`=yoy_change,`Pre-covid`=rel_covid_change) %>%
  write_rds("app/data/small_ces.Rds")

rm(sb_elk_ces_sup,pre_covid_dt,sb_elk_ces_supersectors)

# ces wage
# all series for indiana
in_series <- read_delim("https://download.bls.gov/pub/time.series/sm/sm.data.15.Indiana", 
                        "\t", escape_double = FALSE, trim_ws = TRUE)

selected_series_sb_elk_msa_wage <- read_rds("raw data/selected_series_sb_elk_msa_wage.Rds")


# keep only series we want
sb_elk_ces_supersectors_wage <- in_series %>%
  filter(series_id %in% selected_series_sb_elk_msa_wage$series_id) %>%
  filter(period!="M13") %>% # annual average
  mutate(dt=mdy(paste0(substr(period,2,3),"-01-",year))) %>%
  left_join(selected_series_sb_elk_msa_wage, by="series_id") %>% # add text
  select(state_code,area_code,supersector_code,industry_code,industry_name,area_name,dt,hourly_wage=value)

sb_elk_ces_supersectors_wage$dt %>% max() # "2022-09-01" # latest date

rm(in_series,selected_series_sb_elk_msa_wage)

pre_covid_dt=ymd(paste0("2019-",month(max(sb_elk_ces_supersectors_wage$dt)),"-01"))

sb_elk_ces_sup_wage <- sb_elk_ces_supersectors_wage %>%
  filter(year(dt)>=2000) %>%
  separate(area_name, into = c("msa_name","st"), sep=", ") %>%
  group_by(msa_name,industry_code) %>%
  mutate(last_yr_wage=lag(hourly_wage,12),yoy_change=(hourly_wage-last_yr_wage)/last_yr_wage,
         last_qtr_wage=lag(hourly_wage,3),qtr_change=(hourly_wage-last_qtr_wage)/last_qtr_wage,
         last_mnth_wage=lag(hourly_wage,1),mnth_change=(hourly_wage-last_mnth_wage)/last_mnth_wage,
         rel_covid_wage=hourly_wage[dt==pre_covid_dt],rel_covid_change=(hourly_wage-rel_covid_wage)/rel_covid_wage
  ) %>%
  mutate(change=hourly_wage-last_yr_wage,per_change=(change)/last_yr_wage, # these are for value boxes
         msa_name=str_replace(msa_name,"-"," - ")) %>%
  ungroup()

write_rds(sb_elk_ces_sup_wage,"app/data/sb_elk_ces_sup_wage.Rds")


rm(sb_elk_ces_supersectors_wage)

# labor force and employment
# read all the laus data for indiana
laus_in <- read_delim("https://download.bls.gov/pub/time.series/la/la.data.21.Indiana", 
                      "\t", escape_double = FALSE, trim_ws = TRUE)

# now I need to identify series for sb-mishawaka
# area types
laus_series <- read_delim("https://download.bls.gov/pub/time.series/la/la.series", 
                          "\t", escape_double = FALSE, trim_ws = TRUE)

select_series <- laus_series %>% filter(area_type_code=="B", srd_code==18)

laus_select_areas <- laus_in %>% filter(series_id %in% select_series$series_id)%>%
  filter(period!="M13") %>% # annual average
  mutate(dt=mdy(paste0(substr(period,2,3),"-01-",year))) %>%
  left_join(select_series, by="series_id") %>% # add text
  select(state_code=srd_code,area_code,series_title,dt,value)

laus_select_areas$dt %>% max() # "2022-08-01"

rm(laus_in,laus_series,select_series)

pre_covid_dt=ymd(paste0("2019-",month(max(laus_select_areas$dt)),"-01"))

laus_select <- laus_select_areas %>%
  filter(year(dt)>=2000) %>%
  separate(series_title, into = c("measure","area"),sep = ": ") %>%
  separate(area,into=c("msa_name","area_type","area_state"),sep=", ") %>%
  filter(is.na(area_state)) %>% # remove the IN part and MI part series
  group_by(msa_name,measure) %>%
  mutate(last_yr_value=lag(value,12),yoy_change=(value-last_yr_value)/last_yr_value,
         last_qtr_value=lag(value,3),qtr_change=(value-last_qtr_value)/last_qtr_value,
         last_mnth_value=lag(value,1),mnth_change=(value-last_mnth_value)/last_mnth_value,
         rel_covid_value=value[dt==pre_covid_dt],rel_covid_change=(value-rel_covid_value)/rel_covid_value,
         msa_name=str_replace(msa_name,"-"," - "),
         per_change=yoy_change) %>% # add a space beteen msa name to standardize
  ungroup()

write_rds(laus_select,"app/data/laus_select.Rds")


# clean version for display
laus_select %>%
  filter(dt==max(dt), !str_detect(measure,"Unemployment")) %>%
  select(msa_name,Measure=measure,Current=value,dt,
         `Previous 30 days`=mnth_change,`Previous 90 days`=qtr_change,`Previous Year`=yoy_change,`Pre-covid`=rel_covid_change) %>%
  write_rds("app/data/small_laus.Rds")

rm(laus_select_areas,laus_select,pre_covid_dt)


### housing
yr <- formatC(seq(19,22), width = 2, format = "d", flag = "0")
mnth <- formatC(seq(1,12), width = 2, format = "d", flag = "0")

eg <- expand.grid(yr, mnth)
# check the latest month here: https://www2.census.gov/econ/bps/Metro/
yr_mnth <- sprintf('%s%s', eg[,1], eg[,2]) %>% sort() %>% head(x,n=-4) # lost last 5 months of 2022 for which data is not available

links <- paste0("https://www2.census.gov/econ/bps/Metro/ma",yr_mnth,"c.txt") # c is for current

df <- lapply(links, function(x) {
  Sys.sleep(2)
  print(x)
  read_csv(x, 
           skip = 1)
}) %>% bind_rows()

max(df$Date) # 202208

rm(links,yr,mnth,eg,yr_mnth,links)

housing_sb <- df %>%
  filter(Name=="South Bend-Mishawaka  IN-MI")  %>% 
  separate(Date, into = c("YY", "MM"), sep = c(4)) %>% 
  mutate(dt=mdy(paste0(MM,"-1-",YY))) %>%
  select(dt,Bldgs=`Bldgs...6`,Units=`Units...7`) %>%
  gather(key,total,-dt) %>% group_by(key) %>% mutate(per_change=(total-total[dt=="2020-01-01"])/total[dt=="2020-01-01"])

write_rds(housing_sb,"app/data/housing_sb.Rds")

rm(df,housing_sb)

### Eviction data ###
sb_evictions <- read_csv("https://eviction-lab-data-downloads.s3.amazonaws.com/ets/all_sites_weekly_2020_2021.csv") %>%
  filter(str_detect(city,"South Bend"))

sb_evictions$week_date %>% max() # "2022-09-31"

sb_weekly <- sb_evictions %>% group_by(week_date) %>%
  summarise(total_filings=sum(filings_2020),
            avg_filings=sum(filings_avg)) %>%
  mutate(per_change=(total_filings-avg_filings)/avg_filings)

sb_weekly %>% write_rds("app/data/sb_weekly_evictions.Rds")
rm(sb_evictions,sb_weekly)

# home values
home_prices <- read_csv("https://files.zillowstatic.com/research/public_csvs/zhvi/Metro_zhvi_uc_sfrcondo_tier_0.33_0.67_sm_sa_month.csv")

home_prices_in <- home_prices %>%
  filter(StateName=="IN") %>% # indiana regions
  select(-RegionID,-SizeRank,-RegionType, -StateName) %>% # housekeeping
  gather(dt,value,-RegionName) %>% # wide to long
  filter(!is.na(value)) %>%
  mutate(dt=ymd(dt)) %>%
  arrange(RegionName,desc(dt)) %>%
  group_by(RegionName) %>%
  mutate(lastyrvalue=lead(value,12), per_change=(value-lastyrvalue)/lastyrvalue) %>%
  ungroup() %>%
  rename(msa=RegionName) %>%
  mutate(msa=ifelse(msa=="South Bend, IN","South Bend - Mishawaka",
                    ifelse(msa=="Elkhart, IN","Elkhart - Goshen",msa)))

home_prices_in$dt %>% max() # "2022-09-31"

home_prices_in %>% write_rds("app/data/home_prices_in.Rds")
rm(home_prices,home_prices_in)

# federal data
fhfa_hpi_in <- read_csv("https://www.fhfa.gov/DataTools/Downloads/Documents/HPI/HPI_AT_metro.csv", col_names = F) %>%
  rename(msa_name=1,msa_id=2,yr=3,qtr=4, index=5) %>%
  mutate(index=as.numeric(index)) %>%
  filter(str_detect(msa_name," IN")) %>%
  arrange(msa_name,yr,qtr) %>%
  group_by(msa_name) %>%
  mutate(lastyrindex=lag(index,4), per_change=(index-lastyrindex)/lastyrindex) %>%
  mutate(msa_name=ifelse(str_detect(msa_name,"South Bend"),"South Bend - Mishawaka",
                         ifelse(str_detect(msa_name,"Elkhart"),"Elkhart - Goshen",msa_name)),
         yr_q=yq(paste(yr,"-",qtr)))

fhfa_hpi_in$yr_q %>% max() # "2022-04-31"

fhfa_hpi_in %>% write_rds("app/data/fhfa_hpi_in.Rds")
rm(fhfa_hpi_in)

### rental prices
zori_in <- read_csv("https://files.zillowstatic.com/research/public_csvs/zori/Metro_zori_sm_month.csv") %>%
  filter(RegionType=="country"| StateName=="IN") %>%
  select(RegionName,6:length(names(.))) %>%
  gather(mnth,rent_index,-RegionName) %>%
  mutate(mnth=ymd(mnth)) %>%
  group_by(RegionName) %>% arrange(RegionName,mnth) %>%
  mutate(lastyrindex=lag(rent_index,12), per_change=(rent_index-lastyrindex)/lastyrindex)%>%
  mutate(RegionName=ifelse(str_detect(RegionName,"South Bend"),"South Bend - Mishawaka",
                           ifelse(str_detect(RegionName,"Elkhart"),"Elkhart - Goshen",RegionName))) %>%
  filter(per_change<0.50) # more thn 50% change seems incorrect

zori_in$mnth %>% max() # "2022-09-30"

zori_in %>% write_rds("app/data/zori_in.Rds")
rm(zori_in)


### poverty and spending ###
snap_tanf_df <- lapply(list.files("raw data/poverty/snap and tanf/",pattern = ".xls"), function (x) {
  print(x)
  read_html(paste0("raw data/poverty/snap and tanf/",x)) %>%
    html_table(header = T) %>% .[[1]] %>%
    filter(Description=="Number of families receiving TANF grants" | Description=="Total TANF payments" |
             Description =="Number of households receiving food stamps" | Description=="Total food stamps issued") %>%
    filter(Month!="Annual Average") %>%
    mutate(dt=my(paste0(Month,"-",str_extract(x,"[0-9]+"))))
}) %>% bind_rows()%>%
  separate(Area,sep=", ",into=c("msa_name","extra")) %>%
  mutate(msa_name=str_replace(msa_name,"-"," - "),
         Data=as.numeric(str_remove(Data,","))) %>%
  select(msa_name,dt,Description,value=Data)

max(snap_tanf_df$dt) # "2022-06-01"

snap_tanf_df %>% write_rds("app/data/snap_tanf_df.Rds")
rm(snap_tanf_df)
