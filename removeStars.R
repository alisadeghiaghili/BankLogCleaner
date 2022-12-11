removeStars <- function(data, file) {
  filetype <- file %>% tolower() %>%  str_remove(pattern = "\\d+") %>% str_remove(pattern = "\\.txt")
  if(filetype == "block"){
    data %>% 
      mutate(AccountNumber = AccountNumber %>% str_remove_all(pattern = "\\*"),
             ShebaNumber = ShebaNumber %>% str_remove_all(pattern = "\\*")) %>% 
      return()
  } else {
    return(data)
  }
}