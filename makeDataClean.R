makeDataClean <- function(data) {
  header <- colnames(data)
  for (col in 1:ncol(data)) {
    data[, col] <- data[, col] %>% pull() %>% str_remove(pattern = header[col] %R% ":") %>% str_trim()
    data[, col] <- ifelse(data[, col] %>% pull() == "", NA, data[, col] %>% pull())
  }
  return(data)
}