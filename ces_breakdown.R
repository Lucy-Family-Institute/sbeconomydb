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

# ignoring inconsistency across MSA, we need to figure out how to show breakdown for one MSA  in the table
# we should be able to implement the same logic for other MSAs

# Another analysis that can be done: is the recovery of jobs correlated with wages?