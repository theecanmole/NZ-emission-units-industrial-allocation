# industry final allocations to 2019
https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Images/Industrial-Allocations-Final-Decisions.xlsx

# industry final allocations to 2020
https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Reports/Industrial-Allocations/Industrial-Allocations-Final-Decisions.xlsx
# load packages 
library(readxl)
library(dplyr)
library(RColorBrewer)
library(tidyr)

# check the working directory and set if necessary
setwd("/home/user/r/eur/2010t02018")
getwd()
[1] "/home/user/r/eur/2010to2018"

# obtain emission unit allocation to industry data from EPA

download.file("https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Reports/Industrial-Allocations/Industrial-Allocations-Final-Decisions.xlsx", "Industrial-Allocations-Final-Decisions.xlsx") 

# check how many worksheets
excel_sheets("Industrial-Allocations-Final-Decisions.xlsx")
[1] "IA Final Decisions"

Allocations <- read_excel("Industrial-Allocations-Final-Decisions.xlsx", sheet = "IA Final Decisions",skip=3)

# I will check the consistency of column/variable names
str(Allocations)
Classes ‘tbl_df’, ‘tbl’ and 'data.frame':	1129 obs. of  4 variables:
 $ Activity        : chr  "Aluminium smelting" "Burnt lime" "Burnt lime" "Burnt lime" ...
 $ Applicant’s name: chr  "New Zealand Aluminium Smelters Limited" "Graymont (NZ) Limited" "Holcim (New Zealand) Limited" "Perry Resources (2008) Ltd" ...
 $ Year            : num  2010 2010 2010 2010 2010 2010 2010 2010 2010 2010 ...
 $ Final Allocation: num  210421 47144 3653 4712 948 ...   

# revise and shorten column names
colnames(Allocations) <- c("Activity", "Applicant", "Year", "Allocation")
Classes ‘tbl_df’, ‘tbl’ and 'data.frame':	1207 obs. of  4 variables:
 $ Activity  : chr  "Aluminium smelting" "Burnt lime" "Burnt lime" "Burnt lime" ...
 $ Applicant : chr  "New Zealand Aluminium Smelters Limited" "Graymont (NZ) Limited" "Holcim (New Zealand) Limited" "Perry Resources (2008) Ltd" ...
 $ Year      : num  2010 2010 2010 2010 2010 2010 2010 2010 2010 2010 ...
 $ Allocation: num  210421 47144 3653 4712 948 ...  

# what is most recent year? 
max(Allocations[["Year"]])
[1] 2020  

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

# check 2010 data
str(nzu2010)
Classes ‘tbl_df’, ‘tbl’ and 'data.frame':	141 obs. of  4 variables:
 $ Activity  : chr  "Aluminium smelting" "Burnt lime" "Burnt lime" "Burnt lime" ...
 $ Applicant : chr  "New Zealand Aluminium Smelters Limited" "Graymont (NZ) Limited" "Holcim (New Zealand) Limited" "Perry Resources (2008) Ltd" ...
 $ Year      : num  2010 2010 2010 2010 2010 2010 2010 2010 2010 2010 ...
 $ Allocation: num  210421 47144 3653 4712 948 ...   
 
# Each year, in May, the EPA allocates emssion units to selected industries. see https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/ I want to estimate the market value of free allocation of units. I understand that a provisional allocation is made in May of each year(??). There is an online 'open data' Github repository of New Zealand Unit (NZU) prices going back to May 2010. https://github.com/theecanmole/nzu
# The NZU repository has it's own citation and DOI: Theecanmole. (2016). New Zealand emission unit (NZU) monthly prices 2010 to 2016: V1.0.01 [Data set]. Zenodo. http://doi.org/10.5281/zenodo.221328
# I will add a NZU market price value at the May average price from 2010 to 2019 

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

# combine all year data together into 1 dataframe - I use rbind as all the column names are consistent
Allocationsto2019 <- rbind(nzu2010,nzu2011,nzu2012,nzu2013,nzu2014,nzu2015,nzu2016,nzu2017,nzu2018,nzu2019,nzu2020)

# check the new dataframe
str(Allocationsto2019)
Classes ‘tbl_df’, ‘tbl’ and 'data.frame':	1207 obs. of  5 variables:
 $ Activity  : chr  "Aluminium smelting" "Burnt lime" "Burnt lime" "Burnt lime" ...
 $ Applicant : chr  "New Zealand Aluminium Smelters Limited" "Graymont (NZ) Limited" "Holcim (New Zealand) Limited" "Perry Resources (2008) Ltd" ...
 $ Year      : num  2010 2010 2010 2010 2010 2010 2010 2010 2010 2010 ...
 $ Allocation: num  210421 47144 3653 4712 948 ...
 $ Value     : num  3699201 828792 64220 82837 16666 ...  
 
# filter by year
filter(Allocationsto2019, Year == "2010" )
# same as head  

# same in Base R
Allocationsto2019[Allocationsto2019[["Year"]] == "2010",]

# Create .csv formatted data file
write.csv(Allocationsto2019, file = "Allocationsto2019.csv", row.names = FALSE)

# Create a Windows Excel 2007/10 formatted data file
write.csv(Allocationsto2019, file = "Allocationsto2019.xls", row.names = FALSE, fileEncoding = "UTF-16LE") 

# read back in the new 2010 2019 data if needed
#Allocationsto2019 <- read.csv("Allocationsto2019.csv") 

str(Allocationsto2019)
Classes ‘tbl_df’, ‘tbl’ and 'data.frame':	1207 obs. of  5 variables:
 $ Activity  : chr  "Aluminium smelting" "Burnt lime" "Burnt lime" "Burnt lime" ...
 $ Applicant : chr  "New Zealand Aluminium Smelters Limited" "Graymont (NZ) Limited" "Holcim (New Zealand) Limited" "Perry Resources (2008) Ltd" ...
 $ Year      : num  2010 2010 2010 2010 2010 2010 2010 2010 2010 2010 ...
 $ Allocation: num  210421 47144 3653 4712 948 ...
 $ Value     : num  3699201 828792 64220 82837 16666 ...  

# How many emission units were given to  New Zealand Aluminium Smelters Limited? Filter the data for their allocation. 
nzal <- filter(Allocationsto2019, Activity == "Aluminium smelting" )

# whats that look like?
str(nzal) 
Classes ‘tbl_df’, ‘tbl’ and 'data.frame':	11 obs. of  5 variables:
 $ Activity  : chr  "Aluminium smelting" "Aluminium smelting" "Aluminium smelting" "Aluminium smelting" ...
 $ Applicant : chr  "New Zealand Aluminium Smelters Limited" "New Zealand Aluminium Smelters Limited" "New Zealand Aluminium Smelters Limited" "New Zealand Aluminium Smelters Limited" ...
 $ Year      : num  2010 2011 2012 2013 2014 ...
 $ Allocation: num  210421 437681 301244 1524172 755987 ...
 $ Value     : num  3699201 8683591 1876750 2956894 3084427 ...  

# filter out redundant columns to leave year allocation and value
nzal <- select(nzal, -Activity, -Applicant)
 Classes ‘tbl_df’, ‘tbl’ and 'data.frame':	11 obs. of  3 variables:
 $ Year      : num  2010 2011 2012 2013 2014 ...
 $ Allocation: num  210421 437681 301244 1524172 755987 ...
 $ Value     : num  3699201 8683591 1876750 2956894 3084427 ...  

# Create .csv formatted data file
write.csv(nzal, file = "nzal.csv", row.names = FALSE)

# Create a Windows Excel 2007/10 formatted data file
write.csv(nzal, file = "nzal.xls", row.names = FALSE, fileEncoding = "UTF-16LE")   

# How many were given to  New Zealand Aluminium Smelters Limited each year?
sum(nzal[["Allocation"]])  
[1] 10407692 
# 10,407,692 or 10.407692 million emission units  

# What was the market value of the emission units (based on mid May market prices) that were given to  New Zealand Aluminium Smelters Limited each year?
sum(nzal[["Value"]])
[1] 163372862 

# 163,372,862 or 163.372862 million NZD 

select(nzal, -Value) 
# A tibble: 11 x 2
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

nzalmatrix1 <- matrix(c(210421,437681,301244,1524172,755987,772706,786306,1038914,1324556,1697437,1558268), nrow = 1, ncol=11, byrow=TRUE, dimnames = list(c("Units"), c("2010", "2011", "2012","2013","2014","2015","2016","2017","2018","2019","2020")))

png("NZAL-2010-2020-560by420.png", bg="white", width=560, height=420,pointsize = 14)
par(mar=c(4.4, 4.4, 4.4, 2)+0.1)
barplot(nzalmatrix1/10^6,las=1) 
title(cex.main=1.2,main="NZETS Emission Units Allocated to NZ Aluminium Smelters Ltd",ylab="NZ Units (millions)")
mtext(side=3,line=0.25,cex=0.8,expression(paste("NZ Aluminium Smelters Ltd were given 10 million free emission units from 2010 to 2020")))
mtext(side=1,line=2.5,cex=0.8,expression(paste("Data: https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")))
dev.off()

svg(filename ="NZAL-2010-2020-allocations_720-540.svg", width = 8, height = 6, pointsize = 14, onefile = FALSE, family = "sans", bg = "white")
par(mar=c(4.4, 4.4, 4.4, 2)+0.1)
barplot(nzalmatrix1/10^6,las=1) 
title(cex.main=1.2,main="NZETS Emission Units Allocated to NZ Aluminium Smelters Ltd",ylab="NZ Units (millions)")
mtext(side=3,line=0.25,cex=0.8,expression(paste("NZ Aluminium Smelters Ltd were given 10 million free emission units from 2010 to 2020")))
mtext(side=1,line=2.5,cex=0.8,expression(paste("Data: https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")))
dev.off()
