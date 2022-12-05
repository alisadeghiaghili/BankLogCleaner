setFinalColNames <- function(data, file) {
  filetype <- file %>% str_remove(pattern = "\\d+") %>% str_remove(pattern = "\\.txt")
  if (filetype == "blockerror") {
    colnames(data) <- c("BankName", "AccountNumber", "ShebaNumber", "Amount", "BlockCode", "Date", "TransactionTime", "ReferenceCode", "ErrorCode", "Status", "FileName", "Type")
  } else if(filetype == "transferblockerrors") {
    colnames(data) <- c("BankName", "SourceAccount", "DestinationAccount", "BlockAmount", "DocumentNumber", "BlockCode", "TransferAmount", "Date", "TransactionTime", "ReferenceCode", "ErrorCode", "Status", "FileName", "Type")
  } else if(filetype == "unblock") {
    colnames(data) <- c("BankName", "AccountNumber", "ShebaNumber", "Amount", "BlockCode", "Date", "TransactionTime", "ReferenceCode", "Status", "FileName", "Type")
  } else if(filetype == "transferblock") {
    colnames(data) <- c("BankName", "SourceAccount", "DestinationAccount", "BlockAmount", "DocumentNumber", "BlockCode", "TransferAmount", "Date", "TransactionTime", "ReferenceCode", "Status", "Debit", "Credit", "FileName", "Type")
  } else if(filetype == "unblockerrors") {
    colnames(data) <- c("BankName", "AccountNumber", "ShebaNumber", "Amount", "BlockCode", "Date", "TransactionTime", "ReferenceCode", "ErrorCode", "Status", "FileName", "Type")
  } else if(filetype == "block") {
    colnames(data) <- c("BankName", "AccountNumber", "ShebaNumber", "Amount", "BlockCode", "Date", "TransactionTime", "ReferenceCode", "Status", "FileName", "Type")
  }  
  return(data)
}