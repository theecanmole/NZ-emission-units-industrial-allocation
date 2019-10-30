# combine the NZU emission unit industrial allocation data from the NZ EPA from 2010 to 2018

# check the working directory and set if necessary
# setwd("/home/user/r/eur/2010t02018")
getwd()
[1] "/home/user/r/eur/2010to2018"

# read in the csv formatted data files downloaded from Google sheets
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

# check the new dataframe
str(nzu2010to2018)
'data.frame':	1038 obs. of  5 variables:
 $ Year      : int  2010 2010 2010 2010 2010 2010 2010 2010 2010 2010 ...
 $ Name      : Factor w/ 207 levels "A J & J E Ivicevich",..: 79 49 72 88 123 8 32 67 125 13 ...
 $ Activity  : Factor w/ 48 levels "Aluminium smelting",..: 1 2 2 2 2 3 4 4 5 6 ...
 $ Allocation: int  210421 3653 47144 4712 1848 93275 16818 34 39164 4958 ...
 $ Value     : num  3699201 64220 828792 82837 32488 ...

# Create .csv formatted data file
write.csv(nzu2010to2018, file = "nzu2010to2018.csv", sep = ",", col.names = TRUE, qmethod = "double",row.names = FALSE)

# Create a Windows Excel 2007/10 formatted data file
write.csv(nzu2010to2018, file = "nzu2010to2018.xls", row.names = FALSE, fileEncoding = "UTF-16LE") 

# read in the new 2010 2018 data 
nzu2010to2018 <- read.csv("nzu2010to2018.csv") 

# How many emissions units have been given away
sum(nzu2010to2018[["Allocation"]])
[1] 38976259
# or 38.9 million units 

# How many emission units were allocated for each year
annualallocations <- aggregate(Allocation ~ Year, nzu2010to2018, sum)
# check the data frame
str(annualallocations) 
'data.frame':	9 obs. of  2 variables:
 $ Year      : int  2010 2011 2012 2013 2014 2015 2016 2017 2018
 $ Allocation: int  1766456 3466694 3457468 4817947 4481067 4329248 4307391 5606415 6743573
# print the dataframe 
annualallocations 
  Year Allocation
1 2010    1766456
2 2011    3466694
3 2012    3457468
4 2013    4817947
5 2014    4481067
6 2015    4329248
7 2016    4307391
8 2017    5606415
9 2018    6743573
# linear regression 
linearregression <- lm(Allocation ~ Year, annualallocations)
plot(annualallocations,type='b')
lines(abline(linearregression))
Call:
lm(formula = Allocation ~ Year, data = annualallocations)
Residuals:
    Min      1Q  Median      3Q     Max 
-941264 -460427   44732  512937  946231 
Coefficients:
              Estimate Std. Error t value Pr(>|t|)   
(Intercept) -920054286  174545511  -5.271  0.00116 **
Year            458980      86666   5.296  0.00113 **
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 671300 on 7 degrees of freedom
Multiple R-squared:  0.8003,	Adjusted R-squared:  0.7717 
F-statistic: 28.05 on 1 and 7 DF,  p-value: 0.001128

# create a numeric vector for a graph
annual <- annualallocations[["Allocation"]] 

# Add name attribute to numeric vector
names(annual)<- annualallocations[["Year"]]
str(annual)
Named int [1:9] 1766456 3466694 3457468 4817947 4481067 4329248 4307391 5606415 6743573
 - attr(*, "names")= chr [1:9] "2010" "2011" "2012" "2013"..

# create plot in SVG format
#png("Emissionunits-2010-2018-560by420.png", bg="white", width=560, height=420,pointsize = 14)
svg(filename ="annualallocations_720-540.svg", width = 8, height = 6, pointsize = 14, onefile = FALSE, family = "sans", bg = "white")
par(mar=c(4, 4, 4, 1)+0.1)
barplot(annual/10^6,las=1, beside = TRUE, col=c("lightgray")) 
title(cex.main=1.4,main="NZ Emission Units Allocated to Industry 2010 - 2018",ylab="million units")
mtext(side=1,line=2.5,cex=0.8,expression(paste("Source: https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")))
mtext(side=3,line=0,cex=0.9,expression(paste("Since 2010 emitting industries were given 38.9 million free emission units")))
dev.off()

svg(filename ="annualallocationsline_720-540.svg", width = 8, height = 6, pointsize = 14, onefile = FALSE, family = "sans", bg = "white")    
par(mar=c(3.1,3.1,1,1)+0.1)
# ylim=c(0,7^6),
plot(annualallocations[["Year"]],annualallocations[["Allocation"]]/10^6,ylim=c(0,8),tck=0.01, axes=T,ann=T,las=1,pch=20, cex=0.75,type="o",col=2,lwd=2)
#axis(side=2, tck=0.01, at = c(1^6,2^6,3^6,4^6,5^6,6^6,7^6), labels = c("1","2","3","4","5","6","7"), tick = T,lwd=1,lwd.tick=1)
axis(side=2, tck=0.01, at = NULL, labels = NULL, tick = T,lwd=0,lwd.tick=1,las=1)
#axis(side=4, tck=0.01, at = NULL, labels = NULL, tick = T,lwd=1,lwd.tick=1)
grid()
box()
lines(annualallocations,col=2,lwd=2,lty=1)
mtext(side=2,cex=1, line=-1.5,expression(paste("million units")))
mtext(side=3,cex=1.3, line=-2,expression(paste("NZ Emission Units Allocated to Industry 2010 to 2018")))
mtext(side=1,line=-2,cex=1,expression(paste("Data: EPA")))
mtext(side=1,cex=0.7, line=-1.3,"https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")
dev.off()

png("Emissionunits-2010-2018-560by420.png", bg="white", width=560, height=420,pointsize = 14)
par(mar=c(4, 4, 4, 1)+0.1)
barplot(annual/10^6,las=1, beside = TRUE, col=c("lightgray")) 
title(cex.main=1.4,main="NZ Emission Units Allocated to Industry 2010 - 2018",ylab="million units")
mtext(side=1,line=2.5,cex=0.8,expression(paste("Source: https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")))
mtext(side=3,line=0,cex=0.9,expression(paste("Since 2010 emitting industries were given 38.9 million free emission units")))
dev.off()

plot(annualallocations[["Year"]],annualallocations[["Allocation"]]/10^6, ylim=c(0,7^6),ylab="",las=1, col=c("lightgray"))
lines(annualallocations[["Year"]],annualallocations[["Allocation"]]/10^6)
title(cex.main=1.4,main="NZ Emission Units Allocated to Industry 2010 - 2018",ylab="million units")
mtext(side=1,line=2.5,cex=0.8,expression(paste("Source: https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")))
mtext(side=3,line=0,cex=0.9,expression(paste("Since 2010 emitting industries were given 38.9 million free emission units")))
dev.off()
# What was the total market value of all the units allocated  from 2010 to 2018?
sum(nzu2010to2018[["Value"]])
[1] 473726448
# or 473,726,448 or $NZ473 million 

# How many units allocated for each industrial Activity?
#sumactivity <- aggregate(Allocation ~ Activity, nzu2010to2018, sum)

# How many units allocated for each emitter?
emitterunits <- aggregate(Allocation ~ Name, nzu2010to2018,sum)
head(emitterunits)
                             Name Allocation
1             A J & J E Ivicevich        665
2       ACI Operations NZ Limited     164400
3       Affco New Zealand Limited      26098
4          Alliance Group Limited      58510
5 Alwyn Ernest & Anne Marie Inger       1528
6          Anchor Ethanol Limited      51014

# How many units were given to New Zealand Steel Development Limited each year?
nzu2010to2018[(nzu2010to2018[["Name"]]=="New Zealand Steel Development Limited"),c("Year","Allocation")]
    Year Allocation
108  2010     494704
258  2011     989304
397  2012    1003730
521  2013    1029352
631  2014    1073489
739  2015    1067501
833  2016    1048116
921  2017    1432496
1008 2018    1782366

# How many units were given to New Zealand Steel Development Limited in total?
sum(nzu2010to2018[(nzu2010to2018[["Name"]]=="New Zealand Steel Development Limited"),c("Year","Allocation")])
[1] 9939184
# 10 million

# What was the market value of the units given to New Zealand Steel Development Limited in total?
sum(nzu2010to2018[(nzu2010to2018[["Name"]]=="New Zealand Steel Development Limited"),c("Value")])
[1] 124212977
# 124 million dollars

# What was the market value of the units given to New Zealand Steel Development Limited each year?
nzu2010to2018[(nzu2010to2018[["Name"]]=="New Zealand Steel Development Limited"),c("Year","Value")]
    Year    Value
108  2010  8696896
258  2011 19627791
397  2012  6253238
521  2013  1996943
631  2014  4379835
739  2015  5700455
833  2016 15333937
921  2017 24295132
1008 2018 37928748

# How many units given to NZ Steel each year?
nzu2010to2018[(nzu2010to2018[["Name"]]=="New Zealand Steel Development Limited"),c("Year","Allocation")]
     Year Allocation
108  2010     494704
258  2011     989304
397  2012    1003730
521  2013    1029352
631  2014    1073489
739  2015    1067501
833  2016    1048116
921  2017    1432496
1008 2018    1782366

# create a subset of NZ Steel allocations for charting 
nzsteelunits <-c(nzu2010to2018[(nzu2010to2018[["Name"]]=="New Zealand Steel Development Limited"),c("Allocation")])
nzsteelvalue <-c(nzu2010to2018[(nzu2010to2018[["Name"]]=="New Zealand Steel Development Limited"),c("Value")])
str(nzsteelunits)
 num [1:9] 8696896 19627791 6253238 1996943 4379835 ...  

 # Add name attribute to numeric vector
names(nzsteelunits)<-c(nzu2010to2018[(nzu2010to2018[["Name"]]=="New Zealand Steel Development Limited"),c("Year")])  
str(nzsteelunits)
 Named num [1:9] 8696896 19627791 6253238 1996943 4379835 ...
 - attr(*, "names")= chr [1:9] "2010" "2011" "2012" "2013" ...  
 
png("NZ-Steelunits-2010-2018-560by420-v1.png", bg="white", width=560, height=420,pointsize = 14)
par(mar=c(4, 4, 4, 1)+0.1)
barplot(nzsteelunits/10^6,las=1, beside = TRUE, col=c("#F0E442")) 
title(cex.main=1.4,main="NZ Steel ETS Emission Units Allocated 2010 - 2018",ylab="million units")
mtext(sid=1,line=2.5,cex=0.8,expression(paste("Source: https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")))
dev.off()

png("NZ-Steel-unit-value-2010-2018-720by540.png", bg="white", width=720, height=540,pointsize = 14)
par(mar=c(4, 4, 4, 1)+0.1)
barplot(nzsteelvalue/10^6,las=1, beside = TRUE, col=c("#F0E442")) 
title(cex.main=1.3,main="Value of emission units allocated to NZ Steel 2010 - 2018",ylab="$NZ million")
mtext(sid=1,line=2.5,cex=0.8,expression(paste("Source: https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")))
dev.off()

# How many were given to  New Zealand Aluminium Smelters Limited ?
emitterunits[(emitterunits[["Name"]]=="New Zealand Aluminium Smelters Limited"),]
                                     Name Allocation
79 New Zealand Aluminium Smelters Limited    7151987
# 7.15187 million units

# How many were given to  New Zealand Aluminium Smelters Limited each year?
# How many units allocated to the NZ Alumium Smelter Ltd per year but just tell me year and amount
nzu2010to2018[(nzu2010to2018[["Name"]]=="New Zealand Aluminium Smelters Limited"),c("Year","Allocation")]
    Year Allocation
1   2010     210421
142 2011     437681
293 2012     301244
430 2013    1524172
554 2014     755987
664 2015     772706
772 2016     786306
866 2017    1038914
955 2018    1324556

# How many $$ value per year but just tell me year and value
nzu2010to2018[(nzu2010to2018[["Name"]]=="New Zealand Aluminium Smelters Limited"),c("Year","Allocation","Value")]

nzu2010to2018[(nzu2010to2018[["Name"]]=="New Zealand Aluminium Smelters Limited"),c("Year","Allocation","Value")]
    Year Allocation    Value
1   2010     210421  3699201
142 2011     437681  8683591
293 2012     301244  1876750
430 2013    1524172  2956894
554 2014     755987  3084427
664 2015     772706  4126250
772 2016     786306 11503657
866 2017    1038914 17619981
955 2018    1324556 28186552

> sum(nzu2010to2018[(nzu2010to2018[["Name"]]=="New Zealand Aluminium Smelters Limited"),c("Allocation")])
[1] 7151987
> sum(nzu2010to2018[(nzu2010to2018[["Name"]]=="New Zealand Aluminium Smelters Limited"),c("Value")])
[1] 81737303

# How many units allocated to NZ Aluminium Smelters each year?
nzasunits <- nzu2010to2018[(nzu2010to2018[["Name"]]=="New Zealand Aluminium Smelters Limited"),c("Year","Allocation","Value")]
str(nzasunits)
'data.frame':	9 obs. of  3 variables:
 $ Year      : int  2010 2011 2012 2013 2014 2015 2016 2017 2018
 $ Allocation: int  210421 437681 301244 1524172 755987 772706 786306 1038914 1324556
 $ Value     : num  3699201 8683591 1876750 2956894 3084427  
 
barplot(nzasunits[["Allocation"]]/10^6,las=1, beside = TRUE, col=c("#F0E442")) 
title(cex.main=1.4,main="NZ Aluminium Smelter Ltd Emission Units Allocated 2010 - 2018",ylab="million units")
mtext(sid=1,line=2.5,cex=1,expression(paste("Source: https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")))
mtext(side=3,line=-1,cex=1,expression(paste("Since 2010 New Zealand Aluminium Smelter were given 7 million free emission units ")))
dev.off()
 
 # How many were given to  New Zealand Aluminium Smelters Limited ?
nzal20102018 <- matrix(c(210421,437681,301244,1524172,755987,772706,786306,1038914,1324556), nrow = 1, ncol=9, byrow=TRUE, dimnames = list(c("Units"), c("2010", "2011", "2012","2013","2014","2015","2016","2017","2018")))

png("Smelter-2010-2018-560by420.png", bg="white", width=560, height=420,pointsize = 14)
par(mar=c(4, 4, 4, 1)+0.1)
barplot(nzal20102018/10^6,las=1) 
title(cex.main=1.2,main="NZETS Units Allocated to NZ Aluminium Smelters Ltd 2010 2018",ylab="NZ Units (millions)")
mtext(side=3,line=0.25,cex=0.8,expression(paste("NZAS Ltd were given 7 million free emission units")))
mtext(side=1,line=2.5,cex=0.8,expression(paste("Data: https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")))
dev.off()

svg(filename ="Smelter-2010-2018-allocations_720-540.svg", width = 8, height = 6, pointsize = 14, onefile = FALSE, family = "sans", bg = "white")
par(mar=c(4, 4, 4, 1)+0.1)
barplot(nzal20102018/10^6,las=1) 
title(cex.main=1.2,main="NZETS Units Allocated to NZ Aluminium Smelters Ltd 2010 2018",ylab="NZ Units (millions)")
mtext(side=3,line=0.25,cex=0.8,expression(paste("NZAS Ltd were given 7 million free emission units")))
mtext(side=1,line=2.5,cex=0.8,expression(paste("Data: https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")))
dev.off()

-----------------------------
# How many units were given to New Zealand Aluminium Smelter Limited each year?
nzasunits <- nzu2010to2018[(nzu2010to2018[["Name"]]=="New Zealand Aluminium Smelters Limited"),c("Year","Allocation","Value")]
str(nzasunits)



# How many units and value were given to New Zealand Aluminium Smelters Limited in total?
sum(nzu2010to2018[(nzu2010to2018[["Name"]]=="New Zealand Aluminium Smelters Limited"),c("Allocation")])
[1] 7151987

# What was the market value of the units given to New Zealand Aluminium Smelters Limited in total?
sum(nzu2010to2018[(nzu2010to2018[["Name"]]=="New Zealand Aluminium Smelters Limited"),c("Value")])
[1] 81737303
#  82 million dollars

# What was the market value of the units given to New Zealand Steel Development Limited each year?
nzu2010to2018[(nzu2010to2018[["Name"]]=="New Zealand Aluminium Smelters Limited"),c("Year","Value")]

# create a subset of NZ Steel allocations for charting 
nzsmelterunits <-c(nzu2010to2018[(nzu2010to2018[["Name"]]=="New Zealand Aluminium Smelters Limited"),c("Allocation")])
nzsmeltervalue <-c(nzu2010to2018[(nzu2010to2018[["Name"]]=="New Zealand Aluminium Smelters Limited"),c("Value")])
str(nzsmelterunits)

 # Add name attribute to numeric vector
names(nzsmelterunits)<-c(nzu2010to2018[(nzu2010to2018[["Name"]]=="New Zealand Aluminium Smelters Limited"),c("Year")])  
str(nzsmelterunits)
 Named num [1:9] 8696896 19627791 6253238 1996943 4379835 ...
 - attr(*, "names")= chr [1:9] "2010" "2011" "2012" "2013" ...  

names(nzsmeltervalue)<-c(nzu2010to2018[(nzu2010to2018[["Name"]]=="New Zealand Aluminium Smelters Limited"),c("Year")])
sum(nzsmeltervalue)
[1] 81737303

png("NZAS-Tiwai-units-2010-2018-560by420-v1.png", bg="white", width=560, height=420,pointsize = 14)
par(mar=c(4, 4, 4, 1)+0.1)
barplot(nzsmelterunits/10^6,las=1, beside = TRUE, col=c("#F0E442")) 
title(cex.main=1.4,main="NZ Aluminium Smelters Ltd - the number of \nthe emission units allocated from to 2010 to 2018",ylab="million units")
mtext(side=1,line=2.5,cex=0.8,expression(paste("Source: https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")))
dev.off()

png("NZASmelter-unit-value-2010-2018-560by420.png", bg="white", width=560, height=420,pointsize = 14)
par(mar=c(4, 4, 4, 1)+0.1)
barplot(nzsmeltervalue/10^6,las=1, beside = TRUE, col=c("#F0E442")) 
title(cex.main=1.3,main="NZ Aluminium Smelters Ltd - the market value of \nthe emission units allocated from 2010 to 2018",ylab="$NZ million")
mtext(sid=1,line=2.5,cex=0.8,expression(paste("Source: https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")))
dev.off()
