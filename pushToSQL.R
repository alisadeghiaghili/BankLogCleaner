colnames(block) <- c("BankName", "AccountNumber", "Amount", "BlockCode", "Date", "TransactionTime", "ReferenceCode", "Status", "FileName", "Type")
colnames(unblock) <- c("BankName", "AccountNumber", "ShebaNumber", "Amount", "BlockCode", "Date", "TransactionTime", "ReferenceCode", "Status", "FileName", "Type")
colnames(transferblock) <- c("BankName", "SourceAccount", "DestinationAccount", "BlockAmount", "DocumentNumber", "BlockCode", "TransferAmount", "Date", "TransactionTime", "ReferenceCode", "Status", "Debit", "Credit", "FileName", "Type")


Sys.setlocale(locale="persian")
library(RODBC)
connection <- odbcConnect(dsn = "SadeghiTest")

sqlSave(channel = connection, dat = finalData, tablename = "bankLog.Block1399", rownames = FALSE, append = T, fast = F)
sqlSave(channel = connection, dat = unblock, tablename = "bankLog.UnBlock1399", rownames = FALSE, append = T, fast = F)
sqlSave(channel = connection, dat = transferblock, tablename = "bankLog.TransferBlock1399", rownames = FALSE, append = T, fast = F)

odbcClose(channel = connection)


write_csv(x = unblock, file = "unBlock1396-2.csv")

colnames(block) <- c("BankName", "AccountNumber", "Amount", "BlockCode", "Date", "ReferenceCode", "Status", "FileName", "Type", "TransactionTime")

block <- block %>% 
  select(BankName, AccountNumber, Amount, BlockCode, Date, TransactionTime, ReferenceCode, Status, FileName, Type)

write_csv(x = block, file = "Block1389-1393.csv")

colnames(transferblock) <- c("BankName", "SourceAccount", "DestinationAccount", "BlockAmount", "DocumentNumber", "BlockCode", "TransferAmount", "Date", "ReferenceCode", "Status", "FileName", "Type", "TransactionTime", "Debit", "Credit")

transferblock <- transferblock %>% 
  select(BankName, SourceAccount, DestinationAccount, BlockAmount, DocumentNumber, BlockCode, TransferAmount, Date, TransactionTime, ReferenceCode, Status, Debit, Credit, FileName, Type) 

write_csv(x = transferblock, file = "TransferBlock1400.csv")



colnames(unblock) <- c("BankName", "AccountNumber", "Amount", "BlockCode", "Date", "ReferenceCode", "Status", "FileName", "Type", "TransactionTime")

unblock <- unblock %>% 
  select("BankName", "AccountNumber", "ShebaNumber", "Amount", "BlockCode", "Date", "TransactionTime", "ReferenceCode", "Status", "FileName", "Type") 

%>% 
  View()

write_csv(x = unblock, file = "UnBlock1400.csv")

rm(list = c("block", "blockerror", "unblock", "unblockerrors", "transferblock", "transferblockerrors"))