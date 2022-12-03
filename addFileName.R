addFileName <- function(data, file) {
  data %>% 
    mutate(fileName = file) %>% 
    return()
}