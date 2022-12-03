ommitNAColumns <- function(data, NaColumnsNumbers) {
  data[, c(NaColumnsNumbers)] <- NULL
  return(data)
}