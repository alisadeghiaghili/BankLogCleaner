colsAnalysisDF <- data.frame(id = as.character(NA),
                             ncol = as.numeric(NA))[0, ]

for (file in dir(path = "rds", pattern = "\\.rds")) {
  ncol <- ncol(readRDS(file = file.path("rds", file)))
  colsAnalysisDF <- rbind(colsAnalysisDF, data.frame(id = file, ncol = ncol))
}

colsAnalysisDF <- colsAnalysisDF %>% 
  arrange(id)

blockerror <- data.frame()

for (file in dir(path = "rds", pattern = "\\.rds")) {
  data <- readRDS(file.path("rds", file))
  if (data$Type[1] == "blockerror") {
    if(nrow(blockerror) == 0){
      blockerror <- data
    } else {
      blockerror <- rbind(blockerror, data)
    }
  }
}