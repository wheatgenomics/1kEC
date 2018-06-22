
library(raster)
library(maptools)
library(rgdal)
library(sp)


ClimDatDir<-"/home/DNA/worlclim_data"
climVar<-c("alt","bio","prec","tmax","tmean","tmin")

iw=read.table()

#r<-GPS data



ClimDataAcc<-NULL
  for(i in 1:length(climVar)){
	ClimDataAcc<-cbind(ClimDataAcc,climDataExtr(climVar[i],rr))
  }




climDataExtr<-function(var,r){# var is the climatic variable from worldclim database; r-is dataframe with long. (1st colmn)/lat. (2nd column) data 
    namePatt<-paste(var,".*\\.bil$",sep="")
    files <- list.files(pattern=namePatt)
    rastSt<-stack(files)
    extract(rastSt,r)
}



