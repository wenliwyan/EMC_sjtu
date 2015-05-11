## read data files
merchant <- read.table("emc//merchant.txt", header = TRUE, sep = "\t", fileEncoding = "UTF-8")
trade <- read.table("emc//trade.txt", header = TRUE, sep = "\t", fileEncoding = "UTF-8")
user <- read.table("emc//account.txt", header = TRUE, sep = "\t", fileEncoding = "UTF-8")

## load libraries
library(dplyr)
library(lubridate)

## get data frame of total trade amount for each merchant
merchant2 <- select(merchant[!duplicated(merchant$toaccount),], toaccount, accountname)
tradePerMerchant <- summarize(group_by(trade, toaccount), sumamount = sum(amount))
tradePerMerchant <- arrange(tradePerMerchant, desc(sumamount))
tradePerMerchant <- merge(tradePerMerchant, merchant2, sort = FALSE)

# get data frame of total trade amount for each system
tradePerSys <- summarize(group_by(trade, syscode), sumamount = sum(amount))
tradePerSys <- arrange(tradePerSys, desc(sumamount))
tradePerSys <- merge(tradePerSys, system, sort = FALSE)

## get subset of trades in various dining halls
system <- select(merchant[!duplicated(merchant$syscode),], syscode, codename)
systemDining <- system[grep("食堂", system$codename),]
systemDining <- mutate(systemDining, sysgeneral = as.factor(c("一食","一食","二食","二食","三食","三食","四食","四食","五食","五食","六食","六食")))

tradeDining <- subset(trade, syscode %in% c(30, 99, 269, 34, 268, 36, 267, 38, 265, 33, 266, 37))
tradeDining <- mutate(trade, timestamp = ymd_hms(timestamp), date = strftime(timestamp, "%F"))

## get data frame of total trade amount on dining fro each person 
tradeDiningPerPerson <- summarize(group_by(tradeDining, fromaccount), sumamount = sum(amount))
tradeDiningPerPerson <- merge(tradeDiningPerPerson, user, by.x = "fromaccount", by.y = "account")
summarize(group_by(tradeDiningPerPerson, type), mean(sumamount))
