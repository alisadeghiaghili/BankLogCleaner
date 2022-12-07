createFinalizedBlock <- function(block, transferblock, unblock) {
  EndedUpInTransferBlock <- block %>% 
    semi_join(y = transferblock, by = "BlockCode") %>% 
    mutate(EndedUpIn = "TransferBlock")
  
  EndedUpInUnBlock <- block %>% 
    semi_join(y = unblock, by = "BlockCode") %>% 
    mutate(EndedUpIn = "UnBlock")
  
  resolved <- bind_rows(EndedUpInTransferBlock, EndedUpInUnBlock)
  
  unResolved <- block %>% 
    anti_join(y = resolved, by = "BlockCode")
  
  finalBlock <- bind_rows(resolved, unResolved) %>% 
    arrange(Date)
  return(list(resolved = resolved,
              unResolved = unResolved,
              finalBlock = finalBlock))
}
