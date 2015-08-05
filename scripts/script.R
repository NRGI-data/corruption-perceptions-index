
require("xlsx")
require("rvest")
require("countrycode")
require("reshape2")
# this.dir <- dirname(parent.frame(2)$ofile)
setwd(paste0(getwd(),'/corruption-perceptions-index/scripts'))

#All CPI data files will be stored in a 'data' directory
system("mv ../data/corruption-perceptions-index-wide.csv ../data/corruption-perceptions-index-wide.bak.csv && mv ../data/corruption-perceptions-index-long.csv ../data/corruption-perceptions-index-long.bak.csv && mkdir tmp && mkdir tmp/data")
dir.create("tmp")
dir.create("tmp/data")

#There is no consistent storage of files containing CPI data
#We need to reference them individually, for each year
#And to process them individually
#Hence the code below is somewhat repetitive, though slightly different

url2014<-"http://files.transparency.org/content/download/1857/12438/file/CPI2014_DataBundle.zip"
url2013<-"http://files.transparency.org/content/download/702/3015/file/CPI2013_DataBundle.zip"
url2012<-"http://files.transparency.org/content/download/533/2213/file/2012_CPI_DataPackage.zip"
url2011<-"http://files.transparency.org/content/download/313/1264/file/CPI2011_DataPackage.zip"
url2010<-"http://files.transparency.org/content/download/426/1752/CPI+2010+results_pls_standardized_data.xls"
#Before year 2009, HTML pages needs to be scraped
#The base url is http://www.transparency.org/research/cpi/cpi_XXXX
#where XXXX stands for the year (between 1998 and 2009)

#2014
tryCatch({
    message("Downloading and extracting CPI data 2014")
  download.file(url2014,"tmp/CPI2014_DataBundle.zip")
  unzip("tmp/CPI2014_DataBundle.zip", exdir="tmp")
  all_data<-read.xlsx("tmp/CPI2014_DataBundle/CPI 2014_Regional with data source scores_final.xlsx", sheetIndex = 1,stringsAsFactors=F)
  subset_data2014<-all_data[-c(1,2),c(2,6)]
  subset_data2014[,1]<-sub(",","",subset_data2014[,1])
  colnames(subset_data2014)<-c("Jurisdiction","CPI")
  write.csv(subset_data2014,"tmp/data/CPI2014.csv",quote=F,row.names=F)
  message("CPI data 2014 succesfully downloaded and saved in tmp/data/CPI2014.csv")
}, warning = function(cond) {
    message("CPI data 2014 caused a warning:")
    message(cond)
}, error = function(cond) {
    message("CPI data 2014 caused an error:")
    message(cond)
})
#2013
tryCatch({
    message("Downloading and extracting CPI data 2013")
    download.file(url2013,"tmp/CPI2013_DataBundle.zip")
  unzip("tmp/CPI2013_DataBundle.zip", exdir="tmp")
  all_data<-read.xlsx("tmp/CPI2013_DataBundle/CPI2013_GLOBAL_WithDataSourceScores.xls", sheetIndex = 1, stringsAsFactors=F)
  subset_data2013<-all_data[-1,c(2,7)]
  subset_data2013[,1]<-sub(",","",subset_data2013[,1])
  colnames(subset_data2013)<-c("Jurisdiction","CPI")
  write.csv(subset_data2013,"tmp/data/CPI2013.csv",quote=F,row.names=F)
  message("CPI data 2013 succesfully downloaded and saved in tmp/data/CPI2013.csv")
}, warning = function(cond) {
    message("CPI data 2013 caused a warning:")
    message(cond)
}, error = function(cond) {
    message("CPI data 2013 caused an error:")
    message(cond)
})
#2012
tryCatch({
    message("Downloading and extracting CPI data 2012")
    download.file(url2012,"tmp/2012_CPI_DataPackage.zip")
  unzip("tmp/2012_CPI_DataPackage.zip", exdir="tmp")
  all_data<-read.xlsx("tmp/2012_CPI_DataPackage/CPI2012_Results.xls", sheetIndex = 1, stringsAsFactors=F)
  subset_data2012<-all_data[-1,c(2,4)]
  subset_data2012[,1]<-sub(",","",subset_data2012[,1])
  colnames(subset_data2012)<-c("Jurisdiction","CPI")
  write.csv(subset_data2012,"tmp/data/CPI2012.csv",quote=F,row.names=F)
  message("CPI data 2012 succesfully downloaded and saved in data/CPI2012.csv")
}, warning = function(cond) {
    message("CPI data 2012 caused a warning:")
    message(cond)
}, error = function(cond) {
    message("CPI data 2012 caused an error:")
    message(cond)
})
#2011
tryCatch({
    message("Downloading and extracting CPI data 2011")
    download.file(url2011,"tmp/CPI2011_DataPackage.zip")
  unzip("tmp/CPI2011_DataPackage.zip", exdir="tmp")
  #Below, if sheetIndex data is used, wrong CPI data are returned. Use of sheetName works. Not sure why.
  all_data<-read.xlsx2("tmp/CPI2011_DataPackage/CPI2011_Results.xls", sheetName = "Global", stringsAsFactors=F)
  subset_data2011<-all_data[-1,c(2,3)]
  subset_data2011[,1]<-sub(",","",subset_data2011[,1])
  colnames(subset_data2011)<-c("Jurisdiction","CPI")
  write.csv(subset_data2011,"tmp/data/CPI2011.csv",quote=F,row.names=F)
  message("CPI data 2011 succesfully downloaded and saved in tmp/data/CPI2011.csv")
}, warning = function(cond) {
    message("CPI data 2011 caused a warning:")
    message(cond)
}, error = function(cond) {
    message("CPI data 2011 caused an error:")
    message(cond)
})
#2010
tryCatch({
    message("Downloading and extracting CPI data 2010")
    download.file(url2010,"tmp/CPI2010.xls")
  all_data<-read.xlsx("tmp/CPI2010.xls", sheetIndex = 1, stringsAsFactors=F)
  subset_data2010<-all_data[-c(1:3),c(2,3)]
  colnames(subset_data2010)<-c("Jurisdiction","CPI")
  subset_data2010[,1]<-sub(",","",subset_data2010[,1])
  write.csv(subset_data2010,"tmp/data/CPI2010.csv",quote=F,row.names=F)
  message("CPI data 2010 succesfully downloaded and saved in tmp/data/CPI2010.csv")
}, warning = function(cond) {
    message("CPI data 2010 caused a warning:")
    message(cond)
}, error = function(cond) {
    message("CPI data 2010 caused an error:")
    message(cond)
})
#For 1998:2009 
#The format of each page is stable enough for a function
#to extract the table from the page url
getCPITableFromWebPage<-function(url) {
  webpage<-html(url)
  #Trick there as countries/CPI may be shifted by one column
  col1<-html_text(html_nodes(webpage, "td:nth-child(1)"))
  col2<-html_text(html_nodes(webpage, "td:nth-child(2)"))
  col3<-html_text(html_nodes(webpage, "td:nth-child(3)"))
  #If what we get in second column is not numeric, columns must be shifted
  countries<-col1[which(regexpr("[0-9]+",col1)== -1)]
  to_shift<-which(regexpr("[0-9\\.]+",col2)== 1)
  col3[to_shift]<-col2[to_shift]
  col2[to_shift]<-countries
  #Some decimals are represented as ',' instead of '.'
  col3<-sub(",",".",col3)
  subset_data<-cbind(col2,as.numeric(col3))
  colnames(subset_data)<-c("Jurisdiction","CPI")
  subset_data
}

for (year in 1998:2009) {
    message(paste0("Downloading and extracting CPI data ",year))
        url<-paste("http://www.transparency.org/research/cpi/cpi_",year,sep="")
  filename<-paste0("tmp/data/CPI",year,".csv")
  data<-getCPITableFromWebPage(url)
  data[,1]<-sub(",","",data[,1])
  write.csv(data,filename,quote=c(1),row.names=F)
  message(paste0("CPI data ",year," succesfully downloaded and saved in tmp/data/CPI",year,".csv"))
}

##############################
#Merge all tables to have the CPI for each country (rows) over the years 1998-2014 (columns)

listFiles<-list()
for (year in 1998:2014) {
  data<-read.csv(paste0("tmp/data/CPI",year,".csv"),stringsAsFactor=F,header=T)
  listFiles<-c(listFiles,list(data))
}

countries<-c()
for (i in 1:length(listFiles)) countries<-c(countries,listFiles[[i]][,1])
countries<-sort(unique(countries))

for (i in 1:length(countries)) {
  if(!is.na(countrycode(countries[i],"country.name","iso2c"))) {
    countries[i] <- countrycode(countries[i],"country.name","iso2c")
  } else if (countries[i] == "Kosovo") {
    countries[i] <- "XK"
  } else if (countries[i] == "Kuweit") {
    countries[i] <- "KW"
  } else if (countries[i] == "Taijikistan") {
    countries[i] <- "TJ"
  } else if (countries[i] == "Yugoslavia") {
    countries[i] <- "RS"
  } else {
    print(countries[i])
  }
}
countries<-sort(unique(countries))

CPI.wide<-as.data.frame(countries)

#Scan each, and get the list of countries for that file
#Then take all unique names given to countries ver the years 1998-2014, and match CPI score accordingly
for (i in 1:length(listFiles)) {
  countries.i<-listFiles[[i]][,1]
  for (j in 1:length(countries.i)) {
    if(!is.na(countrycode(countries.i[j],"country.name","iso2c"))) {
      countries.i[j] <- countrycode(countries.i[j],"country.name","iso2c")
    } else if (countries.i[j] == "Kosovo") {
      countries.i[j] <- "XK"
    } else if (countries.i[j] == "Kuweit") {
      countries.i[j] <- "KW"
    } else if (countries.i[j] == "Taijikistan") {
      countries.i[j] <- "TJ"
    } else if (countries.i[j] == "Yugoslavia") {
      countries.i[j] <- "RS"
    } else {
      print(countries.i[j])
    }
  }
  tt<-which(countries.i==7)
  if (length(tt)>0) print(i)
  match.countries<-match(countries.i,CPI.wide[,1])
  CPI.wide<-cbind(CPI.wide,rep(NA,nrow(CPI.wide)))
  CPI.wide[match.countries,i+1]<-round(listFiles[[i]][,2],digits=2)
}


#Set column names, create long format and save
colnames(CPI.wide)<-c("country",1998:2014)
CPI.long <- melt(CPI.wide, id="country")
colnames(CPI.long) <- c("iso2c", "year", "value")

write.csv(CPI.wide,file="../data/corruption-perceptions-index-wide.csv",quote=c(1),row.names=F)
write.csv(CPI.long,file="../data/corruption-perceptions-index-long.csv",quote=c(1),row.names=F)
system("rm -r tmp && rm ../data/corruption-perceptions-index-wide.bak.csv && rm ../data/corruption-perceptions-index-long.bak.csv")






