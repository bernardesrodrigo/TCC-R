install.packages("httr2")
install.packages("jsonlite")

library(httr2)
library(jsonlite)

url <- "http://192.168.0.66:3000/api/v1/application/authenticate"
url_Exec <- "http://192.168.0.66:3000/api/v1/transaction/schedule/executed?page=1&perPage=10&filter={'executedAt':'2022-01-01'}&scale=2"

key <- "3caf7711-4c60-4219-9b1c-0caacae509c5"
Secret <- "f42e2f0e883350960158d64d84b01ce985b261f9d71179d033966e15e6faac3eec6159587dd3806c06d700b74e2215cffb3af7772fe7a92b736c0a710479abc8"

token <- "PNRBUos8XciDolfbMeMhMJ4mrcuCbMkx5hgQUXXpo50IOvaP3wK-1jtv3aFKfcS423PTBgo-D9rniErgRdElYGhZgSTUZd6q6P9baXAmnsEMU0UjoyosvcqIfSxdlfRC1UkYxvTGi-INzfAKYEP-6InT8Ev9RmEeaRFgcamO-RE"


req <- request(url_Exec) %>% req_auth_bearer_token(token)
req
print(req, redact_headers = FALSE)

last_response()

# URL da API
url <- 'http://192.168.0.66:3000/api/v1/application/authenticate'

# Corpo da solicitação em formato de lista
body <- list(api = list(key = "myKey", secret = "mySecret"))

# Fazendo a solicitação POST
response <- POST(url, body = body, encode = "json")

# Verificar o status da resposta
status_code(response)

# Verificar o conteúdo da resposta
content(response)

######################################################################################################

url_auth <- "http://192.168.0.66:3000/api/v1/application/authenticate"
myKey <- "3caf7711-4c60-4219-9b1c-0caacae509c5"
mySecret <- "f42e2f0e883350960158d64d84b01ce985b261f9d71179d033966e15e6faac3eec6159587dd3806c06d700b74e2215cffb3af7772fe7a92b736c0a710479abc8"

url_Exec <- "http://192.168.0.66:3000/api/v1/transaction/schedule/executed?page=1&perPage=10&filter={'executedAt':'2022-01-01'}&scale=2"
token <- "_-G2U1_0cVT8adbJ6GmZO3RQ9rFZ2ywfPA6Di2Knx-vkCb5xX7sSXg14nOfndKZOT7FCEgpLrY48l9WYHWgpvksncaRBLmIyW23yCLigJKy5Vxk9rtGGalDTIhFZeP82wyjLE172H6hvdVrOEjis5qWg1ZxLI_ZMMZPMXcLTsjA"



req_auth <- request(url_auth) %>% 
  req_headers(Authorization = paste("token", token))




req <- request(url) %>% 
  req_headers(Authorization = paste("token", token))

req %>% req_perform()
req
req %>% req_dry_run()
last_response()
last_request()


