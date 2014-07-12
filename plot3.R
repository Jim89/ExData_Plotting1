# R Script for Creating Simple Plots
# Coursera - Exploratory Data Analysis - Course Project 1
# Authour - Jim Leach
# Date - 2014/07/12

################################################################################
# Step 1: Load packages 
################################################################################
require(lubridate,quietly=T) #lubridate is used for date and time manipulations

################################################################################
# Step 2: Download and read in the data
################################################################################
# 2a: Set the location of the data
data_url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# 2b: Download the data
download.file(data_url,"data.zip",method="curl",quiet=TRUE)

# 2c: Unzip the data
unzip("data.zip",overwrite=TRUE)

# 2d: Read the data in to R
data<-read.table("household_power_consumption.txt",
                 sep=";",header=T,na.strings="?",
                 colClasses=c(rep("character",2),rep("numeric",7))
)

################################################################################
# Step 3: Subset and clean up the data
################################################################################
# 3a: Subset to the two days that will be analysed
data_sub<-data[data$Date %in% c("1/2/2007","2/2/2007"),]

# 3b: Clean up the data
# 3bi: Create a datetime field
data_sub$datetime<-with(data_sub,paste(Date,str_sub(Time,-8,-1)))
# 3bii: Format the datetime field as datetime, not character (<3 lubridate!)
data_sub$datetime<-dmy_hms(data_sub$datetime)
# 3biii: Format the date as date
data_sub$Date<-dmy(data_sub$Date)
# 3biv: Format the time as time
data_sub$Time<-strptime(data_sub$Time,format="%H:%M:%S")

################################################################################
# Step 4: Construct a line graph of sub metering(s) vs time and save to file
################################################################################
png("plot3.png")
with(data_sub,plot(datetime,Sub_metering_1,
                   type="l",
                   ylab="Energy sub metering",
                   xlab=""))
with(data_sub,lines(datetime,Sub_metering_2,
                    type="l",
                    col="red"))
with(data_sub,lines(datetime,Sub_metering_3,
                    type="l",
                    col="blue"))
legend("topright",
       c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lty=c(1,1),
       col=c("black","red","blue"))
dev.off()