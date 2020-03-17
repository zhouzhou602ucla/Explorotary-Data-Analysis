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
data <- subset(dt, Date <= "2007-02-02" & Date >= "2007-02-01")

## Plot "plot1.png"
png(filename = "plot1.png",width = 480, height = 480)
hist(data$Global_active_power, xlab = "Global Active Power (kilowatts)", ylab = "Frequency", main = "Global Active Power", col = "red")
dev.off()


