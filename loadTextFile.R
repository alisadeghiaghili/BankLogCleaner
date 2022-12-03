loadTextFile <- function(fileName, pathPart) {
  read_delim(file = file.path(pathPart, fileName), delim = "\t", col_names = FALSE, show_col_types = FALSE) %>% 
    return()
}