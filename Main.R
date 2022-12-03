setwd("D:\\Blocks")

# options(message = TRUE)

source("loadLibs.R")
source("loadFuncs.R")
source("initials.R")

folder <- "1400"
path <- file.path("Logs\\BlockingLogs\\Archive", folder)
files <- extractFileNames(path)
filter <- extractWantedFiles(files)

pathPart <- file.path("BlockingLogs\\Archive", folder)
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
      # transferblockerrors <- rbind(transferblockerrors, data)
      transferblockerrors <- bind_rows(transferblockerrors, data)
    }
  } else if(dataType == "unblock") {
    if(hadUnBlock == 0){
      unblock <- data
      hadUnBlock <- 1
    } else {
      # unblock <- rbind(unblock, data)
      unblock <- bind_rows(unblock, data)
    }
  } else if(dataType == "transferblock") {
    if(hadTransferBlock == 0){
      transferblock <- data
      hadTransferBlock <- 1
    } else {
      # transferblock <- rbind(transferblock, data)
      transferblock <- bind_rows(transferblock, data)
    }
  } else if(dataType == "unblockerrors") {
    if(hadUnBlockErrors == 0){
      unblockerrors <- data
      hadUnBlockErrors <- 1
    } else {
      # unblockerrors <- rbind(unblockerrors, data)
      unblockerrors <- bind_rows(unblockerrors, data)
    }
  } else if(dataType == "block") {
    if(hadBlock == 0){
      block <- data
      hadBlock <- 1
    } else {
      # block <- rbind(block, data)
      block <- bind_rows(block, data)
    }
  } 
  
  
  saveRDS(data, file = file.path("rds", paste0(counter, ".rds")))
  # file.rename(from = file, to = paste0("--", file))
  counter <- counter + 1
}

saveRDS(block, file = file.path("finalRDS", paste0("block.rds")))
saveRDS(blockerror, file = file.path("finalRDS", paste0("blockerror.rds")))
saveRDS(unblock, file = file.path("finalRDS", paste0("unblock.rds")))
saveRDS(unblockerrors, file = file.path("finalRDS", paste0("unblockerrors.rds")))
saveRDS(transferblock, file = file.path("finalRDS", paste0("transferblock.rds")))
saveRDS(transferblockerrors, file = file.path("finalRDS", paste0("transferblockerrors.rds")))