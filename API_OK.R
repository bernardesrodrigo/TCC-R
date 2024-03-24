library(httr2)
library(jsonlite)

#url <- "http://192.168.0.66:3000/api/v1/application/authenticate"
#url_Exec <- "http://192.168.0.66:3000/api/v1/transaction/schedule/executed?page=1&perPage=10&filter={'executedAt':'2023-12-01'}&scale=2"

key <- "3caf7711-4c60-4219-9b1c-0caacae509c5"
Secret <- "f42e2f0e883350960158d64d84b01ce985b261f9d71179d033966e15e6faac3eec6159587dd3806c06d700b74e2215cffb3af7772fe7a92b736c0a710479abc8"

token <- "EkVeRv8A9RiCnNsshVmnwNPquSza-5zRZWW0ViZIyKHgtaaeHCWkuZxAhlG9H8U6-kXb7O29DNGYCqyqvr35F234PQ3VN5YXNQMoeKxHBRn0QlJFJbRVEXkimimennp3McJGjaunBnLjT2Pmjmgz_KTFU6kGSoduwNVdMziERD8"

API1 <- "http://192.168.0.66:3000/api/v1/transaction/schedule/executed"
API2 <- "http://192.168.0.66:3000/api/v2/loading/transaction/schedule"

resp2 <- request(API2) |>
  req_headers('Authorization' = 'uJRibx5E6dUJis2aAYoXCtOLPeT-b7wBGe7jvuTM2yIljGmdg6nvVn8AUF4FLaTtqfUb26cr2IRvbceJporYwLY4TmkV4jkkNuwqpHVT2Pnoz39EbWMYD2S8iXIP0esj_CbkFLO5KoeQIwPwmHAUj2rWKfcLGQ57q6IUuGY_t9E' ) |>
  req_url_query('page' = 1, 'perPage' = 400, 'filter' = '{"insertedAt":"2023-11-06"}') |>
  req_perform()

respJson <- resp_body_json(resp2)

ds <- data.frame(
  te_id = 0,
  te_started_at = 0,
  te_stopped_at = 0,
  ts_vehicle_id = 0,
  ts_auth_code = 0,
  be_started_at = 0,
  be_stopped_at = 0,
  be_recipe_name = 0,
  be_preset_quantity = 0,
  pe_sum_gov = 0,
  pe_sum_gsv = 0,
  pe_sum_mass = 0,
  pe_avg_average_density = 0,
  pe_avg_average_temperature = 0,
  pe_avg_average_inpm = 0,
  pe_avg_average_gl = 0)

# Quantidade de transações recebidas
transactions <- length(respJson$result)

for (i in 1:transactions) {
  if (respJson$result[[i]]$isApproved == TRUE) {
  # Variaveis de transação
    te_id <- respJson$result[[i]]$transactions
    te_started_at <- respJson$result[[i]]$startedAt
    te_stopped_at <- respJson$result[[i]]$stoppedAt
    ts_vehicle_id <- respJson$result[[i]]$vehicle$id
    ts_auth_code <- respJson$result[[i]]$auth$code
  
  # Quantidade de bateladas na transação
  Nbatchs <- length(respJson$result[[i]]$compartments$executed)
  
  for (j in 1:Nbatchs) {
    print(paste(i, "i", j, "j"))
    
    # Variáveis de batelada
    be_started_at <- respJson$result[[i]]$compartments$executed[[j]]$startedAt
    be_stopped_at <- respJson$result[[i]]$compartments$executed[[j]]$stoppedAt
    be_recipe_name <- respJson$result[[i]]$compartments$executed[[j]]$recipe$name
    be_preset_quantity <- respJson$result[[i]]$compartments$executed[[j]]$quantity$programmed
    pe_sum_gov <- respJson$result[[i]]$compartments$executed[[j]]$quantity$executed
    pe_sum_gsv <- respJson$result[[i]]$compartments$executed[[j]]$quantity$executed20C
    pe_sum_mass <- respJson$result[[i]]$compartments$executed[[j]]$mass
    pe_avg_average_density <- respJson$result[[i]]$compartments$executed[[j]]$average$density
    pe_avg_average_temperature <- respJson$result[[i]]$compartments$executed[[j]]$average$temperature
    pe_avg_average_inpm <- respJson$result[[i]]$compartments$executed[[j]]$average$inpm
    pe_avg_average_gl <- respJson$result[[i]]$compartments$executed[[j]]$average$gl

    
    # Adiciona novas linhas ao dataset
    ds <- rbind(ds, c(   
        te_id,
        te_started_at,
        te_stopped_at,
        ts_vehicle_id,
        ts_auth_code,
        be_started_at,
        be_stopped_at,
        be_recipe_name,
        be_preset_quantity,
        pe_sum_gov,
        pe_sum_gsv,
        pe_sum_mass,
        pe_avg_average_density,
        pe_avg_average_temperature,
        pe_avg_average_inpm,
        pe_avg_average_gl))
  }
  }
}
ds <- ds[-c(1),]


#############################################################################
transactions <- length(respJson$result)
i <- 34
j <- 1


# Variaveis de transação
te_id <- respJson$result[[i]]$transactions
te_started_at <- respJson$result[[i]]$startedAt
te_stopped_at <- respJson$result[[i]]$stoppedAt
ts_vehicle_id <- respJson$result[[i]]$vehicle$id
ts_auth_code <- respJson$result[[i]]$auth$code

# Quantidade de bateladas na transação
Nbatchs <- length(respJson$result[[i]]$compartments$executed)



# Variáveis de batelada
be_started_at <- respJson$result[[i]]$compartments$executed[[j]]$startedAt
be_stopped_at <- respJson$result[[i]]$compartments$executed[[j]]$stoppedAt
be_recipe_name <- respJson$result[[i]]$compartments$executed[[j]]$recipe$name
be_preset_quantity <- respJson$result[[i]]$compartments$executed[[j]]$quantity$programmed
pe_sum_gov <- respJson$result[[i]]$compartments$executed[[j]]$quantity$executed
pe_sum_gsv <- respJson$result[[i]]$compartments$executed[[j]]$quantity$executed20C
pe_sum_mass <- respJson$result[[i]]$compartments$executed[[j]]$mass
pe_avg_average_density <- respJson$result[[i]]$compartments$executed[[j]]$average$density
pe_avg_average_temperature <- respJson$result[[i]]$compartments$executed[[j]]$average$temperature
pe_avg_average_inpm <- respJson$result[[i]]$compartments$executed[[j]]$average$inpm
pe_avg_average_gl <- respJson$result[[i]]$compartments$executed[[j]]$average$gl
  

Nbatchs <- 1
for (j in 1:Nbatchs) {
  
  # Variáveis de batelada
  be_started_at <- respJson$result[[i]]$compartments$executed[[j]]$startedAt
  be_stopped_at <- respJson$result[[i]]$compartments$executed[[j]]$stoppedAt
  be_recipe_name <- respJson$result[[i]]$compartments$executed[[j]]$recipe$name
  be_preset_quantity <- respJson$result[[i]]$compartments$executed[[j]]$quantity$programmed
  pe_sum_gov <- respJson$result[[i]]$compartments$executed[[j]]$quantity$executed
  pe_sum_gsv <- respJson$result[[i]]$compartments$executed[[j]]$quantity$executed20C
  pe_sum_mass <- respJson$result[[i]]$compartments$executed[[j]]$mass
  pe_avg_average_density <- respJson$result[[i]]$compartments$executed[[j]]$average$density
  pe_avg_average_temperature <- respJson$result[[i]]$compartments$executed[[j]]$average$temperature
  pe_avg_average_inpm <- respJson$result[[i]]$compartments$executed[[j]]$average$inpm
  pe_avg_average_gl <- respJson$result[[i]]$compartments$executed[[j]]$average$gl
  
  
  # Adiciona novas linhas ao dataset
  ds <- rbind(ds, c(   
    te_id,
    te_started_at,
    te_stopped_at,
    ts_vehicle_id,
    ts_auth_code,
    be_started_at,
    be_stopped_at,
    be_recipe_name,
    be_preset_quantity,
    pe_sum_gov,
    pe_sum_gsv,
    pe_sum_mass,
    pe_avg_average_density,
    pe_avg_average_temperature,
    pe_avg_average_inpm,
    pe_avg_average_gl))
}
