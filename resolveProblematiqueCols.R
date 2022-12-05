resolveProblematiqueCols <- function(data) {
  # problematiqueColumn <- grep(x = colnames(data), pattern = "مبلغ مسدودی|موجودی کافی|شناسه جلسه")
  problematiqueColumn <- grep(x = colnames(data), pattern = "موجودی کافی|شناسه جلسه")
  if(length(problematiqueColumn) > 0) {
    data[, (problematiqueColumn - 1)] <- paste(data[, (problematiqueColumn - 1)] %>% pull(), data[, problematiqueColumn] %>% pull())
    data[, (problematiqueColumn)] <- NULL
  }
  
  return(data)
}