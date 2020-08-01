install.packages(c("raster", "shiny","rcolorbrewer", "viridis", "cptcity", "tmap"), dependencier = TRUE)

library(raster) #raster
library(tmap) #thematic maps
library(cptcity) #colors scale
library(viridis) #colors scale
library(shiny)
library(shinyjs)
# import raster

dem <- raster::raster("./data/dem.tif")
dem

# plot raster
plot(dem)

#raster information
#object
dem


# extend
extent(dem)

#nrow, ncol, ncell
nrow(dem)
ncol(dem)
ncell(dem)

#projection
projection(dem)
crs(dem)

#names
names(dem)

#values
values(dem)

#values
dem[]

#logic operation
#acima ou igual a 500
dem_acima_500 <- dem >= 500
dem_acima_500
plot(dem_acima_500)

#multiplication
dem_acima_500_val <- dem_acima_500 * dem
dem_acima_500_val
plot(dem_acima_500_val)

#substituir valores
#maiores que 1000
dem_500 <- dem
dem_500[dem > 500] <- NA
dem_500
plot(dem_500)

#NAs por 9999
dem_9999 <- dem
dem_9999[is.na(dem_9999)] <- 9999
plot(dem_9999)

#matriz de reclassificação
#vetor
vec <- c(0, 100, 1,
         100, 500, 2,
         500, 1000, 3,
         1000, 1500, 4,
         1500, 2000, 5,
         2000, 2500,6)
vec

#matriz
mat <- matrix(vec, ncol = 3, byrow = TRUE)
mat

# reclassificar
dem_rec <- raster::reclassify(dem, mat, right = FALSE)
dem_rec
plot(dem_rec)

# mapa final
# tmap
tm_shape(dem) +
  tm_raster() +
  tm_layout(legend.position = c("left", "bottom"))

# tmpa- escala de cores
tm_shape(dem) +
  tm_raster(palette = "-RdYlGn") +
  tm_layout(legend.position = c("left", "bottom"))

#acessar paletas de cores do tmap
tmaptools::palette_explorer() #tem que ter o pacote shiny

# tmap - escala de cores - viridis
tm_shape(dem) +
  tm_raster(palette = viridis::cividis(5)) +
  tm_layout(legend.position = c("left", "bottom"))

# tmap - escala de cores - cpt
cptcity::find_cpt("dem")
cptcity::find_cpt(dem)[11]

tm_shape(dem) +
  tm_raster(palette = cptcity::cpt(pal = cptcity::find_cpt("dem")[4]), n = 9) +
  tm_layout(legend.position = c("left", "bottom"))
  
# tmap n
tm_shape(dem) +
  tm_raster(palette = cptcity::cpt(pal = cptcity::find_cpt("dem")[4]), n = 9) +
  tm_layout(legend.position = c("left", "bottom"))

# tmap n
tm_shape(dem) +
  tm_raster(palette = cptcity::cpt(pal = cptcity::find_cpt("dem")[4]), 
            breaks = c(0, 200, 400, 600, 800, 1000, 2000, 2600))+
  tm_layout(legend.position = c("left", "bottom"))

# mapa final continuo
tm_shape(dem) +
  tm_raster(palette = cptcity::cpt(pal = cptcity::find_cpt("dem")[4]), 
            breaks = c(0, 200, 400, 600, 800, 1000, 2000, 2600),
            labels = c("0 até 200", 
                       "201 até 400", 
                       "401 até 600", 
                       "601 até 800",
                       "801 até 1000", 
                       "1001 até 2000",
                       "2001 até 2600"),
            title = "Elevação (m)") +
  tm_graticules(lines = FALSE) + 
  tm_compass(position = c("right", "top")) +
  tm_scale_bar(text.size = .7) +
  tm_layout(main.title = "Modelo Digital de Elevação para o Brasil", 
            main.title.position = "center",
            legend.position = c("left", "bottom"))

tmap::tmap_save(filename = "./map_dem_brasil_con.png",
                width = 20, 
                height = 20, 
                units = "cm", 
                dpi = 600)

# mapa final categorico
tm_shape(dem_rec) +
  tm_raster(style = "cat", 
            palette = "-RdYlGn",
            labels = c("0 até 100", 
                       "101 até 500", 
                       "501 até 1000", 
                       "1001 até 1500", 
                       "1501 até 2000", 
                       "2001 até 2600"),
            title = "Elevação (m)") +
  tm_graticules(lines = FALSE) + 
  tm_compass(position = c("right", "top"), size = 2, type = "4star") +
  tm_scale_bar(text.size = .7) +
  tm_layout(main.title = "Modelo Digital de Elevação para o Brasil", 
            main.title.position = "center",
            legend.position = c("left", "bottom"))

tmap::tmap_save(filename = "./map_dem_brasil_cat.png",
                width = 20, 
                height = 20, 
                units = "cm", 
                dpi = 300)
# end
