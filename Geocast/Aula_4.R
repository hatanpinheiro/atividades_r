
# preparate r -------------------------------------------------------------
# packages
library(raster) # raster
library(sf) # vetor
library(tmap) # thematic maps
library(sf)

# importar raster -----------------------------------------------------------
#landsat1 <- raster::raster("./data/stack_2010.tif")

# Raster brick
landsat <- raster::brick("./data/stack_2010.tif")
plot(landsat)
# informacoes do raster 

# quantidade de layers
nlayers(landsat)

# nrow, ncol, ncell
nrow(landsat)
ncol(landsat)
ncell(landsat)

# resolucao
res(landsat)

# projecao
projection(landsat) # string ou character
crs(landsat) # argumento de crs

# exemplo camporeRaster()
compareRaster(landsat, landsat1)

# names
names(landsat)

# mudando nome das camadas 

names(landsat) <- c("blue", "green", "red", "NIR")
names(landsat)[1:3] <- c("Azul", "Verde", "Vermelho")

# Calculos com as camadas ---------------------------------------------------
# trabalhando com todas as bandas
landsat <- landsat/10
landsat[[4]] <- landsat[[4]]*10
# Alternativa
#landsat$Azul <- landsat[[1]]/10

# plot do raster ---------------------------------------------------
plot(landsat)

# plotRGB
# mudar strech
plotRGB(landsat, stretch = 'lin')
# mudar composicao
plotRGB(landsat, r = 3, g = 2, b =  1, stretch = 'hist')

# Ou com tmap
tm_shape(landsat) + 
  tm_rgb(r = 4, g = 3, b = 2)

# strech
l5 <- raster::stretch(landsat, minq=0.02, maxq=0.98)

# plot
tm_shape(l5) + 
  tm_rgb(r = 4, g = 3, b = 2)+
  tm_grid(lwd = 0) + 
  tm_layout(main.title = "Landsat 4,3,2 - 2010")

# Indices espectrais NDVI -------------------------------------------------------
# Estilo brucutu
# (NIR - Red)/(NIR + Red)
ndvi <- (landsat[[4]] - landsat[[3]]) / (landsat[[4]] + landsat[[3]])
plot(ndvi)

# Estilo otimizado
?overlay
overlay(x = landsat[[4]], y = landsat[[3]], fun = function(x,y){
  return ((x-y)/(x+y))}, 
  filename = "./data/ResultadoNDVI.tif") # economizar recursos

ndvi <- raster("./data/ResultadoNDVI.tif")
plot(ndvi)

# falar sobre " ...	"

# plot com tmap
tm_shape(ndvi) +
  tm_raster() +
  tm_layout(legend.outside = TRUE)

# incorporando novas bandas -------------------------
# add layer
landsat <- addLayer(landsat, ndvi)

plotRGB(landsat, nlayers(landsat), 4, 2, stretch = 'lin')

# Raster stack -------------------------------------------------------
# vamos trabalhar com dados do P.E Rola Moça
rm <- read_sf("./data/shp/Rola-Moca_WGS_UTM23.shp")

#Stack com list.files()

# pre Incendio
preIncendio <- stack(
  list.files("./data/Pre_incendio", full.names = TRUE) # usando list.files()
)
# Pos Incendio
posIncendio <- stack(
  dir("./data/Pos_incendio", full.names = TRUE) # usando dir()
)

plotRGB(preIncendio, stretch = 'hist')
plot(rm, add = TRUE)

# recortando raster por poligono
preIncendio <- mask(preIncendio, rm)
posIncendio <- mask(posIncendio, rm) # pesquisem o parametro inverse = TRUE

# Indices espectrais NBR -------------------------------------------------------
nbrPre <- overlay(preIncendio[[3]], preIncendio[[4]], fun = function(x,y){
  return (x - y)/(x+y)})
plot(nbrPre)

nbrPos <- overlay(posIncendio[[3]], posIncendio[[4]], fun = function(x,y){
  return (x - y)/(x+y)})
plot(nbrPos)

# delta NBR
dNBR <- nbrPre - nbrPos

tm_shape(dNBR) + 
  tm_raster() + 
  tm_graticules(lwd = 0)
# mudando style = 'fisher'
tm_shape(dNBR) + 
  tm_raster(style = "fisher") + 
  tm_graticules(lwd = 0)

