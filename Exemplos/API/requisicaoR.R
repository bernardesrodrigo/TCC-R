library(httr)
library(magrittr) # operador pipe

POST(url = 'http://127.0.0.1:8080/modelo',
     encode = 'json',
     body = list(Wind = 20,
                 Temp = 70,
                 Month = 8)
     ) %>%
  content %>%
  unlist

