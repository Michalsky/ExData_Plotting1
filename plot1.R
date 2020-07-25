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
#Open PNG Device 480x480 pixels
png("./figure/plot1.png", width = 480, height = 480, units = "px")
#Plot histogram
hist(power_cons$Global_active_power, freq = TRUE, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power")
#Close Device
dev.off()