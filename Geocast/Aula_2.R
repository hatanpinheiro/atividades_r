#' ---
#' title: Vetores e mapas no r
#' author: Hatan Pinheiro
#' data: 2020-07-24
#' ---


# install
install.packages("geobr")
install.packages("sf")
install.packages("ggplot2")
install.packages("ggspatial")

# packages
library(geobr) # ibge limits
library(sf) # vector
library(ggplot2) # graphics and maps
library(ggspatial) # spatial elements in ggplot2

# folder for files
setwd("C:/Users/hatan/Google Drive/Cursos/GeoCast/RStudio")
getwd() # show diretory

# downloads
download.file(url = "http://geo.fbds.org.br/SP/RIO_CLARO/USO/SP_3543907_USO.dbf",
              destfile = "SP_3543907_USO.dbf")
download.file(url = "http://geo.fbds.org.br/SP/RIO_CLARO/USO/SP_3543907_USO.prj",
              destfile = "SP_3543907_USO.prj")
download.file(url = "http://geo.fbds.org.br/SP/RIO_CLARO/USO/SP_3543907_USO.shp",
              destfile = "SP_3543907_USO.shp")
download.file(url = "http://geo.fbds.org.br/SP/RIO_CLARO/USO/SP_3543907_USO.shx",
              destfile = "SP_3543907_USO.shx")

#data import
polygons_land_use <- sf::st_read("SP_3543907_USO.shp")
polygons_land_use
plot(polygons_land_use$geometry)

# rio claro limit
rio_claro_limit <- geobr::read_municipality(code_muni = 3543907, year = 2015,)
rio_claro_limit
plot(rio_claro_limit&geom, col = "gray")

# map---------------------
#rio claro limit
ggplot() +
  geom_sf(data = rio_claro_limit)

# rio claro limit color and fill
ggplot() +
  geom_sf(data = rio_claro_limit, color = "black", fill = NA) +
  geom_sf(data = polygons_land_use)
  
ggplot() +
  geom_sf(data = rio_claro_limit, color = "black", fill = NA) +
  geom_sf(data = polygons_land_use, aes(fill = CLASSE_USO), color = NA)

ggplot() +
  geom_sf(data = polygons_land_use, aes(fill = CLASSE_USO), color = NA) +
  geom_sf(data = rio_claro_limit, color = "white", fill = NA)

ggplot() +
  #geom_sf(data = polygons_land_use, aes(fill = CLASSE_USO), color = NA) +
  geom_sf(data = rio_claro_limit, color = "Black", fill = NA) +
  #scale_fill_manual(values = c("blue", "orange", "gray30", "forestgreen", "green")) +
  #coord_sf(datum = sf::st_crs(polygons_land_use))+
  theme_minimal() +
  annotation_scale(location = "br", width_hint = .3)+
  annotation_north_arrow(location = "br", which_north = "true",
                         pad_x = unit(0,"cm"), pad_y = unit(.8, "cm"),
                         style = north_arrow_fancy_orienteering)
# Export
ggsave(filename = "map_rio_claro_land_use.png",
       path = "C:/Users/hatan/Google Drive/Cursos/GeoCast/RStudio",
       width = 20,
       height = 20,
       units = "cm",
       dpi = 300)
  