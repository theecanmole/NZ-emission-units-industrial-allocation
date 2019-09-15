# combine the NZU emission unit industrial allocation data from 2010 to 2018

# check the working directory
setwd("/home/user/r/eur/2010t02018")
getwd()
[1] "/home/user/r/eur/2010to2018"

nzu2010 <- read.csv("NZETS-2010-final-allocations-for-eligible-activities.csv",skip=0,header=TRUE, sep = ",",dec=".",na.strings ='na')
nzu2011 <- read.csv("NZETS-2011-final-allocations-for-eligible-activities.csv",skip=0,header=TRUE, sep = ",",dec=".",na.strings ='na')
nzu2012 <- read.csv("NZETS-2012-final-allocations-for-eligible-activities.csv",skip=0,header=TRUE, sep = ",",dec=".",na.strings ='na')
nzu2013 <- read.csv("NZETS-2013-final-allocations-for-eligible-activities.csv",skip=0,header=TRUE, sep = ",",dec=".",na.strings ='na')
nzu2014 <- read.csv("NZETS-2014-final-allocations-for-eligible-activities.csv",skip=0,header=TRUE, sep = ",",dec=".",na.strings ='na')
nzu2015 <- read.csv("NZETS-2015-final-allocations-for-eligible-activities.csv",skip=0,header=TRUE, sep = ",",dec=".",na.strings ='na')
nzu2016 <- read.csv("NZ-emission-unit-industrial-allocation-decisions-EPA-2016-tidy.csv")
nzu2017 <- read.csv("NZ-emission-unit-industrial-allocation-decisions-EPA-2017-tidy.csv")
nzu2018 <- read.csv("NZ-emission-unit-industrial-allocation-decisions-EPA-2018-tidy.csv")

# I will need to check the consistency of column/variable names
str(nzu2015)
str(nzu2015)
'data.frame':	108 obs. of  4 variables:
 $ Year                  : int  2015 2015 2015 2015 2015 2015 2015 2015 2015 2015 ...
 $ Applicants.Name       : Factor w/ 97 levels "A J & J E Ivicevich",..: 53 31 94 10 61 96 58 23 36 15 ...
 $ Activity              : Factor w/ 26 levels "Aluminium Smelting",..: 1 2 2 3 4 5 6 7 7 8 ...
 $ Final.Unit.Entitlement: int  772706 152951 3089 173906 13271 79585 9927 325532 184794 1563 ...
str(nzu2016)
'data.frame':	94 obs. of  4 variables:
 $ Year      : int  2016 2016 2016 2016 2016 2016 2016 2016 2016 2016 ...
 $ Name      : Factor w/ 85 levels "ACI Operations NZ Limited",..: 44 26 82 8 51 84 48 19 29 42 ...
 $ Activity  : Factor w/ 25 levels "Aluminium Smelting",..: 1 2 2 3 4 5 6 7 7 8 ...
 $ Allocation: int  786306 140446 3306 159680 488 86764 9845 360933 44439 796 ...   
 
 # I have named columns differently for 2010 to 2015 than for later 2016 to 2018 data. I will rename the earlier variables,
colnames(nzu2010) <- c("Year", "Name", "Activity", "Allocation")
colnames(nzu2011) <- c("Year", "Name", "Activity", "Allocation")
colnames(nzu2012) <- c("Year", "Name", "Activity", "Allocation")
colnames(nzu2013) <- c("Year", "Name", "Activity", "Allocation")
colnames(nzu2014) <- c("Year", "Name", "Activity", "Allocation")
colnames(nzu2015) <- c("Year", "Name", "Activity", "Allocation")
colnames(nzu2018) <- c("Year", "Name", "Activity", "Allocation") 

# There is an online 'open data' Github repository of New Zealand Unit (NZU) prices going back to May 2010. https://github.com/theecanmole/nzu

# The NZU repository has it's own citation and DOI: Theecanmole. (2016). New Zealand emission unit (NZU) monthly prices 2010 to 2016: V1.0.01 [Data set]. Zenodo. http://doi.org/10.5281/zenodo.221328

# add a NZU value at the May average price from 2010 to 2018 
nzu2010[["Value"]] <- nzu2010[["Allocation"]]*17.58
nzu2011[["Value"]] <- nzu2011[["Allocation"]]*19.84
nzu2012[["Value"]] <- nzu2012[["Allocation"]]*6.23
nzu2013[["Value"]] <- nzu2013[["Allocation"]]*1.94
nzu2014[["Value"]] <- nzu2014[["Allocation"]]*4.08
nzu2015[["Value"]] <- nzu2015[["Allocation"]]*5.34
nzu2016[["Value"]] <- nzu2016[["Allocation"]]*14.63
nzu2017[["Value"]] <- nzu2017[["Allocation"]]*16.96
nzu2018[["Value"]] <- nzu2018[["Allocation"]]*21.28

# combine all year data together into 1 dataframe - I use rbind as all the column names are consistent
nzu2010to2018<-rbind(nzu2010,nzu2011,nzu2012,nzu2013,nzu2014,nzu2015,nzu2016,nzu2017,nzu2018)
# check new dataframe
str(nzu2010) 
'data.frame':	141 obs. of  5 variables:
 $ Year      : int  2010 2010 2010 2010 2010 2010 2010 2010 2010 2010 ...
 $ Name      : Factor w/ 128 levels "A J & J E Ivicevich",..: 79 49 72 88 123 8 32 67 125 13 ...
 $ Activity  : Factor w/ 26 levels "Aluminium smelting",..: 1 2 2 2 2 3 4 4 5 6 ...
 $ Allocation: int  210421 3653 47144 4712 1848 93275 16818 34 39164 4958 ...
 $ Value     : num  3699201 64220 828792 82837 32488 ... 
 
# What was the total market value of all the units allocated  from 2010 to 2018?
sum(nzu2010to2018[["Value"]])
[1] 473726448
# or 473,726,448 or 473 million $NZ

# How many emissions units have been given away
sum(nzu2010to2018[["Allocation"]])
[1] 38976259
# or 38.9 million units 

# Create .csv formatted data file
write.csv(nzu2010to2018, file = "nzu2010to2018.csv", sep = ",", col.names = TRUE, qmethod = "double",row.names = FALSE)
