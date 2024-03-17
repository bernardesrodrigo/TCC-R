#Abaixo, sequencia de tutoriais para completo entendimento do pacote httr2
#O tutorial 3 chama o 2, que chama o 1 como requisito. Sendo assim, vamos lá.
############################################################################
# Tutorial 1 - https://r-pkgs.org/whole-game.html
# Tutorial 2 - https://httr2.r-lib.org/articles/wrapping-apis.html
# Tutorial 3 - https://www.tidyverse.org/blog/2023/11/httr2-1-0-0/
############################################################################
#
# Tutorial 1 - Criação de pacotes no R
# Executado no projeto PacTest.rprojet 
#
############################################################################
#
# Tutorial 2 - Wrapping APIs
#
#
library(httr2)


req <- request("https://fakerapi.it/api/v1")
resp <- req |>
  # Adicionando caminho de imagens
  req_url_path_append("images") |>
  # Adiciona parametros query _width e _quantity
  req_url_query('_width' = 380, '_quantity' = 1) |>
  req_perform()

# Result come back as JSON
resp |> resp_body_json() |> str()

req |>
  req_url_path_append("invalid") |>
  req_perform()

resp <- last_response()
resp |> resp_body_json()

resp |> resp_headers()

# User agent

req |>
  req_user_agent("my_package_name (http://my.package.web.site)") |>
  req_dry_run()


# Construindo a função


faker <- function(resource, ..., quantity = 1, locale = "en_US", seed = NULL) {
  params <- list(
    ...,
    quantity = quantity,
    locale = locale,
    seed = seed
  )
  names(params) <- paste0("_", names(params))
  
  request("https://fakerapi.it/api/v1") |>
    req_url_path_append(resource) |>
    req_url_query(!!!params) |>
    req_user_agent("my_package_name (http://my.package.web.site)") |>
    req_perform() |>
    resp_body_json()
}

str(faker("images", width = 300))



############################################################################


library(purrr)

faker_person <- function(gender = NULL, birthday_start = NULL, birthday_end = NULL, quantity = 1, locale = "en_US", seed = NULL) {
  if (!is.null(gender)) {
    gender <- match.arg(gender, c("male", "female"))
  }
  if (!is.null(birthday_start)) {
    if (!inherits(birthday_start, "Date")) {
      stop("`birthday_start` must be a date")
    }
    birthday_start <- format(birthday_start, "%Y-%m-%d")
  }
  if (!is.null(birthday_end)) {
    if (!inherits(birthday_end, "Date")) {
      stop("`birthday_end` must be a date")
    }
    birthday_end <- format(birthday_end, "%Y-%m-%d")
  }
  
  json <- faker(
    "persons",
    gender = gender,
    birthday_start = birthday_start,
    birthday_end = birthday_end,
    quantity = quantity,
    locale = locale,
    seed = seed
  )  
  
  tibble::tibble(
    firstname = map_chr(json$data, "firstname"),
    lastname = map_chr(json$data, "lastname"),
    email = map_chr(json$data, "email"),
    gender = map_chr(json$data, "gender")
  )
}
faker_person("male", quantity = 5)
library(httr2)
library(magrittr)
###########################################################
#NY TIMES BOOKS API
NYT_KEY <- "2sevExgyw0AkmChP4HHnVkdi7GbgpiOC"

resp <- request("https://api.nytimes.com/svc/books/v3") |>
  req_url_path_append("/reviews.json") |>
  req_url_query('api-key' = NYT_KEY, isbn = 9780307476463) |>
  req_perform()
resp|> resp_body_json() |> str()

nytimes_error_body <- function(resp) {
  resp %>% resp_body_json() %>% .$fault %>% .$faultstring
}
resp <- request("https://api.nytimes.com/svc/books/v3") %>%
  req_url_path_append("reviews.json") %>%
  req_url_query('api-key' = "invalid", isbn = 9780307476463) %>%
  req_error(body = nytimes_error_body) %>% 
  req_perform()
  
req <- request("https://api.nytimes.com/svc/books/v3") %>%
  req_url_path_append("reviews.json") %>%
  req_url_query('api-key' = "invalid", isbn = 9780307476463) %>%
  req_throttle(10/60, realm = "https://api.nytimes.com/svc/books")


# Empacotando
my_key <- '2sevExgyw0AkmChP4HHnVkdi7GbgpiOC'

nytimes_books <- function(api_key = get_api_key(), path, ...) {
  request("https://api.nytimes.com/svc/books/v3") %>% 
    req_url_path_append("/reviews.json") %>% 
    req_url_query(..., 'api-key' = api_key) %>% 
    req_error(body = nytimes_error_body) %>% 
    req_throttle(10/60, realm = "https://api.nytimes.com/svc/books") %>% 
    req_perform() %>% 
    resp_body_json()
}

drunk <- nytimes_books(my_key, "/reviews.json", isbn = "0316453382")
drunk$results[[1]]$summary


# User-supplied key

get_api_key <- function() {
  key <- Sys.getenv("NYTIMES_KEY")
  if (identical(key, "")) {
    return(key)
  }
  
  if (is_testing()) {
    return(resting_key())
  } else {
    stop("No API key found, pleasy supply with 'api-key' argument or with NYTIMES_KEY env var")
  }
}

is_testing <- function() {
  identical(Sys.getenv("TESTTHAT"), "true")
}

testing_key <- function() {
  secret_decrypt("4Nx84VPa83dMt3X6bv0fNBlLbv3U4D1kHM76YisKEfpCarBm1UHJHARwJHCFXQSV", "HTTR2_KEY")
}

set_api_key <- function(key = NULL) {
  if (is.null(key)) {
    key <- askpass::askpass("Please enter your API key")
  }
  Sys.setenv("NYTIMES_KEY" = key)
}


#############################################################
#Github Gists API
#############################################################

token <- "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"

req <- request("https://api.github.com/gists") %>% 
  req_headers(Authorization = paste("token", token))

req %>% req_perform()
req
req %>% req_dry_run()



# Simulando o erro
resp <- request("https://api.github.com/gists") %>% 
  req_url_query(since = "abcdef") %>% 
  req_headers(Authorization = paste("token", token)) %>% 
  req_error(body = gist_error_body) %>% 
  req_perform()

# Verificando o erro
resp <- last_response()
resp
resp %>% resp_body_json()

# Tratando o erro
gist_error_body <- function(resp) {
  body <- resp_body_json(resp)
  
  message <- body$message
  if (!is.null(body$documentation_url)) {
    message <- c(message, paste0("See docs at <", body$documentation_url, ">"))
  }
  message
}
gist_error_body(resp)

# Rate-limiting

resp <- req %>% req_perform()
resp %>%  resp_headers("ratelimit")
