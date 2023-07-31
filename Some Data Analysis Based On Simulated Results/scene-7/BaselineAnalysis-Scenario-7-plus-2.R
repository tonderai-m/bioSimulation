library(ggplot2)
library(scales)
library(tidyr)
library(dplyr)
library(broom)
library(reshape2)
library(ggridges)
library(tidyverse)
library("xlsx")
getwd()
setwd("C:/Users/19794/Desktop/Some Data Analysis Based On Simulated Results/scene-7") # Home-Locations
list.files(path = getwd())
#my_data1<-data.frame(read.table("FactorialDesign-1.R",  header = T,  sep = "," , skip = 6, quote = "\"", fill = TRUE))
# memory.limit(size = 56000)
my_data1.1<-data.frame(read.table("experiment-scene-7a.csv",  header = T,  sep = "," , skip = 6, quote = "\"", fill = TRUE))
my_data1.2<-data.frame(read.table("experiment-scene-7b.csv",  header = T,  sep = "," , skip = 6, quote = "\"", fill = TRUE))
my_data1.3<-data.frame(read.table("experiment-scene-7c.csv",  header = T,  sep = "," , skip = 6, quote = "\"", fill = TRUE))
my_data1.4<-data.frame(read.table("experiment-scene-7d.csv",  header = T,  sep = "," , skip = 6, quote = "\"", fill = TRUE))

my_data1<- rbind(my_data1.1,my_data1.2,my_data1.3,my_data1.4)
str(my_data1)
my_data1 <-  data.frame(suppressWarnings(sapply(my_data1, as.numeric)))

my_data_L0_to_L7_Separate <- my_data1
names(my_data_L0_to_L7_Separate)
names(my_data1[c(44:54)])
my_data_L0_to_L7_Separate[c(44:54)] <- 10**my_data1[c(44:54)]
mydd_L0_to_L7 <- my_data_L0_to_L7_Separate  %>%
  group_by(R.1,R.2,R.3,ask.patches,ask.patches.2,X.run.number.) %>%
  summarise_all("mean", na.rm = TRUE)
  names(mydd_L0_to_L7[c(44:54)] )
  mydd_L0_to_L7[c(44:54)] <- log10(mydd_L0_to_L7[c(44:54)])

mydd_L0_to_L777 <- my_data_L0_to_L7_Separate %>%
  group_by(R.1,R.2,R.3,ask.patches,ask.patches.2) %>%
  summarise_all("mean", na.rm = TRUE)
  names(mydd_L0_to_L777[c(44:54)] )
  mydd_L0_to_L777[c(44:54)] <- log10(mydd_L0_to_L777[c(44:54)])
  
#memory.limit(size = 56000)
my_data_2.1 <-  my_data1
my_data_2 <- my_data_2.1[!is.na(my_data_2.1$AverageLoad),]

my_data_2$Condition1.4 <- ifelse(my_data_2$AverageLoad > -1.4,"Contaminated", "Safe")
my_data_2$Condition2 <- ifelse(my_data_2$AverageLoad > -2,"Contaminated", "Safe")

# nrow(my_data_2[my_data_2$Condition1.4  == "Contaminated" & my_data_2$R.1,R.2,R.3 == 13,])
# nrow(my_data_2[my_data_2$Condition1.4  == "Safe" & my_data_2$R.1,R.2,R.3 == 13,])
# nrow(my_data_2[my_data_2$Condition2  == "Contaminated" & my_data_2$R.1,R.2,R.3 == 13,])
# nrow(my_data_2[my_data_2$Condition2 == "Safe" & my_data_2$R.1,R.2,R.3 == 13,])

mydd_L0_to_L8 <-my_data_2  %>%
  group_by(p.L1.to.L4.nc, p.L6.to.L7.nc)  %>%
  count(R.1,R.2,R.3,ask.patches,ask.patches.2,Condition2)

# mydd_L0_to_L8.1 <-my_data_2  %>%
#   count(R.1,R.2,R.3,Condition2)

mydd_L0_to_L9 <-my_data_2  %>%
  group_by(p.L1.to.L4.nc, p.L6.to.L7.nc)  %>%
  count(R.1,R.2,R.3,ask.patches,ask.patches.2,Condition1.4)
# 
# mydd_L0_to_L9.1 <-my_data_2  %>%
#   count(R.1,R.2,R.3,ask.patches,ask.patches.2,Condition1.4)

mydd_L0_to_L12 <-my_data_2  %>%
  group_by(p.L1.to.L4.nc, p.L6.to.L7.nc)  %>%
  count(X.run.number.,R.1,R.2,R.3,ask.patches,ask.patches.2,Condition1.4)

# mydd_L0_to_L12.1 <-my_data_2  %>%
#   count(X.run.number.,R.1,R.2,R.3,Condition1.4)

mydd_L0_to_L13 <-my_data_2  %>%
  group_by(p.L1.to.L4.nc, p.L6.to.L7.nc)  %>%
  count(X.run.number.,R.1,R.2,R.3,ask.patches,ask.patches.2,Condition2)  

# mydd_L0_to_L13.1 <-my_data_2  %>%
#   count(X.run.number.,R.1,R.2,R.3,Condition2) 


my_data_2_2 <- my_data_2
my_data_2_2$ask.patches.2 <- as.factor(my_data_2$ask.patches.2)
str(my_data_2$ask.patches.2)
levels(my_data_2_2$ask.patches.2)

my_data_2_2$ask.patches <- as.factor(my_data_2$ask.patches)
str(my_data_2$ask.patches)
levels(my_data_2_2$ask.patches)

my_data_2_2$R.1 <- as.factor(my_data_2$R.1)
str(my_data_2$R.1)
levels(my_data_2_2$R.1)

my_data_2_2$p.L1.to.L4.nc <- as.factor(my_data_2$p.L1.to.L4.nc)
str(my_data_2$p.L1.to.L4.nc)
levels(my_data_2_2$p.L1.to.L4.nc)

my_data_2_2$p.L6.to.L7.nc <- as.factor(my_data_2$p.L6.to.L7.nc)
str(my_data_2$p.L6.to.L7.nc)
levels(my_data_2_2$p.L6.to.L7.nc)

my_data_2$p.L1.to.L4.nc

my_data_2.1 <- my_data_2_2[my_data_2_2$R.1 == 0 & my_data_2_2$ask.patches == 0.3 & my_data_2_2$p.L1.to.L4.nc == 3, ]#my_data_2_2$p.L6.to.L7.nc == 3 & 

my_data_2_3 <- my_data_2.1[44:51]
names(my_data_2_3)

my_data_2_5 <- my_data_2_3 %>% 
  rename(  L0 = Average.Amount.LogCFU.L0,
           L1 = Average.Amount.LogCFU.L1,
           L2 = Average.Amount.LogCFU.L2,
           L3 = Average.Amount.LogCFU.L3,
           L4 = Average.Amount.LogCFU.L4,
           L5 = Average.Amount.LogCFU.L5,
           L6 = Average.Amount.LogCFU.L6,
           L7 = Average.Amount.LogCFU.L7)

my_data_2_5 <- my_data_2_5 %>% 
  mutate(id = row_number())

my_data_2_6 <- data.frame(melt(my_data_2_5, id="id"))
my_data_2_6 <- data.frame(my_data_2_6)

my_data_2_6$variable <- as.factor(my_data_2_6$variable)
str(my_data_2_6$variable)
levels(my_data_2_6$variable)

myplot <- ggplot(data = na.omit(my_data_2_6[my_data_2_6$value > -2,]), aes(x= variable, y=value, na.rm = TRUE)) +
  geom_boxplot(fill="grey", lwd=0.8) +  
  theme_bw() +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.1,decimal.mark = '.'),limits = c(-2,2.5)) +
  labs( x = "Facility Equipment" , y =  "Average Contamination Level [logCFU/g]") + 
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.margin = margin(2.8,2.4,1.2,.9, "cm"),# top(t), righ(r), bottom(b), leftt(l)
        axis.ticks = element_line(size = 1, color="Black") ,
        axis.title.x = element_text(vjust = -5, size=25),
        axis.title.y = element_text(vjust = 5, size=25),
        axis.ticks.length.y = unit(.30, "cm"),
        axis.ticks.length.x = unit(.30, "cm"),
        axis.line = element_line( color = "Black", size = 1),
        panel.border = element_rect(colour = "black", fill=NA, size=1.3),
        axis.text.y = element_text( size = 20), # change right 
        axis.text.y.left = element_text(margin = margin(.3,.5,.3,.3, "cm")),
        axis.text.x.bottom = element_text(vjust = -1 ),
        axis.text.x = element_text( size = 20) )  
myplot
jpeg(file="C:/Users/19794/Desktop/ Scene-7-Facility_Equipment_vs_Contamination_FC [0 0 0]_probability[0.3].jpeg",width=924, height=693)
print(myplot)
dev.off()


myplot.1 <- ggplot(data = my_data_2_2[my_data_2_2$AverageLoad > -2 & my_data_2_2$ask.patches != 0 ,], aes(x=ask.patches, y=AverageLoad)) +
  geom_boxplot(fill="grey", lwd=0.8) +  
  theme_bw() +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.1,decimal.mark = '.')) +
  labs( x = "Percentage Of Contaminated Surface", y =  "Avarage contamination level [logCFU/g]") + 
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.margin = margin(2.8,2.4,1.2,.9, "cm"),# top(t), righ(r), bottom(b), leftt(l)
        axis.ticks = element_line(size = 1, color="Black") ,
        axis.title.x = element_text(vjust = -5, size=25),
        axis.title.y = element_text(vjust = 5, size=25),
        axis.ticks.length.y = unit(.30, "cm"),
        axis.ticks.length.x = unit(.30, "cm"),
        axis.line = element_line( color = "Black", size = 1),
        panel.border = element_rect(colour = "black", fill=NA, size=1.3),
        axis.text.y = element_text( size = 20), # change right 
        axis.text.y.left = element_text(margin = margin(.3,.5,.3,.3, "cm")),
        axis.text.x.bottom = element_text(vjust = -1 ),
        axis.text.x = element_text( size = 20) ) 
myplot.1
jpeg(file="C:/Users/tonderaimadamba/OneDrive - Texas A&M University/Project/Scenarios/scene-7/ResultsScenario-7/04_Contamination-level_vs_ask.patches.jpeg",width=924, height=693)
print(myplot)
dev.off()

my_data_2_2.1 <- my_data_2_2[my_data_2_2$AverageLoad > -2,]
names(my_data_2_2.1)
my_now_data <- cbind(my_data_2_2.1[c(7, 10,36, 18,  19,35, 17, 52:56, 62:63)])
names(my_now_data)
names(my_data_2_2.1[c(7, 10,36, 18, 35, 17, 19, 52:56, 62:63)])

myplot_2 <- ggplot(data = my_data_2_2[my_data_2_2$AverageLoad > -2,], aes(x= R.1, y=AverageLoad)) +
  geom_boxplot(fill="grey", lwd=0.8) +  
  theme_bw() +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.1,decimal.mark = '.')) +
  labs( x = "Initial Free Chlorine [mg/L]", y =  "Avarage contamination level [logCFU/g]") + 
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.margin = margin(2.8,2.4,1.2,.9, "cm"),# top(t), righ(r), bottom(b), leftt(l)
        axis.ticks = element_line(size = 1, color="Black") ,
        axis.title.x = element_text(vjust = -5, size=25),
        axis.title.y = element_text(vjust = 5, size=25),
        axis.ticks.length.y = unit(.30, "cm"),
        axis.ticks.length.x = unit(.30, "cm"),
        axis.line = element_line( color = "Black", size = 1),
        panel.border = element_rect(colour = "black", fill=NA, size=1.3),
        axis.text.y = element_text( size = 20), # change right 
        axis.text.y.left = element_text(margin = margin(.3,.5,.3,.3, "cm")),
        axis.text.x.bottom = element_text(vjust = -1 ),
        axis.text.x = element_text( size = 20) )
myplot_2
jpeg(file="C:/Users/19794/Desktop/ Contamination-level_vs_Chlorination_Combined.jpeg",width=924, height=693)
print(myplot_2)
dev.off()


write.csv(as.data.frame(mydd_L0_to_L7),"C:/Users/tonderaimadamba/OneDrive - Texas A&M University/Project/Scenarios/scene-7/ResultsScenario-7/accross-replication.csv")
write.csv(as.data.frame(mydd_L0_to_L777),"C:/Users/tonderaimadamba/OneDrive - Texas A&M University/Project/Scenarios/scene-7/ResultsScenario-7/accross-FC.csv")
write.csv(as.data.frame(mydd_L0_to_L8),"C:/Users/tonderaimadamba/OneDrive - Texas A&M University/Project/Scenarios/scene-7/ResultsScenario-7/package-counts-negative-2.csv")
write.csv(as.data.frame(mydd_L0_to_L9),"C:/Users/tonderaimadamba/OneDrive - Texas A&M University/Project/Scenarios/scene-7/ResultsScenario-7/package-counts-negative-1.4logs.csv")
write.csv(as.data.frame(mydd_L0_to_L12),"C:/Users/tonderaimadamba/OneDrive - Texas A&M University/Project/Scenarios/scene-7/ResultsScenario-7/replication-package-counts-negative-1.4logs.csv")
write.csv(as.data.frame(mydd_L0_to_L13),"C:/Users/tonderaimadamba/OneDrive - Texas A&M University/Project/Scenarios/scene-7/ResultsScenario-7/replication-package-counts-negative-2logs.csv")
write.csv(as.data.frame(my_now_data),"C:/Users/tonderaimadamba/OneDrive - Texas A&M University/Project/Scenarios/scene-7/ResultsScenario-7/raw-data.csv")



