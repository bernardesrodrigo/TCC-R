install.packages("xlsx")

library("readxl")
library("xlsx")
library("tidyverse")
library(stringr)
library(dplyr)

dados <- read_excel("DadosIML_20221.xls")

view(dados)
head(dados)
str(dados)
glimpse(dados)
print(dados)
dim(dados)
names(dados)


dados$data <- substr(dados$DataEntradaIML, 1, 10)
dados$horax <- substr(dados$DataEntradaIML, 11, 19)


dados$hora = ifelse(str_detect(dados$horax, fixed(pattern = ":")), dados$horax, 'k' )
dados$data = ifelse(str_detect(dados$data, fixed(pattern = "/")), dados$data, 'k' )
dados$horax <- NULL
dados$DataEntradaIML = NULL

dados = dados %>% 
  relocate(hora) %>%
  relocate(data)
  
writew
  



##dados2 <- relocate(data, .before = AnoBO )

