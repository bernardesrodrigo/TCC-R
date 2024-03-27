library("tidyverse")
library("stringr")
library("readxl")
library("ggplot2")
library(wordcloud)
library(RColorBrewer)  # Para obter paletas de cores
library(dplyr)

library(cluster) #algoritmo de cluster
library(dendextend) #compara dendogramas
library(factoextra) #algoritmo de cluster e visualizacao
library(fpc) #algoritmo de cluster e visualizacao
library(gridExtra) #para a funcao grid arrange



ds <- read_excel("sample2.xlsx")
view(ds)
dim(ds)
str(ds)

#Normaliza nomes das receitas de cada braço
ds$be_recipe_name <- sub("_BRC_1", "", ds$be_recipe_name)
ds$be_recipe_name <- sub("_BRC_2", "", ds$be_recipe_name)
ds$be_recipe_name <- sub(" BRC 1", "", ds$be_recipe_name)
ds$be_recipe_name <- sub(" BRC 2", "", ds$be_recipe_name)

ds$be_recipe_name <- str_trim(ds$be_recipe_name, side = "right")

#Converte as variáveis datas string em date time
ds$te_started_at <- as.POSIXct(ds$te_started_at, format="%Y-%m-%d %H:%M:%S", tz="UTC")
ds$te_stopped_at <- as.POSIXct(ds$te_stopped_at, format="%Y-%m-%d %H:%M:%S", tz="UTC")
ds$be_started_at <- as.POSIXct(ds$be_started_at, format="%Y-%m-%d %H:%M:%S", tz="UTC")
ds$be_stopped_at <- as.POSIXct(ds$be_stopped_at, format="%Y-%m-%d %H:%M:%S", tz="UTC")
  
#Calcula o tempo de cada transação e cada batelada
ds$te_durat <- ds$te_stopped_at - ds$te_started_at
ds$be_durat <- ds$be_stopped_at - ds$be_started_at

#Calcula média de litros carregados por minuto
ds$te_avgLmin <- ds$pe_sum_gov / as.numeric(ds$te_durat)
ds$be_avgLmin <- ds$pe_sum_gov / as.numeric(ds$be_durat)

#Calcula o valor excedente/faltante em função do valor presetado
ds$be_overrun <- ds$be_preset_quantity - ds$pe_sum_gov

#Subistitui o número da placa por um número fictício
#ds$placaf <- str_replace_all(ds$ts_vehicle_id, "[0-9]", function(x) as.character(sample(0:9, 1)))

summary(ds)
summary(ds$be_avgLmin)
#top10 <- table(ds$ts_vehicle_id)
sum(ds$pe_sum_gov)                            


######################################## CLUSTERS ###############################################
variaveis <- c('ts_vehicle_id', 'be_recipe_name') #'be_compartment_number', 'be_arm_number', 'be_avgLmin', , ,  'be_overrun'

# Seleciona variaveis no DS original
dst <- ds %>% select(all_of(variaveis))

# Remove a variavel categorica 'ts_vehicle_id'
dsScale <- dst[,-1]

# Dumização da variave 'be_recipe_name'
dsDummy <- model.matrix(~ be_recipe_name - 1, data = dsScale)

# Remove a variavel "be_recipe_name'
dsScale <- dsScale[-1]
# Combina-se os 2 DS
dsScale <- cbind(dsScale, dsDummy)

# padroniza o DS
dsScale.padro <- dsScale

#calcular as distancias da matriz utilizando a distancia euclidiana
distancia <- dist(dsScale.padro, method = "euclidean")

#Calcular o Cluster: metodos disponiveis "average", "single", "complete" e "ward.D"
cluster.hierarquico <- hclust(distancia, method = "single")
plot(cluster.hierarquico, cex = 0.6, hang = -1)

#Criar o grafico e destacar os grupos
rect.hclust(cluster.hierarquico, k = 2)

#VERIFICANDO ELBOW 
fviz_nbclust(dsScale.padro, FUN = hcut, method = "wss") ## 5 grupos

#Rodar o modelo
dsScale.k2 <- kmeans(dsScale.padro, centers = 3)
#Visualizar os clusters
fviz_cluster(dsScale.k2, data = dst.padro, main = "Cluster K2")








