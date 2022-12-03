#unblockerrors
rm(list = c("data", "finalData"))

Sys.setlocale(locale="persian")

folder <- "1398"
path <- file.path("Logs\\BlockingLogs\\Archive", folder)

files <- extractFileNames(path)
filter <- extractWantedFiles(files)
chars <- char_class("ابپتثجچحخدذرزژسشصضطظعغفقکگلمنوهی")

ues <- files[filter] %>% tolower() %>% str_detect(pattern = "unblockerrors\\d*.txt")

counter <- 0
for (file in files[filter][ues][25:31]){
  counter <- counter + 1
  print(counter)
  print(file)
  
  data <- read_delim(file = file.path(path, file), delim = "\t", col_names = F) %>% 
    omitEmptyColumnsWithHeader() %>% 
    mutate(X1 = str_remove(string = X1, pattern = ".*:") %>% str_trim(),
           X2 = str_remove(string = X2, pattern = ".*: ") %>% str_trim(),
           X3 = str_remove(string = X3, pattern = ".*: ") %>% str_trim(),
           X4 = str_remove(string = X4, pattern = ".*:") %>% str_trim(),
           X5 = str_remove(string = X5, pattern = ".*:") %>% str_trim(), 
           X6 = str_remove(string = X6, pattern = ".*:") %>% str_trim(), 
           X7 = str_remove(string = X7, pattern = one_or_more(chars) %R% space(lo = 1) %R% one_or_more(chars) %R% ":") %>% str_trim(),
           X8 = str_remove(string = X8, pattern = ".*:") %>% str_trim(),
           X9 = str_remove(string = X9, pattern = ".*:") %>% str_trim(),
           X10 = str_trim(X10), 
           #X9 = str_remove(string = X9, pattern = ".*:") %>% str_trim(), 
           fileName = file,
           Type = "unblockerrors")
  if("finalData" %in% ls()) {
    finalData <- bind_rows(finalData, data)
  } else {
    finalData <- data
  }
}


colnames(finalData) <- c("BankName", "AccountNumber", "ShebaNumber", "Amount", "BlockCode", "Date", "TransactionTime", "ReferenceCode", "ErrorCode", "Status", "FileName", "Type") #unblockerror

finalData %>% 
  View()

folder <- 1398

library(RODBC)
connection <- odbcConnect(dsn = "SadeghiTest")
sqlSave(channel = connection, dat = finalData, tablename = paste0("bankLog.UnBlockErrors", folder), rownames = FALSE, append = T, fast = F)
odbcClose(channel = connection)

write_csv(x = finalData, file = paste0("unblockerrors", folder,".csv"))
