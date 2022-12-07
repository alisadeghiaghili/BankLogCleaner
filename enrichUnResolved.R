enrichUnResolved <- function(unResolved) {
  unResolved %>% 
    mutate(BankName = ifelse(is.na(BankName), "بانک:", str_c("بانک:", BankName)),
           AccountNumber = ifelse(is.na(AccountNumber), "حساب:", str_c("حساب:", AccountNumber)),
           ShebaNumber = ifelse(is.na(ShebaNumber), "شبا:", str_c("شبا:", ShebaNumber)),
           Amount = ifelse(is.na(Amount), "مبلغ:", str_c("مبلغ:", Amount)),
           BlockCode = ifelse(is.na(BlockCode), "کد مسدودی:", str_c("کد مسدودی:", BlockCode)),
           Date = ifelse(is.na(Date), "تاریخ:", str_c("تاریخ:", Date)),
           TransactionTime = ifelse(is.na(TransactionTime), "زمان تراکنش:", str_c("زمان تراکنش:", TransactionTime)),
           ReferenceCode = ifelse(is.na(ReferenceCode), "کد پیگیری:", str_c("کد پیگیری:", ReferenceCode)),
           Status = ifelse(is.na(Status), "وضعیت:", str_c("وضعیت:", Status)),
           FileName = NULL, 
           Type = NULL,
           EndedUpIn = NULL
           ) %>% 
    return()
}