library(tidyverse)
library(plotly)
library(lubridate)



per_cap_personal_income_df <- lapply(list.files("C:/Users/smotghar/OneDrive - nd.edu/Data/BEA/",pattern = ".csv"), function(x) {
  
  read_csv(paste0("C:/Users/smotghar/OneDrive - nd.edu/Data/BEA/",x), 
           skip = 4)%>%
    filter(str_detect(GeoName,"IN"), str_detect(Description,"Per capita personal income"))%>%
    select(-GeoFips,-LineCode,-Description)%>%
    gather(yr,per_cap_income,-GeoName) %>%
    mutate(yr=as.numeric(yr)) %>%
    separate(GeoName,sep = ",", into = c("msa","fluff")) %>% select(-fluff)
}) %>% bind_rows()

