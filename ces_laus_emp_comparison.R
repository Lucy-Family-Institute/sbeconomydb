# difference between employed in CES and LAUS

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
laus_series <- read_delim("https://download.bls.gov/pub/time.series/la/la.series", 
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

# ces is based on place of work, LAUS on place of residence
# ces employment - laus employment = people working - people living
# if positive, more people working than living - true for elkhart goshen
# if negative, more people living than working

p <- full_join(sb_elk_ces_sup,laus_select_areas,by=c("msa_name","dt")) %>%
  mutate(emp_diff=laus_employment-ces_employment) %>%
  filter(str_detect(msa_name,"South")) %>%
  ggplot(aes(x=dt,y=emp_diff, group=msa_name, color=msa_name)) + geom_line() +
  ylab("Workers living but not working/ Commuting out") + ylim(c(-5000,35000)) + theme(legend.position = "bottom")

q <- full_join(sb_elk_ces_sup,laus_select_areas,by=c("msa_name","dt")) %>%
  mutate(emp_diff=ces_employment-laus_employment) %>%
  filter(str_detect(msa_name,"Elkhart")) %>%
  ggplot(aes(x=dt,y=emp_diff, group=msa_name, color=msa_name)) + geom_line()+
  ylab("Workers working but not living/ Commuting in")+ ylim(c(-5000,35000))+ theme(legend.position = "bottom")

library(patchwork)
p+q

# another way that allows to see both
full_join(sb_elk_ces_sup,laus_select_areas,by=c("msa_name","dt")) %>%
  filter(str_detect(msa_name,"South")) %>%
  ggplot(aes(x=dt)) + geom_line(aes(y=ces_employment), color="red") + geom_line(aes(y=laus_employment), color="blue")

r <- bind_rows(sb_elk_ces_sup %>%
  mutate(source="Workers working in region") %>% rename(employment=ces_employment),
laus_select_areas %>%
  mutate(source="Workers living in the region") %>% rename(employment=laus_employment)) %>%
  filter(str_detect(msa_name,"South")) %>%
  ggplot(aes(x=dt, y=employment, group=source, color=source)) + geom_line()  +
  theme_minimal()+ theme(legend.position = "bottom", legend.title = element_blank()) + labs(title = "SB Mishawaka MSA") +
  ylim(c(70000,160000))

s <- bind_rows(sb_elk_ces_sup %>%
            mutate(source="Workers working in region") %>% rename(employment=ces_employment),
          laus_select_areas %>%
            mutate(source="Workers living in the region") %>% rename(employment=laus_employment)) %>%
  filter(str_detect(msa_name,"Elkhart")) %>%
  ggplot(aes(x=dt, y=employment, group=source, color=source)) + geom_line()  +
  theme_minimal()+ theme(legend.position = "bottom", legend.title = element_blank()) + labs(title = "Elkhart-Goshen MSA")+
  ylim(c(70000,160000))

r+s