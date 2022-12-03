omitEmptyColumnsWithHeader <- function(data) {
  emptyCols <- findEmptyColumns(data = data)
  data[, emptyCols] <- NULL
  return(data)
}