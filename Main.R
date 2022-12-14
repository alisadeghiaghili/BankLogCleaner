setwd("D:\\BankLogCleaner")

# options(message = TRUE)

source("loadLibs.R")
source("loadFuncs.R")
source("initials.R")

logsPath <- "D:\\vazirian logs\\Blocking Logs"
# folders <- dir(logsPath)

# for (folder in folders){
  # path <- file.path(logsPath, folder)
  # print(path)
  # files <- extractFileNames(path)
  files <- dir(path = logsPath, pattern = "\\.txt")
  filter <- extractWantedFiles(files)

  for (file in files[filter]) {
    # print(file)
    # data <- loadTextFile(file, pathPart = path) %>% 
    #   omitEmptyColumnsWithHeader()
    # data <- loadTextFile(file, pathPart = path) %>%
    #   omitEmptyColumnsWithHeader()
    
    data <- loadTextFile(file, pathPart = logsPath) %>%
      omitEmptyColumnsWithHeader()
    
    if(nrow(data) == 0) {
      next()
    }
    
    header <- extractColumnNames(data)
    AllNaColumnsNumber <- findNAs(header = header)
    if(length(AllNaColumnsNumber) > 0) {
      data <- ommitNAColumns(data = data, NaColumnsNumbers = AllNaColumnsNumber)
      colnames(data) <- header[-c(AllNaColumnsNumber)]
    } else {
      colnames(data) <- header
    }
    
    data <- makeDataClean(data) %>% 
      enrichData(folder = folder, file = file) %>% 
      resolveProblematiqueCols()
    
    data <- setFinalColNames(data = data, file = file) %>% 
      removeStars(file = file)
    
    dataType <- data$Type[1]
    if (dataType == "blockerror" | dataType == "blockerrors") {
      if(hadBlockError == 0){
        blockerror <- data
        hadBlockError <- 1
      } else {
        blockerror <- bind_rows(blockerror, data)
      }
    } else if(dataType == "transferblockerror" | dataType == "transferblockerrors") {
      if(hadTransferBlockErrors == 0){
        transferblockerrors <- data
        hadTransferBlockErrors <- 1
      } else {
        transferblockerrors <- bind_rows(transferblockerrors, data)
      }
    } else if(dataType == "unblock" | dataType == "unblocks") {
      if(hadUnBlock == 0){
        unblock <- data
        hadUnBlock <- 1
      } else {
        unblock <- bind_rows(unblock, data)
      }
    } else if(dataType == "transferblock" | dataType == "transferblocks") {
      if(hadTransferBlock == 0){
        transferblock <- data
        hadTransferBlock <- 1
      } else {
        transferblock <- bind_rows(transferblock, data)
      }
    } else if(dataType == "unblockerror" | dataType == "unblockerrors") {
      if(hadUnBlockErrors == 0){
        unblockerrors <- data
        hadUnBlockErrors <- 1
      } else {
        unblockerrors <- bind_rows(unblockerrors, data)
      }
    } else if(dataType == "block" | dataType == "blocks") {
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
# }



saveRDS(block, file = file.path("finalRDS", paste0("block.rds")))
saveRDS(blockerror, file = file.path("finalRDS", paste0("blockerror.rds")))
saveRDS(unblock, file = file.path("finalRDS", paste0("unblock.rds")))
saveRDS(unblockerrors, file = file.path("finalRDS", paste0("unblockerrors.rds")))
saveRDS(transferblock, file = file.path("finalRDS", paste0("transferblock.rds")))
saveRDS(transferblockerrors, file = file.path("finalRDS", paste0("transferblockerrors.rds")))

block <- createEndedUpInCol(block)
result <- createFinalizedBlock(block = block, transferblock = transferblock, unblock = unblock)
saveRDS(result$finalBlock, file = file.path("finalRDS", paste0("finalBlock.rds")))

dir.create(path = file.path(logsPath, Sys.Date()))

for (file in files[filter]) {
  file.move(files = file.path(logsPath, Sys.Date(), file))
}

enrichUnResolved(unResolved = result$unResolved) %>%
  write_tsv(file = file.path(logsPath, "test.txt"), col_names = F)

# types <- c("block", "blockerror", "unblock", "unblockerrors", "transferblock", "transferblockerrors")
Connection <- createConnection(dsn = "SadeghiTest")
# sqlSave(channel = Connection, dat = unblock, tablename = "bankLog.Block", append = T, colnames = F, rownames = F)
sqlSave(channel = Connection, dat = result$resolved, tablename = "bankLog.Block", append = T, colnames = F, rownames = F)
sqlSave(channel = Connection, dat = blockerror, tablename = "bankLog.BlockErrors", append = T, colnames = F, rownames = F)
sqlSave(channel = Connection, dat = unblock, tablename = "bankLog.UnBlock", append = T, colnames = F, rownames = F)
sqlSave(channel = Connection, dat = unblockerrors, tablename = "bankLog.UnBlockErrors", append = T, colnames = F, rownames = F)
sqlSave(channel = Connection, dat = transferblock, tablename = "bankLog.TransferBlock", append = T, colnames = F, rownames = F)
sqlSave(channel = Connection, dat = transferblockerrors, tablename = "bankLog.TransferBlockErrors", append = T, colnames = F, rownames = F)
odbcClose(channel = Connection)