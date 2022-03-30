## Industrial allocation of New Zealand Emission Units to industry under the New Zealand Emissions Trading Scheme. 

### Description

The New Zealand [Environmental Protection Authority](https://www.epa.govt.nz) manages the [New Zealand Emissions Trading Scheme](https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/). 

Emissions units are allocated (gifted for no cost) to [participant emitting industries](https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industries-in-the-emissions-trading-scheme/) each calendar year. This is the annual [Industrial Allocation](https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/) of emissions units to emitting industries.
    
The New Zealand [Environmental Protection Authority](https://www.epa.govt.nz) (EPA) publishes the final industrial allocation of emission units annually on it's website [Industrial allocations decisions](https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/)

The EPA website states at; [EPA Provisional Allocation](https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/how-to-apply/) "If you Apply for a Provisional Allocation you receive your entitlement in advance, based on your production for the previous calendar year. To ‘square up’ your entitlement with what you actually produced, in the next application period you’re required to submit an allocation adjustment".

The EPA website states at; [EPA application deadlines](https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/how-to-apply/) "You must submit your application via the Register by the following statutory deadlines: Provisional allocation applications: Apply between 1 January - 30 April of the year for which you wish to receive NZUs. Final allocation applications and annual allocation adjustments: Apply between 1 January - 30 April of the year following the year for which you wish to receive NZUs".

The EPA website also discloses a complete record of all industry final allocations to 2021 in a MS Excel workbook [Industrial-Allocations-Final-Decisions.xlsx](https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Reports/Industrial-Allocations/Industrial-Allocations-Final-Decisions.xlsx)

This data repository is a reproducible exploration of the free industrial allocation of New Zealand emission units to New Zealand Aluminium Smelters Limited.

### Data Preparation

#### Requirements

Data preparation was performed with [R version 3.6.0](https://cran.r-project.org/) with the [RKWard 0.6.5 IDE](https://rkward.kde.org/) running on an i586-pc-linux-gnu (64-bit), [Debian GNU/Linux 9 (Stretch) MX-18](https://mxlinux.org/index.php) operating system.

#### Processing

Follow the steps in the R script file Sum-allocation-2010-2018.r

Load packages 
```{r}
library(readxl)
library(dplyr)
library(RColorBrewer)
library(tidyr)
```
check the working directory and set if necessary
```{r}
setwd("/folder")
getwd()
```
Obtain the Excel workbook of the emission unit allocation to industry data from the EPA
```{r}
download.file("https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Reports/Industrial-Allocations/Industrial-Allocations-Final-Decisions.xlsx", "Industrial-Allocations-Final-Decisions.xlsx") 
```
check how many worksheets
```{r}
excel_sheets("Industrial-Allocations-Final-Decisions.xlsx")
```
```{r}
[1] "IA Final Decisions"
```
read in the sheet of unit allocations
```{r}
Allocations <- read_excel("Industrial-Allocations-Final-Decisions.xlsx", sheet = "IA Final Decisions",skip=3)
```
Check the consistency of column/variable names
```{r}
str(Allocations)
```
```{r}
Classes ‘tbl_df’, ‘tbl’ and 'data.frame':	1129 obs. of  4 variables:
 $ Activity        : chr  "Aluminium smelting" "Burnt lime" "Burnt lime" "Burnt lime" ...
 $ Applicant’s name: chr  "New Zealand Aluminium Smelters Limited" "Graymont (NZ) Limited" "Holcim (New Zealand) Limited" "Perry Resources (2008) Ltd" ...
 $ Year            : num  2010 2010 2010 2010 2010 2010 2010 2010 2010 2010 ...
 $ Final Allocation: num  210421 47144 3653 4712 948 ...   
```
Revise and shorten the column names
```{r}
colnames(Allocations) <- c("Activity", "Applicant", "Year", "Allocation")
```
Separate the allocation data into years
```{r}
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
```
Each year, from 1 May, the EPA makes a [provisional allocation](https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/) of emission units to selected industries. I want to estimate the market value of each years free allocation of units. I understand that the deadline for a provisional allocation is 30 April of each year so I assume the transfer of the emission units is made in May of each year. There is an online 'open data' Github repository of New Zealand Unit (NZU) prices going back to May 2010. This data set has it's own citation and DOI: Theecanmole. (2016). [New Zealand emission unit (NZU) monthly prices 2010 to 2016](https://github.com/theecanmole/nzu) [V1.0.01 [Data set]. Zenodo](http://doi.org/10.5281/zenodo.221328). I add a market price for the units at the May average price from 2010 to 2020 to the annual allocation data. 
```{r}
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
```
Combine all year data together into 1 dataframe - I use rbind as all the column names are consistent
```{r}
Allocations <- rbind(nzu2010,nzu2011,nzu2012,nzu2013,nzu2014,nzu2015,nzu2016,nzu2017,nzu2018,nzu2019,nzu2020)
```
Check the new dataframe
```{r}
str(Allocations)
```
Create a .csv formatted data file
```{r}
write.csv(Allocations, file = "Allocations.csv", row.names = FALSE)
```
Or create a Windows Excel 2007/10 formatted data file (if needed)
```{r}
write.csv(Allocations, file = "Allocations.xls", row.names = FALSE, fileEncoding = "UTF-16LE") 
```
read back in the new 2010 2020 data if needed
```{r}
Allocations <- read.csv("Allocations.csv") 
```
Look at a summary of the allocations dataframe
```{r}
summary(Allocations)
```
```{r}
                      Activity                              Applicant   
 Fresh tomatoes           :314   Oji Fibre Solutions (NZ) Limited:  33  
 Protein meal             :180   Under Glass (Bombay) Ltd        :  28  
 Fresh capsicums          :150   J.S.Ewers Ltd                   :  26  
 Fresh cucumbers          :123   Gourmet Mokai Limited           :  22  
 Cut roses                : 97   Parkgard Growers 2000 Limited   :  19  
 Reconstituted wood panels: 61   Jai Shankar Growers Limited     :  17  
 (Other)                  :282   (Other)                         :1062  
      Year        Allocation          Value         
 Min.   :2010   Min.   :      1   Min.   :       4  
 1st Qu.:2012   1st Qu.:    160   1st Qu.:    1527  
 Median :2014   Median :   1075   Median :   11374  
 Mean   :2014   Mean   :  45569   Mean   :  724853  
 3rd Qu.:2017   3rd Qu.:   6916   3rd Qu.:   83210  
 Max.   :2020   Max.   :2118983   Max.   :53589080  
``` 
How many emission units were given to  New Zealand Aluminium Smelters Limited? Filter the data for the aluminium smelter allocations, and create a dataframe.
```{r}
nzal <- filter(Allocations, Applicant =="New Zealand Aluminium Smelters Limited") 
```
What does that dataframe that look like?
```{r}
str(nzal) 
```
```{r}
Classes ‘tbl_df’, ‘tbl’ and 'data.frame':	11 obs. of  5 variables:
 $ Activity  : chr  "Aluminium smelting" "Aluminium smelting" "Aluminium smelting" "Aluminium smelting" ...
 $ Applicant : chr  "New Zealand Aluminium Smelters Limited" "New Zealand Aluminium Smelters Limited" "New Zealand Aluminium Smelters Limited" "New Zealand Aluminium Smelters Limited" ...
 $ Year      : num  2010 2011 2012 2013 2014 ...
 $ Allocation: num  210421 437681 301244 1524172 755987 ...
 $ Value     : num  3699201 8683591 1876750 2956894 3084427 ...  
```
Filter out redundant columns to leave year, allocation and value
```{r}
nzal <- select(nzal, -Activity, -Applicant)
```
```{r}
'data.frame':	11 obs. of  3 variables:
 $ Year      : int  2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 ...
 $ Allocation: int  210421 437681 301244 1524172 755987 772706 786306 1038914 1324556 1697437 ...
 $ Value     : num  3699201 8683591 1876750 2956894 3084427 ...  
```
What is the most recent year allocation? it is 2020. 
```{r}
tail(nzal,1)
```
```{r}
  Year Allocation    Value
11 2020    1558268 38707377 
```
How do I estimate the 2021 provisional allocation that was probably processed by EPA in May 2021? It is based on prior year 2020 actual production see [Section 81(1) of the Climate Change Response Act 2002](https://www.legislation.govt.nz/act/public/2002/0040/latest/DLM1662643.html). So obtain the 2020 final allocation of units and divide by 2020 final allocation baseline from [Regulation 7 of the Climate Change (Eligible Industrial Activities) Regulations 2010](https://www.legislation.govt.nz/regulation/public/2010/0189/latest/DLM3075118.html). The final 2020 allocation of units multiplied by the 2021 allocation baseline equals the 2021 provisional allocation. 
```{r}
1558268 / 5.194 
```
```{r}
[1]  300013.1
```
```{r}
300013.1 * 5.130
```
```{r}
[1] 1539067
```
What is the market value of the 2021 provisional allocation assuming a mid May 2021 carbon price 37.14 per tonne
```{r}
1539067 * 37.14
[1] 57160948 
```
Add the estimated provisional 2021 allocation and May market value to the data frame
```{r}
nzal <- rbind (nzal,c(2021,1539067,57160948))
```
Check the dataframe
```{r}
str(nzal) 
```
```{r}
'data.frame':	12 obs. of  3 variables:
 $ Year      : num  2010 2011 2012 2013 2014 ...
 $ Allocation: num  210421 437681 301244 1524172 755987 ...
 $ Value     : num  3699201 8683591 1876750 2956894 3084427 ...   
```
What data is there for last year 2021
```{r}
tail(nzal,1) 
```
```{r}
   Year Allocation    Value
12 2021    1539067 57160948 
```
Create .csv formatted data file
```{r}
write.csv(nzal, file = "nzal.csv", row.names = FALSE)
```
Create a Windows Excel 2007/10 formatted data file (if needed)
```{r}
write.csv(nzal, file = "nzal.xls", row.names = FALSE, fileEncoding = "UTF-16LE")   
```
Read the csv data file back into R if needed later
```{r}
nzal <- read.csv("nzal.csv") 
```
How many NZUs were given to  New Zealand Aluminium Smelters Limited in total?
```{r}
sum(nzal[["Allocation"]])  
```
```{r}
[1] 11946759
```
So 11,946,759 or 11.946759 million or call it 12 million emission units have been given to New Zealand Aluminium Smelters Limited 

What was the market value of the all emission units (based on mid May market prices) that were given to  New Zealand Aluminium Smelters Limited from 2010 to 2021?
```{r}
sum(nzal[["Value"]])
```
```{r}
[1] 220533810
```
The total market value is $220,533,810 or $220.533810 million $NZD

Look at the unit allocations for each year
```{r}
select(nzal, -Value) 
```
```{r}
A tibble: 11 x 2
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
```
Edit the unit allocations into a matrix
```{r}
nzalmatrix1 <- matrix(c(210421,437681,301244,1524172,755987,772706,786306,1038914,1324556,1697437,1558268,1539067), nrow = 1, ncol=12, byrow=TRUE, dimnames = list(c("Units"), c("2010", "2011", "2012","2013","2014","2015","2016","2017","2018","2019","2020","2021")))
```
Create a small .png format chart of the annual allocations of free emission units
```{r}
png("NZAL-2010-2020-560by420F11.png", bg="white", width=560, height=420,pointsize = 11)
par(mar=c(4.4, 4.4, 4.4, 2)+0.1)
barplot(nzalmatrix1/10^6,las=1) 
title(cex.main=1.4,main="NZETS Emission Units Allocated to NZ Aluminium Smelters Ltd",ylab="NZ Units (millions)")
mtext(side=3,line=0.25,cex=1,expression(paste("From 2010 to 2021 NZ Aluminium Smelters Ltd were given 12 million free emission units")))
mtext(side=1,line=2.5,cex=1,expression(paste("Data: https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")))
dev.off()
```
Create a .svg format chart of the annual allocations of free emission units
```{r}
svg(filename ="NZAL-2010-2020-allocations_720-540font11.svg", width = 8, height = 6, pointsize = 11, onefile = FALSE, family = "sans", bg = "white")
par(mar=c(4.4, 4.4, 4.4, 2)+0.1)
barplot(nzalmatrix1/10^6,las=1) 
title(cex.main=1.4,main="NZETS Emission Units Allocated to NZ Aluminium Smelters Ltd",ylab="NZ Units (millions)")
mtext(side=3,line=0.25,cex=1,expression(paste("From 2010 to 2021 NZ Aluminium Smelters Ltd were given 12 million free emission units")))
mtext(side=1,line=2.5,cex=1,expression(paste("Data: https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")))
dev.off()
```
Select only the market values of NZ Aluminium Smelters Limited's allocations of emissions units
```{r}
select(nzal, Value) 
      Value
1   3699201
2   8683591
3   1876750
4   2956894
5   3084427
6   4126250
7  11503657
8  17619981
9  28186552
10 42928182
11 38707377
12 57160948  
```
Edit them into matrix for use in a barplot 
```{r}
nzalmatrix2 <- matrix(c(3699201,8683591,1876750,2956894,3084427,4126250,11503657,17619981,28186552,42928182,38707377,57160948), nrow = 1, ncol=12, byrow=TRUE, dimnames = list(c("Units"), c("2010", "2011", "2012","2013","2014","2015","2016","2017","2018","2019","2020","2021")))
```
Check the matrix 
```{r}
nzalmatrix2
``` 
```{r}
        2010    2011    2012    2013    2014    2015     2016     2017
Units 3699201 8683591 1876750 2956894 3084427 4126250 11503657 17619981
          2018     2019     2020     2021
Units 28186552 42928182 38707377 57160948 
```
Create a small .png chart
```{r}
png("NZAL-allocation-value-560by420f12.png", bg="white", width=560, height=420,pointsize = 11)
par(mar=c(4.4, 4.4, 4.4, 2)+0.1)
barplot(nzalmatrix2/10^6,las=1) 
title(cex.main=1.3,main="NZ Aluminium Smelters Ltd Value of Allocated Emission Units",ylab="$NZD million")
mtext(side=3,line=0.25,cex=1,expression(paste("From 2010 to 2021 NZ Aluminium Smelters Ltd were given free emission units worth $220 million")))
mtext(side=1,line=2.5,cex=1,expression(paste("Data: https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")))
dev.off()
```
Create slightly larger .svg format chart
```{r}
svg(filename ="NZAL-allocation-value-720-540f12.svg", width = 8, height = 6, pointsize = 12, onefile = FALSE, family = "sans", bg = "white")
par(mar=c(4.4, 4.4, 4.4, 2)+0.1)
barplot(nzalmatrix2/10^6,las=1) 
title(cex.main=1.4,main="NZ Aluminium Smelters Ltd Value of Allocated Emission Units",ylab="$NZD million")
mtext(side=3,line=0.25,cex=1,expression(paste("From 2010 to 2021 NZ Aluminium Smelters Ltd were given free emission units worth $220 million")))
mtext(side=1,line=2.5,cex=0.9,expression(paste("Data: https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")))
dev.off()
```

![Quantity of NZETS Emission Units Allocated to NZ Aluminium Smelters Ltd 2010 to 2021](NZAL-2010-2020-allocations_720-540font11.svg)

![Value of NZETS Emission Units Allocated to NZ Aluminium Smelters Ltd 2010 to 2021](NZAL-allocation-value-720-540f12.svg)


### License

#### ODC-PDDL-1.0

These datasets and the R script are made available under the Public Domain Dedication and License v1.0 whose full text can be found at: http://www.opendatacommons.org/licenses/pddl/1.0/. You are free to share, to copy, distribute and use the data, to create or produce works from the data and to adapt, modify, transform and build upon the data, without restriction.


#### Index of data and script files

1. Industrial-Allocations-Final-Decisions.xlsx

2. Allocations.csv

3. nzal.csv

4. nzal.xls

5. Sum-allocation-2010-2018.r, the R script file of code

6. NZAL-2010-2020-560by420F11.png

7. NZAL-2010-2020-allocations_720-540font11.svg

8. NZAL-allocation-value-560by420f12.png

9. NZAL-allocation-value-720-540f12.svg

10. [Licence.txt](https://github.com/theecanmole/nzu/blob/master/Licence.txt) (Public Domain  Dedication and License v1.0 http://opendatacommons.org/licenses/pddl/1.0/)
