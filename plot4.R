library(ggplot2)
library(lubridate)
library(ggpubr)
## Load the data
dt <- read.delim("household_power_consumption.txt",sep = ";", header = TRUE)

## Format the variables "Date" and "Time"
dt$Date <- as.Date(dt$Date, "%d/%m/%Y")
dt$DateAndTime <- strptime(paste(dt$Date,dt$Time),format = "%Y-%m-%d %H:%M:%S")

## Create "NA" for those which was coded by "?"
dt$Global_active_power <- gsub(pattern = "^?", replacement = "", dt$Global_active_power)
## Read "Global_active_power" as numerical variable
dt$Global_active_power <- as.numeric(dt$Global_active_power)

## Keep data from the dates 2007-02-01 and 2007-02-02
data <- subset(dt, Date < "2007-02-03" & Date > "2007-01-31")
data$Sub_metering_1 <- as.numeric(gsub(pattern = "^?", replacement = "", data$Sub_metering_1))
data$Sub_metering_2 <- as.numeric(gsub(pattern = "^?", replacement = "", data$Sub_metering_2))
data$Sub_metering_3 <- as.numeric(gsub(pattern = "^?", replacement = "", data$Sub_metering_3))
data$DateAndTime2 <- as.POSIXct(data$DateAndTime)
data$Voltage <- as.numeric(gsub(pattern = "^?", replacement = "", data$Voltage))
data$Global_reactive_power <- as.numeric(gsub(pattern = "^?", replacement = "", data$Global_reactive_power))

## Set figure location
f1 <- ggplot(data = data, aes(x = DateAndTime2, y = Global_active_power))+ geom_line()+ xlab("")+ ylab("Global Active Power (kilowatts)") + scale_x_datetime(date_breaks = 'day',date_labels = '%a')

f2 <- ggplot(data = data, aes(x = DateAndTime2))+ 
  geom_line(aes(y = Sub_metering_1, colour = "Sub_metering_1"),size=0.5)+ 
  geom_line(aes(y = Sub_metering_2, colour = "Sub_metering_2"),size=0.5)+
  geom_line(aes(y = Sub_metering_3, colour = "Sub_metering_3"),size=0.5)+
  xlab("")+
  ylab("Energy sub metering")+
  scale_x_datetime(date_breaks = 'day',date_labels = '%a')+
  scale_colour_manual("",breaks = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), values=c("red","black","blue"))+
  theme(legend.position=c(0.8, 0.8))+
  theme(legend.margin = margin(6, 6, 6, 6))+
  theme(legend.key = element_blank())+
  theme(legend.text=element_text(size=8))

f3 <- ggplot(data=data, aes(x = DateAndTime2, y = Voltage))+
  geom_line()+
  xlab("datetime")+
  ylab("Voltage")+
  scale_x_datetime(date_breaks = 'day',date_labels = '%a')

f4 <- ggplot(data=data, aes(x = DateAndTime2, y = Global_reactive_power))+
  geom_line()+
  xlab("datetime")+
  ylab("Global_reactive_power")+
  scale_x_datetime(date_breaks = 'day',date_labels = '%a')

png(filename = "plot4.png",width = 480, height = 480)
ggarrange(f1,f3,f2,f4,nrow=2,ncol=2)
dev.off()