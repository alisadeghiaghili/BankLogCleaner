setFinalColNames <- function(data, file) {
  filetype <- file %>% tolower() %>%  str_remove(pattern = "\\d+") %>% str_remove(pattern = "\\.txt")
  if (filetype == "blockerror" | filetype == "blockerrors") {
    colnames(data) <- c("BankName", "AccountNumber", "ShebaNumber", "Amount", "BlockCode", "Date", "TransactionTime", "ReferenceCode", "ErrorCode", "Status", "FileName", "Type")
  } else if(filetype == "transferblockerror" | filetype == "transferblockerrors") {
    colnames(data) <- c("BankName", "SourceAccount", "DestinationAccount", "BlockAmount", "DocumentNumber", "BlockCode", "TransferAmount", "Date", "TransactionTime", "ReferenceCode", "ErrorCode", "Status", "FileName", "Type")
  } else if(filetype == "unblock" | filetype == "unblocks") {
    colnames(data) <- c("BankName", "AccountNumber", "ShebaNumber", "Amount", "BlockCode", "Date", "TransactionTime", "ReferenceCode", "Status", "FileName", "Type")
  } else if(filetype == "transferblock" | filetype == "transferblocks") {
    colnames(data) <- c("BankName", "SourceAccount", "DestinationAccount", "BlockAmount", "DocumentNumber", "BlockCode", "TransferAmount", "Date", "TransactionTime", "ReferenceCode", "Status", "Debit", "Credit", "FileName", "Type")
  } else if(filetype == "unblockerror" | filetype == "unblockerrors") {
    colnames(data) <- c("BankName", "AccountNumber", "ShebaNumber", "Amount", "BlockCode", "Date", "TransactionTime", "ReferenceCode", "ErrorCode", "Status", "FileName", "Type")
  } else if(filetype == "block" | filetype == "blocks") {
    colnames(data) <- c("BankName", "AccountNumber", "ShebaNumber", "Amount", "BlockCode", "Date", "TransactionTime", "ReferenceCode", "Status", "FileName", "Type")
  }  
  return(data)
}