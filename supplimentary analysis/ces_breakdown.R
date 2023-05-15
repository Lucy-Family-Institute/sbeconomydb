# this code explores how to show the breakdown of ces industries

# 1. can we just filter the child industries at an appropriate ;evel using industry codes?
# possibly we can use the industry codes to figure out the level of industry and filter on it

# note that th level of breakdown available varies across industry within MSA AND across MSAs. (see the file ces industr breakdown in the sbeconomydb folder for across MSA discrepancy)

# this inconsistenty makes for difficult viewing 
# for example if an industry breaks down but not the other, sorting of inductries by employment may be misleading
# across MSA inconsitency is likely not problematic. the filter just needs to allow for cases when breakdown isnt available


# which level of breakdown is available is provided here: https://www.bls.gov/sae/additional-resources/list-of-published-state-and-metropolitan-area-series/indiana.htm
# we can siply selec series codes from here and format the table accordingly

# 2. formatting table
# one option is to use child table which seems quite complicatd: https://rstudio.github.io/DT/002-rowdetails.html
# alternative is to add a radio button that allows selecting which level brakdown we wish to see

# ignoring inconsistency across MSA, we need to figure out how to show breakdown for one MSA  in the table
# we should be able to implement the same logic for other MSAs

# this piece of code adds description and also filters series for indiana, total employment and unseasonal
selected_series_sb_elk_msa <- series_codes %>%
  select(series_id:seasonal) %>% # select variables which are useful for filtering
  left_join(area_codes, by="area_code") %>% filter(str_detect(area_name,", IN")) %>% # indiana areas
  left_join(supersec_codes, by="supersector_code") %>% # add supersector names
  left_join(industry_codes, by="industry_code") %>% # add industry names
  left_join(data_type, by="data_type_code") %>% filter(data_type_code=="01") %>% # total employees
  left_join(seasonal_code, by=c("seasonal"="seasonal_code")) %>% filter(seasonal=="U") # selecting unseasonal as all past data is unseasonal

# now, I need indicator variables on which to filter to show the level of breakdown
selected_series_sb_elk_msa_ind <- selected_series_sb_elk_msa %>%  
  mutate(sup_sector = ifelse(paste0(supersector_code,"000000")==industry_code,1,0)) %>% # identify supersectors -  2 digit
  group_by(area_code,supersector_code) %>% mutate(non_sup_sector_filt=ifelse(n()==1,sup_sector,1-sup_sector)) # this treats all childs as same - we need to figure out a way to separetely identify 3 digit and 4 digit industries

# the numbers at child level will not match to total unemployment
# this is because since not all child level industries are present, sum of child level emloyment does not edd up to sectoral employment. 

# Another analysis that can be done: is the recovery of jobs correlated with wages?