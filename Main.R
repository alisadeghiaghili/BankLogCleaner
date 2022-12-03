setwd("D:\\BankLogCleaner")

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
  
  pathPart <- file.path(logsPath, folder)
  for (file in files[filter]) {
    print(file)
    data <- loadTextFile(file, pathPart = pathPart) %>% 
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
      enrichData(file = file) %>% 
      resolveProblematiqueCols()
    
    
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
    # file.rename(from = file, to = paste0("--", file))
    counter <- counter + 1
  }
}

saveRDS(block, file = file.path("finalRDS", paste0("block.rds")))
saveRDS(blockerror, file = file.path("finalRDS", paste0("blockerror.rds")))
saveRDS(unblock, file = file.path("finalRDS", paste0("unblock.rds")))
saveRDS(unblockerrors, file = file.path("finalRDS", paste0("unblockerrors.rds")))
saveRDS(transferblock, file = file.path("finalRDS", paste0("transferblock.rds")))
saveRDS(transferblockerrors, file = file.path("finalRDS", paste0("transferblockerrors.rds")))

Connection <- createConnection(dsn = "SadeghiTest")
tableNames <- sqlTables(channel = Connection, schema = "bankLog")$TABLE_NAME
relatedTables <- str_subset(string = tableNames, pattern = "UnBlock\\d+")
lastTable <- relatedTables[length(relatedTables)]
tableStructureQuery <- paste0("SELECT * into ", "bankLog.UnBlock1401"," FROM [SadeghiTest].[bankLog].[", lastTable, "] where 1 = 0")
tableColNames <- sqlQuery(channel = Connection, query = "select * from bankLog.UnBlock1401") %>% colnames()
colnames(unblock) <- tableColNames
sqlSave(channel = Connection, dat = unblock, tablename = "bankLog.UnBlock1401", append = T, fast = T)
odbcClose(channel = Connection)