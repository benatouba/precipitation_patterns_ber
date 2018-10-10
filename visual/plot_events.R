library(ncdf4)
library(fields)
library(rgdal)
library(matlab)
library(lubridate)

model <- "comparison" # event, reference, comparison (event - reference)
date <- "20150613" # as string
gif_delay <- 100 # ms

setwd("/data/scratch/smidbenq/ma/events/")
dname <- "TOT_PREC"

nc <- nc_open(paste0(date, "/", model, "_", date, ".nc"))

# get precipitation

data <- ncvar_get(nc, dname)
dlname <- ncatt_get(nc,dname,"long_name")
dunits <- ncatt_get(nc,dname,"units")
fillvalue <- ncatt_get(nc,dname,"_FillValue")
data[data <= 0] <- NA

if (model != "comparison"){
  breaks <- c(0, 5, 10, 15, 20, 25, 30, 35)
  colors <- jet.colors(7)
  
} else {
  breaks <- c(-30, -20, -10, 0, 10, 20, 30, 40)
  colors <- rev(brewer.pal(n = 7, name = "RdBu"))
}
shapefile <-readOGR("/data/scratch/smidbenq/ma/radolan/shapefiles/NUTS_RG_01M_2013_4326_LEVL_1.shp", 
                    layer = "NUTS_RG_01M_2013_4326_LEVL_1")

# get longitude and latitude
lon <- ncvar_get(nc,"lon")
lat <- ncvar_get(nc,"lat")

# get time
time <- ncvar_get(nc,"time")
tunits <- ncatt_get(nc,"time","units")
origin <- ymd_hms(tunits$value, tz = "UTC")
real_time <- origin + duration(time, units = "seconds")

# convert time -- split the time units string into field


for (i in 1:length(data[1,1,])) {
  png(sprintf("%s/%s_day_%02d_hour_%02d.png", 
              date,
              model, 
              day(real_time[i]), 
              hour(real_time[i])), 
      width = 1024, height = 768)
  image.plot(x = lon[100:270,100:270], y = lat[100:270,100:270], z = data[100:270,100:270,i],
             nlevel = 7,
             col = colors,
             breaks = breaks,
             # horizontal = T,
             legend.lab = "Total Precipitation [mm]",
             legend.cex = 0.7,
             legend.width = 0.3,
             xlab = "",
             ylab = "",
             main = paste(real_time[i], "+ next hour")
  )
  plot(shapefile, add=T)
  dev.off()
}

system(sprintf("convert -delay %2i %s/%s_*.png %s/%s_%s.gif", 
               gif_delay, 
               date,
               model,
               date,
               model,
               date))

