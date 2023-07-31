#####################################################################
# Cotton Production Data 
# Task forecast the price of cotton 
# Used data from Adiyami 
# created by Tonderai Madamba 
#####################################################################

library(ggplot2)
library(fpp2)
library(scales)
library(dplyr)
library(tidyr)
library(broom)
library(ggridges)
library(tidyverse)


rm(list=ls()) # clear all 
getwd()
setwd("C:/Users/19794/Desktop/") # Home-Locations

list.files(path = getwd()) # Get the file name 


my_data <- data.frame(read.table("Cotton_production_yield.csv" ,  header = T,  sep = "," , fill = TRUE))
names(my_data)

# [1] "ï..Year"                
# [2] "Acres.Planted"          
# [3] "Acres.Harvested"        
# [4] "YielD_per.Acre..lbs."   
# [5] "X480.lb.bale.production"
# [6] "Price.per.lb"           
# [7] "Value.of.Production.US"

# Declare time series variable for brice 
Price <- ts(my_data$Price.per.lb,start = c(1909,1))
Acres.Planted <- ts(my_data$Acres.Planted,start = c(1909,1))
Acres.Harvested <- ts(my_data$Acres.Harvested,start = c(1909,1))
Yield <- ts(my_data$Yield.per.Acre..lbs.,start = c(1909,1))
X480 <- ts(my_data$X480.lb.bale.production,start = c(1909,1))
US.Production <- ts(my_data$Value.of.Production.US,start = c(1909,1))

# autoplot(Price)
# autoplot(Acres.Planted)
# autoplot(Acres.Harvested)
# autoplot(Yield)
# autoplot(X480)
# autoplot(US.Production)

# Compare side by side 
par(mar=c(1, 1, 1, 1))
par(mfrow=c(2,3))
plot(Price)
plot(US.Production)
plot(X480)
plot(Yield)
plot(Acres.Harvested)
plot(Acres.Planted)
mtext("Plots Showing Trend", side = 3,cex = 2, line = -3, outer = TRUE, col = "red")


#####################################################################
# THERE IS TREND_... for analysis make data stationary and flat...
# TRANSFORM Data.... normalize make stationary remove trand that's the better terminology 
# To do this get the difference between first entry and second entry and so on. (diff)
#####################################################################

D_Price <- diff(Price)
D_Acres.Planted <- diff(Acres.Planted)
D_Acres.Harvested <- diff(Acres.Harvested)
D_Yield <- diff(Yield)
D_X480 <- diff(X480)
D_US.Production  <- diff(US.Production)

# ggseasonplot(D_Price)

# quick plot each plot 
 # autoplot(D_Price)
 # autoplot(D_US.Production)
 # autoplot(D_X480)
 # autoplot(D_Yield)
 # autoplot(D_Acres.Harvested)
 # autoplot(D_Acres.Planted)

# Compare side by side 
par(mfrow=c(2,3))
plot(D_Price)
plot(D_US.Production)
plot(D_X480)
plot(D_Yield)
plot(D_Acres.Harvested)
plot(D_Acres.Planted)
mtext("Trend Normalized by Delta", side = 3,cex = 2, line = -3, outer = TRUE, col = "red")

#### Forcasting 
#### naive method 
fit_Naive <- naive(Price)
print(summary(fit_Naive))  ### 0.1242 very low 
checkresiduals(fit_Naive) ### Not bat 
forcast(fit_arima)
par(mfrow=c(1,1))
plot(forecast(fit_Naive,h=10))
#### Forcasting 
#### ETS method exponantial smothers 
fit_ETS <- ets(Price)
print(summary(fit_ETS))  ### 0.08 very very low better than ets 
checkresiduals(fit_ETS) ### Not bat 
par(mfrow=c(1,1))
plot(forecast(fit_ETS,h=15))

#### Forcasting 
#### Arima Model 
Price <- ts(my_data$Price.per.lb,start = c(1909,1))
fit_arima <- auto.arima(Price, seasonal = FALSE)
print(summary(fit_arima))  ### 0.07764664 slightly better than ets 
checkresiduals(fit_arima) ### Not bat
## Forecast
par(mfrow=c(1,1))
plot(forecast(fit_arima,h=70))
