enrichUnResolved <- function(unResolved) {
  unResolved %>% 
    mutate(BankName = ifelse(is.na(BankName), "بانک:", paste0("بانک:", BankName)),
           AccountNumber = ifelse(is.na(AccountNumber), "حساب:", paste0("حساب:", AccountNumber)),
           ShebaNumber = ifelse(is.na(ShebaNumber), "شبا:", paste0("شبا:", ShebaNumber)),
           Amount = ifelse(is.na(Amount), "مبلغ:", paste0("مبلغ:", Amount)),
           BlockCode = ifelse(is.na(BlockCode), "کد مسدودی:", paste0("کد مسدودی:", BlockCode)),
           Date = ifelse(is.na(Date), "تاریخ:", paste0("تاریخ:", Date)),
           TransactionTime = ifelse(is.na(TransactionTime), "زمان تراکنش:", paste0("زمان تراکنش:", TransactionTime)),
           ReferenceCode = ifelse(is.na(ReferenceCode), "کد پیگیری:", paste0("کد پیگیری:", ReferenceCode)),
           Status = ifelse(is.na(Status), "وضعیت:", paste0("وضعیت:", Status)),
           FileName = NULL, 
           Type = NULL,
           EndedUpIn = NULL
           ) %>% 
    return()
}