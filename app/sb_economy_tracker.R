library(shiny)
library(tidyverse)
library(plotly)
library(shinydashboard)
library(lubridate)
library(readxl)

library(leaflet)
library(sf)

library(economiccomplexity) # for computing economic complexity
library(networkD3)
library(DT) # for searchable tables
library(wordcloud2)
library(png)

# http://www.incontext.indiana.edu/2005/november/7.asp#:~:text=The%20best%20way%20to%20distinguish,establishment%20taken%20from%20payroll%20records.

#setwd("C:/Users/Swapnil PC/OneDrive - nd.edu/notre dame research/sbeconomydb/")

df <- read_rds("data/df.Rds") 
df_cand <- read_rds("data/df_cand.Rds")
employers_jobs <- read_rds("data/employers_jobs.Rds")

all_claims <- read_rds("data/all_claims.Rds")
sb_naics_sector <- read_csv("data/sb_naics_sector.csv")
sb_oes <- read_csv("data/sb_oes.csv")
sb_elk_ces_sup <- read_rds("data/sb_elk_ces_sup.Rds")
sb_elk_ces_sup_wage <- read_rds("data/sb_elk_ces_sup_wage.Rds")
small_ces <- read_rds("data/small_ces.Rds")
small_laus <- read_rds("data/small_laus.Rds")
emp_change <- read_rds("data/emp_change.Rds")
laus_select <- read_rds("data/laus_select.Rds")

housing_sb <- read_rds("data/housing_sb.Rds")
sb_weekly_evictions <- read_rds("data/sb_weekly_evictions.Rds")
home_prices_in <- read_rds("data/home_prices_in.Rds")
fhfa_hpi_in <- read_rds("data/fhfa_hpi_in.Rds")
zori_in <- read_rds("data/zori_in.Rds")

sb_oes_over_time <- read_rds("data/sb_oes.Rds")
per_cap_personal_income_df <- read_rds("data/per_cap_personal_income_df.Rds")
snap_tanf_df <- read_rds("data/snap_tanf_df.Rds")

# claimants files
total_claimants <- read_rds("data/unique_claimants.Rds")
age <- read_rds("data/claimants_age.Rds")
gender <- read_rds("data/claimants_gender.Rds")
education <- read_rds("data/claimants_education.Rds")
industries <- read_rds("data/claimants_industries.Rds")
occ_grps <- read_rds("data/claimants_occupations.Rds")

sb_mi_msa <- read_rds("data/sb_mi_msa.Rds")

# business licenses
sb_business_licenses <- read_rds("data/sb_business_licenses.Rds")
new_business_df <- read_rds("data/new_business_df.Rds")

tools_jobs <- read_rds("data/tools_jobs.Rds")
skills_jobs <- read_rds("data/skills_jobs.Rds")
jobs_occupations <- read_rds("data/jobs_occupations.Rds")
certifications_jobs <- read_rds("data/certifications_jobs.Rds")

#setwd("C:/Users/Swapnil PC/OneDrive - nd.edu/notre dame research/citi foundation grant/Economic complexity/ECI Dashboard (shared with CRC)/data and code/")

#### Tab 2: Industry Structure ####
msa_4digit_2019_q4 <- read_csv("data/msa_4digit_2019_q4.csv")

#ui.R-----------------------------------------------------------------------------------------------------------------------------------------
ui = dashboardPage(#skin = "black", # blue is default but not too many options
  title = "South Bend Economy Database",
                   dashboardHeader(#title = "South Bend Economy Database",
                                   titleWidth = 300,
                                   tags$li(a(href = 'https://lucyinstitute.nd.edu//',
                                             img(src = 'lucy_logo.png',
                                                 title = "Company Home", height = "50px"),
                                             style = "padding-top:0px; padding-bottom:0px;"),
                                           class = "dropdown"),
                                   tags$li(a(href = 'https://www.citigroup.com/citi/foundation/',
                                             img(src = 'citi-foundation-title.jpg',
                                                 title = "Sponsor", height = "50px"),
                                             style = "padding-top:0px; padding-bottom:0px; padding-left:0px; padding-right:0px;"),
                                           class = "dropdown"),
                                   
                                   tags$li(a(href = 'http://www.pulte.nd.edu',
                                             img(src = 'logo.png',
                                                 title = "Company Home", height = "50px"),
                                             style = "padding-top:0px; padding-bottom:0px;"),
                                           class = "dropdown")),
                   dashboardSidebar(
                     sidebarMenu(
                       menuItem("Homepage", tabName = "homepage"),
                       menuItem("Economy Tracker", tabName = "economy_tracker", icon = icon("heartbeat"), startExpanded = TRUE,
                                menuSubItem("Labor Demand and Supply", tabName = "labor_market", icon = icon("users")),
                                menuSubItem("Employment and Unemployment", tabName = "emp_unemp", icon = icon("briefcase")),
                                menuSubItem("Housing", tabName = "housing", icon = icon("home")),
                                menuSubItem("Business Activity", tabName = "business_activity", icon = icon("business-time")),
                                menuSubItem("Income and poverty", tabName = "income_and_poverty", icon = icon("briefcase")),
                                menuSubItem("Structural Indicators", tabName = "structural", icon = icon("database"))
                                ),
                       menuItem("Info", tabName = "info", icon = icon("info-circle"),
                                menuSubItem("About", tabName = "about", icon = icon("address-card")),
                                menuSubItem("Data", tabName = "data", icon = icon("database"))#,
                                #menuSubItem("Glossary", tabName = "glossary", icon = icon("glasses"))
                                )
                       ), # use collapsed = TRUE to hide dashboard menu
                     
                   width = 300), # end of sidebar
                   # Body content
                   dashboardBody(
                     # the following lines adds a background image
                     #tags$img(
                     #  src = "South_Bend_Flag.png",
                     #  style = 'position: absolute'
                     #),
                     tabItems(
                       tabItem(tabName = "labor_market",
                               fluidRow(
                                 column(
                                   h1("Labor Demand and Supply",
                                      style="text-align:justify;color:white;background-color:darkblue;padding:15px;border-radius:10px"),br(),
                                   width=12)
                               ),
                               fluidRow(
                                 valueBoxOutput("totaljobbox", width = 3),
                                 valueBoxOutput("jobchangebox", width = 3),
                                 valueBoxOutput("totalcandidatebox", width = 3),
                                 valueBoxOutput("candidatechangebox", width = 3)
                               ),
                               
                               fluidRow(
                                 column(
                                   p("The graphs show the daily number of job openings and the number of candidates looking for a job. 
                                     The jobs can be disaggregated into industry groups and the number of candidates can be disaggregated into occupation type.",
                                     br(),br(),
                                     "In a healthy labor market, there are at least as many jobs as people looking for them. 
                                     The ratio of the number of candidates to jobs less than or equal to 1 suggests enough jobs for everyone.",
                                     style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
                                   width=8),
                                 valueBoxOutput("candidatestojobbox", width = 4)
                                 ),
                               fluidRow(
                                 column(
                               #    selectInput(
                              #   inputId = "select_msa",
                               #  label = "Select MSA",
                                # choices = c("South Bend - Mishawaka", "Elkhart - Goshen")
                               #),
                               selectizeInput(
                                 'select_msa', 'Select Occupation',
                                 choices = unique(df$msa) # now we can easily add more msa's! the dropdown options will be automatically updated
                               ),
                               width=8)),
                               fluidRow(
                                 box(plotlyOutput(outputId = 'jobPlot'), 
                                     radioButtons("abs_per", "Select Y axis",
                                                  c("Total"="Job Openings",
                                                    "Percentage Change"="per_change"),
                                                  inline = T),
                                     radioButtons("ind", "Select Industry or education",
                                                  c("All Industries"="Total Openings",
                                                    "Health Care and Social Assistance"="Health Care and Social Assistance",                                       
                                                    "Retail Trade"="Retail Trade",                                                            
                                                    "Accommodation and Food Services"="Accommodation and Food Services",                                         
                                                    "Transportation and Warehousing"="Transportation and Warehousing",                                          
                                                    "Manufacturing"="Manufacturing",                                                           
                                                    "Less than High School"="Less than High School",
                                                    "High School Diploma or Equivalent"="High School Diploma or Equivalent",
                                                    "Bachelor's Degree"="Bachelor's Degree",
                                                    "Associate's Degree"="Associate's Degree",
                                                    "Master's Degree"="Master's Degree")),width = 6),
                                 box(plotlyOutput(outputId = 'candidatePlot'),
                                     radioButtons("abs_per_cand", "Select Y axis",
                                                  c("Total"="Candidates",
                                                    "Percentage Change"="per_change"), inline = T),
                                     radioButtons("cand", "Select Occupation group",
                                                  c("All Occupations"="Total Candidates",
                                                    "Production Occupations"="Production Occupations",
                                                    "Office and Administrative Support Occupations"="Office and Administrative Support Occupations",
                                                    "Management Occupations"="Management Occupations",	
                                                    "Transportation and Material Moving Occupations"="Transportation and Material Moving Occupations",	
                                                    "Sales and Related Occupations"="Sales and Related Occupations",
                                                    "Less than High School"="Less than High School",
                                                    "High School Diploma or Equivalent"="High School Diploma or Equivalent",
                                                    "Bachelor's Degree"="Bachelor's Degree",
                                                    "Associate's Degree"="Associate's Degree",
                                                    "Master's Degree"="Master's Degree")), width = 6)
                                 ),
                               fluidRow(
                                 box(plotlyOutput(outputId = 'indjobsPlot'), width = 6),
                                 box(plotlyOutput(outputId = 'candoccgrpPlot'), width = 6)
                               )
                       ),
                       
                       tabItem(tabName = "emp_unemp",
                               fluidRow(
                                 column(
                                   h1("Employment and Unemployment",
                                      style="text-align:justify;color:white;background-color:darkblue;padding:15px;border-radius:10px"),br(),
                                   width=12)
                               ),
                               fluidRow(
                                 valueBoxOutput("totalemploymentbox", width = 3),
                                 valueBoxOutput("employmentchangebox", width = 3),
                                 valueBoxOutput("totallaborforce", width = 3),
                                 valueBoxOutput("unemploymentbox", width = 3)
                               ),
                               fluidRow(
                                 column(
                                   #selectInput(
                                   #inputId = "select_msa_emp",
                                   #label = "Select MSA",
                                   #choices = c("South Bend - Mishawaka", "Elkhart - Goshen")
                                 #),
                                 selectizeInput(
                                   inputId = "select_msa_emp",
                                   label = "Select MSA",
                                   choices = unique(laus_select$msa_name)
                                 ),
                                 width = 6)
                                 ),
                               fluidRow(
                                 column(
                                   br(),
                                   p("The graph shows the employment by industry. These are estimates produced from monthly survey of businesses and government agencies.",
                                     style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
                                 width=6),
                                 column(
                                   br(),
                                   p("The graph shows the number of people in labor force and employed. The gap between the labor force and employment is the number of unemployed.
                                     These estimates are based on place of residence.",
                                     style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
                                   width=6)
                               ),
                               
                               fluidRow(box(plotlyOutput('cesPlot_new'), 
                                            p("Current month = ", format(max(small_ces$dt),"%b, %Y")),
                                            dataTableOutput('small_ces'), width = 6),
                                        box(plotlyOutput(outputId = 'lausPlot'),
                                            radioButtons("abs_per_laus", "Select Y axis",
                                                         c("Total"="value",
                                                           "Percentage Change"="per_change"), inline = T),
                                            p("Current month = ", format(max(small_laus$dt),"%b, %Y")),
                                            dataTableOutput('small_laus'),
                                            p("Current month = ", format(max(emp_change$dt),"%b, %Y")),
                                            dataTableOutput('emp_change'),width = 6)),
                               fluidRow(box(plotlyOutput('ceswagePlot'),width = 12))
                               ),
                       tabItem(tabName = "housing",
                               fluidRow(
                                 column(
                                   h1("Housing Market",
                                      style="text-align:justify;color:white;background-color:darkblue;padding:15px;border-radius:10px"),br(),
                                   width=12)
                               ),
                               fluidRow(
                                 valueBoxOutput("totalbuildingbox", width = 3),
                                 valueBoxOutput("buildingchangebox", width = 3),
                                 valueBoxOutput("totalevictionbox", width = 3),
                                 valueBoxOutput("evictionchangebox", width = 3)
                               ),
                               
                               fluidRow(
                                 column(
                                   br(),
                                   p("A good indicator for how well the economy is doing is to see how the housing construction activity is performing.
                                   The graph shows the number of new housing permits issued in SB-Mishawaka MSA. 
                                     The number has been fairly constant across 2019-2020, suggesting that COVID did not decrease house construction activity.",
                                     style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
                                   width=6),
                                 column(
                                   br(),
                                   p("The graph shows the number of eviction filings in South Bend, IN for the current year and average for the years 2016-19. 
                                     The shaded regions are where there were orders against eviction in effect. 
                                     Here too, the number of eviction filings are lower in 2020 as compared to average of 2016-19 suggesting that the stay on evictions helped in reducing the filings.",
                                     style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
                                   width=6)
                               ),
                               
                               fluidRow(box(plotlyOutput(outputId = 'housingPlot'),
                                            radioButtons("abs_per_housing", "Select Y axis",
                                                         c("Total"="total",
                                                           "Percentage Change"="per_change"), inline = T),
                                            width=6),
                                        box(plotlyOutput(outputId = 'evictionPlot'),width=6)
                               ),
                               fluidRow(
                                 column(selectInput(
                                   inputId = "select_msa_homevalue",
                                   label = "Select MSA",
                                   choices = c("South Bend - Mishawaka", "Elkhart - Goshen")
                                 ),width = 6)
                                 ),
                               fluidRow(
                                 valueBoxOutput("homevaluebox", width = 3),
                                 valueBoxOutput("homevaluechangebox", width = 3)
                               ),
                               fluidRow(
                                 column(
                                   br(),
                                   p("The graph shows the typical value for homes in the region.",
                                     style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
                                   width=6)
                               ),
                               fluidRow(box(plotlyOutput(outputId = 'homevaluePlot'),
                                            radioButtons("abs_per_homevalue", "Select Y axis",
                                                         c("Value"="value",
                                                           "Percentage Change"="per_change"), inline = T),
                                            width=6),
                                        box(plotlyOutput(outputId = 'zoriPlot'),
                                            radioButtons("abs_per_zori", "Select Y axis",
                                                         c("Value"="rent_index",
                                                           "Percentage Change"="per_change"), inline = T),
                                            width=6)
                               ),
                               fluidRow(box(plotlyOutput(outputId = 'fhfahpiPlot'),
                                            radioButtons("abs_per_homevalue2", "Select Y axis",
                                                         c("Value"="index",
                                                           "Percentage Change"="per_change"), inline = T),
                                            width=6)
                               )
                               
                               ),
                       tabItem(tabName = "business_activity",
                               fluidRow(
                                 column(
                                   h1("Business Activity",
                                      style="text-align:justify;color:white;background-color:darkblue;padding:15px;border-radius:10px"),br(),
                                   width=12)
                               ),
                               fluidRow(
                                 column(selectInput(
                                   inputId = "select_msa_ba",
                                   label = "Select MSA",
                                   choices = c("South Bend - Mishawaka", "Elkhart - Goshen")
                                 ), width=6)
                                 ),
                               fluidRow(
                                 column(
                                   br(),
                                   p("Below is a wordcloud of employers currently hiring.", 
                                     style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),width=6),
                                 column(
                                   br(),
                                   p("Occupations in demand in",format(unique(jobs_occupations$dt),"%B %d, %Y"),".", 
                                     style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),width=6)
                               ),
                               fluidRow(box(wordcloud2Output(outputId = 'employers_wordcloud'), # wordcloud 0.2.1 seems to supress running plotly. do not update this package
                                            width=6),
                                        box(plotlyOutput(outputId = 'joboccPlot'),
                                            width=6)
                                        ),
                               fluidRow(
                                 column(
                                   br(),
                                   p("Top 10 Job skills in demand in",format(max(skills_jobs$dt),"%B %Y"),".",
                                     style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),width=6),
                                 column(
                                   br(),
                                   p("Top 10 Tools and Technology in demand in",format(max(tools_jobs$dt),"%B %Y"),".", 
                                     style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),width=6)
                               ),
                               fluidRow(box(plotlyOutput(outputId = 'skillsPlot'),
                                            width=6),
                                        box(plotlyOutput(outputId = 'toolsPlot'),
                                            width=6)
                               ),
                               fluidRow(
                                 column(
                                   br(),
                                   p("Search for skills by typing in the box.", 
                                     style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),width=6),
                                 column(
                                   br(),
                                   p("Search for tools and technologies by typing in the box.", 
                                     style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),width=6)
                               ),
                               fluidRow(box(DTOutput("skillstable"),width=6),
                                        box(DTOutput("toolstable"),width=6)
                               ),
                               fluidRow(
                                 column(
                                   br(),
                                   p("The graph shows the number of business licenses issued in South Bend, IN.", 
                                     style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),width=6),
                                 column(
                                   br(),
                                   p("Top 10 Certifications in demand in",format(unique(certifications_jobs$dt),"%B %Y"),".", 
                                     style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),width=6)
                               ),
                               fluidRow(box(plotlyOutput(outputId = 'businessactivityPlot'),
                                            width=6),
                                        box(plotlyOutput(outputId = 'certificationsPlot'),
                                            width=6)
                               ),
                               fluidRow(box(p("The graph shows the business initiation activity in Indiana counties. It tracks Employer Identification Number (EIN) applications that business use for tax purposes"),
                                            plotlyOutput(outputId = 'businesseinPlot'),
                                            width=6),
                                        box(width=6)
                               )
                              ),
                       tabItem(tabName = "income_and_poverty",
                               fluidRow(
                                 column(
                                   h1("Income and Poverty",
                                      style="text-align:justify;color:white;background-color:darkblue;padding:15px;border-radius:10px"),br(),
                                   width=12)
                               ),
                               fluidRow(
                                 column(selectInput(
                                   inputId = "select_msa_inc_pov",
                                   label = "Select MSA",
                                   choices = c("South Bend - Mishawaka", "Elkhart - Goshen")
                                 ), width=6)
                                 ),
                               fluidRow(box("The graph below shows the personal income per capita in the region",
                                 plotlyOutput(outputId = 'PersonalIncomePlot'), width = 6),
                                        box("The graph below shows the hourly average wage for different occcupations in SB-Mishawaka MSA.",
                                            plotlyOutput(outputId = 'wagePlot'), width = 6)
                                 ),
                               fluidRow(box("The graph to the right shows the number of SNAP and TANF beneficiaries in the region.",br(),
                                            "TANF (Temporary Assistance to Needy Families) is a program that provides cash assistance to children under age 18 who are deprived of financial support of a parent. Eligibility requires a child who is living with a parent or relative such as a grandparent, aunt, uncle, etc., and deprived of financial support from a parent by reason of death, absence from the home, unemployment, or a physical or mental incapacity. A family may not possess assets valued in excess of $1,000 at the time application for assistance is made.The house, which is the usual residence, is exempt.",br(),
                                            "The Supplemental Nutrition Assistance (SNAP) program, formerly known as food stamps, designed to raise the nutritional level of low income households by supplementing their available food purchasing dollars with food stamp coupons. To qualify, applicants must meet both non-financial and financial requirements. Non-financial requirements include state residency, citizenship/alien status, work registration and cooperation with the IMPACT Program. Financial criteria include income and asset limits. There is a gross income limit for the number of people sharing food the stamps will buy, except for households with elderly or disabled members.",
                                            selectInput(
                                              inputId = "select_welfare_measure",
                                              label = "Select welfare measure",
                                              choices = c("TANF - Beneficiaries"="Number of families receiving TANF grants", #"TANF - Amount"="Total TANF payments",
                                                          "SNAP - Beneficiaries"="Number of households receiving food stamps")#"SNAP - Amount"="Total food stamps issued"
                                            ),
                                            width = 6),
                                        box(plotlyOutput(outputId = 'snap_tanfPlot'), width = 6)
                               )
                               ),
                       tabItem(tabName = "structural",
                               fluidRow(
                                 column(
                                   h1("Structural Indicators",
                                      style="text-align:justify;color:white;background-color:darkblue;padding:15px;border-radius:10px"),br(),
                                   width=12)
                               ),
                               fluidRow(
                                 column(
                                   br(),
                                   p("The graph below shows the employment in different sectors in SB-Mishawaka MSA. 
                                     The size of the boxes is proportional to the number of people employed by the industry.
                                     The largest sectors are Manufacturing, Accommodation and Food Services, and Retail Trade.",
                                     style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
                                   width=6),
                                 column(
                                   br(),
                                   p("The graph below shows the employment in different occupations in SB-Mishawaka MSA. 
                                   The size of the boxes is proportional to the number of people employed in the occupation.
                                   The most common occupations are Office and Administrative Support Occupations, Sales and Related Occupations, Food Preparation and Serving Related Occupations and Production Occupations.",
                                     style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
                                   width=6)
                               ),
                               fluidRow(box(plotlyOutput(outputId = 'industryPlot'), width = 6),
                                   box(plotlyOutput(outputId = 'occupationPlot'), width = 6)
                                   )
                               
                               ),
                       tabItem(tabName = "about",
                               fluidRow(
                                 column(
                                   h1("About",
                                      style="text-align:justify;color:white;background-color:darkblue;padding:15px;border-radius:10px"),br(),
                                   width=12)
                               ),
                               fluidRow(
                                 column(
                                   p("This website has been developed by the ",tags$a(href = "https://pulte.nd.edu/", "Pulte Institute for Global Development"), "and the",
                                     tags$a(href = "https://lucyinstitute.nd.edu/", "Lucy Family Institute for Data & Society"),
                                   " at the University of Notre Dame, in collaboration with the City of South Bend. Funding was provided by the Citi Foundation.",
                                     br(),br(),
                                     "The objective is to provide clear visibility of the state of the South Bend - Mishawaka MSA economy.",
                                     br(),br(),
                                     "The Economy tracker data will be updated monthly.",
                                     br(),br(),
                                     #"The Economic Complexity Analysis was originally developed by Hausmann et al. (2014) to understand growth potential for countries. The methodology was adapted for metro areas by Escobari et al. (2019). 
                                     #The website design is influenced by ",tags$a(href = "https://atlas.cid.harvard.edu/", "Atlas of Economic Complexity"),
                                     #br(),br(),
                                     "All the data and the code is available ",tags$a(href = "https://github.com/Lucy-Family-Institute/sbeconomydb", "here."),
                                     #"For any feedback/questions, please ",tags$a(href = "mailto:smotghare@nd.edu", "contact us."),
                                     br(),br(),
                                     "Citation:",
                                     br(), 
                                     "The Lucy Family Institute for Data & Society. (2022). South Bend Economy Database. https://pulte.shinyapps.io/sbeconomydb/",
                                     #br(),br(),
                                     #"Download newsletter ",tags$a(href = "my-report.pdf", "here"),
                                     #br(),br(),
                                     #a(href="my-report.pdf", "Download PDF", download=NA, target="_blank"),
                                     #br(),br(),
                                     #"References",
                                     #br(),
                                     #"   Hausmann, R., Hidalgo, C. A., Bustos, S., Coscia, M., and Simoes, A. (2014). The atlas of economic complexity: Mapping paths to prosperity. MIT Press.",
                                     #br(),
                                     #"   Escobari, M., Seyal, I., Morales-Arilla, J., and Shearer, C. (2019). Growing cities that work for all: A capability-based approach to regional economic competitiveness.",
                                     style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
                                   width=12)
                                 )
                               ),
                       tabItem(tabName = "data",
                               fluidRow(
                                 column(
                                   h1("Data Sources",
                                      style="text-align:justify;color:white;background-color:darkblue;padding:15px;border-radius:10px"),br(),
                                   width=12)
                               ),
                               fluidRow(
                                 column(
                                   #br(),
                                   p("Data on this website is sourced from publicly available databases including",
                                     br(),br(),
                                     tags$a(href = "https://www.bls.gov/", "U.S. Bureau of Labor Statistics"),br(),
                                     tags$a(href = "https://www.bea.gov/", "U.S. Bureau of Economic Analysis"),br(),
                                     tags$a(href = "https://www.indianacareerconnect.com/", "Indiana Career Connect"),br(),
                                     tags$a(href = "https://www.census.gov/", "U.S. Census Bureau"),br(),
                                     tags$a(href = "http://www.hoosierdata.in.gov/", "Hoosiers by the Numbers"),br(),
                                     tags$a(href = "https://www.in.gov/dwd/", "Indiana Department of Workforce Development"),br(),
                                     tags$a(href = "https://evictionlab.org/", "The Eviction Lab"),br(),
                                     tags$a(href = "https://southbendin.gov/", "The City of South Bend"),br(),
                                     tags$a(href = "https://www.zillow.com/", "Zillow"),br(),
                                     
                                     style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
                                   width=12)
                               )
                       ),
                        tabItem(tabName = "homepage",
                                fluidRow(
                                  column(
                                    #br(),
                                    #h4(
                                    #  "Please bookmark new web address:", tags$a(href = "https://lucyapps.shinyapps.io/sbeconomydb/", "https://lucyapps.shinyapps.io/sbeconomydb/"),br(), 
                                    #  style="text-align:justify;color:black;background-color:pink;padding:15px;border-radius:10px"
                                    #),
                                    h1("South Bend Economy Database",
                                       style="text-align:justify;color:white;background-color:darkblue;padding:15px;border-radius:10px") ,br(),
                                    h4(
                                     "Research and Data Visualization tools to understand the economic dynamics and new growth opportunities for South Bend, Indiana.", br(), br()
                                     ,
                                      style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"
                                     ),
                                    width=6),
                                  column(
                                    box(
                                      status = "primary", solidHeader = F, width = 12,
                                      imageOutput("myImage", height = "auto", width = "auto")), 
                                    width = 6)
                                ),
                                
                                fluidRow(
                                  column(leafletOutput(outputId = 'mapPlot_msa'),width = 6),
                                  column(
                                    br(),
                                    p("South Bend-Mishawaka Metropolitan Statistical Area (SB-Mishawaka MSA), sometimes referred to as Michiana, 
                                     is an area consisting of two counties - one in northern Indiana (St. Joseph) and one in southwest Michigan (Cass). 
                                     It is anchored by the cities of South Bend and Mishawaka in Indiana.", br(), br(),
                                      "It has a population of 323,613 (as of 2019) and has a 216 th largest GDP among all MSAs (as of 2018).",br(), br(),
                                      "With an Economic Complexity Index (ECI) of 0.0691, it ranks as the 243rd most complex MSA in the ECI ranking of 388 MSAs. 
                                     Compared to five years prior, SB-Mishawaka MSA's economy has become less complex, worsening 8 positions in the ECI ranking.",br(), br(),
                                      "Click on the links in the left pane to explore the region.",
                                      style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
                                    width=6)
                                  
                                
                                )
                                )#,
                       #tabItem(tabName = "glossary",
                      #         fluidRow(
                      #           column(
                      #             h1("Glossary",
                      #                style="text-align:justify;color:white;background-color:darkblue;padding:15px;border-radius:10px"),br(),
                      #             width=12)
                      #         ),
                      #         fluidRow(
                      #          column(
                      #             br(),
                      #             p(strong("Economic Complexity:")," A measure of the knowledge in a society as expressed in the products it makes.",br(),
                      #               strong("Economic Complexity Index (ECI):")," A rank of Metropolitan Statistical Areas (MSAs) based on how diversified and complex products they produce.",br(),
                      #               strong("Industry Complexity Index (ICI):")," A rank of Industries based on how likely the industry is observed with other industries.",br(),
                      #               strong("Industry Space:")," Industry Space illustrates the relatedness of its industries and potential paths to diversify its economy.",br(),
                      #               strong("Opportunity gain:")," Measures how much a location could benefit in opening future diversification opportunities by developing a particular industry.",br(),
                      #               strong("Distance to existing capabilities:")," This measures the difficulty of developing a new industry. A lower distance signifies an industry is", em("nearby")," to existing knowhow and hence the industry can be developed relatively easily.",br(),
                      #               strong("Opportunity Gain:")," Opportunity gain for future diversification: higher values hold more linkages to other high-complexity industries, opening more opportunities for continued diversification.",
                      #               style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
                      #             width=12)
                       #        )
                       #)
                       
                   )
) # end of dashboardbody
) #end dashboardPage




#server.R  -------------------------------------------------------------------------------------------------

server = function(input, output, session) {
  output$jobPlot <- renderPlotly({
    
    fig <- df %>%
      filter(var==input$ind,
             msa==input$select_msa) %>%
      plot_ly(x=~dt, y=~get(input$abs_per), 
              type="scatter",mode="lines", fill = 'tozeroy',
              line = list(shape = 'spline'), # more data would make this look nicer
              hoverinfo = 'text',
              text=~paste('</br> Date: ', dt,
                          '</br> Job Openings: ', `Job Openings`,
                          '</br> Percentage Change: ', paste(round(per_change*100,2),"%"))) %>% 
      layout(showlegend=F,
        title = paste0("Job Openings in ",input$select_msa," Metropolitan Statistical Area"),
             xaxis = list(title = "",range=c(max(df$dt)-years(1),max(df$dt)),rangeslider = list(visible = T)),
             yaxis = list(title="",range=c(input$date_start,input$date_end)),
             margin = list(l = 50, r = 50, t = 60, b = 60),
             annotations = list(text = "Source: www.indianacareerconnect.com",
                                font = list(size = 12),
                                showarrow = FALSE,
                                xref = 'paper', x = -0.03,
                                yref = 'paper', y = -0.45))
    
    if(input$abs_per=="per_change") {
      fig <- fig%>% 
        layout(yaxis = list(tickformat = "%"))
    }
    
    
    fig
    
  })
  
  output$indjobsPlot <- renderPlotly({
    
    latest_date=max(df$dt)
    
    fig <- df %>%
      filter(msa==input$select_msa) %>%
      filter(dt==max(dt), indicator=="industry") %>%
      mutate(per=`Job Openings`/sum(`Job Openings`)) %>%
      plot_ly(
        labels = ~ paste0(var," (",round(per*100,0),"%",")"),
        parents = NA,
        values = ~ `Job Openings`,
        type = 'treemap',
        hovertemplate = "%{label}<br>Job openings: %{value}<extra></extra>"
      ) %>%
      layout(autosize = TRUE,
             title = paste0("Job Openings by Industry in ",input$select_msa," as of ",format(latest_date,"%b %d, %Y")),
             margin = list(l = 0, r = 0, t = 30, b = 30),
             annotations = list(text = "Source: www.indianacareerconnect.com",
                                font = list(size = 12),
                                showarrow = FALSE,
                                xref = 'paper', x = 0.01,
                                yref = 'paper', y = -0.05))
    
    
    fig
  })
  
  output$candidatePlot <- renderPlotly({
    
    fig <- df_cand %>%
      filter(var==input$cand,
             msa==input$select_msa)  %>%
      plot_ly(x=~dt, y=~get(input$abs_per_cand),
              type="scatter",mode="lines", fill = 'tozeroy',
              line = list(shape = 'spline'),
              hoverinfo = 'text',
              text=~paste('</br> Date: ', dt,
                '</br> Candidates: ', Candidates,
                          '</br> Percentage Change: ', paste(round(per_change*100,2),"%")))%>% 
      layout(showlegend=F,
             title = paste0("Candidates in ",input$select_msa," Metropolitan Statistical Area"),
             xaxis = list(title = "",range=c(max(df_cand$dt)-years(1),max(df$dt)),rangeslider = list(visible = T)),
             yaxis = list(title="",range=c(input$date_start,input$date_end)),
             margin = list(l = 50, r = 50, t = 60, b = 60),
             annotations = list(text = "Source: www.indianacareerconnect.com",
                                font = list(size = 12),
                                showarrow = FALSE,
                                xref = 'paper', x = -0.03,
                                yref = 'paper', y = -0.45))

    
    if(input$abs_per_cand=="per_change") {
      fig <- fig%>% 
        layout(yaxis = list(tickformat = "%"))
    }
    
    
    fig
  })
  
  output$candoccgrpPlot <- renderPlotly({
    
    latest_date=max(df_cand$dt)
    
    fig <- df_cand %>%
      filter(indicator=="Occupation Group",
             msa==input$select_msa) %>%
      filter(dt==max(dt)) %>%
      filter(dt==max(dt), indicator=="Occupation Group") %>%
      mutate(per=Candidates/sum(Candidates)) %>%
      plot_ly(
        labels = ~ paste0(var," (",round(per*100,0),"%",")"),
        parents = NA,
        values = ~ Candidates,
        type = 'treemap',
        hovertemplate = "%{label}<br>Candidates: %{value}<extra></extra>"#,
        #text=~paste('Total Jobs =', bls_employment,
        #'<br>Percentage =',paste(round(per_jobs*100,0),"%"))
      ) %>%
      layout(autosize = TRUE,
             title = paste0("Candidates by Occupation in ",input$select_msa," as of ",format(latest_date,"%b %d, %Y")),
             title = paste0("Candidates by Occupation in South Bend-Mishawaka MSA as of ",format(latest_date,"%b %d, %Y")),
             margin = list(l = 0, r = 0, t = 30, b = 30),
             annotations = list(text = "Source: www.indianacareerconnect.com",
                                font = list(size = 12),
                                showarrow = FALSE,
                                xref = 'paper', x = 0.01,
                                yref = 'paper', y = -0.05))
    
    
    fig
  })
  
  output$small_ces = renderDT(
    small_ces %>%
    filter(msa_name==input$select_msa_emp) %>% # show dt for the selected msa
      select(-msa_name,-dt) %>% # lose msa_name column and date
    datatable(selection=list(mode = 'single',selected=1), rownames=F) %>% 
      formatPercentage(c(3,4,5,6), 2) %>% formatStyle(columns = c('Previous 30 days','Previous 90 days','Previous Year','Pre-covid'),
                                                      color=styleInterval(-0.00001, c('red','green'))), # so that 0 is colored green 
    server = FALSE)
  
  output$small_laus = renderDT(
    small_laus %>%
      filter(msa_name==input$select_msa_emp) %>% # show dt for the selected msa
      select(-msa_name,-dt) %>% # lose msa_name column and date
      datatable(selection=list(mode = 'single',selected=1), rownames=F,options = list(searching = FALSE)) %>% 
      formatPercentage(c(3,4,5,6), 2) %>% formatStyle(columns = c('Previous 30 days','Previous 90 days','Previous Year','Pre-covid'),
                                                      color=styleInterval(-0.00001, c('red','green'))), # so that 0 is colored green 
    server = FALSE)
  
  output$emp_change = renderDT(
    emp_change %>%
      filter(msa_name==input$select_msa_emp) %>% # show dt for the selected msa
      select(-msa_name,-dt) %>% # lose msa_name column and date
      datatable(selection=list(mode = 'single',selected=1), rownames=F,options = list(searching = FALSE)) %>% 
      formatPercentage(c(3,4,5), 2) %>% formatStyle(columns = c('Previous 30 days','Previous 90 days','Previous Year'),
                                                      color=styleInterval(-0.00001, c('red','green'))), # so that 0 is colored green 
    server = FALSE)
  
  output$cesPlot_new <- renderPlotly({
    
    clicked_ind <- filter(small_ces,msa_name==input$select_msa_emp)$Industry[input$small_ces_rows_selected]
    
    fig <- sb_elk_ces_sup %>%
      filter(msa_name==input$select_msa_emp,
        industry_name== clicked_ind
        ) %>%
      plot_ly(x=~dt, y=~total_employment,
              type="scatter",mode="lines", line = list(shape = 'spline'),
              hoverinfo = 'text',
              text=~paste('</br> Date: ', dt,
                          '</br> Industry: ', clicked_ind,
                          '</br> Employment: ', total_employment,
                          '</br> Percentage Change: ', paste(round(per_change*100,2),"%"))) %>% 
      layout(title = paste0("Employment by Industry in ",input$select_msa_emp," MSA"),
             xaxis = list(title = "",range=c(ymd("2019-01-01"),max(sb_elk_ces_sup$dt)),rangeslider = list(visible = T)),
             yaxis = list(title=""),
             margin = list(l = 50, r = 50, t = 60, b = 60),
             annotations = list(text = "Source: State and Metro Area Employment, BLS",
                                font = list(size = 12),
                                showarrow = FALSE,
                                xref = 'paper', x = -0.03,
                                yref = 'paper', y = -0.45))
    
    
    fig
  })
  
  output$ceswagePlot <- renderPlotly({
    
      fig <- sb_elk_ces_sup_wage %>%
      plot_ly(x=~dt, y=~hourly_wage,
              type="scatter",mode="lines", line = list(shape = 'spline'), color=~msa_name,
              hoverinfo = 'text',
              text=~paste('</br> Date: ', dt,
                          '</br> Industry: ', industry_name,
                          '</br> Percentage Change: ', paste(round(per_change*100,2),"%"))) %>% 
      layout(title = paste0("Average wage across MSAs"),
             xaxis = list(title = "",range=c(ymd("2019-01-01"),max(sb_elk_ces_sup_wage$dt)),rangeslider = list(visible = T)),
             yaxis = list(title=""),
             margin = list(l = 50, r = 50, t = 60, b = 60),
             annotations = list(text = "Source: State and Metro Area Employment, BLS",
                                font = list(size = 12),
                                showarrow = FALSE,
                                xref = 'paper', x = -0.03,
                                yref = 'paper', y = -0.45))
    
    
    fig
  })
  
  output$lausPlot <- renderPlotly({
    fig <- laus_select %>%
      filter(msa_name==input$select_msa_emp,
             (measure=="Labor Force" | measure=="Employment")) %>%
      plot_ly(x=~dt, y=~get(input$abs_per_laus), 
              split = ~measure,
              type="scatter",mode="lines", line = list(shape = 'spline'),
              hoverinfo = 'text',
              text=~paste('</br> Date: ', dt,
                          '</br> Employment: ', value,
                          '</br> Percentage Change: ', paste(round(per_change*100,2),"%"))) %>% 
      layout(title = "Labor force, employment and unemployment",
             xaxis = list(title = "",range=c(ymd("2019-01-01"),max(laus_select$dt)),rangeslider = list(visible = T)),
             yaxis = list(title="",range=c(input$date_start,input$date_end)),
             margin = list(l = 50, r = 50, t = 60, b = 60),
             annotations = list(text = "Source: State and Metro Area Employment, BLS",
                                font = list(size = 12),
                                showarrow = FALSE,
                                xref = 'paper', x = -0.03,
                                yref = 'paper', y = -0.45))
    
    if(input$abs_per_laus=="per_change") {
      fig <- fig%>% 
        layout(yaxis = list(tickformat = "%"))
    }
    
    fig
  })
  


  

  

  
  output$housingPlot <- renderPlotly({
    fig <- housing_sb %>%
      filter(year(dt)>=2019) %>%
      #filter(key=="Bldgs") %>%
      plot_ly(x=~dt, y=~get(input$abs_per_housing),
              type="scatter",mode="lines", line = list(shape = 'spline'),
              split=~key,
              hoverinfo = 'text',
              text=~paste('</br> Date: ', dt,
                          '</br> Permits: ', total))%>% 
      layout(title = "New permits issued in SB-Mishawaka MSA",
             xaxis = list(title = ""),
             yaxis = list(title=""),
             margin = list(l = 50, r = 50, t = 60, b = 60),
             annotations = list(text = "Source: Building Permits Survey, US Census Bureau",
                                font = list(size = 12),
                                showarrow = FALSE,
                                xref = 'paper', x = -0.03,
                                yref = 'paper', y = -0.2))
    
    if(input$abs_per_housing=="per_change") {
      fig <- fig%>% 
        layout(yaxis = list(tickformat = "%"))
    }
    
    fig
  })
  
  output$homevaluePlot <- renderPlotly( {
    fig <- home_prices_in %>%
      mutate(color_var=ifelse(msa==input$select_msa_homevalue,1,0))%>%
      #filter(msa==input$select_msa_homevalue) %>%
      plot_ly(x=~dt, y=~get(input$abs_per_homevalue), 
              type="scatter",mode="lines",
              line = list(shape = 'spline'), # more data would make this look nicer
              split = ~msa,
              color=~color_var, colors = c("grey","red"), 
              hoverinfo = 'text',
              text=~paste('</br> MSA: ', msa,
                          '</br> Date: ', dt,
                          '</br> Home value: ', `value`,
                          '</br> Percentage Change: ', paste(round(per_change*100,2),"%"))) %>% 
      hide_colorbar() %>%
      layout(showlegend = FALSE,
             title = paste0("Home values in ",input$select_msa_homevalue," Metropolitan Statistical Area"),
             xaxis = list(title = "",range=c(ymd("2015-01-01"),Sys.Date()),rangeslider = list(visible = T, range=c(min(home_prices_in$dt),max(home_prices_in$dt)))), # use zeroline = FALSE to remove zero line :)
             yaxis = list(title = ""),
             margin = list(l = 50, r = 50, t = 60, b = 60),
             annotations = list(text = "Source: www.zillow.com",
                                font = list(size = 12),
                                showarrow = FALSE,
                                xref = 'paper', x = -0.03,
                                yref = 'paper', y = -0.45))
    
    if(input$abs_per_homevalue=="per_change") {
      fig <- fig%>% 
        layout(yaxis = list(tickformat = "%"))
    }
    
    
    fig
  })
  
  output$fhfahpiPlot <- renderPlotly( {
    
    fig <- fhfa_hpi_in %>%
      mutate(color_var=ifelse(msa_name==input$select_msa_homevalue,1,0))%>%
      plot_ly(x=~yr_q, y=~get(input$abs_per_homevalue2), 
              type="scatter",mode="lines",
              line = list(shape = 'spline'), # more data would make this look nicer
              split = ~msa_name,
              color=~color_var, colors = c("grey","red"), 
              hoverinfo = 'text',
              text=~paste('</br> MSA: ', msa_name,
                          '</br> Date: ', yr_q,
                          '</br> Home value: ', `index`,
                          '</br> Percentage Change: ', paste(round(per_change*100,2),"%"))) %>% 
      hide_colorbar() %>%
      layout(showlegend = FALSE,
             title = paste0("Index of home values in ",input$select_msa_homevalue," Metropolitan Statistical Area"),
             xaxis = list(title = "",range=c(ymd("2015-01-01"),Sys.Date()),rangeslider = list(visible = T, range=c(min(fhfa_hpi_in$yr_q),max(fhfa_hpi_in$yr_q)))), # use zeroline = FALSE to remove zero line :)
             yaxis = list(title = ""),
             margin = list(l = 50, r = 50, t = 60, b = 60),
             annotations = list(text = "Source: FHFA House Price Index®",
                                font = list(size = 12),
                                showarrow = FALSE,
                                xref = 'paper', x = -0.03,
                                yref = 'paper', y = -0.45))
    
    if(input$abs_per_homevalue2=="per_change") {
      fig <- fig%>% 
        layout(yaxis = list(tickformat = "%"))
    }
    
    
    fig
  })
  
  output$zoriPlot <- renderPlotly( {
    
    fig <- zori_in %>%
      mutate(color_var=ifelse(RegionName==input$select_msa_homevalue,1,
                              ifelse(RegionName=="United States",2,0)))%>%
      plot_ly(x=~mnth, y=~get(input$abs_per_zori), 
              type="scatter",mode="lines",
              line = list(shape = 'spline'), # more data would make this look nicer
              split = ~RegionName,
              color=~color_var, colors = c("grey","red","green"), 
              hoverinfo = 'text',
              text=~paste('</br> MSA: ', RegionName,
                          '</br> Date: ', mnth,
                          '</br> Home value: ', `rent_index`,
                          '</br> Percentage Change: ', paste(round(per_change*100,2),"%"))) %>% 
      hide_colorbar() %>%
      layout(showlegend = FALSE,
             title = paste0("Index of rental values in ",input$select_msa_homevalue," Metropolitan Statistical Area"),
             xaxis = list(title = "",range=c(ymd("2016-03-01"),Sys.Date()),rangeslider = list(visible = T, range=c(min(zori_in$mnth),max(zori_in$mnth)))), # use zeroline = FALSE to remove zero line :)
             yaxis = list(title = ""),
             margin = list(l = 50, r = 50, t = 60, b = 60),
             annotations = list(text = "Source: www.zillow.com",
                                font = list(size = 12),
                                showarrow = FALSE,
                                xref = 'paper', x = -0.03,
                                yref = 'paper', y = -0.45))
    
    if(input$abs_per_zori=="per_change") {
      fig <- fig%>% 
        layout(yaxis = list(tickformat = "%"))
    }
    
    
    fig
  })
  
  output$wagePlot <- renderPlotly( {
    fig <- sb_oes_over_time %>%
      #mutate(color_var=ifelse(msa==input$select_msa_homevalue,1,0))%>%
      #filter(msa==input$select_msa_homevalue) %>%
      plot_ly(x=~yr, y=~h_mean,#y=~get(input$abs_per_homevalue), 
              type="scatter",mode="lines",
              line = list(shape = 'spline'), # more data would make this look nicer
              split = ~occ_code,
              #color=~color_var, colors = c("grey","red"), 
              hoverinfo = 'text',
              text=~paste('</br> Year:', yr,
                          '</br>', occ_title,
                          '</br> Hourly wage:$', `h_mean`)
      ) %>% 
      hide_colorbar() %>%
      layout(showlegend = FALSE,
             title = paste0("Average hourly wage by occupation"),
             xaxis = list(title = ""), # use zeroline = FALSE to remove zero line :)
             yaxis = list(title = "Average hourly wage ($)"),
             margin = list(l = 50, r = 50, t = 60, b = 60),
             annotations = list(text = "Source: Occupational Employment and Wage Statistics",
                                font = list(size = 12),
                                showarrow = FALSE,
                                xref = 'paper', x = -0.03,
                                yref = 'paper', y = -0.2)
      )
    
    
    fig
  })
  
  
  output$snap_tanfPlot <- renderPlotly({
    fig <- snap_tanf_df %>%
      filter(msa_name==input$select_msa_inc_pov,
             Description==input$select_welfare_measure
      ) %>%
      plot_ly(x=~dt, y=~value,
              type="scatter",mode="lines", line = list(shape = 'spline'),
              hoverinfo = 'text',
              text=~paste('</br> Date: ', dt,
                          '</br>', Description,"=", value)) %>% 
      layout(title = paste0("Poverty and welfare in ",input$select_msa_inc_pov," MSA"),
             xaxis = list(title = "",range=c(ymd("2019-01-01"),max(snap_tanf_df$dt)),rangeslider = list(visible = T)),
             yaxis = list(title=""),
             margin = list(l = 50, r = 50, t = 60, b = 60),
             annotations = list(text = "Source: STATS Indiana",
                                font = list(size = 12),
                                showarrow = FALSE,
                                xref = 'paper', x = -0.03,
                                yref = 'paper', y = -0.45))
    fig
  })
  
  output$PersonalIncomePlot <- renderPlotly( {
    fig <- per_cap_personal_income_df %>%
      mutate(color_var=ifelse(msa==input$select_msa_inc_pov,1,0))%>%
      plot_ly(x=~yr, y=~per_cap_income,#y=~get(input$abs_per_homevalue), 
              type="scatter",mode="lines",
              line = list(shape = 'spline'), # more data would make this look nicer
              split = ~msa,
              color=~color_var, colors = c("grey","red"), 
              hoverinfo = 'text',
              text=~paste('</br> MSA: ', msa,
                          '</br> Year: ', yr,
                          '</br> Per capita personal income: ', `per_cap_income`)) %>% 
      hide_colorbar() %>%
      layout(showlegend = FALSE,
             title = paste0("Per capita personal income in ",input$select_msa_inc_pov," Metropolitan Statistical Area"),
             xaxis = list(title = "",range=c(2000,max(per_cap_personal_income_df$yr)),
                          rangeslider = list(visible = T, range=c(min(per_cap_personal_income_df$yr),max(per_cap_personal_income_df$yr)))
             ), # use zeroline = FALSE to remove zero line :)
             yaxis = list(title = ""),
             margin = list(l = 50, r = 50, t = 50, b = 20),
             annotations = list(text = "Source: U.S. Bureau of Economic Analysis",
                                font = list(size = 12),
                                showarrow = FALSE,
                                xref = 'paper', x = -0.03,
                                yref = 'paper', y = -0.45))
    
    
    fig
  })
  
  output$businessactivityPlot <- renderPlotly({
    fig <- sb_business_licenses %>%
      filter(mnth>=ymd("2015-02-01")
      ) %>%
      plot_ly(x=~mnth, y=~issues,#y=~get(input$abs_per), 
              type="scatter",mode="lines",
              line = list(shape = 'spline'), # more data would make this look nicer
              hoverinfo = 'text',
              text=~paste('</br> Month: ', mnth,
                          '</br> Licenses Issued: ', `issues`)) %>% 
      layout(showlegend = FALSE,
             title = "Business Licenses isssued (new and renewals) in South Bend, IN",
             xaxis = list(title = ""), # use zeroline = FALSE to remove zero line :)
             yaxis = list(title=""),
             margin = list(l = 50, r = 50, t = 60, b = 60),
             annotations = list(text = "Source: City of South Bend",
                                font = list(size = 12),
                                showarrow = FALSE,
                                xref = 'paper', x = -0.03,
                                yref = 'paper', y = -0.2)
      )
    
    fig
  })
  
  output$businesseinPlot <- renderPlotly({
    fig <- new_business_df %>%
      mutate(color_var=ifelse(County=="St. Joseph County",1,0)
             #color_var=ifelse(msa==input$select_msa_homevalue,1,0)
      )%>%
      
      plot_ly(x=~yr, y=~applications, 
              type="scatter",mode="lines",
              line = list(shape = 'spline'), # more data would make this look nicer
              split = ~County,
              color=~color_var, colors = c("grey","red"), 
              hoverinfo = 'text',
              text=~paste('</br> County: ', County,
                          '</br> Year: ', yr,
                          '</br> Applications: ', `applications`)) %>% 
      hide_colorbar() %>%
      layout(showlegend = FALSE,
             title = paste0("EIN issues in Indiana counties"),
             xaxis = list(title = "", range=c(2015,2020), rangeslider=list(visible=T)), # use zeroline = FALSE to remove zero line :)
             yaxis = list(title = ""),
             margin = list(l = 50, r = 50, t = 60, b = 60),
             annotations = list(text = "Source: Business Formation Statistics",
                                font = list(size = 12),
                                showarrow = FALSE,
                                xref = 'paper', x = -0.03,
                                yref = 'paper', y = -0.45))
    
    fig
  })
  
  output$employers_wordcloud <- renderWordcloud2({
    employers_jobs %>%
      filter(msa==input$select_msa_ba) %>% select(-msa) %>% as.data.frame() %>%
    wordcloud2(size=0.3, color='random-light', 
                      backgroundColor="black", minRotation = 0, maxRotation = 0, rotateRatio = 1)
  })

  output$joboccPlot <- renderPlotly({
    fig <- jobs_occupations %>%
      filter(msa==input$select_msa_ba) %>%
      mutate(`Occupation`=factor(`Occupation`,levels = rev(unique(`Occupation`)))) %>%
      plot_ly(y=~`Occupation`, x=~`Job Openings`,
              type = "bar", orientation="h") %>%
      layout(showlegend = FALSE,
             title = paste0("Occupations in demand in ",input$select_msa_ba," MSA"),
             xaxis = list(title = "Number of job openings"), # use zeroline = FALSE to remove zero line :)
             yaxis = list(title = "Occupation"),
             margin = list(l = 350, r = 50, t = 60, b = 90),
             annotations = list(text = "Source: www.indianacareerconnect.com",
                                font = list(size = 12),
                                showarrow = FALSE,
                                xref = 'paper', x = -0.6,
                                yref = 'paper', y = -0.35)
      )
    
    fig
  })
    
  output$skillsPlot <- renderPlotly({
    fig <- skills_jobs %>%
      filter(msa==input$select_msa_ba) %>%
      slice(1:10) %>%
      mutate(`Advertised Detailed Job Skill`=factor(`Advertised Detailed Job Skill`,levels = rev(unique(`Advertised Detailed Job Skill`)))) %>%
      plot_ly(y=~`Advertised Detailed Job Skill`, x=~`Job Opening Match Count`,
              type = "bar", orientation="h") %>%
      layout(showlegend = FALSE,
             title = paste0("Job skills in demand in ",input$select_msa_ba," MSA"),
             xaxis = list(title = "Number of jobs requiring the skill"), # use zeroline = FALSE to remove zero line :)
             yaxis = list(title = "Job skill"),
             margin = list(l = 50, r = 50, t = 60, b = 90),
             annotations = list(text = "Source: www.indianacareerconnect.com",
                                font = list(size = 12),
                                showarrow = FALSE,
                                xref = 'paper', x = -0.2,
                                yref = 'paper', y = -0.35)
      )
    
    fig
  })
  
  output$skillstable = DT::renderDataTable({
    skills_jobs%>%
      filter(msa==input$select_msa_ba) %>%
      select(Skill=`Advertised Detailed Job Skill`,`Number of jobs`=`Job Opening Match Count`)
  })
  
  output$toolsPlot <- renderPlotly({
    fig <- tools_jobs %>%
      filter(msa==input$select_msa_ba) %>%
      slice(1:10) %>%
      mutate(`Advertised Detailed Tool or Technology`=factor(`Advertised Detailed Tool or Technology`,levels = rev(unique(`Advertised Detailed Tool or Technology`)))) %>%
      plot_ly(y=~`Advertised Detailed Tool or Technology`, x=~`Job Opening Match Count`,
              type = "bar", orientation="h") %>%
      layout(showlegend = FALSE,
             title = paste0("Job tool/ technology in demand in ",input$select_msa_ba," MSA"),
             xaxis = list(title = "Number of jobs requiring the tool/technology"), # use zeroline = FALSE to remove zero line :)
             yaxis = list(title = "Tool/technology"),
             margin = list(l = 50, r = 50, t = 60, b = 90),
             annotations = list(text = "Source: www.indianacareerconnect.com",
                                font = list(size = 12),
                                showarrow = FALSE,
                                xref = 'paper', x = -0.4,
                                yref = 'paper', y = -0.35)
      )
    
    fig
  })
  
  output$toolstable = DT::renderDataTable({
    tools_jobs%>%
      filter(msa==input$select_msa_ba) %>%
      select(Skill=`Advertised Detailed Tool or Technology`,`Number of jobs`=`Job Opening Match Count`)
  })
  
  output$certificationsPlot <- renderPlotly({
    fig <- certifications_jobs %>%
      filter(msa==input$select_msa_ba) %>%
      mutate(`Advertised Certification Group`=factor(`Advertised Certification Group`,levels = rev(unique(`Advertised Certification Group`)))) %>%
      plot_ly(y=~`Advertised Certification Group`, x=~`Job Opening Match Count`,
              type = "bar", orientation="h") %>%
      layout(showlegend = FALSE,
             title = paste0("Job certification in demand in ",input$select_msa_ba," MSA"),
             xaxis = list(title = "Number of jobs requiring the certification"), # use zeroline = FALSE to remove zero line :)
             yaxis = list(title = "Certification"),
             margin = list(l = 350, r = 50, t = 60, b = 90),
             annotations = list(text = "Source: www.indianacareerconnect.com",
                                font = list(size = 12),
                                showarrow = FALSE,
                                xref = 'paper', x = -0.2,
                                yref = 'paper', y = -0.35)
      )
    
    fig
  })
  
  output$select_occ_text <- renderText({
    paste("As of",format(max(jobs_occupations$dt),"%b %d, %Y")," this occupation has",jobs_occupations$`Job Openings`[jobs_occupations$Occupation==input$e1 & jobs_occupations$dt==max(jobs_occupations$dt) & jobs_occupations$msa==input$select_msa_jo],"jobs")
  })
  
    
  output$evictionPlot <- renderPlotly({
    
  fig <- sb_weekly_evictions %>%
      plot_ly(x=~week_date, y=~total_filings, 
              type="scatter",mode="lines",
              line = list(shape = 'spline'), # more data would make this look nicer
              hoverinfo = 'text',
              text=~paste('</br> Week ending: ', week_date,
                          '</br> Eviction filings: ', `total_filings`),
              name="Total eviction filings") %>%
      add_trace(y=~avg_filings, name="Average filings 2016-19",
                text=~paste('</br> Week ending: ', week_date,
                            '</br> Average Eviction filings: ', `avg_filings`))%>%
      layout(title = "Weekly eviction filings in South Bend, IN",
             xaxis = list(title = ""), # use zeroline = FALSE to remove zero line :)
             yaxis = list(title = ""),
             legend = list(#shapes=list(type='line', y0= mdy("07-01-2020"),  x0=120, line=list(dash='dot', width=1)),
               orientation = "h",   # show entries horizontally
               xanchor = "center",  # use center of legend as anchor
               x = 0.5,y=-0.1),
             margin = list(l = 50, r = 50, t = 60, b = 60),
             annotations = list(text = "Source: www.evictionlab.org",
                                font = list(size = 12),
                                showarrow = FALSE,
                                xref = 'paper', x = -0.03,
                                yref = 'paper', y = -0.25),
             shapes = list(
               list(type = "rect",
                    fillcolor = "green", line = list(color = "green"), opacity = 0.3,
                    x0 = "2020-03-19", x1 = "2020-08-14", xref = "x",
                    y0 = 0, y1 = 100, yref = "y"),
               list(type = "rect",
                    fillcolor = "yellow", line = list(color = "yellow"), opacity = 0.3,
                    x0 = "2020-09-04", x1 = "2021-06-30", xref = "x",
                    y0 = 0, y1 = 100, yref = "y"))
      )
    
    
    fig
  })
  
  
  
  output$industryPlot <- renderPlotly({
    sb_naics_sector %>%
      mutate(per_jobs=bls_employment/sum(bls_employment)) %>%
      plot_ly(
        labels = ~ paste('Industry=',industry_title),
        parents = NA,
        values = ~ bls_employment,
        type = 'treemap',
        hovertemplate = "Industry: %{label}<br>Employment: %{value}<extra></extra>",
        text=~paste('Total Jobs =', bls_employment,
                    '<br>Percentage =',paste(round(per_jobs*100,0),"%"))) %>%
      layout(autosize = TRUE, #margin = list(l = 0, r = 0, b = 0, t = 0, pad = 4),
             margin = list(l = 50, r = 50, t = 60, b = 60),
             annotations = list(text = "Source: 2019 Quarterly Census of Employment and Wages, BLS",
                                font = list(size = 12),
                                showarrow = FALSE,
                                xref = 'paper', x = -0.03,
                                yref = 'paper', y = -0.2))
  })
  
  output$occupationPlot <- renderPlotly({
    sb_oes %>%
      mutate(per_jobs=tot_emp/sum(tot_emp)) %>%
      plot_ly(
        labels = ~ paste('Occupation=',occ_title),
        parents = NA,
        values = ~ tot_emp,
        type = 'treemap',
        hovertemplate = "Occupation: %{label}<br>Employment: %{value}<extra></extra>",
        text=~paste('Total Employment =', tot_emp,
                    '<br> Percentage =',paste(round(per_jobs*100,0),"%"))) %>%
      layout(autosize = TRUE, #margin = list(l = 0, r = 0, b = 0, t = 0, pad = 4),
             margin = list(l = 50, r = 50, t = 60, b = 60),
             annotations = list(text = "Source: 2019 Occupational Employment Statistics, BLS",
                                font = list(size = 12),
                                showarrow = FALSE,
                                xref = 'paper', x = -0.03,
                                yref = 'paper', y = -0.2))
  })
  

  
# Economic Complexity #
output$mapPlot_msa <- renderLeaflet({
  
  sb_mi_msa %>%
    #mutate(color_var=ifelse(GEOID==43780,1,0)) %>%
    st_transform() %>% # Transform or convert coordinates of simple feature
    leaflet() %>%
    addProviderTiles(provider = "CartoDB.Positron") %>% # free third-party basemaps
    addPolygons(popup = ~ NAME, # the text to show when clicked
                stroke = FALSE,
                smoothFactor = 0.5,
                fillOpacity = 0.5,
                weight = 1,
                fillColor = "green",
                highlightOptions = highlightOptions(color = "white", weight = 2,
                                                    bringToFront = TRUE)) %>%
    flyTo(lng = -86.17639118581819 , lat = 41.738542466611605, zoom = 8)
  
})


output$myImage <- renderImage({
  #width  <- session$clientData$output_myImage_width
  #height <- session$clientData$output_myImage_height
  # Return a list containing the filename
  list(src = 'www/South_Bend_Flag.png',
       contentType = 'image/png',
       width="100%",
       alt = "Alignment",
       style="text-align:justify;color:black;padding:15px;border-radius:10px")
}, deleteFile = FALSE)

output$myImage2 <- renderImage({
  #width  <- session$clientData$output_myImage_width
  #height <- session$clientData$output_myImage_height
  # Return a list containing the filename
  list(src = 'www/South_Bend_Flag.png',
       contentType = 'image/png',
       width="100%",
       alt = "Alignment",
       style="text-align:justify;color:black;padding:15px;border-radius:10px")
}, deleteFile = FALSE)

# switch this on if need to include image in etire page
#output$picture <- renderImage({
#  return(list(src = "www/South_Bend_Flag.png",contentType = "image/png",alt = "Alignment"))
#}, deleteFile = FALSE) #where the src is wherever you have the picture
  
#value boxes-------------------------------------------------------------------------------------------
  output$totaljobbox = renderValueBox({
    recent_date = max(df$dt)
    my_query = "Total Jobs as of SAMPLE"
    med_trips = df$`Job Openings`[ df$indicator=="Total Openings" & df$dt==recent_date & df$msa==input$select_msa ]
    valueBox(
      paste0(med_trips), sub("SAMPLE",format(recent_date,"%b %d, %Y"),my_query), icon = icon("fas fa-briefcase"),
      color = "yellow")
  }) 
  output$jobchangebox = renderValueBox({
    recent_date = max(df$dt)
    shl_trips = paste0(round(df$per_change[ df$indicator=="Total Openings" & df$dt==recent_date & df$msa==input$select_msa]*100,2),"%")
    valueBox(
      paste0(shl_trips), "Percent change as compared to the year before", icon = icon("fas fa-percent"),
      color = "green")
  }) 
  output$totalcandidatebox = renderValueBox({ 
    recent_date = max(df_cand$dt)
    my_query = "Total Candidates as of SAMPLE"
    ubers_etc = df_cand$`Candidates`[ df_cand$indicator=="Total Candidates" & df_cand$dt==recent_date & df_cand$msa==input$select_msa]
    valueBox(
      paste0(ubers_etc), sub("SAMPLE",format(recent_date,"%b %d, %Y"),my_query), icon = icon("fas fa-user-graduate"),
      color = "maroon")
  })
  output$candidatechangebox = renderValueBox({ 
    recent_date = max(df_cand$dt)

    ubers_etc = paste0(round(df_cand$per_change[ df_cand$indicator=="Total Candidates" & df_cand$dt==recent_date & df_cand$msa==input$select_msa]*100,2),"%")
    valueBox(
      paste0(ubers_etc), "Percent change as compared to the year before", icon = icon("fas fa-percent"),
      color = "purple")
  })
  
  output$candidatestojobbox = renderValueBox({ 
    recent_date = max(df_cand$dt)
    my_query = "Number of candidates per job as of SAMPLE"
    candidates = df_cand$`Candidates`[ df_cand$indicator=="Total Candidates" & df_cand$dt==recent_date & df_cand$msa==input$select_msa]
    jobs= df$`Job Openings`[ df$indicator=="Total Openings" & df$dt==recent_date & df$msa==input$select_msa ]
    cand_per_job=round(candidates/jobs,2)
    valueBox(
      paste0(cand_per_job), 
      p(sub("SAMPLE",format(recent_date,"%b %d, %Y"),my_query),
      br(),
      "A number less than or equal to one is good."),
      icon = icon("fas fa-file-medical-alt"),
      color = "blue")
  })
  
  # ces data
  output$totalemploymentbox = renderValueBox({
    recent_date = max(sb_elk_ces_sup$dt)
    my_query = "Total Employment as of SAMPLE"
    employment = sb_elk_ces_sup$total_employment[ sb_elk_ces_sup$industry_name=="Total Nonfarm" & sb_elk_ces_sup$dt==recent_date & sb_elk_ces_sup$msa_name==input$select_msa_emp ]
    valueBox(
      format(employment,big.mark=",",scientific=FALSE), sub("SAMPLE",format(recent_date,"%b %d, %Y"),my_query), icon = icon("fas fa-briefcase"),
      color = "yellow")
  }) 
  output$employmentchangebox = renderValueBox({
    recent_date = max(sb_elk_ces_sup$dt)
    emp_change = sb_elk_ces_sup$change[ sb_elk_ces_sup$industry_name=="Total Nonfarm" & sb_elk_ces_sup$dt==recent_date & sb_elk_ces_sup$msa_name==input$select_msa_emp]
    emp_change_per = round(sb_elk_ces_sup$per_change[ sb_elk_ces_sup$industry_name=="Total Nonfarm" & sb_elk_ces_sup$dt==recent_date & sb_elk_ces_sup$msa_name==input$select_msa_emp]*100,2)
    valueBox(
      #emp_change, 
      paste0(format(emp_change,big.mark=",",scientific=FALSE),"(",emp_change_per,"%)"),
      "Change compared to the year before", icon = icon("fas fa-percent"),
      color = "green")
  }) 
  
  # laus data
  output$totallaborforce = renderValueBox({ 
    recent_date = max(laus_select$dt)
    my_query = "Total labor force as of SAMPLE"
    labor_force = laus_select$value[ laus_select$measure=="Labor Force" & laus_select$dt==recent_date & laus_select$msa_name==input$select_msa_emp]
    valueBox(
      format(labor_force,big.mark=",",scientific=FALSE), sub("SAMPLE",format(recent_date,"%b %d, %Y"),my_query), icon = icon("fas fa-user-graduate"),
      color = "maroon")
  })
  output$unemploymentbox = renderValueBox({ 
    recent_date = max(laus_select$dt)
    my_query = "Unemployed as of SAMPLE"
    unemployed = laus_select$value[ laus_select$measure=="Unemployment" & laus_select$dt==recent_date & laus_select$msa_name==input$select_msa_emp]
    unemployed_per= round(laus_select$value[ laus_select$measure=="Unemployment Rate" & laus_select$dt==recent_date & laus_select$msa_name==input$select_msa_emp],2)
    valueBox(
      paste0(format(unemployed,big.mark=",",scientific=FALSE),"(",unemployed_per,"%)"), sub("SAMPLE",format(recent_date,"%b %d, %Y"),my_query), icon = icon("fas fa-percent"),
      color = "purple")
  })
  

  
  # housing boxes
  output$totalbuildingbox = renderValueBox({ 
    recent_date = as.character(max(housing_sb$dt)) 
    my_query = "Total permits issued as of 'SAMPLE'"
    n_units = housing_sb$total[housing_sb$key=="Units" & housing_sb$dt==recent_date ]
    valueBox(
      n_units, sub("SAMPLE",recent_date,my_query),
      color = "purple")
    
  })
  
  output$buildingchangebox = renderValueBox({ 
    recent_date = as.character(max(housing_sb$dt)) 
    my_query = "Percent change since 'SAMPLE'"
    comparison_date = "January 2020"
    per_change = paste0(round(housing_sb$per_change[housing_sb$key=="Units" & housing_sb$dt==recent_date ]*100,2),"%")
    valueBox(
      per_change, sub("SAMPLE",comparison_date,my_query),
      color = "purple")
   
  })
  
  output$homevaluebox = renderValueBox({
    recent_date = max(home_prices_in$dt)
    my_query = "Home value as of SAMPLE"
    home_value = home_prices_in$value[home_prices_in$dt==recent_date & home_prices_in$msa==input$select_msa_homevalue ]
    valueBox(
      paste0(format(home_value,big.mark=",",scientific=FALSE)), sub("SAMPLE",format(recent_date,"%b %d, %Y"),my_query), icon = icon("home"),
      color = "yellow")
  }) 
  
  output$homevaluechangebox = renderValueBox({
    recent_date = max(home_prices_in$dt)
    homevaluechange = paste0(round(home_prices_in$per_change[ home_prices_in$dt==recent_date & home_prices_in$msa==input$select_msa_homevalue]*100,2),"%")
    valueBox(
      paste0(homevaluechange), "Change compared to the year before", icon = icon("fas fa-percent"),
      color = "green")
  })
  
  
  
#evictions boxes
  output$totalevictionbox = renderValueBox({ 
    recent_date = as.character(max(sb_weekly_evictions$week_date)) 
    my_query = "Total eviction filings in week ending 'SAMPLE'"
    n_eviction_filings = sb_weekly_evictions$total_filings[sb_weekly_evictions$week_date==recent_date ] %>% sum()
    valueBox(
      n_eviction_filings, sub("SAMPLE",recent_date,my_query),
      color = "purple")
    
  })
  
  output$evictionchangebox = renderValueBox({ 
    recent_date = as.character(max(sb_weekly_evictions$week_date)) 
    my_query = "Percent change since 'SAMPLE'"
    comparison_date = "average (2016-19)"
    per_change = paste0(round(sb_weekly_evictions$per_change[sb_weekly_evictions$week_date==recent_date ]*100,2),"%")
    valueBox(
      per_change, sub("SAMPLE",comparison_date,my_query),
      color = "purple")
    
  })


}


#Execute APP------------
shinyApp(ui, server)


