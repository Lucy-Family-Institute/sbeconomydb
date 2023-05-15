library(blscrapeR)
set_bls_key("82dd32248e774edb8acb7b9c0efb800c")
# First time, reload your enviornment so you can use the key without restarting R.
readRenviron("~/.Renviron")
# You can check it with:
Sys.getenv("BLS_KEY")

lst <- list(selected_series_sb_elk_msa$series_id[1:50],selected_series_sb_elk_msa$series_id[51:100],
     selected_series_sb_elk_msa$series_id[101:150],selected_series_sb_elk_msa$series_id[151:186])

df <- lapply(lst, function (x) {
  bls_api(x,
          startyear = 2003, endyear = 2023, Sys.getenv("BLS_KEY")) 
}) %>% bind_rows()

sb_elk_ces_supersectors <- df %>%
  filter(period!="M13") %>% # annual average
  mutate(dt=mdy(paste0(substr(period,2,3),"-01-",year))) %>%
  left_join(selected_series_sb_elk_msa, by=c("seriesID"="series_id")) %>% # add text
  select(state_code,area_code,supersector_code,industry_code,industry_name,area_name,dt,total_employment=value)