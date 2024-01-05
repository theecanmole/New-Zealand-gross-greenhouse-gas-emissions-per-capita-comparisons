## From wikicommons page https://commons.wikimedia.org/wiki/File:Per_capita_greenhouse_gas_emissions.svg

## New Zealand gross greenhouse gas emissions per capita comparisons 1990 to 2021

January 2024 Our World in Data version data 1990 to 2021

New data source: Our World in Data

https://ourworldindata.org/grapher/per-capita-ghg-emissions?tab=chart&time=1990..2021&country=CHN~IND~OWID_WRL~NZL~GBR~OWID_EU27~OWID_AFR

# save GHG emissions for selected countries and years to a .csv file named "per-capita-ghg-emissions.csv"

# read into R as a dataframe
data <- read.csv("per-capita-ghg-emissions.csv") 

str(data) 
'data.frame':	35646 obs. of  4 variables:
 $ Entity                                                : chr  "Afghanistan" "Afghanistan" "Afghanistan" "Afghanistan" ...
 $ Code                                                  : chr  "AFG" "AFG" "AFG" "AFG" ...
 $ Year                                                  : int  1850 1851 1852 1853 1854 1855 1856 1857 1858 1859 ...
 $ Per.capita.greenhouse.gas.emissions.in.CO..equivalents: num  1.94 1.96 1.96 1.97 1.97 ... 

# rename per capita GHG emissions
colnames(data)[4] <- "emissions"
  
# select nz data
nz <- data[data[["Entity"]] == "New Zealand",4]
str(nz) 
num [1:172] 294 246 226 213 201 ... 

max(nz)
[1] 294.1872 
# that is much too high!

## the World in Data GHG emissions per capita for NZ look a bit odd. So I will use Stats NZ population and MfE gross GHG emissions data 

# obtain NZ population data in annual series which is sourced from Stats NZ
https://figure.nz/chart/MFMkVhvbhuVFbiWr 
# download file "Population_Estimated_population_by_year_ended_June_19372023.csv"
# read in to R
nzpop <- read.csv("Population_Estimated_population_by_year_ended_June_19372023.csv") 

#colnames(nzpop) <- c("date","number") 
str(nzpop) 
 'data.frame':	522 obs. of  9 variables:
 $ Year.ended.June         : int  1937 1937 1937 1937 1937 1937 1938 1938 1938 1938 ...
 $ Definition.of.population: chr  "Estimated de facto population" "Estimated de facto population" "Estimated de facto population" "Estimated de facto population" ...
 $ Measure                 : chr  "Estimated population" "Estimated population" "Estimated population" "Sex ratio" ...
 $ Unit                    : chr  "Male" "Female" "Total" "Ratio" ...
 $ Value                   : num  806000 781400 1587400 103 14600 ...
 $ Value.Unit              : chr  "number" "number" "number" "number" ...
 $ Value.Label             : chr  "Number of people" "Number of people" "Number of people" "Number of males per 100 females" ...
 $ Null.Reason             : chr  "" "" "" "" ...
 $ Metadata.1              : chr  "" "" "" "" ... 

# subset out the year and total population columns
nzpop2 <- nzpop[nzpop[["Unit"]] == "Total",c(1,5)]
str(nzpop2) 
'data.frame':	87 obs. of  2 variables:
 $ Year.ended.June: int  1937 1938 1939 1940 1941 1942 1943 1944 1945 1946 ...
 $ Value          : num  1587400 1604500 1626500 1636100 1629000 ... 
# rename columns
colnames(nzpop2) <- c("year","value")
# subset out rows for 1990 to 2021
nzpop3 <- nzpop2[54:85,]
str(nzpop3)
'data.frame':	32 obs. of  2 variables:
 $ year : int  1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 ...
 $ value: num  3329800 3495100 3531700 3572200 3620000 ... 

# get 2021 emissions from MfE inventory 1990 to 2021
crfsummarydatasector <- read.csv(file = "crfsummarydatasector.csv")
# add gross emissions in kilo tonnes
nzpop3$gross <- crfsummarydatasector[["Gross"]]
# calculate NZ specific per capita emissions in tonnes
nzpop3$percap <- nzpop3$gross / nzpop3[["value"]] * 1000

summary(nzpop3$percap) 
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  15.03   17.58   18.66   18.21   19.40   20.04 

# use NZ specific per capita emissions not World in Data values for NZ per capita emissions
nz <- nzpop3$percap
nz
 [1] 19.43662 18.79444 18.92431 18.67024 18.74564 18.61891 18.90449 19.40643
 [9] 18.65973 19.02831 19.40288 20.03757 19.67391 19.82206 19.49095 19.77604
[17] 19.54150 18.86295 18.62773 17.81418 17.77370 17.58808 17.94127 17.65606
[25] 17.53850 17.14691 16.31918 16.31033 16.07483 16.06479 15.19207 15.03034
length(nz) 
[1] 32 
uk <- data[data[["Entity"]] == "United Kingdom",4]
length(uk) 
[1] 172
# append 140 NAs to NZ so it will fir onto a 172 year dataframe
nzna <- rep(NA,140) 
nz2 <- append(nzna,nz)
str(nz2)
num [1:172] NA NA NA NA NA NA NA NA NA NA ... 
tail(nz2) 
[1] 16.31918 16.31033 16.07483 16.06479 15.19207 15.03034 

# select country and region emission per capita data only from 1990
africa <- data[data[["Entity"]] == "Africa",4]
uk <- data[data[["Entity"]] == "United Kingdom",4]
europe <- data[data[["Entity"]] == "Europe",4]
china <- data[data[["Entity"]] == "China",4]
india <- data[data[["Entity"]] == "India",4]
world <- data[data[["Entity"]] == "World",4]
# create a year vector
year <- 1850:2021
str(year) 
int [1:172] 1850 1851 1852 1853 1854 1855 1856 1857 1858 1859 ...
# create dataframe
data2 <- data.frame(year, nz2,africa,uk,europe,china,india,world)
str(data2) 
'data.frame':	172 obs. of  8 variables:
 $ year  : int  1850 1851 1852 1853 1854 1855 1856 1857 1858 1859 ...
 $ nz    : num  294 246 226 213 201 ...
 $ africa: num  2.3 2.53 2.66 2.76 2.8 ...
 $ uk    : num  6.98 6.61 6.49 6.42 7.41 ...
 $ europe: num  4.35 4.31 4.32 4.32 4.45 ...
 $ china : num  1.08 1.08 1.06 1.07 1.05 ...
 $ india : num  1.46 1.35 1.3 1.26 1.24 ...
 $ world : num  3.13 3.2 3.24 3.3 3.35 .. 

# subset only 1990 to 2021 rows
data3 <- data2[141:172,] 
str(data3) 
'data.frame':	32 obs. of  8 variables:
 $ year  : int  1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 ...
 $ nz2   : num  19.4 18.8 18.9 18.7 18.7 ...
 $ africa: num  4.59 4.59 4.58 4.61 4.67 ...
 $ uk    : num  13.9 14 13.4 13 12.8 ...
 $ europe: num  14.1 13.6 12.4 11.9 11.2 ...
 $ china : num  3.77 3.72 3.77 3.88 4.04 ...
 $ india : num  1.76 1.77 1.8 1.78 1.78 ...
 $ world : num  7.12 7.06 6.86 6.79 6.81 ... 

 
# create chart of only NZ per capita greenhouse gas emissions
svg(filename="NZ-Per-capita-greenhouse-gas-emissions.svg", width = 8, height = 6, pointsize = 12, onefile = FALSE, family = "sans", bg = "white", antialias = c("default", "none", "gray", "subpixel"))
par(mar=c(2.7,2.7,1,1)+0.1)
plot(data3[["year"]],data3[["nz2"]], ylim=c(0,23), tck=0.01,axes=FALSE,ann=FALSE, type="l",las=1,col='1')
axis(side=1, tck=0.01, las=0,tick=TRUE)
axis(side=2, tck=0.01, las=1, at = NULL, labels = TRUE, tick = TRUE)
axis(side=3, tck=0.01, las=0,at = NULL, labels = FALSE, tick=TRUE)
axis(side=4, tck=0.01, at = NULL, labels = FALSE, tick = TRUE)
box()
grid()
points(data3$year,data3$nz2,col=1 ,pch=19)
text(2021,19,"New Zealand",cex=1.2,adj=1,col=1)
mtext(side=1,cex=0.8,line=-1.1,"Data: Our World in Data https://ourworldindata.org/grapher/per-capita-ghg-emissions")
mtext(side=3,cex=1.4, line=-3,expression(paste("New Zealand per capita greenhouse gas emissions 1990 - 2021")) )
mtext(side=2,cex=1, line=-1.35,expression(paste("tonnes of greenhouse gas in C", O[2], " equivalent")))
dev.off() 


# load colours library
library(RColorBrewer)
# select six colours from 'Dark2' quantative palette
brewer.pal(6, name="Dark2")
[1] "#1B9E77" Mountain Meadow(dull green) "#D95F02" Bamboo(brown) "#7570B3" Deluge(blue?) "#E7298A" Cerise(pink) "#66A61E" Vida Loca(olive green) "#E6AB02" Corn(mustard) 
# eyeball the colours
display.brewer.pal(6, name="Dark2")

# create the NZ and country comparisons chart 1990 to 2021
svg(filename="Per-capita-greenhouse-gas-emissions-2021.svg", width = 8, height = 6, pointsize = 12, onefile = FALSE, family = "sans", bg = "white", antialias = c("default", "none", "gray", "subpixel"))
par(mar=c(2.7,2.7,1,1)+0.1)
plot(data3$year,data3$nz2,ylim=c(0,25), xlim=c(1989.5,2021),tck=0.01,axes=FALSE,ann=FALSE, type="n",las=1)
axis(side=1, tck=0.01, las=0,tick=TRUE)
axis(side=2, tck=0.01, las=1, at = NULL, labels = TRUE, tick = TRUE)
axis(side=3, tck=0.01, las=0,at = NULL, labels = FALSE, tick=TRUE)
axis(side=4, tck=0.01, at = NULL, labels = FALSE, tick = TRUE)
box()
grid()
points(data3$year,data3$nz2,col=1 ,pch=19)
lines(data3$year,data3$nz2,col=1,lwd=1,lty=1)
lines(data3$year,data3$uk,col="#1b9e77",lwd=2)
points(data3$year,data3$uk,col="#1b9e77",pch=15)
lines(data3$year,data3$europe,col="#d95f02",lwd=2)
points(data3$year,data3$europe,col="#d95f02",pch=16)
lines(data3$year,data3$china,col="#7570b3",lwd=2)
points(data3$year,data3$china,col="#7570b3",pch=17)
lines(data3$year,data3$world,col="#e7298a",lwd=2)
points(data3$year,data3$world,col="#e7298a",pch=18)
lines(data3$year,data3$india,col="#66a61e",lwd=2)
points(data3$year,data3$india,col="#66a61e",pch=25,bg="#66a61e")
lines(data3$year,data3$africa,col="#e6ab02",lwd=2)
points(data3$year,data3$africa,col="#e6ab02",pch=20,cex=1.2)
text(2021,18,"New Zealand",cex=1.2,adj=1,col=1)
text(1990,15,"United Kingdom",cex=1.2,adj=0,col=1)
text(1990,11,"Europe",cex=1.2,adj=0,col=1)
text(1990,8,"World Average",cex=1.2,adj=0,col=1)
text(2021,10.5,"China",cex=1.2,adj=1,col=1)
text(2021,4.5,"Africa",cex=1.2,adj=1,col=1)
text(2021,1.5,"India",cex=1.2,adj=1,col=1)
mtext(side=1,cex=0.8,line=-1.1,"Data: Our World in Data https://ourworldindata.org/grapher/per-capita-ghg-emissions")
mtext(side=3,cex=1.4, line=-3.9,expression(paste("New Zealand per capita greenhouse gas emissions comparisons \n1990 - 2021")) )
mtext(side=2,cex=1, line=-1.35,expression(paste("tonnes of greenhouse gas in C", O[2], " equivalent")))
dev.off()
                    


## April 2022 chart with World Resources Institute CAIT data 1990 to 2018

The earlier version of this chart was created from data from World Resources Institute and uploaded to wikimedia commons on 9 April 2022.

#CAIT Climate Data Explorer. 2015. Washington, DC: World Resources Institute. 
#Available online at: http://cait.wri.org.  Please Note: CAIT data are derived from several sources. 
#Full citations are available at http://cait.wri.org/faq.html#q07. 
#Any use of the Land-Use Change and Forestry or Agriculture indicator should be cited as FAO 2014, FAOSTAT Emissions Database. 
#Any use of CO2 emissions from fuel combustion data should be cited as CO2 Emissions from Fuel Combustion, ©OECD/IEA, 2014.
#An example citation: WRI, CAIT. 2014. Climate Analysis Indicators Tool: WRI’s Climate Data Explorer. Washington, DC: World Resources Institute. Available at: http://cait2.wri.org.

# recreate dataframe of emissions data from WRI CAIT
percapdata <- structure(list(year = c(1990, 1991, 1992, 1993, 1994, 1995, 1996, 
1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 
2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018
), af = c(4.53, 4.48, 4.41, 4.33, 4.36, 4.29, 4.18, 4.13, 4.14, 
3.99, 3.86, 3.86, 3.86, 3.89, 3.85, 3.86, 3.75, 3.75, 3.74, 3.6, 
3.63, 3.79, 3.75, 3.71, 3.65, 3.58, 3.59, 3.52, 3.45), aus = c(32.71, 
32.29, 32.03, 31.7, 31.53, 31.61, 31.18, 31.45, 32.5, 34.01, 
34.56, 34.29, 33.62, 29.34, 31.57, 29.34, 31.25, 31.04, 29.04, 
29.22, 27.29, 28.86, 28.29, 24.01, 24.12, 23.79, 23.87, 25.33, 
24.79), china = c(2.53, 2.63, 2.71, 2.87, 2.96, 3.25, 3.25, 3.22, 
3.3, 3.24, 3.37, 3.51, 3.72, 4.18, 4.73, 5.26, 5.76, 6.2, 6.38, 
6.8, 7.38, 7.71, 7.91, 8.21, 8.18, 8.13, 8.13, 8.23, 8.4), eu = c(10.18, 
9.96, 9.59, 9.39, 9.33, 9.43, 9.67, 9.47, 9.36, 9.18, 9.16, 9.17, 
9.1, 9.27, 9.23, 9.12, 9.08, 8.97, 8.73, 8.09, 8.26, 7.43, 7.28, 
7.09, 6.74, 6.85, 7.61, 7.63, 7.46), india = c(1.16, 1.19, 1.21, 
1.22, 1.24, 1.29, 1.31, 1.35, 1.36, 1.41, 1.42, 1.63, 1.62, 1.64, 
1.69, 1.72, 1.78, 1.88, 1.93, 2.03, 2.09, 2.09, 2.18, 2.2, 2.31, 
2.29, 2.32, 2.39, 2.47), nz = c(13.57, 12.77, 12.88, 12.47, 12.79, 
12.95, 12.89, 13.33, 12.81, 13.34, 13.3, 14.7, 14.84, 15.15, 
14.6, 14.8, 14.68, 14.24, 14.12, 13.33, 13.13, 14.3, 14.74, 14.53, 
14.4, 14.1, 14.81, 14.84, 14.43), uk = c(13.04, 13.26, 12.84, 
12.52, 12.3, 12.11, 12.42, 12.02, 11.92, 11.44, 11.44, 11.58, 
11.23, 11.31, 11.17, 10.99, 10.86, 10.53, 10.12, 9.16, 9.3, 8.55, 
8.83, 8.48, 7.78, 7.48, 7.08, 6.82, 6.64), world = c(6.06, 6.05, 
5.81, 5.76, 5.71, 5.75, 5.8, 5.74, 5.64, 5.62, 5.64, 5.6, 5.64, 
5.81, 5.96, 6.07, 6.16, 6.23, 6.27, 6.13, 6.33, 6.43, 6.45, 6.44, 
6.45, 6.36, 6.34, 6.35, 6.4)), class = "data.frame", row.names = c(NA, 
-29L))

# check the data
str(percapdata)
'data.frame':	29 obs. of  9 variables:
 $ year : num  1990 1991 1992 1993 1994 ...
 $ af   : num  4.53 4.48 4.41 4.33 4.36 4.29 4.18 4.13 4.14 3.99 ...
 $ aus  : num  32.7 32.3 32 31.7 31.5 ...
 $ china: num  2.53 2.63 2.71 2.87 2.96 3.25 3.25 3.22 3.3 3.24 ...
 $ eu   : num  10.18 9.96 9.59 9.39 9.33 ...
 $ india: num  1.16 1.19 1.21 1.22 1.24 1.29 1.31 1.35 1.36 1.41 ...
 $ nz   : num  13.6 12.8 12.9 12.5 12.8 ...
 $ uk   : num  13 13.3 12.8 12.5 12.3 ...
 $ world: num  6.06 6.05 5.81 5.76 5.71 5.75 5.8 5.74 5.64 5.62 ...  

# save the data to a .csv file
write.csv(percapdata, file = "PerCapData-GHG.csv", quote = TRUE, eol = "\n", na = "NA",row.names = FALSE, fileEncoding = "")  
 
# create the chart
svg(filename="Per capita greenhouse gas emissions.svg", width = 8, height = 6, pointsize = 12, onefile = FALSE, family = "sans", bg = "white", antialias = c("default", "none", "gray", "subpixel"))
par(mar=c(2.7,2.7,1,1)+0.1)
plot(percapdata$year,percapdata$nz,ylim=c(0,20), xlim=c(1989.5,2018),tck=0.01,axes=FALSE,ann=FALSE, type="n",las=1)
axis(side=1, tck=0.01, las=0,tick=TRUE)
axis(side=2, tck=0.01, las=1, at = NULL, labels = TRUE, tick = TRUE)
axis(side=3, tck=0.01, las=0,at = NULL, labels = FALSE, tick=TRUE)
axis(side=4, tck=0.01, at = NULL, labels = FALSE, tick = TRUE)
box()
grid()
lines(percapdata$year,percapdata$nz,col=1,lwd=2,lty=1)
lines(percapdata$year,percapdata$uk,col="#1b9e77",lwd=2)
points(percapdata$year,percapdata$uk,col="#1b9e77",pch=15)
lines(percapdata$year,percapdata$eu,col="#d95f02",lwd=2)
points(percapdata$year,percapdata$eu,col="#d95f02",pch=16)
lines(percapdata$year,percapdata$china,col="#7570b3",lwd=2)
points(percapdata$year,percapdata$china,col="#7570b3",pch=17)
lines(percapdata$year,percapdata$world,col="#e7298a",lwd=2)
points(percapdata$year,percapdata$world,col="#e7298a",pch=18)
lines(percapdata$year,percapdata$india,col="#66a61e",lwd=2)
points(percapdata$year,percapdata$india,col="#66a61e",pch=25,bg="#66a61e")
lines(percapdata$year,percapdata$af,col="#e6ab02",lwd=2)
points(percapdata$year,percapdata$af,col="#e6ab02",pch=20,cex=1.2)
text(2010,16,"New Zealand",cex=1.2,adj=0,col=1)
text(1990,14,"United Kingdom",cex=1.2,adj=0,col=1)
text(1990,11,"Europe",cex=1.2,adj=0,col=1)
text(1990,6.5,"World Average",cex=1.2,adj=0,col=1)
text(1990,3.4,"China",cex=1.2,adj=0,col=1)
text(2010,3,"Africa",cex=1.2,adj=0,col=1)
text(2010,1,"India",cex=1.2,adj=0,col=1)
mtext(side=1,cex=0.8,line=-1.1,"Data: WRI, Washington DC, Historical GHG Emissions, 2022. https://www.climatewatchdata.org")
mtext(side=3,cex=1.4, line=-3.9,expression(paste("New Zealand Per Capita Greenhouse \nGas Emissions Compared 1990 - 2018")) )
mtext(side=2,cex=1, line=-1.35,expression(paste("tonnes of greenhouse gas in C", O[2], " equivalent")))
dev.off()

# the WRI CAIT data was downloaded as country vectors then combined into a dataframe
wripercap<-data.frame(cbind(year,nzg,ukg,eug,wg,cg,ig,afg),row.names = year,check.names = TRUE)
dim(wripercap) 
[1] 23  8
str(wripercap) 
'data.frame':	23 obs. of  8 variables:
 $ year: num  1990 1991 1992 1993 1994 ...
 $ nzg : num  19.6 18.5 18.6 18.2 18.5 ...
 $ ukg : num  12.9 13 12.6 12.2 12 ...
 $ eug : num  12.8 12.5 12.3 11.6 11.1 ...
 $ wg  : num  5.76 5.71 5.61 5.55 5.5 ...
 $ cg  : num  2.93 3.01 3.1 3.26 3.36 ...
 $ ig  : num  1.43 1.46 1.48 1.48 1.51 ...
 $ afg : num  2.55 2.52 2.49 2.55 2.51 ...
 
write.csv(wripercap, file = "PerCap-ghg-nz-world.csv", quote = TRUE, eol = "\n", na = "NA",row.names = FALSE, fileEncoding = "") 

## older 2012 or 2014 version of chart of WRI CAIT data

#colour scheme
#http://colorbrewer2.org/?type=qualitative&scheme=Dark2&n=6
#['#1b9e77','#d95f02','#7570b3','#e7298a','#66a61e','#e6ab02']

svg(filename="NZ-percapita-GHG-1990-2014v1.svg", width = 8, height = 6, pointsize = 14, onefile = FALSE, family = "sans", bg = "white", antialias = c("default", "none", "gray", "subpixel"))
par(mar=c(2.7,2.7,1,1)+0.1)
plot(year,nzg,ylim=c(0,23), xlim=c(1989.5,2012),tck=0.01,axes=FALSE,ann=FALSE, type="n",las=1)
axis(side=1, tck=0.01, las=0,tick=TRUE)
axis(side=2, tck=0.01, las=1, at = NULL, labels = TRUE, tick = TRUE)
axis(side=3, tck=0.01, las=0,at = NULL, labels = FALSE, tick=TRUE)
axis(side=4, tck=0.01, at = NULL, labels = FALSE, tick = TRUE)
box()
grid()
lines(year,nzg,col=1,lwd=3,lty=1)
#points(year,nzg,col=1,pch=19)
lines(year,ukg,col="#1b9e77",lwd=2)
points(year,ukg,col="#1b9e77",pch=15)
lines(year,eug,col="#d95f02",lwd=2)
points(year,eug,col="#d95f02",pch=16)
lines(year,cg,col="#7570b3",lwd=2)
points(year,cg,col="#7570b3",pch=17)
lines(year,wg,col="#e7298a",lwd=2)
points(year,wg,col="#e7298a",pch=18)
lines(year,ig,col="#66a61e",lwd=2)
points(year,ig,col="#66a61e",pch=25,bg="#66a61e")
lines(year,afg,col="#e6ab02",lwd=2)
points(year,afg,col="#e6ab02",pch=19)
text(1990,17.5,"New Zealand",cex=1.2,adj=0,col=1)
text(1990,14,"United Kingdom",cex=1.2,adj=0,col=1)
text(1990,11,"Europe",cex=1.2,adj=0,col=1)
text(1990,6.5,"World Average",cex=1.2,adj=0,col=1)
text(1990,4,"China",cex=1.2,adj=0,col=1)
text(2010,3.5,"Africa",cex=1.2,adj=0,col=1)
text(2010,1.4,"India",cex=1.2,adj=0,col=1)
mtext(side=1,cex=0.8,line=-1.1,"Data: WRI, CAIT. 2014. Climate Analysis Indicators Tool \nWRI’s Climate Data Explorer Washington DC http://cait2.wri.org")
mtext(side=3,cex=1.7, line=-3.9,expression(paste("New Zealand Per Capita Greenhouse \nGas Emissions 1990 - 2012")) )
mtext(side=2,cex=1, line=-1.35,expression(paste("tonnes of greenhouse gas in C", O[2], " equivalent")))
dev.off()

# png format chart
png("popNZ-percapita-GHG-1990-2014v1.png", bg="white", width=800, height=600,pointsize = 16)
par(mar=c(2.7,2.7,1,1)+0.1)
plot(year,nzg,ylim=c(0,23), xlim=c(1989.5,2012),tck=0.01,axes=FALSE,ann=FALSE, type="n",las=1)
axis(side=1, tck=0.01, las=0,tick=TRUE)
axis(side=2, tck=0.01, las=1, at = NULL, labels = TRUE, tick = TRUE)
axis(side=3, tck=0.01, las=0,at = NULL, labels = FALSE, tick=TRUE)
axis(side=4, tck=0.01, at = NULL, labels = FALSE, tick = TRUE)
box()
grid()
lines(year,nzg,col=1,lwd=1,lty=1)
points(year,nzg,col=1,pch=16)
lines(year,ukg,col="#1b9e77",lwd=2)
points(year,ukg,col="#1b9e77",pch=15)
lines(year,eug,col="#d95f02",lwd=2)
points(year,eug,col="#d95f02",pch=16)
lines(year,cg,col="#7570b3",lwd=2)
points(year,cg,col="#7570b3",pch=17)
lines(year,wg,col="#e7298a",lwd=2)
points(year,wg,col="#e7298a",pch=18)
lines(year,ig,col="#66a61e",lwd=2)
points(year,ig,col="#66a61e",pch=25,bg="#66a61e")
lines(year,afg,col="#e6ab02",lwd=2)
points(year,afg,col="#e6ab02",pch=19)
text(1990,17.5,"New Zealand",cex=1.2,adj=0,col=1)
text(1990,14,"United Kingdom",cex=1.2,adj=0,col=1)
text(1990,11,"Europe",cex=1.2,adj=0,col=1)
text(1990,6.5,"World Average",cex=1.2,adj=0,col=1)
text(1990,4,"China",cex=1.2,adj=0,col=1)
text(2010,3.5,"Africa",cex=1.2,adj=0,col=1)
text(2010,1.4,"India",cex=1.2,adj=0,col=1)
mtext(side=1,cex=0.9,line=-1.2,"Data: WRI, CAIT. 2014. Climate Analysis Indicators Tool \nWRI’s Climate Data Explorer Washington DC http://cait2.wri.org")
mtext(side=3,cex=1.7, line=-3.25,expression(paste("NZ Per Capita Greenhouse Gas Emissions 1990 - 2012")) )
mtext(side=2,cex=1, line=-1.35,expression(paste("tonnes of greenhouse gas in C", O[2], " equivalent")))
dev.off()

# smaller png format chart
png("popNZ-percapita-GHG-1990-2014v2.png", bg="white", width=800, height=600,pointsize = 16)
par(mar=c(2.7,2.7,1,1)+0.1)
plot(year,nzg,ylim=c(0,20), xlim=c(1989.5,2012),tck=0.01,axes=FALSE,ann=FALSE, type="n",las=1)
axis(side=1, tck=0.01, las=0,tick=TRUE)
axis(side=2, tck=0.01, las=1, at = NULL, labels = TRUE, tick = TRUE)
axis(side=3, tck=0.01, las=0,at = NULL, labels = FALSE, tick=TRUE)
axis(side=4, tck=0.01, at = NULL, labels = FALSE, tick = TRUE)
box()
grid()
lines(year,nzg,col=1,lwd=3,lty=1)
#points(year,nzg,col=1,pch=19)
lines(year,ukg,col="#1b9e77",lwd=2)
points(year,ukg,col="#1b9e77",pch=15)
lines(year,eug,col="#d95f02",lwd=2)
points(year,eug,col="#d95f02",pch=16)
lines(year,cg,col="#7570b3",lwd=2)
points(year,cg,col="#7570b3",pch=17)
lines(year,wg,col="#e7298a",lwd=2)
points(year,wg,col="#e7298a",pch=18)
lines(year,ig,col="#66a61e",lwd=2)
points(year,ig,col="#66a61e",pch=19)
lines(year,afg,col="#e6ab02",lwd=2)
points(year,afg,col="#e6ab02",pch=20)
text(1990,17.5,"New Zealand",cex=1.2,adj=0,col=1)
text(1990,14,"United Kingdom",cex=1.2,adj=0,col=1)
text(1990,11,"Europe",cex=1.2,adj=0,col=1)
text(1990,6.5,"World Average",cex=1.2,adj=0,col=1)
text(1990,4,"China",cex=1.2,adj=0,col=1)
text(2010,3.5,"Africa",cex=1.2,adj=0,col=1)
text(2010,1.4,"India",cex=1.2,adj=0,col=1)
mtext(side=1,cex=0.9,line=-1.2,"Data: WRI, CAIT. 2014. Climate Analysis Indicators Tool \nWRI’s Climate Data Explorer Washington DC http://cait2.wri.org")
#mtext(side=3,cex=1.7, line=-3.25,expression(paste("NZ Per Capita Greenhouse Gas Emissions 1990 - 2012")) )
mtext(side=2,cex=1, line=-1.35,expression(paste("tonnes of greenhouse gas in C", O[2], " equivalent")))
dev.off()
