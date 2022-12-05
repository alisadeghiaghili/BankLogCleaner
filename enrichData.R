enrichData <- function(data, folder, file) {
  source("addFileName.R")
  source("addType.R")
  
  data %>%
    addFileName(folder = folder, file = file) %>%
    addType(file = file) %>%
    return()
}