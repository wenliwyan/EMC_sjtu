## read data files

merchant <- read.table("emc//merchant.txt", header = TRUE, sep = "\t", fileEncoding = "UTF-8")
trade <- read.table("emc//trade.txt", header = TRUE, sep = "\t", fileEncoding = "UTF-8")

library(dplyr)

## get the list of merchants' account number with descending total trading amount

trade %>% group_by(toaccount) 
      %>% summarize(amountTotal = sum(amount))
      %>% arrange(desc(amountTotal))
      %>% totalTradePerMerchant
