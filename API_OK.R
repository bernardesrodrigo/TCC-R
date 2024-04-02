library(httr2)
library(jsonlite)

##################################### URL's API's Versões 1 e 2 #####################################

API <- "http://192.168.0.66:3000/api/v1/transaction/schedule/executed"
APIsc <- "http://192.168.0.66:3000/api/v2/loading/transaction/schedule"
APIex <- "http://192.168.0.66:3000/api/v2/loading/transaction/executed"

##################################### Requisição Json #####################################
respAPIex <- request(APIex) |>
  req_headers('Authorization' = 'uJRibx5E6dUJis2aAYoXCtOLPeT-b7wBGe7jvuTM2yIljGmdg6nvVn8AUF4FLaTtqfUb26cr2IRvbceJporYwLY4TmkV4jkkNuwqpHVT2Pnoz39EbWMYD2S8iXIP0esj_CbkFLO5KoeQIwPwmHAUj2rWKfcLGQ57q6IUuGY_t9E' ) |>
  req_url_query('page' = 1, 'perPage' = 600, 'filter' = '{"startedAt":["2023-12-01", "2023-12-31"]}') |>
#  req_url_query('page' = 1, 'perPage' = 600, 'filter' = '{"startedAt":"2023-12-04"}') |>
  req_perform()
respJsonAPIex <- resp_body_json(respAPIex)

respAPIsc <- request(APIsc) |>
  req_headers('Authorization' = 'uJRibx5E6dUJis2aAYoXCtOLPeT-b7wBGe7jvuTM2yIljGmdg6nvVn8AUF4FLaTtqfUb26cr2IRvbceJporYwLY4TmkV4jkkNuwqpHVT2Pnoz39EbWMYD2S8iXIP0esj_CbkFLO5KoeQIwPwmHAUj2rWKfcLGQ57q6IUuGY_t9E' ) |>
  req_url_query('page' = 1, 'perPage' = 600, 'filter' = '{"startedAt":["2023-12-01", "2023-12-31"]}') |>
  #  req_url_query('page' = 1, 'perPage' = 600, 'filter' = '{"startedAt":"2023-12-04"}') |>
  req_perform()
respJsonAPIsc <- resp_body_json(respAPIsc)


# Cria o dataframe com as variáveis a serem recebidas
ds <- data.frame(
  te_id = 0,
  te_started_at = 0,
  te_stopped_at = 0,
  ts_vehicle_id = 0,
  #ts_auth_code = 0,
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
  pe_avg_average_inpm20C = 0,
  pe_avg_average_gl = 0,
  de_name = 0,
  be_number = 0,
  be_arm_number = 0,
  be_compartment_number = 0)

# Identifica Quantidade de transações (caminhões carregados) recebidas
transactionsex <- length(respJsonAPIex$result)
transactionssc <- length(respJsonAPIsc$result)
# Varre o arquivo Json alocando os dados de "Transações" e "Bateladas" no dataframe
for (i in 1:transactionsex) {
  te_id <- respJsonAPIex$result[[i]]$id
  te_started_at <- respJsonAPIex$result[[i]]$startedAt
  te_stopped_at <- respJsonAPIex$result[[i]]$stoppedAt
  
  for (k in 1:transactionssc) {
    if (te_id == respJsonAPIsc$result[[k]]$transactions[1]){
      ts_vehicle_id <- respJsonAPIsc$result[[k]]$vehicle$id
    }
  }
  
  #ts_auth_code <- respJsonAPIex$result[[i]]$auth$code
  
  # Quantidade de bateladas na transação
  Nbatchs <- length(respJsonAPIex$result[[i]]$compartments)
  
  for (j in 1:Nbatchs) {
    print(paste(i, "i", j, "j"))
    
    # Variáveis de batelada
    be_started_at <- respJsonAPIex$result[[i]]$compartments[[j]]$startedAt
    be_stopped_at <- respJsonAPIex$result[[i]]$compartments[[j]]$stoppedAt
    be_recipe_name <- respJsonAPIex$result[[i]]$compartments[[j]]$recipe$name
    be_preset_quantity <- respJsonAPIex$result[[i]]$compartments[[j]]$quantity$programmed
    pe_sum_gov <- respJsonAPIex$result[[i]]$compartments[[j]]$quantity$executed
    pe_sum_gsv <- respJsonAPIex$result[[i]]$compartments[[j]]$quantity$executed20C
    pe_sum_mass <- respJsonAPIex$result[[i]]$compartments[[j]]$mass
    pe_avg_average_density <- respJsonAPIex$result[[i]]$compartments[[j]]$average$density
    pe_avg_average_temperature <- respJsonAPIex$result[[i]]$compartments[[j]]$average$temperature
    pe_avg_average_inpm <- respJsonAPIex$result[[i]]$compartments[[j]]$average$inpm
    pe_avg_average_inpm20C <- respJsonAPIex$result[[i]]$compartments[[j]]$average$inpm20C
    pe_avg_average_gl <- respJsonAPIex$result[[i]]$compartments[[j]]$average$gl
    de_name <- respJsonAPIex$result[[i]]$device$name
    be_number <- respJsonAPIex$result[[i]]$compartments[[j]]$number
    be_arm_number <- respJsonAPIex$result[[i]]$compartments[[j]]$arm
    be_compartment_number <- respJsonAPIex$result[[i]]$compartments[[j]]$compartment
    
    
    # Adiciona novas linhas ao dataset
    ds <- rbind(ds, c(   
      te_id,
      te_started_at,
      te_stopped_at,
      ts_vehicle_id,
      #ts_auth_code,
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
      pe_avg_average_inpm20C,
      pe_avg_average_gl,
      de_name,
      be_number,
      be_arm_number,
      be_compartment_number))
  }
}
# Deleta linha inicial "zerada" do dateframe
ds <- ds[-c(1),]


##################################### API URL's #####################################
#url <- "http://192.168.0.66:3000/api/v1/application/authenticate"
#url_Exec <- "http://192.168.0.66:3000/api/v1/transaction/schedule/executed?page=1&perPage=10&filter={'executedAt':'2023-12-01'}&scale=2"

##################################### API Key / Secret / Token #####################################

key <- "3caf7711-4c60-4219-9b1c-0caacae509c5"
Secret <- "f42e2f0e883350960158d64d84b01ce985b261f9d71179d033966e15e6faac3eec6159587dd3806c06d700b74e2215cffb3af7772fe7a92b736c0a710479abc8"
token <- "EkVeRv8A9RiCnNsshVmnwNPquSza-5zRZWW0ViZIyKHgtaaeHCWkuZxAhlG9H8U6-kXb7O29DNGYCqyqvr35F234PQ3VN5YXNQMoeKxHBRn0QlJFJbRVEXkimimennp3McJGjaunBnLjT2Pmjmgz_KTFU6kGSoduwNVdMziERD8"














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
