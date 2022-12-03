#transferblockerrors
rm(list = c("data", "finalData"))

Sys.setlocale(locale="persian")

folder <- "1398"
path <- file.path("Logs\\BlockingLogs\\Archive", folder)

files <- extractFileNames(path)
filter <- extractWantedFiles(files)
chars <- char_class("ابپتثجچحخدذرزژسشصضطظعغفقکگلمنوهی")

tbes <- files[filter] %>% tolower() %>% str_detect(pattern = "transferblockerrors\\d*.txt")
for (file in files[filter][tbes]){
  data <- read_delim(file = file.path(path, file), delim = "\t", col_names = F) %>% 
    omitEmptyColumnsWithHeader() %>% 
    mutate(X1 = str_remove(string = X1, pattern = ".*:") %>% str_trim(),
           X2 = str_remove(string = X2, pattern = ".*: ") %>% str_trim(),
           X3 = str_remove(string = X3, pattern = ".*: ") %>% str_trim(),
           X4 = str_remove(string = X4, pattern = ".*:") %>% str_trim(),
           X5 = str_remove(string = X5, pattern = ".*: ") %>% str_trim(),
           X6 = str_remove(string = X6, pattern = ".*:") %>% str_trim(), 
           X7 = str_remove(string = X7, pattern = ".*:") %>% str_trim(),
           X8 = str_remove(string = X8, pattern = ".*:") %>% str_trim(),
           X9 = str_remove(string = X9, pattern = one_or_more(chars) %R% space(lo = 1) %R% one_or_more(chars) %R% ":") %>% str_trim(),
           X10 = str_remove(string = X10, pattern = ".*:") %>% str_trim(),
           X11 = str_remove(string = X11, pattern = ".*:") %>% str_trim(),
           X12 = str_trim(string = X12) %>% 
             str_replace(pattern = "&#1588;&#1605;&#1575;&#1585;&#1607; &#1581;&#1587;&#1575;&#1576; &#1605;&#1602;&#1589;&#1583; &#1583;&#1585; &#1604;&#1610;&#1587;&#1578; &#1588;&#1605;&#1575;&#1585;&#1607; &#1581;&#1587;&#1575;&#1576;&#1607;&#1575;&#1610; &#1605;&#1580;&#1575;&#1586; &#1605;&#1608;&#1580;&#1608;&#1583; &#1606;&#1605;&#1610; &#1576;&#1575;&#1588;&#1583;.",
                          replacement = "شماره حساب مقصد در لیست شماره حسابهای مجاز موجود نمی باشد") %>% 
             str_trim(),
           fileName = file,
           Type = "transferblockerrors") 
  if("finalData" %in% ls()) {
    finalData <- bind_rows(finalData, data)
  } else {
    finalData <- data
  }
}

colnames(finalData) <- c("BankName", "SourceAccount", "DestinationAccount", "BlockAmount", "DocumentNumber", "BlockCode", "TransferAmount", "Date", "TransactionTime", "ReferenceCode", "ErrorCode", "Status","FileName", "Type") #transferblockerror

finalData %>% 
  View()

folder <- 1398

library(RODBC)
connection <- odbcConnect(dsn = "SadeghiTest")
sqlSave(channel = connection, dat = finalData, tablename = paste0("bankLog.TransferBlockErrors", folder), rownames = FALSE, append = T, fast = F)
odbcClose(channel = connection)

write_csv(x = finalData, file = paste0("transferblockerrors", folder,".csv"))
