...## NZ Aluminium free industrial allocation of emissions units from 2010

# Industry final allocations to 2022
https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Reports/Industrial-Allocations/Industrial-Allocations-Final-Decisions_2022.xlsx

# Industry final allocations to 2020
https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Reports/Industrial-Allocations/Industrial-Allocations-Final-Decisions.xlsx

# Industry final allocations to 2019
https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Images/Industrial-Allocations-Final-Decisions.xlsx 

# load packages 
library(readxl)
library(dplyr)
#library(RColorBrewer)
#library(tidyr)

# check the working directory and set if necessary
setwd("/home/user/r/eur/2010t02018")
getwd()
[1] "/home/user/r/eur/2010to2018"

# obtain latest emission unit allocation to industry data from EPA

download.file("https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Reports/Industrial-Allocations/Industrial-Allocations-Final-Decisions_2022.xlsx", "Industrial-Allocations-Final-Decisions.xlsx") 
# downloaded 212 bytes
url= c("https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Reports/Industrial-Allocations/Industrial-Allocations-Final-Decisions_2022.xlsx")
filename = c("Industrial-Allocations-Final-Decisions.xlsx") 
str(url)
chr "https://www.epa.govt.nz/assets...."
str(filename) 
chr "Industrial-Allocations-Final-Decisions.xlsx"
# try download again
download.file(url,filename)
trying URL 'https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Reports/Industrial-Allocations/Industrial-Allocations-Final-Decisions_2022.xlsx'
Content type 'text/html' length 212 bytes
==================================================
downloaded 212 bytes xcel 
# I manually downloaded Final Decisions 2022 excel sheet and copied it to the working folder
rm(filename,url) 
ls() 
character(0)
# check how many worksheets
excel_sheets("Industrial-Allocations-Final-Decisions_2022.xlsx")
[1] "IA Final Decisions"

Allocations <- read_excel("Industrial-Allocations-Final-Decisions_2022.xlsx", sheet = "IA Final Decisions",skip=3)

# I will check the consistency of column/variable names
str(Allocations)
tibble [1,377 × 4] (S3: tbl_df/tbl/data.frame)
 $ Activity        : chr [1:1377] "Aluminium smelting" "Burnt lime" "Burnt lime" "Burnt lime" ...
 $ Applicant’s name: chr [1:1377] "New Zealand Aluminium Smelters Limited" "Graymont (NZ) Limited" "Holcim (New Zealand) Limited" "Perry Resources (2008) Ltd" ...
 $ Year            : num [1:1377] 2010 2010 2010 2010 2010 2010 2010 2010 2010 2010 ...
 $ Final Allocation: num [1:1377] 210421 47144 3653 4712 948 ...

# revise and shorten column names
colnames(Allocations) <- c("Activity", "Applicant", "Year", "Units")

# what is most recent year? 
max(Allocations[["Year"]])
[1] 2022

# filter by year

head(filter(Allocations, Year == "2010" ))
# A tibble: 6 x 4
  Activity           Applicant                                 Year Allocation
  <chr>              <chr>                                    <dbl>      <dbl>
1 Aluminium smelting New Zealand Aluminium Smelters Limited    2010     210421
2 Burnt lime         Graymont (NZ) Limited                     2010      47144
3 Burnt lime         Holcim (New Zealand) Limited              2010       3653
4 Burnt lime         Perry Resources (2008) Ltd                2010       4712
5 Burnt lime         Websters Hydrated Lime Company Limited    2010        948

# separate data into years
nzu2010 <- filter(Allocations, Year =="2010")
nzu2011 <- filter(Allocations, Year =="2011")
nzu2012 <- filter(Allocations, Year =="2012")
nzu2013 <- filter(Allocations, Year =="2013")
nzu2014 <- filter(Allocations, Year =="2014")
nzu2015 <- filter(Allocations, Year =="2015")
nzu2016 <- filter(Allocations, Year =="2016")
nzu2017 <- filter(Allocations, Year =="2017")
nzu2018 <- filter(Allocations, Year =="2018")
nzu2019 <- filter(Allocations, Year =="2019") 
nzu2020 <- filter(Allocations, Year =="2020")  
nzu2021 <- filter(Allocations, Year =="2021")  
nzu2022 <- filter(Allocations, Year =="2022")  

# check just the 2010 data
str(nzu2010)
tibble [141 × 4] (S3: tbl_df/tbl/data.frame)
 $ Activity : chr [1:141] "Aluminium smelting" "Burnt lime" "Burnt lime" "Burnt lime" ...
 $ Applicant: chr [1:141] "New Zealand Aluminium Smelters Limited" "Graymont (NZ) Limited" "Holcim (New Zealand) Limited" "Perry Resources (2008) Ltd" ...
 $ Year     : num [1:141] 2010 2010 2010 2010 2010 2010 2010 2010 2010 2010 ...
 $ Units    : num [1:141] 210421 47144 3653 4712 948 ...
 
# Each year, from May, the EPA makes a 'provisional' allocation of emssion units to selected industries. see https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/ I want to estimate the market value of free allocation of units. I understand that the deadline for a provisional allocation is 30 April of each year so I assume the transfer of allocation is made in May of each year. 
# There is an online 'open data' Github repository of New Zealand Unit (NZU) prices going back to May 2010. https://github.com/theecanmole/nzu, the NZU repository has it's own citation and DOI: Theecanmole. (2016). New Zealand emission unit (NZU) monthly prices 2010 to 2016: V1.0.01 [Data set]. Zenodo. http://doi.org/10.5281/zenodo.221328
# Add a NZU market price value at the May average price for each year

nzu2010[["Mayunitprice"]] <- 17.58
nzu2011[["Mayunitprice"]] <- 19.84
nzu2012[["Mayunitprice"]] <- 6.23
nzu2013[["Mayunitprice"]] <- 1.94
nzu2014[["Mayunitprice"]] <- 4.08
nzu2015[["Mayunitprice"]] <- 5.34
nzu2016[["Mayunitprice"]] <- 14.63
nzu2017[["Mayunitprice"]] <- 16.96
nzu2018[["Mayunitprice"]] <- 21.28
nzu2019[["Mayunitprice"]] <- 25.29 
nzu2020[["Mayunitprice"]] <- 24.84
nzu2021[["Mayunitprice"]] <- 37.14
nzu2022[["Mayunitprice"]] <- 76.55

#nzu2010[["Mayunitprice"]] <- nzu2010[["Allocation"]]*17.58
#nzu2011[["Mayunitprice"]] <- nzu2011[["Allocation"]]*19.84
#nzu2012[["Mayunitprice"]] <- nzu2012[["Allocation"]]*6.23
#nzu2013[["Mayunitprice"]] <- nzu2013[["Allocation"]]*1.94
#nzu2014[["Mayunitprice"]] <- nzu2014[["Allocation"]]*4.08
#nzu2015[["Mayunitprice"]] <- nzu2015[["Allocation"]]*5.34
#nzu2016[["Mayunitprice"]] <- nzu2016[["Allocation"]]*14.63
#nzu2017[["Mayunitprice"]] <- nzu2017[["Allocation"]]*16.96
#nzu2018[["Mayunitprice"]] <- nzu2018[["Allocation"]]*21.28
#nzu2019[["Mayunitprice"]] <- nzu2019[["Allocation"]]*25.29 
#nzu2020[["Mayunitprice"]] <- nzu2020[["Allocation"]]*24.84
#nzu2021[["Mayunitprice"]] <- nzu2021[["Allocation"]]*37.14
#nzu2022[["Mayunitprice"]] <- nzu2022[["Allocation"]]*76.55

# combine all year data together into 1 dataframe - I use rbind as all the column names are consistent
Allocations <- rbind(nzu2010,nzu2011,nzu2012,nzu2013,nzu2014,nzu2015,nzu2016,nzu2017,nzu2018,nzu2019,nzu2020,nzu2021,nzu2022)

# check the new dataframe
str(Allocations)

# put the market value of each allocation based on May unit prices into the dataframe
Allocations$Unitvalue = Allocations[["Units"]]*Allocations[["Mayunitprice"]]

summary(Allocations$Unitvalue) 

# Create a .csv formatted data file
write.csv(Allocations, file = "Allocations.csv", row.names = FALSE)

# read my csv data file back into R if needed
Allocations <- read.csv("Allocations.csv")  

# Create a Windows Excel 2007/10 formatted data file (if needed)
write.csv(Allocations, file = "Allocations.xls", row.names = FALSE, fileEncoding = "UTF-16LE") 

str(Allocations)
tibble [1,377 × 6] (S3: tbl_df/tbl/data.frame)
 $ Activity    : chr [1:1377] "Aluminium smelting" "Burnt lime" "Burnt lime" "Burnt lime" ...
 $ Applicant   : chr [1:1377] "New Zealand Aluminium Smelters Limited" "Graymont (NZ) Limited" "Holcim (New Zealand) Limited" "Perry Resources (2008) Ltd" ...
 $ Year        : num [1:1377] 2010 2010 2010 2010 2010 2010 2010 2010 2010 2010 ...
 $ Units       : num [1:1377] 210421 47144 3653 4712 948 ...
 $ Mayunitprice: num [1:1377] 17.6 17.6 17.6 17.6 17.6 ...
 $ Unitvalue   : num [1:1377] 3699201 828792 64220 82837 16666 ...

# look at summary of allocations dataframe
summary(Allocations)
   Activity          Applicant              Year          Units        
 Length:1377        Length:1377        Min.   :2010   Min.   :      1  
 Class :character   Class :character   1st Qu.:2012   1st Qu.:    195  
 Mode  :character   Mode  :character   Median :2015   Median :   1182  
                                       Mean   :2015   Mean   :  49195  
                                       3rd Qu.:2018   3rd Qu.:   8079  
                                       Max.   :2022   Max.   :2145482  
  Mayunitprice     Unitvalue        
 Min.   : 1.94   Min.   :        4  
 1st Qu.: 5.34   1st Qu.:     2083  
 Median :17.58   Median :    15673  
 Mean   :19.00   Mean   :  1154879  
 3rd Qu.:21.28   3rd Qu.:   139015  
 Max.   :76.55   Max.   :146249005 
 
# How many emission units were given to  New Zealand Aluminium Smelters Limited? Filter the data for their allocation. Create a dataframe.
nzal <- filter(Allocations, Applicant =="New Zealand Aluminium Smelters Limited") 

# what does that dataframe that look like?
str(nzal) 
tibble [13 × 6] (S3: tbl_df/tbl/data.frame)
 $ Activity    : chr [1:13] "Aluminium smelting" "Aluminium smelting" "Aluminium smelting" "Aluminium smelting" ...
 $ Applicant   : chr [1:13] "New Zealand Aluminium Smelters Limited" "New Zealand Aluminium Smelters Limited" "New Zealand Aluminium Smelters Limited" "New Zealand Aluminium Smelters Limited" ...
 $ Year        : num [1:13] 2010 2011 2012 2013 2014 ...
 $ Units       : num [1:13] 210421 437681 301244 1524172 755987 ...
 $ Mayunitprice: num [1:13] 17.58 19.84 6.23 1.94 4.08 ...
 $ Unitvalue   : num [1:13] 3699201 8683591 1876750 2956894 3084427 ...

# filter out redundant columns to leave year allocation May price and value
nzal <- select(nzal, -Activity, -Applicant)

# what is the most recent year of Final allocation? It is 2022. 
tail(nzal)
# A tibble: 6 × 4
   Year   Units Mayunitprice Unitvalue
  <dbl>   <dbl>        <dbl>     <dbl>
1  2017 1038914         17.0 17619981.
2  2018 1324556         21.3 28186552.
3  2019 1697437         25.3 42928182.
4  2020 1558268         24.8 38707377.
5  2021  628561         37.1 23344756.
6  2022  605320         76.6 46337246 

nzal
# A tibble: 13 × 4
    Year   Units Mayunitprice Unitvalue
   <dbl>   <dbl>        <dbl>     <dbl>
 1  2010  210421        17.6   3699201.
 2  2011  437681        19.8   8683591.
 3  2012  301244         6.23  1876750.
 4  2013 1524172         1.94  2956894.
 5  2014  755987         4.08  3084427.
 6  2015  772706         5.34  4126250.
 7  2016  786306        14.6  11503657.
 8  2017 1038914        17.0  17619981.
 9  2018 1324556        21.3  28186552.
10  2019 1697437        25.3  42928182.
11  2020 1558268        24.8  38707377.
12  2021  628561        37.1  23344756.
13  2022  605320        76.6  46337246 

# How to estimate the 2021 provisional allocation that was probably processed by EPA in May 2021. That is based on prior year 2020 actual production see https://www.legislation.govt.nz/act/public/2002/0040/latest/DLM1662643.html Section 81(1) of the Climate Change Response Act 2002. Obtain 2020 final allocation of units and divide by final Allocation Baseline (see Regulation 7 of the Climate Change (Eligible Industrial Activities) Regulations 2010 https://www.legislation.govt.nz/regulation/public/2010/0189/latest/DLM3075118.html) = 2020 actual production
1558268 / 5.194 
[1]  300013.1 tonnes

#What is 2021 provisional allocation? It is 2020 production * provisional AB (5.130) Multiply 2020 actual production by final allocation baseline from Regulation 7.
300013.1 * 5.130
[1] 1539067

# what is the market value of the 2021 provisional allocation assuming a mid May 2021 carbon price 37.14 per tonne
1539067 * 37.14
[1] 57160948 

ls()

# add provisional 2021 allocation to data frame 'nzal'
#nzal <- rbind (nzal,c(2021,1539067,57160948))

# check the dataframe
str(nzal) 
tibble [13 × 4] (S3: tbl_df/tbl/data.frame)
 $ Year        : num [1:13] 2010 2011 2012 2013 2014 ...
 $ Units       : num [1:13] 210421 437681 301244 1524172 755987 ...
 $ Mayunitprice: num [1:13] 17.58 19.84 6.23 1.94 4.08 ...
 $ Unitvalue   : num [1:13] 3699201 8683591 1876750 2956894 3084427 ...
 
# Create .csv formatted data file
write.csv(nzal, file = "nzal.csv", row.names = FALSE)

# read my csv data file back into R
nzal <- read.csv("nzal.csv") 
# add 'Final' allocation baseline factor
nzal$Baseline <- baselines[1:13] 
str(nzal)
'data.frame':	13 obs. of  5 variables:
 $ Year        : int  2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 ...
 $ Units       : int  210421 437681 301244 1524172 755987 772706 786306 1038914 1324556 1697437 ...
 $ Mayunitprice: num  17.58 19.84 6.23 1.94 4.08 ...
 $ Unitvalue   : num  3699201 8683591 1876750 2956894 3084427 ...
 $ Baseline    : num  2.65 2.73 2.06 10.44 5.14 ... 

 # add aluminium production based on P x B = U or P = U / B
nzal$Production <- nzal[["Units"]]/nzal[["Baseline"]] 
'data.frame':	13 obs. of  6 variables:
 $ Year        : int  2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 ...
 $ Units       : int  210421 437681 301244 1524172 755987 772706 786306 1038914 1324556 1697437 ...
 $ Mayunitprice: num  17.58 19.84 6.23 1.94 4.08 ...
 $ Unitvalue   : num  3699201 8683591 1876750 2956894 3084427 ...
 $ Baseline    : num  2.65 2.73 2.06 10.44 5.14 ...
 $ Production  : num  79554 160558 146093 145980 147194 ... 
 
str(nzallist) 



dump("nzal", file = "nzaldumpdata.R", append = FALSE,control = "all", envir = parent.frame(), evaluate = TRUE)
save.image() 

# How many NZUs were given to  New Zealand Aluminium Smelters Limited in total?
sum(nzal[["Units"]]) 
[1] 11641573            # 12 million!

# [1] 11946759
# 11,946,759 or 11.946759 million emission units  or call it 12 million

# What was the market value of the emission units (based on mid May market prices) that were given to  New Zealand Aluminium Smelters Limited each year?
sum(nzal[["Unitvalue"]])
[1] 233054863
# 233.055 million dollars

# look at the unit allocations for each year
select(nzal,c(Year, Units)) 
# A tibble: 13 × 2
    Year Allocation
   <dbl>      <dbl>
 1  2010     210421
 2  2011     437681
 3  2012     301244
 4  2013    1524172
 5  2014     755987
 6  2015     772706
 7  2016     786306
 8  2017    1038914
 9  2018    1324556
10  2019    1697437
11  2020    1558268
12  2021     628561
13  2022     605320
# create plot
max(nzal$Units/10^6) # [1] 1.697437
plot(select(nzal,c(Year, Units/10^6)),type="o",lwd=3,col=4) 
plot(nzal$Year, nzal$Units/10^6,ylim=c(0,2),las=1,type="o",lwd=3,col=4) 
# edit the unit allocations into a matrix, create a numeric vector of NZAL allocations
a <-nzal$Units
str(a) 
num [1:13] 210421 437681 301244 1524172 755987 .. 
# create labelled matrix
nzalmatrix2 <- matrix(c(a), nrow = 1, ncol=13, byrow=TRUE, dimnames = list(c("Units"), c("2010", "2011", "2012","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022")))
nzalmatrix2 
        2010   2011   2012    2013   2014   2015   2016    2017    2018    2019
Units 210421 437681 301244 1524172 755987 772706 786306 1038914 1324556 1697437
         2020   2021   2022
Units 1558268 628561 60532 

# OLD edit the unit allocations into a matrix
#nzalmatrix1 <- matrix(c(210421,437681,301244,1524172,755987,772706,786306,1038914,1324556,1697437,1558268,1539067), nrow = 1, ncol=12, byrow=TRUE, dimnames = list(c("Units"), c("2010", "2011", "2012","2013","2014","2015","2016","2017","2018","2019","2020","2021")))
#nzalmatrix1 
#        2010   2011   2012    2013   2014   2015   2016    2017    2018    2019
#Units 210421 437681 301244 1524172 755987 772706 786306 1038914 1324556 1697437
#         2020    2021
#Units 1558268 1539067

# create a small .png format chart of the market value of free emission units
png("NZAL-2010-2020-560by420F11.png", bg="white", width=560, height=420,pointsize = 11)
par(mar=c(4.4, 4.4, 4.4, 2)+0.1)
barplot(nzalmatrix2/10^6,las=1) 
title(cex.main=1.4,main="NZETS Emission Units allocated to NZ Aluminium Smelters Ltd",ylab="NZ Units (millions)")
mtext(side=3,line=0.25,cex=1,expression(paste("From 2010 to 2022 NZ Aluminium Smelters Ltd were given 12 million free emission units")))
mtext(side=1,line=2.5,cex=1,expression(paste("Data: https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")))
dev.off()

# create a .svg format chart of the market value of free emission units
svg(filename ="NZAL-2010-2020-allocations_720-540font11.svg", width = 8, height = 6, pointsize = 11, onefile = FALSE, family = "sans", bg = "white")
par(mar=c(4.4, 4.4, 4.4, 2)+0.1)
barplot(nzalmatrix2/10^6,las=1) 
title(cex.main=1.4,main="NZETS Emission Units allocated to NZ Aluminium Smelters Ltd",ylab="NZ Units (millions)")
mtext(side=3,line=0.25,cex=1,expression(paste("From 2010 to 2022 NZ Aluminium Smelters Ltd were given 12 million free emission units")))
mtext(side=1,line=2.5,cex=1,expression(paste("Data: https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")))
dev.off()

# just select the market values of NZALs allocations of emissions units
v <- nzal$Value

# What is the estimated value of the emission units allocated to NZAL?
sum(v) 
[1] 233054863 # 233.054863 million dollars

# edit them into matrix for use in a barplot 

nzalmatrix3 <- matrix(c(v), nrow = 1, ncol=13, byrow=TRUE, dimnames = list(c("Units"), c("2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022")))
# check matrix 
nzalmatrix3 
          2010    2011    2012    2013    2014    2015     2016     2017
Units 3699201 8683591 1876750 2956894 3084427 4126250 11503657 17619981
          2018     2019     2020     2021     2022
Units 28186552 42928182 38707377 23344756 46337246 

# create small .png chart
png("NZAL-allocation-value-560by420f12.png", bg="white", width=560, height=420,pointsize = 11)
par(mar=c(4.4, 4.4, 4.4, 2)+0.1)
barplot(nzalmatrix3/10^6,las=1) 
title(cex.main=1.3,main="NZ Aluminium Smelters Ltd value of allocated Emission Units",ylab="$NZD million")
mtext(side=3,line=0.25,cex=1,expression(paste("From 2010 to 2022 NZ Aluminium Smelters Ltd were given free emission units worth $233 million")))
mtext(side=1,line=2.5,cex=1,expression(paste("Data: https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")))
dev.off()

# create slightly larger .svg format chart
svg(filename ="NZAL-allocation-value-720-540f12.svg", width = 8, height = 6, pointsize = 12, onefile = FALSE, family = "sans", bg = "white")
par(mar=c(4.4, 4.4, 4.4, 2)+0.1)
barplot(nzalmatrix3/10^6,las=1) 
title(cex.main=1.4,main="NZ Aluminium Smelters Ltd value of allocated emission units",ylab="$NZD million")
mtext(side=3,line=0.25,cex=1,expression(paste("From 2010 to 2022 NZ Aluminium Smelters Ltd were given free emission units worth $233 million")))
mtext(side=1,line=2.5,cex=0.9,expression(paste("Data: https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")))
dev.off()

nzalmatrix4 <- matrix(c(5.13,2.12), nrow = 1, ncol=2, byrow=TRUE,dimnames = list(c("Units"), c("2021 Provisional Allocative Baseline","2021 Final Allocative Baseline")))

nzalmatrix4
      Provisional Final
Units        5.13  2.12

svg(filename ="NZAL-allocation-baseline2021-720-540.svg", width = 8, height = 6, pointsize = 11, onefile = FALSE, family = "sans", bg = "white")
par(mar=c(4.4, 4.4, 4.4, 2)+0.1)
barplot(nzalmatrix4,las=1)
title(cex.main=1.4,main="NZ Aluminium Smelters Ltd provisional and final allocative baselines",ylab="NZ Units per tonne aluminium produced")
mtext(side=3,line=0.25,cex=1,expression(paste("The 2021 final allocative baseline excludes electricity and is half of the provisional baseline")))
mtext(side=1,line=2.5,cex=1,expression(paste("Data: Climate Change (Eligible Industrial Activities) Regulations 2010")))
dev.off()

==================================================================================

https://www.legislation.govt.nz/regulation/public/2010/0189/latest/DLM3075118.html

# create table that is NZ AL allocation baseline Climate Change (Eligible Industrial Activities) Regulations 2010 No 7
# https://www.legislation.govt.nz/regulation/public/2010/0189/latest/DLM3075118.html

# read in the Final baselines from the csv file copied from the legislation web page
baseline <- read.csv("baseline.csv") 
baseline 
   Allocativebaseline Year
1               2.645 2010
2               2.726 2011
3               2.062 2012
4              10.441 2013
5               5.136 2014
6               5.152 2015
7               5.160 2016
8               5.142 2017
9               5.184 2018
10              5.366 2019
11              5.194 2020
12              2.120 2021
13              2.048 2022
14              2.042 2023 

baselines <-c(baseline$Allocativebaseline)

str(baselines)
 num [1:14] 2.65 2.73 2.06 10.44 5.14 ...

nzalbaseline <- matrix(baselines, nrow = 1, ncol=14, byrow=TRUE, dimnames = list(c("NA"),
c("2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022","2023")))

svg(filename ="NZAL-Allocation-baseline-720-540.svg", width = 8, height = 6, pointsize = 12, onefile = FALSE, family = "sans", bg = "white")
#png("NZAL-Allocation-baseline-560by420-v1.png", bg="white", width=560, height=420,pointsize = 11)
par(mar=c(4, 4, 4, 1)+0.1)
barplot(nzalbaseline,ylim=c(0,11),las=1,space=c(0.1,1.1), beside = TRUE, col=c(rep("#ED731D",14),"red"))
title(cex.main=1.4,main=expression(paste("Aluminium final allocation baseline factor 2010 - 2023")),ylab="Units per tonne aluminium produced",xlab="")
mtext(side=1,line=2.5,cex=1,expression(paste("Source: Climate Change (Eligible Industrial Activities) Regulations 2010 No 7")))
mtext(side=3,line=0,cex=0.9,expression(paste("What happened in 2013? The allocation factor is five times more than emissions per tonne aluminium")))
legend("topright", inset=c(0.0,0.0) ,bty="n",cex=1.2,c("Final allocation","Provisional allocation"),fill=c("#ED731D","red"))
dev.off()

# add 2024 provisional baseline
baseline1 <- rbind(baseline,c(2.042,2024))
str(baseline1) 
'data.frame':	15 obs. of  2 variables:
 $ Allocativebaseline: num  2.65 2.73 2.06 10.44 5.14 ...
 $ Year              : num  2010 2011 2012 2013 2014 ...

# create matrix
nzalbaseline1 <- matrix(baseline1$Allocativebaseline, nrow = 1, ncol=15, byrow=TRUE, dimnames = list(c("NA"),
c("2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022","2023","2024")))

nzalbaseline1 
    2010  2011  2012   2013  2014  2015 2016  2017  2018  2019  2020 2021  2022
NA 2.645 2.726 2.062 10.441 5.136 5.152 5.16 5.142 5.184 5.366 5.194 2.12 2.048
    2023  2024
NA 2.042 2.042

svg(filename ="NZAL-allocation-all-baseline-720-540.svg", width = 8, height = 6, pointsize = 12, onefile = FALSE, family = "sans", bg = "white")
png("NZAL-Allocation-all-baseline-560by420.png", bg="white", width=560, height=420,pointsize = 11)
par(mar=c(4, 4, 4, 1)+0.1)
barplot(nzalbaseline1,ylim=c(0,11),las=1,space=c(0.1,1.1), beside = TRUE, col=c(rep("#ED731D",14),"red"))
title(cex.main=1.4,main=expression(paste("Aluminium all allocation baseline factors 2010 - 2024")),ylab="Units per tonne aluminium produced",xlab="")
mtext(side=1,line=2.5,cex=1,expression(paste("Source: Climate Change (Eligible Industrial Activities) Regulations 2010 No 7")))
mtext(side=3,line=0,cex=0.9,expression(paste("What happened in 2013? The allocation factor is five times more than emissions per tonne aluminium")))
legend("topright", inset=c(0.0,0.0) ,bty="n",cex=1.2,c("Final allocation","Provisional allocation"),fill=c("#ED731D","red"))
dev.off()

https://www.legislation.govt.nz/regulation/public/2024/0028/latest/LMS944589.html
2.042, which is the allocative baseline for any 2024 provisional allocation: 
https://www.legislation.govt.nz/regulation/public/2023/0044/latest/LMS821749.html
2.034, which is the allocative baseline for any 2023 provisional allocation:

From the EPAs letter about calculating 2021 provisional allocation;  
estimating the provisional allocation (PA) for 2023

PA = LA x sum(PDCT x AB) / TM

(S.81 https://www.legislation.govt.nz/act/public/2002/0040/latest/DLM1662643.html) 

LA = level of assistance - 2010 to 2020 LA = 0.9 "less applicable phase out rate" (S.81.2.a) 0.01 p.a. from 2021 to 2030
LA2023 <- 0.9 - 0.01 - 0.01 - 0.01 
PDCT = "is the amount of each prescribed product from the eligible industrial activity produced by the person in the year immediately preceding the year to which the provisional allocation relates, as determined, if relevant, in accordance with regulations made under this Act"
PDCT2023 = Final PDCT2022
PDCT2023 <- nzal[nzal$Year =="2022" & nzal$Production,6] 
AB2023 = 2.034
#(Climate Change (Eligible Industrial Activities) Amendment Regulations 2023, https://www.legislation.govt.nz/regulation/public/2023/0044/latest/LMS821749.html
TM = transitional measure (the 'two for one' to 2017) = 1
 AB2023 = 2.034
LA2023
[1] 0.87
PDCT2023
[1] 295566.4
AB2023
[1] 2.034
PA2023 <- round(LA2023 * (PDCT2023 * AB2023),0)
PA2023 
[1] 523028 
tail(nzal,1)
   Year  Units Mayunitprice Unitvalue Baseline Production
13 2022 605320        76.55  46337246    2.048   295566.4
2023 May mean unit price? => 53.81 to calculate value of units allocated in May 2023
uv2023 <- round(53.81 * PA2023,2) 
uv2023
[1] 28144137
rbind(nzal,
pa2023 <- c(2023,PA2023,53.81,uv2023,AB2023,NA)
pa2023
[1]     2023.000   523028.000       53.810 28144136.680        2.034
[6]           NA 

nzal20102023 <- rbind(nzal, pa2023)
tail(nzal20102023,3)
   Year  Units Mayunitprice Unitvalue Baseline Production
12 2021 628561        37.14  23344756    2.120   296491.0
13 2022 605320        76.55  46337246    2.048   295566.4
14 2023 523028        53.81  28144137    2.034         NA 
# ceate factor denoting type of allocation, Final allocations to 2022 first
Type <- rep("Final",13)
Type <- append(Type,"Provisional")
str(Type)
Type
[1] "Final"       "Final"       "Final"       "Final"       "Final"      
 [6] "Final"       "Final"       "Final"       "Final"       "Final"      
[11] "Final"       "Final"       "Final"       "Provisional" 
# add to dataframe as a column
nzal20102023$Type <- Type
str(nzal20102023) 
'data.frame':	14 obs. of  7 variables:
 $ Year        : num  2010 2011 2012 2013 2014 ...
 $ Units       : num  210421 437681 301244 1524172 755987 ...
 $ Mayunitprice: num  17.58 19.84 6.23 1.94 4.08 ...
 $ Unitvalue   : num  3699201 8683591 1876750 2956894 3084427 ...
 $ Baseline    : num  2.65 2.73 2.06 10.44 5.14 ...
 $ Production  : num  79554 160558 146093 145980 147194 ...
 $ Type        : chr  "Final" "Final" "Final" "Final" ... 
 
 
# How many NZUs were given to  New Zealand Aluminium Smelters Limited in total including the provisional allocation 2023?
sum(nzal20102023[["Units"]])  
[1] 12164601 
# $12 million 
# What was the market value of the NZUs given to  New Zealand Aluminium Smelters Limited in total the including provisional allocation 2023?
sum(nzal20102023[["Unitvalue"]])  
[1] 261199000 
# $261 million 
# Create a .csv formatted data file
write.csv(nzal20102023, file = "nzalallocations", row.names = FALSE) 

https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/how-to-apply/    Step 2 choose an application type
#Provisional If you apply for a Provisional Allocation you receive your entitlement in advance, based on your production for the previous calendar year. To ‘square up’ your entitlement with what you actually produced, in the next application period you’re required to submit an allocation adjustment.

https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/how-to-apply/    correct at 27/02/2022
#Deadlines  info@epa.govt.nz
#You must submit your application via the Register by the following statutory deadlines:
#Provisional allocation applications: Apply between 1 January - 30 April of the year for which you wish to receive NZUs.
#Final allocation applications and annual allocation adjustments: Apply between 1 January - 30 April of the year following the year for which you wish to receive NZUs.
