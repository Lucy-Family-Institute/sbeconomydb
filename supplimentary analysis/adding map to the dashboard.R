library(tidyverse)

emp_change <- read_rds("G:/Shared drives/Lucy Family Institute Team drive/Dashboards/sbeconomydb/app/data/emp_change.Rds")

emp_change_small <- emp_change %>%
  filter(str_detect(Measure,"Number")) %>% select(msa_name,Current)


library(tidyverse)
library(tigris)
library(leaflet)

cbsa <- core_based_statistical_areas(cb=T)
in_counties <- counties(state = "18", cb=T)

# remove micro areas and alaska and hawaii metros to fasten map rendering
cbsa_in_metros <- cbsa %>%
  filter(LSAD=="M1") %>%
  filter(str_detect(NAME," IN")) %>%
  separate(NAME,sep=",", into = c("MSA_NAME","extra")) %>%
  mutate(MSA_NAME=str_replace(MSA_NAME,"-"," - ")) %>%
  full_join(emp_change_small,by=c("MSA_NAME"="msa_name")) %>%# add 
  select(MSA_NAME,GEOID,Current)

binpal <- colorBin("viridis",as.numeric(cbsa_in_metros$GEOID), length(cbsa_in_metros$GEOID)) # coloring function for leaflet

leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolylines(data = in_counties,
               color = "black",
               stroke = TRUE,
               opacity = 0.7, 
               weight = 0.5) %>%
  addPolygons(data=cbsa_in_metros,
              fillColor = ~binpal(as.numeric(GEOID)), 
              fillOpacity = 0.7, 
              weight = 0.2, 
              smoothFactor = 0.2,
              label=~paste0(MSA_NAME,"\n",Current),
              labelOptions = labelOptions(noHide = T, textOnly = TRUE, direction = "center"))

# the order of add poly lines and add polygons is important!

# label on multiple lines
labs <- lapply(seq(nrow(cbsa_in_metros)), function(i) {
  paste0( '<p style="text-align:center">', as_tibble(cbsa_in_metros)[i, "MSA_NAME"], '</p>', 
          '<p style="text-align:center">',as_tibble(cbsa_in_metros)[i, "Current"], '</p>') 
})

leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolylines(data = in_counties,
               color = "black",
               stroke = TRUE,
               opacity = 0.7, 
               weight = 0.5) %>%
  addPolygons(data=cbsa_in_metros,
              fillColor = ~binpal(as.numeric(GEOID)), 
              fillOpacity = 0.7, 
              weight = 0.2, 
              smoothFactor = 0.2,
              label=lapply(labs, htmltools::HTML),
              labelOptions = labelOptions(noHide = T, textOnly = TRUE, direction = "center"))

# not sure how to delete the space between name and number
# one option s to use <br> instead of <p>

#### counties ####
library(rvest)

county_df <- read_html("C:/Users/smotghar/OneDrive - nd.edu/R work directory/sbeconomydb/raw data/counties/Number of Unemployed per Job Openings Distribution/11.2022.xls") %>%
  html_table(header = T) %>% .[[1]] %>%
  select(county_name=2,unemp_per_opening=5) %>%
  mutate(county_name=str_remove(county_name," County"))

small_county_df <- in_counties %>%
  left_join(county_df, by=c("NAME"="county_name")) %>%
  select(COUNTYFP,NAME,unemp_per_opening)

binpal_counties <- colorBin("viridis",as.numeric(in_counties$COUNTYFP), length(in_counties$COUNTYFP)) # coloring function for leaflet

labs <- lapply(seq(nrow(small_county_df)), function(i) {
  paste0(tibble(small_county_df)[i, "NAME"], '<br/>', 
         tibble(small_county_df)[i, "unemp_per_opening"]) 
})

leaflet() %>%
  setView(lat = 39.7438077406383, lng = -86.17120980808964, zoom = 8)%>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolylines(data = small_county_df,
               color = "black",
               stroke = TRUE,
               opacity = 0.7, 
               weight = 0.5) %>%
  addPolygons(data=small_county_df,
              fillColor = ~binpal_counties(as.numeric(COUNTYFP)), 
              fillOpacity = 0.7, 
              weight = 0.2, 
              smoothFactor = 0.2,
              label = lapply(labs, htmltools::HTML),
              labelOptions = labelOptions(noHide = T, textOnly = TRUE, direction = "center")) 