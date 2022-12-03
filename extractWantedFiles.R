extractWantedFiles <- function (files) {
  str_detect(string = tolower(files), 
             pattern = "(block\\s?\\(?\\d*\\)?|unblock\\d*|blockerrors?\\d*|unblockerrors\\d*|transferblock\\d*|transferblockerrors\\d*)\\.txt") %>% 
    return()
}