library(tidyverse)
library(readxl)

DWD_Current_WARNs <- read_excel("C:/Users/smotghar/Downloads/DWD Current WARNs.xlsx", skip = 1)

# data cleaning
df <- DWD_Current_WARNs %>% 
  filter(!str_detect(City,","), !str_detect(City,"&")) %>% # drop multiple cities
  mutate(`Affected Workers`=as.numeric(`Affected Workers`)) %>%# drop some non-numeric values
  mutate(affect_month=floor_date(mdy(`LO/CL Date`),"month"),
         `Notice Type`=trimws(`Notice Type`,whitespace = "[\\h\\v]")) %>% # [\\h\\v] is important. not working otherwise
  filter(year(affect_month)>=1980, nchar(`Notice Type`)==2)

# plot
# table for display
df %>%
  filter(affect_month=="2022-12-01") %>% # slider 
  select(Company, City, `Affected Workers`,NAICS, `Description of Work`, `Notice Type`)
  
# graph for display
df %>%
  group_by(affect_month) %>%
  summarise(n_notices=n(),n_workers=sum(`Affected Workers`, na.rm=T)) %>%
  ggplot(aes(x=affect_month)) + 
  geom_line(aes(y=n_notices), color="red")

# map
map_df <- df %>% # aggregate by city
  filter(affect_month=="2022-12-01", # slider
         #`Notice Type`=="CL" # toggle switch
         ) %>% # toggle switch
  group_by(City) %>%
  summarise(n_notices=n(), n_workers=sum(`Affected Workers`)) #%>%
  #select(City, n_notices) # filter?

# plot these cities
library(tigris)
library(leaflet)

in_places <- places(state=18,cb=T)

in_counties <- counties(state = 18, cb=T)

write_rds(in_counties,"in_counties.Rds")

in_places_centroid <- in_places %>% mutate(cent_roid=st_centroid(geometry)) %>%
  rowwise() %>%
  mutate(lat=cent_roid[[1]][1],long=cent_roid[[1]][2])

write_rds(in_places_centroid,"in_places_centroid.Rds")

# pull in centroid
temp <- map_df %>%
  left_join(in_places_centroid, by=c("City"="NAME"))

# draw a circle around cities
leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolylines(data = in_counties,
               color = "black",
               stroke = TRUE,
               opacity = 0.5, 
               weight = 0.5) %>%
  addCircles(data=map_df,
             lat = ~long,lng = ~lat, weight = 1,
             color="blue",
             radius = ~n_workers/10* 10000,
             popup = ~City
  )



# highlight cities
leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolylines(data = in_places,
               color = "black",
               stroke = TRUE,
               opacity = 0.7, 
               weight = 0.5) %>%
  addPolygons(data=filter(in_places, NAME %in% map_df$City),
              fillColor = "red", 
              fillOpacity = 0.7, 
              weight = 0.2, 
              smoothFactor = 0.2)

# total numbers for all time periods
df %>% 
  group_by(affect_month, `Notice Type`) %>%
  summarise(n_notices=n(), n_workers=sum(`Affected Workers`)) %>%
  ggplot(aes(x=affect_month, y=n_notices, group=`Notice Type`, fill=`Notice Type`)) + geom_bar(stat="identity")
  
  

#### california data ####
library(readxl)
download.file("https://edd.ca.gov/siteassets/files/jobs_and_training/warn/warn_report.xlsx", 
              destfile = "raw data/cal_warn_notices.xlsx", mode = "wb")

df <- read_excel("raw data/cal_warn_notices.xlsx")
