findEmptyColumns <- function(data) {
  numberOfRows <- nrow(data)
  colnames(data)[is.na(data) %>% colSums() == numberOfRows] %>% 
    return()
}