# difference between employed in CES and LAUS
library(tidyverse)
library(lubridate)

# CEs total non-farm employment
in_series <- read_delim("https://download.bls.gov/pub/time.series/sm/sm.data.15.Indiana", 
                        "\t", escape_double = FALSE, trim_ws = TRUE) %>%
  mutate(value=value*1000) # values are in thousands

selected_series_sb_elk_msa <- read_csv("raw data/selected_ces_series_sb_elk_msa.csv")

# keep only series we want
sb_elk_ces_sup <- in_series %>%
  filter(series_id %in% selected_series_sb_elk_msa$series_id) %>%
  filter(period!="M13") %>% # annual average
  mutate(dt=mdy(paste0(substr(period,2,3),"-01-",year))) %>%
  left_join(selected_series_sb_elk_msa, by="series_id") %>% # add text
  filter(industry_name=="Total Nonfarm")%>% 
  select(area_name,dt,ces_employment=value) %>%
  filter(year(dt)>=2000) %>%
  separate(area_name, into = c("msa_name","st"), sep=", ") %>%
  mutate(msa_name=str_replace(msa_name,"-"," - ")) %>% select(-st)

rm(in_series,selected_series_sb_elk_msa)

#### LAUS ####
laus_in <- read_delim("https://download.bls.gov/pub/time.series/la/la.data.21.Indiana", 
                      "\t", escape_double = FALSE, trim_ws = TRUE)

# now I need to identify series for sb-mishawaka
# area types
laus_series <- read_delim("https://download.bls.govs/pub/time.series/la/la.series", 
                          "\t", escape_double = FALSE, trim_ws = TRUE)

select_series <- laus_series %>% filter(area_type_code=="B", srd_code==18)

laus_select_areas <- laus_in %>% filter(series_id %in% select_series$series_id)%>%
  filter(period!="M13") %>% # annual average
  mutate(dt=mdy(paste0(substr(period,2,3),"-01-",year))) %>%
  left_join(select_series, by="series_id") %>% # add text
  select(state_code=srd_code,area_code,series_title,dt,value) %>%
  filter(str_detect(series_title,"Employment:")) %>%
  filter(year(dt)>=2000) %>%
  separate(series_title, into = c("measure","area"),sep = ": ") %>%
  separate(area,into=c("msa_name","area_type","area_state"),sep=", ") %>%
  filter(is.na(area_state)) %>% # remove the IN part and MI part series
  mutate(msa_name=str_replace(msa_name,"-"," - "))  %>% # add a space beteen msa name to standardize
  select(msa_name,dt,laus_employment=value)

rm(laus_in,laus_series,select_series)

# laus is based on place of residence while ces is based on place of employment
# ces - laus = 
# people employed in MSA firms - people employed in MSa = excess employed people in MSA over those e mployed
full_join(sb_elk_ces_sup,laus_select_areas,by=c("msa_name","dt")) %>%
  mutate(emp_diff=ces_employment-laus_employment) %>%
  filter(str_detect(msa_name,"South") | str_detect(msa_name,"Elkhart")) %>%
  ggplot(aes(x=dt,y=emp_diff, group=msa_name, color=msa_name)) + geom_line() +
  ylab("Excess people working in MSA or\n Number of people travelling to MSA") +
  geom_hline(yintercept = 0) 
