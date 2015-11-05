## This script downloads a zip file from Uc Irvine Machine Learning Repository,
## which contains household power consumption data from one household with a 
## one-minute sampling rate over a period of 4 years.  

## This script produces a .png file containing a line plot of the
## Global active power data in kilowatts, a line plot of the voltage
## data in kilowatts, a line plot of the 3 sub-metering records, and a line plot
## of global reactive power for 1-Feb-2007 and 2-Feb-2007

## WARNINGS ##
## this script requires the use of the plyr package
## make sure all graphics devices are off (using dev.cur() and dev.off())

## library(plyr)

## reset margins
par(mar = c(5,4,4,2))

## check to see if directory exists, otherwise create it
if (!file.exists("data")) {
        dir.create("data")
}

## download UCI HAR dataset zip file 
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile = "./data/HPC.zip")
dateDownloaded <- date()

## unzip the file to the same directory
#unzip("./data/HPC.zip", exdir = "./data")

## set colClasses
tab5rows <- read.table("./data/household_power_consumption.txt", header = TRUE, 
                       sep = ";", nrows = 5)
classes <- sapply(tab5rows, class)

# housekeeping
rm(tab5rows)

## read file using ColClasses
hpc <- read.table("./data/household_power_consumption.txt", header = TRUE, 
                  sep = ";", na.strings = "?", colClasses = classes,
                  comment.char = "")

## create a data set for Feb 1 and Feb 2 2007 with single field for date-time
hpc$Date <- as.Date(as.character(hpc$Date), "%d/%m/%Y")
hpcdata <- hpc[ which(hpc$Date == "2007-02-01" | hpc$Date == "2007-02-02"), ]
hpcdata <- transform(hpcdata, DateTime = 
                             as.POSIXlt(paste(as.character(hpcdata$Date), 
                                              as.character(hpcdata$Time))))
hpcdata <- hpcdata[ , c(10, 3:9)]
row.names(hpcdata) <- NULL  # remove unneeded row names

# housekeeping - remove unneeded data
rm(hpc)
rm(classes)

## set up png file
png("plot4.png", width = 480, height = 480, units = "px")

## construct plot
the_plot()

dev.off()  # close PNG device

## Reset par
par(mfrow = c(1,1))

the_plot = function() {
        
        ## Construct Plot 4
        ## set printing order
        par(mfrow = c(2, 2))
        
        # Plot 1
        plot(hpcdata$DateTime, hpcdata$Global_active_power, type = "l", 
             xlab = "", ylab = "Global Active Power")
        
        # Plot 2
        plot(hpcdata$DateTime, hpcdata$Voltage, type = "l", xlab = "datetime",
             ylab = "Voltage")
        
        # Plot 3
        plot(hpcdata$DateTime, hpcdata$Sub_metering_1, type = "l", xlab = "",
             ylab = "Energy sub metering")
        points(hpcdata$DateTime, hpcdata$Sub_metering_2, type = "l", 
               col = "red")
        points(hpcdata$DateTime, hpcdata$Sub_metering_3, type = "l", 
               col = "blue")
        legend("topright", pch = "-", lwd = 3, col = c("black", "red", "blue"), 
               bty = "n", legend = c("Sub_metering_1", "Sub_metering_2", 
                                     "Sub_metering_3"))
        
        # Plot 4
        plot(hpcdata$DateTime, hpcdata$Global_reactive_power, type = "l", 
             xlab = "datetime", ylab = "Global_reactive_power")
}