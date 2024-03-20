library(httr2)
library(jsonlite)

url <- "http://192.168.0.66:3000/api/v1/application/authenticate"
url_Exec <- "http://192.168.0.66:3000/api/v1/transaction/schedule/executed?page=1&perPage=10&filter={'executedAt':'2023-12-01'}&scale=2"

key <- "3caf7711-4c60-4219-9b1c-0caacae509c5"
Secret <- "f42e2f0e883350960158d64d84b01ce985b261f9d71179d033966e15e6faac3eec6159587dd3806c06d700b74e2215cffb3af7772fe7a92b736c0a710479abc8"

token <- "EkVeRv8A9RiCnNsshVmnwNPquSza-5zRZWW0ViZIyKHgtaaeHCWkuZxAhlG9H8U6-kXb7O29DNGYCqyqvr35F234PQ3VN5YXNQMoeKxHBRn0QlJFJbRVEXkimimennp3McJGjaunBnLjT2Pmjmgz_KTFU6kGSoduwNVdMziERD8"

API1 <- "http://192.168.0.66:3000/api/v1/transaction/schedule/executed"
API2 <- "http://192.168.0.66:3000/api/v2/loading/transaction/schedule"

# FLX request
#token <- 

resp2 <- request(API2) |>
  req_headers('Authorization' = 'EkVeRv8A9RiCnNsshVmnwNPquSza-5zRZWW0ViZIyKHgtaaeHCWkuZxAhlG9H8U6-kXb7O29DNGYCqyqvr35F234PQ3VN5YXNQMoeKxHBRn0QlJFJbRVEXkimimennp3McJGjaunBnLjT2Pmjmgz_KTFU6kGSoduwNVdMziERD8' ) |>
  req_url_query('page' = 1, 'perPage' = 6, 'filter' = '{"executedAt":"2023-12-02"}') |>
  req_perform()
resp2 |> resp_body_json() |> tibble::as_tibble()
teste <- tibble::as.tibble(resp_body_json(resp2))

# Converter de json para dataframe
teste2 <- as.data.frame(teste)

df <- as.data.frame(resp2)
resp2

resp2 |> 
  resps_data(\(resp) list(resp_body_json(resp)))


sw_data <- function(resp) {
  tibble::as_tibble(resp_body_json(resp)[1:9])
}
# Acessando uma variável no tibble
teste$rows[[2]]$compartments[[4]]$recipe$name

########################### teste converter json para dataframe ##########################


reposLoL <- fromJSON("https://api.github.com/users/hadley/repos", simplifyDataFrame = FALSE)

library(data.tree)
repos <- as.Node(reposLoL)
print(repos, "id", "login")

#convert this to a data.frame
reposdf <- repos |> ToDataFrameTable(ownerId = "id", 
                                  "login", 
                                  repoName = function(x) x$parent$name, #relative to the leaf
                                  fullName = "full_name", #unambiguous values are inherited from ancestors
                                  repoId = function(x) x$parent$id,
                                  "fork", 
                                  "type")

reposdf
reposdf$repoName


















############################################## FIM ###########################################################































req <- request(url_Exec) %>% req_auth_bearer_token(token) %>% req_perform()
req %>% req_body_json() %>% str()


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


