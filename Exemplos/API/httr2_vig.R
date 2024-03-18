library(httr2)

req <- request(example_url())
req
last_response()
req %>% req_dry_run()

req %>% 
  req_url_query(param = "value") %>% 
  req_user_agent("My user agent") %>% 
  req_method("HEAD") %>% 
  req_dry_run()

req %>% 
  req_body_json(list(x = 1, y = "a")) %>% 
  req_dry_run()

req_json <- req %>% req_url_path("/json")
resp <- req_json %>% req_perform()
resp_raw(resp = resp)

resp
resp %>% resp_raw()

#But generally, you’ll want to use the resp_ functions to extract parts of the response for further processing. 
#For example, you could parse the JSON body into an R data structure:

resp %>% 
  resp_body_json() %>% 
  str()

#Or get the value of a header:

resp %>% resp_header("Content-Length") 
resp %>% resp_status()

######################Error handling
req %>% 
  req_url_path("status/404") %>% 
  req_perform()

req %>% 
  req_url_path("status/500") %>% 
  req_perform()

last_request()
last_response()
req_error()


#################### Control the request process

urls <- paste0("https://swapi.dev/api/people/", 1:10)
reqs <- lapply(urls, request)
resps <- req_perform_sequential(reqs)

resps |> 
  _[[1]] |> 
  resp_body_json() |> 
  str()

resps |> 
  resps_data(\(resp) list(resp_body_json(resp))) |> 
  _[1:3] |> 
  str(list.len = 10)


sw_data <- function(resp) {
  tibble::as_tibble(resp_body_json(resp)[1:9])
}
resps %>%  resps_data(sw_data)
