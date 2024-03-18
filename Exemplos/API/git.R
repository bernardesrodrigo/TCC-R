install.packages("httr")
install.packages("jsonlite")

library(httr)
library(jsonlite)

# Exibir os dados
print(dados)
url <- "https://api.github.com/repos/bernardesrodrigo/test"
resposta <- GET(url)

# Verificar o status da resposta
status_code(resposta)

# Converter a resposta para um data frame
dados <- fromJSON(content(resposta, "text"))

