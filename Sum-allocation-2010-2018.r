# NZ Aluminium free industrial allocation of emissions units 2010 to 2022

https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/how-to-apply/    Step 2 choose an application type
#Provisional If you apply for a Provisional Allocation you receive your entitlement in advance, based on your production for the previous calendar year. To ‘square up’ your entitlement with what you actually produced, in the next application period you’re required to submit an allocation adjustment.

https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/how-to-apply/    correct at 27/02/2022
#Deadlines  info@epa.govt.nz
#You must submit your application via the Register by the following statutory deadlines:
#Provisional allocation applications: Apply between 1 January - 30 April of the year for which you wish to receive NZUs.
#Final allocation applications and annual allocation adjustments: Apply between 1 January - 30 April of the year following the year for which you wish to receive NZUs.

# Industry final allocations to 2022
https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Reports/Industrial-Allocations/Industrial-Allocations-Final-Decisions_2022.xlsx

# Industry final allocations to 2020
https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Reports/Industrial-Allocations/Industrial-Allocations-Final-Decisions.xlsx

# Industry final allocations to 2019
https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Images/Industrial-Allocations-Final-Decisions.xlsx 

# load packages 
library(readxl)
library(dplyr)
library(RColorBrewer)
#library(tidyr)

# check the working directory and set if necessary
setwd("/home/user/r/eur/2010t02018")
getwd()
[1] "/home/user/r/eur/2010to2018"

# obtain latest emission unit allocation to industry data from EPA

download.file("https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Reports/Industrial-Allocations/Industrial-Allocations-Final-Decisions_2022.xlsx", "Industrial-Allocations-Final-Decisions.xlsx") 
# downloaded 212 bytes
url= c("
https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Reports/Industrial-Allocations/Industrial-Allocations-Final-Decisions_2022.xlsx
https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Reports/Industrial-Allocations/Industrial-Allocations-Final-Decisions_2022.xlsx")
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
colnames(Allocations) <- c("Activity", "Applicant", "Year", "Allocation")

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
Classes ‘tbl_df’, ‘tbl’ and 'data.frame':	141 obs. of  4 variables:
 $ Activity  : chr  "Aluminium smelting" "Burnt lime" "Burnt lime" "Burnt lime" ...
 $ Applicant : chr  "New Zealand Aluminium Smelters Limited" "Graymont (NZ) Limited" "Holcim (New Zealand) Limited" "Perry Resources (2008) Ltd" ...
 $ Year      : num  2010 2010 2010 2010 2010 2010 2010 2010 2010 2010 ...
 $ Allocation: num  210421 47144 3653 4712 948 ...   
 
# Each year, from May, the EPA makes a 'provisional' allocation of emssion units to selected industries. see https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/ I want to estimate the market value of free allocation of units. I understand that the deadline for a provisional allocation is 30 April of each year so I assume the transfer of allocation is made in May of each year. There is an online 'open data' Github repository of New Zealand Unit (NZU) prices going back to May 2010. https://github.com/theecanmole/nzu
# The NZU repository has it's own citation and DOI: Theecanmole. (2016). New Zealand emission unit (NZU) monthly prices 2010 to 2016: V1.0.01 [Data set]. Zenodo. http://doi.org/10.5281/zenodo.221328
# I will add a NZU market price value at the May average price from 2010

nzu2010[["Value"]] <- nzu2010[["Allocation"]]*17.58
nzu2011[["Value"]] <- nzu2011[["Allocation"]]*19.84
nzu2012[["Value"]] <- nzu2012[["Allocation"]]*6.23
nzu2013[["Value"]] <- nzu2013[["Allocation"]]*1.94
nzu2014[["Value"]] <- nzu2014[["Allocation"]]*4.08
nzu2015[["Value"]] <- nzu2015[["Allocation"]]*5.34
nzu2016[["Value"]] <- nzu2016[["Allocation"]]*14.63
nzu2017[["Value"]] <- nzu2017[["Allocation"]]*16.96
nzu2018[["Value"]] <- nzu2018[["Allocation"]]*21.28
nzu2019[["Value"]] <- nzu2019[["Allocation"]]*25.29 
nzu2020[["Value"]] <- nzu2020[["Allocation"]]*24.84
nzu2021[["Value"]] <- nzu2021[["Allocation"]]*37.14
nzu2022[["Value"]] <- nzu2022[["Allocation"]]*76.55

# combine all year data together into 1 dataframe - I use rbind as all the column names are consistent
Allocations <- rbind(nzu2010,nzu2011,nzu2012,nzu2013,nzu2014,nzu2015,nzu2016,nzu2017,nzu2018,nzu2019,nzu2020,nzu2021,nzu2022)

# check the new dataframe
str(Allocations)
tibble [1,377 × 5] (S3: tbl_df/tbl/data.frame)
 $ Activity  : chr [1:1377] "Aluminium smelting" "Burnt lime" "Burnt lime" "Burnt lime" ...
 $ Applicant : chr [1:1377] "New Zealand Aluminium Smelters Limited" "Graymont (NZ) Limited" "Holcim (New Zealand) Limited" "Perry Resources (2008) Ltd" ...
 $ Year      : num [1:1377] 2010 2010 2010 2010 2010 2010 2010 2010 2010 2010 ...
 $ Allocation: num [1:1377] 210421 47144 3653 4712 948 ...
 $ Value     : num [1:1377] 3699201 828792 64220 82837 16666 ... 

# put the market unit prices into the dataframe
Allocations$unitvalue = Allocations[["Value"]]/Allocations[["Allocation"]]
summary(Allocations$unitvalue) 
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
   1.94    5.34   17.58   19.00   21.28   76.55 
   
# Create a .csv formatted data file
write.csv(Allocations, file = "Allocations.csv", row.names = FALSE)

# read my csv data file back into R if needed
Allocations <- read.csv("Allocations.csv")  

# Create a Windows Excel 2007/10 formatted data file (if needed)
write.csv(Allocations, file = "Allocations.xls", row.names = FALSE, fileEncoding = "UTF-16LE") 

# read back in the new 2010 2020 data if needed
Allocations <- read.csv("Allocations.csv") 

str(Allocations)
tibble [1,377 × 5] (S3: tbl_df/tbl/data.frame)
 $ Activity  : chr [1:1377] "Aluminium smelting" "Burnt lime" "Burnt lime" "Burnt lime" ...
 $ Applicant : chr [1:1377] "New Zealand Aluminium Smelters Limited" "Graymont (NZ) Limited" "Holcim (New Zealand) Limited" "Perry Resources (2008) Ltd" ...
 $ Year      : num [1:1377] 2010 2010 2010 2010 2010 2010 2010 2010 2010 2010 ...
 $ Allocation: num [1:1377] 210421 47144 3653 4712 948 ...
 $ Value     : num [1:1377] 3699201 828792 64220 82837 16666 ...
 
 # look at summary of allocations dataframe
summary(Allocations)
   Activity          Applicant              Year        Allocation     
 Length:1377        Length:1377        Min.   :2010   Min.   :      1  
 Class :character   Class :character   1st Qu.:2012   1st Qu.:    195  
 Mode  :character   Mode  :character   Median :2015   Median :   1182  
                                       Mean   :2015   Mean   :  49195  
                                       3rd Qu.:2018   3rd Qu.:   8079  
                                       Max.   :2022   Max.   :2145482  
     Value             unitvalue    
 Min.   :        4   Min.   : 1.94  
 1st Qu.:     2083   1st Qu.: 5.34  
 Median :    15673   Median :17.58  
 Mean   :  1154879   Mean   :19.00  
 3rd Qu.:   139015   3rd Qu.:21.28  
 Max.   :146249005   Max.   :76.55
 
# How many emission units were given to  New Zealand Aluminium Smelters Limited? Filter the data for their allocation. Create a dataframe.
nzal <- filter(Allocations, Applicant =="New Zealand Aluminium Smelters Limited") 

# what does that dataframe that look like?
str(nzal) 
tibble [13 × 6] (S3: tbl_df/tbl/data.frame)
 $ Activity  : chr [1:13] "Aluminium smelting" "Aluminium smelting" "Aluminium smelting" "Aluminium smelting" ...
 $ Applicant : chr [1:13] "New Zealand Aluminium Smelters Limited" "New Zealand Aluminium Smelters Limited" "New Zealand Aluminium Smelters Limited" "New Zealand Aluminium Smelters Limited" ...
 $ Year      : num [1:13] 2010 2011 2012 2013 2014 ...
 $ Allocation: num [1:13] 210421 437681 301244 1524172 755987 ...
 $ Value     : num [1:13] 3699201 8683591 1876750 2956894 3084427 ...
 $ unitvalue : num [1:13] 17.58 19.84 6.23 1.94 4.08 ...

# filter out redundant columns to leave year allocation and value
nzal <- select(nzal, -Activity, -Applicant)

# what is the most recent year of allocation? It is 2022. 
tail(nzal)
# A tibble: 6 × 4
   Year Allocation     Value unitvalue
  <dbl>      <dbl>     <dbl>     <dbl>
1  2017    1038914 17619981.      17.0
2  2018    1324556 28186552.      21.3
3  2019    1697437 42928182.      25.3
4  2020    1558268 38707377.      24.8
5  2021     628561 23344756.      37.1
6  2022     605320 46337246       76.6

# How to estimate the 2021 provisional allocation that was probably processed by EPA in May 2021. That is based on prior year 2020 actual production see https://www.legislation.govt.nz/act/public/2002/0040/latest/DLM1662643.html Section 81(1) of the Climate Change Response Act 2002. Obtain 2020 final allocation of units and divide by final Allocation Baseline (see Regulation 7 of the Climate Change (Eligible Industrial Activities) Regulations 2010 https://www.legislation.govt.nz/regulation/public/2010/0189/latest/DLM3075118.html) = 2020 actual production
1558268 / 5.194 
[1]  300013.1 tonnes

#What is 2021 provisional allocation? It is 2020 production * provisional AB (5.130) Multiply 2020 actual production by final allocation baseline from Regulation 7.
300013.1 * 5.130
[1] 1539067

# what is the market value of the 2021 provisional allocation assuming a mid May 2021 carbon price 37.14 per tonne
1539067 * 37.14
[1] 57160948 

# add provisional 2021 allocation to data frame 'nzal'
#nzal <- rbind (nzal,c(2021,1539067,57160948))

# check the dataframe
str(nzal) 
tibble [13 × 4] (S3: tbl_df/tbl/data.frame)
 $ Year      : num [1:13] 2010 2011 2012 2013 2014 ...
 $ Allocation: num [1:13] 210421 437681 301244 1524172 755987 ...
 $ Value     : num [1:13] 3699201 8683591 1876750 2956894 3084427 ...
 $ unitvalue : num [1:13] 17.58 19.84 6.23 1.94 4.08 ... 
# reorder the columns to Year -> Allocation x unitvalue = Value 
nzal <- nzal[,c(1,2,4,3)] 
str(nzal) 
tibble [13 × 4] (S3: tbl_df/tbl/data.frame)
 $ Year      : num [1:13] 2010 2011 2012 2013 2014 ...
 $ Allocation: num [1:13] 210421 437681 301244 1524172 755987 ...
 $ unitvalue : num [1:13] 17.58 19.84 6.23 1.94 4.08 ...
 $ Value     : num [1:13] 3699201 8683591 1876750 2956894 3084427 ... 
 
nzal
# A tibble: 13 × 4
    Year Allocation unitvalue     Value
   <dbl>      <dbl>     <dbl>     <dbl>
 1  2010     210421     17.6   3699201.
 2  2011     437681     19.8   8683591.
 3  2012     301244      6.23  1876750.
 4  2013    1524172      1.94  2956894.
 5  2014     755987      4.08  3084427.
 6  2015     772706      5.34  4126250.
 7  2016     786306     14.6  11503657.
 8  2017    1038914     17.0  17619981.
 9  2018    1324556     21.3  28186552.
10  2019    1697437     25.3  42928182.
11  2020    1558268     24.8  38707377.
12  2021     628561     37.1  23344756.
13  2022     605320     76.6  46337246 

# Create .csv formatted data file
write.csv(nzal, file = "nzal.csv", row.names = FALSE)

# read my csv data file back into R
#nzal <- read.csv("nzal.csv") 
dput(nzal) 
structure(list(Year = 2010:2021, Allocation = c(210421L, 437681L, 
301244L, 1524172L, 755987L, 772706L, 786306L, 1038914L, 1324556L, 
1697437L, 1558268L, 1539067L), Value = c(3699201.18, 8683591.04, 
1876750.12, 2956893.68, 3084426.96, 4126250.04, 11503656.78, 
17619981.44, 28186551.68, 42928181.73, 38707377.12, 57160948)), class = "data.frame", row.names = c(NA, 
-12L))
# or
nzallist <- structure(list(Year = 2010:2021, Allocation = c(210421L, 437681L, 
301244L, 1524172L, 755987L, 772706L, 786306L, 1038914L, 1324556L, 
1697437L, 1558268L, 1539067L), Value = c(3699201.18, 8683591.04, 
1876750.12, 2956893.68, 3084426.96, 4126250.04, 11503656.78, 
17619981.44, 28186551.68, 42928181.73, 38707377.12, 57160948)), class = "data.frame", row.names = c(NA, 
-12L))

str(nzallist) 
'data.frame':	12 obs. of  3 variables:
 $ Year      : int  2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 ...
 $ Allocation: int  210421 437681 301244 1524172 755987 772706 786306 1038914 1324556 1697437 ...
 $ Value     : num  3699201 8683591 1876750 2956894 3084427 
dump("nzal", file = "nzaldumpdata.R", append = FALSE,control = "all", envir = parent.frame(), evaluate = TRUE)
save.image() 

# How many NZUs were given to  New Zealand Aluminium Smelters Limited in total?
sum(nzal[["Allocation"]]) 
[1] 11641573

# [1] 11946759
# 11,946,759 or 11.946759 million emission units  or call it 12 million

# What was the market value of the emission units (based on mid May market prices) that were given to  New Zealand Aluminium Smelters Limited each year?
sum(nzal[["Value"]])
[1] 233054863
# 233.055 million dollars

# look at the unit allocations for each year
select(nzal,c(Year, Allocation)) 
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

# edit the unit allocations into a matrix, create a numeric vector of NZAL allocations
a <-nzal$Allocation
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


https://www.legislation.govt.nz/regulation/public/2010/0189/latest/DLM3075118.html
