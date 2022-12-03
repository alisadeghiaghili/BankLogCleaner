addType <- function(data, file) {
  data %>% 
    mutate(Type = case_when(
      str_detect(tolower(file), pattern = "^block\\s?\\(?\\d*\\)?\\.txt") ~ "block",
      str_detect(tolower(file), pattern = "^blockerrors?\\d*\\.txt") ~ "blockerror",
      str_detect(tolower(file), pattern = "^unblock\\d*\\.txt") ~ "unblock",
      str_detect(tolower(file), pattern = "^unblockerrors\\d*\\.txt") ~ "unblockerrors",
      str_detect(tolower(file), pattern = "^transferblock\\d*\\.txt") ~ "transferblock",
      str_detect(tolower(file), pattern = "^transferblockerrors\\d*\\.txt") ~ "transferblockerrors"
      )
    ) %>% 
  return()
}