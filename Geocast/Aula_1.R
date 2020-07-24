install.packages("geobr")

library(geobr)

estados_brasil <- geobr:: read_state(code_state = "all", 
                                     year = 2018, 
                                     simplified = TRUE, 
                                     showProgress = TRUE)

estados_brasil

plot(estados_brasil$geom)
