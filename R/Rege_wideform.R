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


###################input

#Define data locations
dataloc<-""
datafile<-"input_regen_test_data.csv"
population_counts_file<-"regen_population_counts_test.csv"

infile <- paste(dataloc,datafile,sep='')

population_counts_file <- paste(dataloc,population_counts_file,sep='')

input_data <-read.csv(infile)

population_counts <-read.csv(population_counts_file)

################### pre-processing


#enforce dtypes, ensure strata (cell) and calibration groups/estimation domains are factors.

input_data_with_counts <- merge(input_data, population_counts, by = c("period","cell"))

input_data_with_counts$extcalweights <- input_data_with_counts$aweight * input_data_with_counts$gweight

input_data_with_counts$winsorised_value <- input_data_with_counts$value * input_data_with_counts$outlier_weight


##### Regenesses stuf

#Switch off so get dummy encoding of matrix
contrasts.off()

######Using design to calculate domain estimates, variance etc

#Set up the calibration object by giving ReGenesees the survey design, weights and external calibration model used.
#--> must have var proportional to auxiliary otherwise estimates will be off (heteroskedasticity)

input_data_with_counts$cell <- as.factor(input_data_with_counts$cell)

input_data_with_counts$calibration_group <- input_data_with_counts$cell

caldesign <-ext.calibrated(ids=~ruref,
                           weights=~aweight,
                           strata=~cell,
                           fpc=~univcts,
                           data=input_data_with_counts,
                           weights.cal=~extcalweights,
                           calmodel=~(turnover:calibration_group) -1,
                           sigma2=~turnover)


#Calculate estimates, SEs and CVs of Totals at overall and size-band level
New_Total_estimates <- svystatTM(caldesign,
                             ~winsorised_value,
                             estimator='Total',
                             vartype=c('se','cv'),by=~question_no)  


New_Sizeb_estimates <- svystatTM(caldesign,
                             ~winsorised_value,
                             estimator='Total',
                             vartype=c('se','cv'),
                             by=~size_band+question_no)



########################## Exporting

output_df <- merge(input_data_with_counts, New_Sizeb_estimates, by = c("size_band","question_no"))

write.csv(output_df, paste("","post_regenesses.csv"), row.names = FALSE)




### Notes to ask methodology:
# 1: what to do with period var
# 2: Check details of winsorised value how it should be calculated
# 3: estimates by size band or total or both? Should it be configured
# 4: Check details input_data_with_counts$extcalweights <- input_data_with_counts$aweight * input_data_with_counts$gweight
# 5: should counts and extcalweights and winsorised value be calculated in estimation python
# 


