extractColumnNames <- function(data) {
  firstRow <- data[1, ]
  header <- c()
  
  for (col in 1:ncol(firstRow)){
    parts <- firstRow[, col] %>% 
      str_split(pattern = ":") %>% 
      unlist() %>% 
      str_trim()
    header <- c(header, parts[1])
  }
  
  return(header)
}
