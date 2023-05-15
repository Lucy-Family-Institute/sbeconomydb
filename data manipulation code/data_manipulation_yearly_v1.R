# update annually

# business einplot
url <- "https://www.census.gov/econ/bfs/xlsx/bfs_county_apps_annual.xlsx"
destfile <- "bfs_county_apps_annual.xlsx"
curl::curl_download(url, destfile)
read_excel(destfile, 
           skip = 2)%>%
  filter(State=="IN") %>%
  select(County,contains("BA")) %>%
  pivot_longer(-County,names_to = "yr1",values_to = "applications") %>%
  mutate(yr=as.numeric(str_extract(yr1,"[0-9]+"))) %>%
  write_rds("app/data/new_business_df.Rds")

rm(url,destfile)

#### per capita personal income ####

per_cap_personal_income_df <- lapply(list.files("data/raw//BEA/",pattern = ".csv"), function(x) {
  
  read_csv(paste0("C:/Users/LOANER/OneDrive - nd.edu/Data/BEA/",x), 
           skip = 4)%>%
    filter(str_detect(GeoName,"IN"), str_detect(Description,"Per capita personal income"))%>%
    select(-GeoFips,-LineCode,-Description)%>%
    gather(yr,per_cap_income,-GeoName) %>%
    mutate(yr=as.numeric(yr)) %>%
    separate(GeoName,sep = ",", into = c("msa","fluff")) %>% select(-fluff) %>%
    mutate(msa=str_replace(msa,"-"," - ")) # add a space for consistency with other datasets
  
}) %>% bind_rows()

write_rds(per_cap_personal_income_df,"data/per_cap_personal_income_df.Rds")