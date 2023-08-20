##
fileUrl <- "http://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip"
localFileName <- "household_power_consumption.zip"

# Download the file
download.file(fileUrl, localFileName)

# Unzip the downloaded file
unzip(localFileName, exdir = "data")
##
## now we see we have a file in my RStudio 'data' directory named
##                             'household_power_consumption.txt'

##  move on - we have missing data in this file as '?'

Mydata <- read.table('./data/household_power_consumption.txt', header = TRUE, 
                   sep = ";", dec = ".", na.strings = "?")

str(Mydata)
##
## We want data ONLY for dates 2007-02-01 AND 2002-02-02

####### USE 'dplyr'.....

library(dplyr)
filtered_data <- Mydata %>%
  filter(Date %in% c('1/2/2007', '2/2/2007'))

## 
## see what 'filtered_data' looks like..
head(filtered_data)
str(filtered_data)
#View(filtered_data)

## Now  -- fix 'date' and 'time'
date_time <- strptime(paste(filtered_data$Date, filtered_data$Time, sep = ' '), '%d/%m/%Y %H:%M:%S')
## see what we have
str(date_time)

##  Now do 'plot4'
par(mfrow = c(2, 2))

glob_Act_Pwr <- as.numeric(filtered_data$Global_active_power)
plot(date_time, glob_Act_Pwr, type = 'l', xlab = ' ', ylab = 'Global Active Power(kilowatts)')

Volts <- as.numeric(filtered_data$Voltage)
plot(date_time, Volts, type = 'l', xlab = 'datetime ', ylab = 'Voltage')

subMtr1 <- as.numeric(filtered_data$Sub_metering_1)
subMtr2 <- as.numeric(filtered_data$Sub_metering_2)
subMtr3 <- as.numeric(filtered_data$Sub_metering_3)

plot(date_time, subMtr1, type = 'l', ylab = 'Energy Submetering', xlab = ' ')
lines(date_time, subMtr2, type = 'l', col = 'red')
lines(date_time, subMtr3, type = 'l', col = 'blue')
#### with bty = n AND cex = 0.9 we take away the index box and reduce the size of the letters
legend('topright', c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), 
       lty = 1, lwd = 2.5, col = c('black', 'red', 'blue'), bty = 'n', cex = 0.9)

glob_React_Pwr <- as.numeric(filtered_data$Global_reactive_power)
plot(date_time, glob_React_Pwr, type = 'l', xlab = 'datetime', ylab = 'Global Reactive Power')

dev.copy(png, file = './data/plot4.png', width = 480, height = 480)
dev.off()






