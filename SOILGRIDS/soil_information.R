library(rgdal)
library(gdalUtils)
library(sf)
library(readr)

voi = c("bdod") # variable of interest
# voi = c("cec")
# voi = c("cfvo")
# voi = c("clay")
# voi = c("nitrogen")
# voi = c("phh2o")
# voi = c("sand")
# voi = c("silt")
# voi = c("soc")
depth = "0-30cm"
layer = "mean"
voi_layer = paste(voi,depth,layer, sep="_") # layer of interest 

webdav_path = '/vsicurl?max_retry=3&retry_delay=1&list_dir=no&url=https://files.isric.org/soilgrids/latest/data/'


data <- read_csv("puntos.csv")
spdata = st_as_sf(data, coords = c("x","y"), crs = 4326)
igh = '+proj=igh +lat_0=0 + lon_0=0 +datum=WGS84 + units=m +no_defs'
spdata_igh = st_transform(spdata, igh)

data_igh = data.frame(st_coordinates(spdata_igh), id=spdata_igh$index)

fun_pixel_values=function(rowPX,data,VOI,VOI_LYR){
  as.numeric(
    gdallocationinfo(
      srcfile=paste0(webdav_path,"/",VOI,"/", VOI_LYR,".vrt"),
      x=data[rowPX,"X"],
      y=data[rowPX,"Y"],
      geoloc=TRUE,
      valonly=TRUE))
}

value_pixels=unlist(lapply(1:3,function(x){fun_pixel_values(x,puntos_igh,voi,voi_layer)}))

