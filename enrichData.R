enrichData <- function(data, file) {
  source("addFileName.R")
  source("addType.R")
  
  data %>%
    addFileName(file = file) %>%
    addType(file = file) %>%
    return()
}