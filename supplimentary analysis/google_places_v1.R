library(tidyverse)
library(googleway)

# ref: http://symbolixau.github.io/googleway/articles/googleway-vignette.html#google-places-api

mykey <- "AIzaSyAcp0Rm7iODxxMBwTmImJGYs44Zo-dtPyc"

res5 <- google_places(search_string = 'grocery stores in South Bend IN', key=mykey)

df <- res4$results