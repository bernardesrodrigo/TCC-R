token <- "PNRBUos8XciDolfbMeMhMJ4mrcuCbMkx5hgQUXXpo50IOvaP3wK-1jtv3aFKfcS423PTBgo-D9rniErgRdElYGhZgSTUZd6q6P9baXAmnsEMU0UjoyosvcqIfSxdlfRC1UkYxvTGi-INzfAKYEP-6InT8Ev9RmEeaRFgcamO-RE"

req <- request("http://192.168.0.66:3000/api/v1/transaction/schedule/executed?page=1&perPage=10&filter={'executedAt':'2022-01-01'}&scale=2") %>% 
  req_headers(Authorization = paste("token", token))

req %>% req_perform()
req
req %>% req_dry_run()





req <- request(url_Exec)
req
#> <httr2_request>
#> GET http://127.0.0.1:51981/
#> Body: empty
req |> req_dry_run()
#> GET / HTTP/1.1
#> Host: 127.0.0.1:51981
#> User-Agent: httr2/0.2.3.9000 r-curl/5.1.0 libcurl/8.1.2
#> Accept: */*
#> Accept-Encoding: deflate, gzip
req |> 
  req_url_query(param = "value") |> 
  req_user_agent("My user agent") |> 
  req_method("HEAD") |> 
  req_dry_run()
#> HEAD /?param=value HTTP/1.1
#> Host: 127.0.0.1:51981
#> User-Agent: My user agent
#> Accept: */*
#> Accept-Encoding: deflate, gzip
req |> 
  req_body_json(list(x = 1, y = "a")) |> 
  req_dry_run()
#> POST / HTTP/1.1
#> Host: 127.0.0.1:51981
#> User-Agent: httr2/0.2.3.9000 r-curl/5.1.0 libcurl/8.1.2
#> Accept: */*
#> Accept-Encoding: deflate, gzip
#> Content-Type: application/json
#> Content-Length: 15
#> 
#> {"x":1,"y":"a"}
req_json <- req |> req_url_path("/json")
resp <- req_json |> req_perform()
resp
#> <httr2_response>
#> GET http://127.0.0.1:51981/json
#> Status: 200 OK
#> Content-Type: application/json
#> Body: In memory (407 bytes)

resp |> resp_raw()
#> HTTP/1.1 200 OK
#> Connection: close
#> Date: Tue, 14 Nov 2023 14:41:32 GMT
#> Content-Type: application/json
#> Content-Length: 407
#> ETag: "de760e6d"
#> 
#> {
#>   "firstName": "John",
#>   "lastName": "Smith",
#>   "isAlive": true,
#>   "age": 27,
#>   "address": {
#>     "streetAddress": "21 2nd Street",
#>     "city": "New York",
#>     "state": "NY",
#>     "postalCode": "10021-3100"
#>   },
#>   "phoneNumbers": [
#>     {
#>       "type": "home",
#>       "number": "212 555-1234"
#>     },
#>     {
#>       "type": "office",
#>       "number": "646 555-4567"
#>     }
#>   ],
#>   "children": [],
#>   "spouse": null
#> }
resp |> 
  resp_body_json() |> 
  str()
#> List of 8
#>  $ firstName   : chr "John"
#>  $ lastName    : chr "Smith"
#>  $ isAlive     : logi TRUE
#>  $ age         : int 27
#>  $ address     :List of 4
#>   ..$ streetAddress: chr "21 2nd Street"
#>   ..$ city         : chr "New York"
#>   ..$ state        : chr "NY"
#>   ..$ postalCode   : chr "10021-3100"
#>  $ phoneNumbers:List of 2
#>   ..$ :List of 2
#>   .. ..$ type  : chr "home"
#>   .. ..$ number: chr "212 555-1234"
#>   ..$ :List of 2
#>   .. ..$ type  : chr "office"
#>   .. ..$ number: chr "646 555-4567"
#>  $ children    : list()
#>  $ spouse      : NULL

