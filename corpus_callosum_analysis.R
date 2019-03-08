setwd("/Your/path")
getwd()
list.files()
cc <- read.csv("results_training_v3.csv", sep=",", dec=".", header=T)
fiq <- read.csv("fiq_training_v1.csv", sep=";", dec=".", header=T)
# merge two data frames by ID
ccfiq <- merge(cc,fiq,by="subject")
# import the segmentation data provided by the organizers (previously removed the variable description from row #2
seg <- read.csv("btsv01_anlz.csv", sep=",", dec=".", header=T)
ccfiq_seg <- merge(ccfiq,seg,by="subject")
summary(ccfiq_seg)
attach(ccfiq_seg)
names(ccfiq_seg)
cor(C5, residual_fluid_intelligence_score)
cor(W7, residual_fluid_intelligence_score)
hist(C5)
plot(C5, residual_fluid_intelligence_score, pch=20, cex=0.5)
hist(residual_fluid_intelligence_score)
C5p <- C5/CC_area
C4p <- C4/CC_area
fit <- lm(residual_fluid_intelligence_score~C5/CC_area+C4/CC_area+C3/CC_area+C2/CC_area+C1/CC_area, data=ccfiq)
summary(fit)
fit <- lm(residual_fluid_intelligence_score~C5/CC_area+C1/CC_area, data=ccfiq)
summary(fit)

plot(C5/CC_area, residual_fluid_intelligence_score, pch=20, cex=0.5)
cor(C5/CC_area, residual_fluid_intelligence_score)
cor(C1/CC_area, residual_fluid_intelligence_score)
cor((C5/CC_area)/(C1/CC_area), residual_fluid_intelligence_score)

fit <- lm(residual_fluid_intelligence_score~C5/CC_area+C4/CC_area+C1/CC_area, data=ccfiq)
summary(fit)

fit <- lm(residual_fluid_intelligence_score~W7/CC_area+W6/CC_area+W1/CC_area+W2/CC_area+W3/CC_area, data=ccfiq)
summary(fit)

fit <- lm(residual_fluid_intelligence_score~W7/CC_area+W2/CC_area, data=ccfiq)
summary(fit)
#
fit <- lm(residual_fluid_intelligence_score~C5/CC_area+C1/CC_area, data=ccfiq)
summary(fit)
fit <- lm(residual_fluid_intelligence_score~W7/CC_area+W2/CC_area, data=ccfiq)
summary(fit)
