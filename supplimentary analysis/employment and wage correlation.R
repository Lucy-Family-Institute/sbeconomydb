library(tidyverse)
library(lubridate)
library(ggrepel)

# select series code
# series code attributes
series_codes <- read_delim("https://download.bls.gov/pub/time.series/sm/sm.series", 
                           "\t", escape_double = FALSE, trim_ws = TRUE)

# area codes and names
area_codes <- read_delim("https://download.bls.gov/pub/time.series/sm/sm.area", 
                         "\t", escape_double = FALSE, trim_ws = TRUE)

# description of each column
supersec_codes <- read_delim("https://download.bls.gov/pub/time.series/sm/sm.supersector", 
                             "\t", escape_double = FALSE, trim_ws = TRUE)
# data type code
data_type <- read_delim("https://download.bls.gov/pub/time.series/sm/sm.data_type", 
                        "\t", escape_double = FALSE, trim_ws = TRUE)

seasonal_code <- read_delim("https://download.bls.gov/pub/time.series/sm/sm.seasonal", 
                            "\t", escape_double = FALSE, trim_ws = TRUE)

industry_codes <- read_delim("https://download.bls.gov/pub/time.series/sm/sm.industry", 
                             "\t", escape_double = FALSE, trim_ws = TRUE)

selected_series_sb_elk_msa <- series_codes %>%
  select(series_id:seasonal) %>% # select variables which are useful for filtering
  left_join(area_codes, by="area_code") %>% filter(str_detect(area_name,", IN")) %>% # indiana areas
  left_join(supersec_codes, by="supersector_code") %>% # add supersector names
  left_join(industry_codes, by="industry_code") %>% # add industry names
  left_join(data_type, by="data_type_code") %>% filter(data_type_code=="01") %>% # total employees
  left_join(seasonal_code, by=c("seasonal"="seasonal_code")) %>% filter(seasonal=="U") %>% # selecting unseasonal as all past data is unseasonal
  filter(industry_name=="Total Private"
  )

rm(series_codes,area_codes,supersec_codes,data_type,seasonal_code,industry_codes)

# change in employment
in_series <- read_delim("https://download.bls.gov/pub/time.series/sm/sm.data.15.Indiana", 
                        "\t", escape_double = FALSE, trim_ws = TRUE) %>%
  mutate(value=value*1000) # values are in thousands

# keep only series we want
sb_elk_ces_supersectors <- in_series %>%
  filter(series_id %in% selected_series_sb_elk_msa$series_id) %>%
  filter(period!="M13") %>% # annual average
  mutate(dt=mdy(paste0(substr(period,2,3),"-01-",year))) %>%
  left_join(selected_series_sb_elk_msa, by="series_id") %>% # add text
  select(state_code,area_code,supersector_code,industry_code,industry_name,area_name,dt,total_employment=value)

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

rm(sb_elk_ces_supersectors)

#### df for wage ####
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

rm(in_series,selected_series_sb_elk_msa_wage)

pre_covid_dt=ymd(paste0("2019-",month(max(sb_elk_ces_supersectors_wage$dt)),"-01"))

sb_elk_ces_sup_wage <- sb_elk_ces_supersectors_wage %>%
  filter(year(dt)>=2000) %>%
  separate(area_name, into = c("msa_name","st"), sep=", ") %>%
  group_by(msa_name,industry_code) %>%
  mutate(last_yr_wage=lag(hourly_wage,12),yoy_change=(hourly_wage-last_yr_wage)/last_yr_wage,
         last_qtr_wage=lag(hourly_wage,3),qtr_change=(hourly_wage-last_qtr_wage)/last_qtr_wage,
         last_mnth_wage=lag(hourly_wage,1),mnth_change=(hourly_wage-last_mnth_wage)/last_mnth_wage,
         rel_covid_wage=hourly_wage[dt==pre_covid_dt],rel_covid_change=(hourly_wage-rel_covid_wage)/rel_covid_wage,
         rel_covid_wage_inf=hourly_wage[dt==pre_covid_dt]*1.15,rel_covid_change_inf=(hourly_wage-rel_covid_wage_inf)/rel_covid_wage_inf
  ) %>%
  mutate(change=hourly_wage-last_yr_wage,per_change=(change)/last_yr_wage, # these are for value boxes
         msa_name=str_replace(msa_name,"-"," - ")) %>%
  ungroup()

rm(sb_elk_ces_supersectors_wage)
rm(pre_covid_dt)
#### join employment and wage ####
full_join(
  sb_elk_ces_sup %>%
  filter(dt==max(dt)) %>%
  filter(industry_name=="Total Private") %>%
  select(msa_name,industry_name,dt,rel_covid_change_employment=rel_covid_change),
sb_elk_ces_sup_wage%>%
  filter(dt==max(dt)) %>%
  filter(industry_name=="Total Private") %>%
  select(msa_name,industry_name,dt,rel_covid_change_wage=rel_covid_change,rel_covid_change_wage_inf=rel_covid_change_inf),
by = c("msa_name", "industry_name", "dt")
) %>%
  ggplot(aes(y=rel_covid_change_employment, x=rel_covid_change_wage)) + geom_point()+
  #geom_text(aes(label=msa_name),hjust=-0.1, vjust=-0.1) + 
  geom_label_repel(aes(label=msa_name)) +
  geom_hline(yintercept = 0, linetype="dashed") + geom_vline(xintercept = 0, linetype="dashed") + 
  theme_minimal() +
  geom_smooth(method="lm", se=F, linetype="dashed") + scale_y_continuous(labels = scales::percent)+ 
  geom_vline(xintercept = 0.15, color="red", linetype="dashed") +
  scale_x_continuous(labels = scales::percent)+
  theme(aspect.ratio=1) +
  annotate(geom="text", x=0.15, y=0.05, label="% change in inflation", angle=90, vjust=-0.2,
             color="red") +
  annotate(geom="text", x=0.22, y=0.028, label="Trend line", angle=30,
           color="blue") +
  labs(x="% Change in average hourly wage",
       y="% Change in total employment",
       title="% Change in total employment and average wage between August 2022 and August 2019",
       #caption="Change in nominal wage accounting for inflation."
       )