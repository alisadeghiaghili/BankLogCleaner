setwd("D:\\Blocks")

# options(message = TRUE)

source("loadLibs.R")
source("loadFuncs.R")
source("initials.R")

folder <- "1398"
path <- file.path("Logs\\BlockingLogs\\Archive", folder)

files <- extractFileNames(path)
filter <- extractWantedFiles(files)

pathPart <- file.path("BlockingLogs\\Archive", folder)

setwd(file.path("D:\\Blocks\\Logs", pathPart))

dir(recursive = T)

for (file in files[filter]) {
  fileSplitted <- file %>% str_split(pattern = "/") %>% unlist()
  file.rename(from = file, to = paste0(fileSplitted[1], "/!!", fileSplitted[2]))
}
