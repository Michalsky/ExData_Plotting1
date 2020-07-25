#Load SQLDF library
library('sqldf')

#Download and unzip data
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "power_consumption.zip")
unzip("./power_consumption.zip")


#Query data for specific time-frame and do minor data formatting
file_query <- "SELECT Date,
                      strftime('%H:%M:%S', Time) Time,
                      Global_active_power,
                      Global_reactive_power,
                      Voltage,
                      Global_intensity,
                      Sub_metering_1,
                      Sub_metering_2,
                      Sub_metering_3 
              FROM file WHERE Date = '1/2/2007' or Date = '2/2/2007'"

file_name = "household_power_consumption.txt"

power_cons <- read.csv.sql(file_name, file_query, sep=";")
power_cons$Date <- as.Date(power_cons$Date, '%d/%m/%Y')

#Replace ? with NA in the dataset
power_cons[power_cons$Global_active_power == '?'] <- NA
power_cons[power_cons$Global_reactive_power == '?'] <- NA
power_cons[power_cons$Voltage == '?'] <- NA
power_cons[power_cons$Global_intensity == '?'] <- NA
power_cons[power_cons$Sub_metering_1 == '?'] <- NA
power_cons[power_cons$Sub_metering_2 == '?'] <- NA
power_cons[power_cons$Sub_metering_3 == '?'] <- NA

#Generate datetime column to be used in plots
power_cons$datetime <- as.POSIXlt(strftime(paste(power_cons$Date,power_cons$Time), '%Y-%m-%d %H:%M:%S'), '%Y-%m-%d %H:%M:%S', tz=Sys.timezone())
#Open PNG Device with 480x480 pixels
png("./figure/plot4.png", width = 480, height = 480, units = "px")
#Specify plot layout 2x2
par(mfrow=c(2,2))  
#Plot top-left
plot(power_cons$datetime,power_cons$Global_active_power, xlab = "", ylab = "Global Active Power (kilowatts)", type = "l")
#Plot top-right
plot(power_cons$datetime,power_cons$Voltage, ylab = "Voltage", xlab = "datetime", type="l")
#Plot bottom-left
plot(power_cons$datetime,power_cons$Sub_metering_1, xlab = "", ylab = "Energy Sub Metering", type = "l")
#Add other lines to existing 3rd plot
lines(power_cons$datetime,power_cons$Sub_metering_2, type="l", col="red")
lines(power_cons$datetime,power_cons$Sub_metering_3, type="l", col="blue")
#Create borderless legend in the top right of 3rd plot
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=c(1,1,1),col=c("black","red","blue"),bg="white", bty="n")
#Plot bottom-right
plot(power_cons$datetime,power_cons$Global_reactive_power,ylab = "Global_reactive_power", xlab="datetime", type="l")
#Close Device
dev.off()