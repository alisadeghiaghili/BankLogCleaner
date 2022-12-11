setwd("E:\\BankLogCleaner")

# options(message = TRUE)

source("loadLibs.R")
source("loadFuncs.R")
source("initials.R")

logsPath <- "D:\\vazirian logs\\Blocking Logs"
folders <- dir(logsPath)

for (folder in folders){
  path <- file.path(logsPath, folder)
  print(path)
  files <- extractFileNames(path)
  filter <- extractWantedFiles(files)
  
  # pathPart <- file.path(logsPath, folder)
  for (file in files[filter]) {
    print(file)
    
    folder <- folders[33]
    path <- file.path(logsPath, folder)
    data <- loadTextFile(file, pathPart = path)
    
    data[1159:nrow(data), ]
    
    
    problemRow <-  1158 
    data1 <- data[1:problemRow, ]
    tail(data1)
    data2 <- data[(problemRow + 1):nrow(data), ]  
      
    data1 <- data1 %>% 
      omitEmptyColumnsWithHeader()
    
    if(nrow(data1) == 0) {
      next()
    }
    
    header <- extractColumnNames(data1)
    AllNaColumnsNumber <- findNAs(header = header)
    if(length(AllNaColumnsNumber) > 0) {
      data2 <- ommitNAColumns(data = data1, NaColumnsNumbers = AllNaColumnsNumber)
      colnames(data1) <- header[-c(AllNaColumnsNumber)]
    } else {
      colnames(data1) <- header
    }
    
    data1 <- makeDataClean(data1) %>% 
      enrichData(folder = folder, file = file) %>% 
      resolveProblematiqueCols()
    
    colnames(data1) <- c("BankName", "AccountNumber", "Amount", "BlockCode", "Date", "TransactionTime", "ReferenceCode", "Status", "FileName", "Type")
    data1 <- data1 %>% 
      mutate(ShebaNumber = as.character(NA)) %>% 
      select("BankName", "AccountNumber", "ShebaNumber", everything())
    
    data2 <- data2 %>% 
      omitEmptyColumnsWithHeader()
    
    if(nrow(data2) == 0) {
      next()
    }
    
    header <- extractColumnNames(data2)
    AllNaColumnsNumber <- findNAs(header = header)
    if(length(AllNaColumnsNumber) > 0) {
      data2 <- ommitNAColumns(data = data2, NaColumnsNumbers = AllNaColumnsNumber)
      colnames(data2) <- header[-c(AllNaColumnsNumber)]
    } else {
      colnames(data2) <- header
    }
    
    data2 <- makeDataClean(data2) %>% 
      enrichData(folder = folder, file = file) %>% 
      resolveProblematiqueCols()
    
    colnames(data2) <- c("BankName", "AccountNumber", "ShebaNumber", "Amount", "BlockCode", "Date", "TransactionTime", "ReferenceCode", "Status", "FileName", "Type")
    
    data <- rbind(data1, data2)
    
    data <- setFinalColNames(data = data, file = file) %>% 
      removeStars()
    
    dataType <- data$Type[1]
    if (dataType == "blockerror") {
      if(hadBlockError == 0){
        blockerror <- data
        hadBlockError <- 1
      } else {
        # blockerror <- rbind(blockerror, data)
        blockerror <- bind_rows(blockerror, data)
      }
    } else if(dataType == "transferblockerrors") {
      if(hadTransferBlockErrors == 0){
        transferblockerrors <- data
        hadTransferBlockErrors <- 1
      } else {
        transferblockerrors <- bind_rows(transferblockerrors, data)
      }
    } else if(dataType == "unblock") {
      if(hadUnBlock == 0){
        unblock <- data
        hadUnBlock <- 1
      } else {
        unblock <- bind_rows(unblock, data)
      }
    } else if(dataType == "transferblock") {
      if(hadTransferBlock == 0){
        transferblock <- data
        hadTransferBlock <- 1
      } else {
        transferblock <- bind_rows(transferblock, data)
      }
    } else if(dataType == "unblockerrors") {
      if(hadUnBlockErrors == 0){
        unblockerrors <- data
        hadUnBlockErrors <- 1
      } else {
        unblockerrors <- bind_rows(unblockerrors, data)
      }
    } else if(dataType == "block") {
      if(hadBlock == 0){
        block <- data
        hadBlock <- 1
      } else {
        block <- bind_rows(block, data)
      }
    } 
    
    
    saveRDS(data, file = file.path("rds", paste0(counter, ".rds")))
    counter <- counter + 1
    
  }
}