addFileName <- function(data, folder, file) {
  data %>% 
    mutate(fileName = file.path(folder, file)) %>% 
    return()
}