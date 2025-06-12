################################################################
#
# Simple example of using ReGenesees to produce estimates and 
# standard errors/CVs using externally calibrated weights.

# This example is for the Construction Survey and the weights will 
# have been calculated using the SML Estimation method.
#
# Jonathan Digby-North 12.07.2022
#
#
#
###############################################################

#Load package
library(ReGenesees)

#Define data locations
dataloc<-"Rsurveymethod/tests/"
datafile<-"minitest_cons.csv"
infile <- paste(dataloc,datafile,sep='')

outdir<- ""


#Read data
#Ensure strata (cell) and calibration groups/estimation domains are factors. FileEncoding will depend on file being imported
data1<-read.csv(infile, 
                colClasses=c(rep('numeric',3),
                           'factor',
                           rep('numeric',2),
                           rep('factor',2),
                           rep('numeric',3)
                           ,'factor' ), 
                fileEncoding="UTF-8-BOM")

#Switch off so get dummy encoding of matrix
contrasts.off()

######Using design to calculate domain estimates, variance etc

#Set up the calibration object by giving ReGenesees the survey design, weights and external calibration model used.
#--> must have var proportional to auxiliary otherwise estimates will be off (heteroskedasticity)

caldesign <-ext.calibrated(ids=~ruref,
                           weights=~aweight,
                           strata=~cell,
                           fpc=~univcts,
                           data=data1,
                           weights.cal=~extcalweights,
                           calmodel=~(turnover:calibration_group) -1,
                           sigma2=~turnover)


#Calculate estimates, SEs and CVs of Totals at overall and size-band level
Total_estimates <- svystatTM(caldesign,
                             ~var1+var2+var3,
                             estimator='Total',
                             vartype=c('se','cv'),by=~all)  #all added so format of results is same


Sizeb_estimates <- svystatTM(caldesign,
                             ~var1+var2+var3,
                             estimator='Total',
                             vartype=c('se','cv'),
                             by=~size_band)

#Output the data so can be accessed by rest of pipeline
write.csv(Total_estimates, paste(outdir,"total_estimates.csv"), row.names = FALSE)
write.csv(Sizeb_estimates, paste(outdir,"Sizeb_estimates.csv"), row.names = FALSE)
