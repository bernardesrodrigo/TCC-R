# Tutorial
# https://rpubs.com/StevenDuttRoss/API_no_R

library("httr")
library("jsonlite")

#############
# base da API
#############

base <- "http://api.portaldatransparencia.gov.br/api-de-dados/despesas/por-orgao?ano="

#############
# parametros obrigatorios
#############
ano <- 2019
# Ministerio da educação = 26000
orgaoSuperior <- 26000
# Unidade orçamentária UNIRIO = 26269
orgao <- 26269
pagina <- 1
#############
# colocando tudo junto
#############
call1 <- paste(base, ano, "&orgaoSuperior=26000&orgao=", orgao, "&pagina", pagina, sep="")

# acesso (status: 200 = ok)
get_budget <- GET(call1, type = "basic")
get_budget
get_budget_text <- content(get_budget, "text")
get_budget_text
