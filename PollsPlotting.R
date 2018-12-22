# clean workspace
cat("\f")
rm(list=ls()) 

library(sp)
library(rgeos)
library(rgdal)
library(raster) 


geo <- read.table(file = 'PollsGeocoded.tsv', sep = '\t', header = FALSE)
geo <- geo[! is.na( geo[, 6] ) , ]
geo <- geo[! is.na( geo[, 5] ) , ]
geo$lon <- geo$V6
geo$lat <- geo$V5

votinglocation <- SpatialPointsDataFrame(coords = geo[7:8],
                                         data   = geo[1:4],
                                         proj4string = CRS("+proj=longlat +datum=WGS84 +no_defs"))
                                         # note: CRS set at unprojected WGS84

slums <- readOGR(dsn=path.expand("C:/Users/PEDRO/Desktop/map"),
                 layer="Limite_Favelas_2013")

rio <- readOGR(dsn=path.expand("C:/Users/PEDRO/Desktop/map"),
               layer="Limite_do_Município_do_Rio_de_Janeiro")

newcrs <- CRS("+proj=utm +zone=23 +south +ellps=GRS67 +units=m +no_defs")
polls <- spTransform(votinglocation, newcrs)

plot(rio,  border = "black", col = "transparent")
plot(polls, col = "red", add = T)
plot(slums,  border = "blue", col = "transparent", add = T)


