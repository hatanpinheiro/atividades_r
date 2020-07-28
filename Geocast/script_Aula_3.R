#' ---
#' title: We R Live 03: Mapas com tmap
#' author: Hatan Pinheiro Silva
#' date: 2020-07-28
#' ---

# preparate r -------------------------------------------------------------
# packages
library(geobr) # ibge limits
library(sf) # vector
library(tmap) # thematic maps

# directory
# Vou mostrar organizando um projegto do RStudio
# criando um diretório:
# dir.create("./data")

# download geospatial data ------------------------------------------------
# lines - Rios simples 
download.file(url = "http://geo.fbds.org.br/SP/RIO_CLARO/HIDROGRAFIA/SP_3543907_RIOS_SIMPLES.dbf", 
              destfile = "./data/SP_3543907_RIOS_SIMPLES.dbf", mode = "wb")
download.file(url = "http://geo.fbds.org.br/SP/RIO_CLARO/HIDROGRAFIA/SP_3543907_RIOS_SIMPLES.prj", 
              destfile = "./data/SP_3543907_RIOS_SIMPLES.prj", mode = "wb")
download.file(url = "http://geo.fbds.org.br/SP/RIO_CLARO/HIDROGRAFIA/SP_3543907_RIOS_SIMPLES.shp", 
              destfile = "./data/SP_3543907_RIOS_SIMPLES.shp", mode = "wb")
download.file(url = "http://geo.fbds.org.br/SP/RIO_CLARO/HIDROGRAFIA/SP_3543907_RIOS_SIMPLES.shx", 
              destfile = "./data/SP_3543907_RIOS_SIMPLES.shx", mode = "wb")

# points - Nascentes 
download.file(url = "http://geo.fbds.org.br/SP/RIO_CLARO/HIDROGRAFIA/SP_3543907_NASCENTES.dbf", 
              destfile = "./data/SP_3543907_NASCENTES.dbf", mode = "wb")
download.file(url = "http://geo.fbds.org.br/SP/RIO_CLARO/HIDROGRAFIA/SP_3543907_NASCENTES.prj", 
              destfile = "./data/SP_3543907_NASCENTES.prj", mode = "wb")
download.file(url = "http://geo.fbds.org.br/SP/RIO_CLARO/HIDROGRAFIA/SP_3543907_NASCENTES.shp", 
              destfile = "./data/SP_3543907_NASCENTES.shp", mode = "wb")
download.file(url = "http://geo.fbds.org.br/SP/RIO_CLARO/HIDROGRAFIA/SP_3543907_NASCENTES.shx", 
              destfile = "./data/SP_3543907_NASCENTES.shx", mode = "w")

# import geospatial data --------------------------------------------------
# Nascentes
nascentes <- sf::st_read("./data/SP_3543907_NASCENTES.shp") # pode demorar
nascentes
plot(nascentes$geometry)

# Rios simples
rios <- sf::st_read("./data/SP_3543907_RIOS_SIMPLES.shp") # pode demorar
rios
plot(rios$geometry)

# Municipios SP
muni_sp <- geobr::read_municipality(code_muni = 'SP', year = 2015)
muni_sp
plot(muni_sp$geom, col = "gray")

# Rio claro
rio_claro_limit <- geobr::read_municipality(code_muni = 3543907, year = 2015)
rio_claro_limit
plot(rio_claro_limit$geom, col = "gray")

# 1. mapa --------------------------------------------------------------------
# Rio Claro com municipios limitrofes
tm_shape(muni_sp, bbox = rio_claro_limit) +
  tm_polygons(col = "lightgrey") +
  tm_shape(rio_claro_limit) +
  tm_borders(col = 'red', lty = 'dotted', lwd = 5) #lty = line type; lwd = line width

# 2. mapa --------------------------------------------------------------------
# rios e nascentes de Rio Claro com municipios limitrofes 
m1 <- tm_shape(muni_sp, bbox = rio_claro_limit) +
  tm_polygons(col = "lightgrey") +
  tm_text('name_muni') +
  tm_shape(rio_claro_limit) +
  tm_polygons(col = "darkgrey") +
  tm_text('name_muni')
  

m1

# 3. Adicionando detalhes ----
# rios e nascentes de Rio Claro com municipios limitrofes 
m2 <- tm_shape(muni_sp, bbox = rio_claro_limit) +
  tm_polygons(col = "lightgrey") +
  tm_text('name_muni') +
  tm_shape(rio_claro_limit) +
  tm_polygons(col = "darkgrey") +
  tm_compass() +
  tm_grid(projection = 32723) + 
  tm_scale_bar() +
  tm_layout(main.title = "Mapa ", legend.outside = T, main.title.position = 'center')
m2  

# 4. compondo dois ou mais mapas em uma imagem ------
# tmap_arrange
tmap_arrange(m1, m2)

# 5. estilo pré concebidos
# tmap_style
m2 + tm_style("bw")
m2 + tm_style("classic")
m2 + tm_style("cobalt")
m2 + tm_style("col_blind")

# 6. salvando mapa
tmap::tmap_save(m2, filename = "map_rio_claro.png")

# 7. tmap_mode()
tmap_mode()
tmap_mode("view")
webmap <- tm_shape(muni_sp, bbox = rio_claro_limit) +
  tm_polygons(col = "lightgrey") +
  tm_text("name_muni") +
  tm_shape(rio_claro_limit) +
  tm_polygons(col = "darkgrey") +
  tm_text("name_muni") + 
  tm_shape(rios) +
  tm_lines(col = "blue")
webmap

# 8. export html 'widget'
tmap::tmap_save(filename = "map_rio_claro.html",
                width = 20, 
                height = 20, 
                units = "cm", 
                dpi = 300)

# end ---------------------------------------------------------------------
