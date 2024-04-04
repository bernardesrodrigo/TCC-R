library("tidyverse")
library("ggplot2")
library(wordcloud)
#library(RColorBrewer)  # Para obter paletas de cores
library(dplyr)

############################# TOTAL CARREGADO POR DATA ######################################################
# Crie o gráfico de barras
dados_agrupados <- aggregate(pe_sum_gov ~ data_formatada, data = transform(ds, data_formatada = as.Date(be_started_at)), sum)
str(dados_agrupados)


ggplot(dados_agrupados, aes(x = data_formatada, y = pe_sum_gov)) +
  geom_bar(stat = "identity", fill = "blue") +
  labs(title = "Somatório dos Valores por Data",
       x = "Data",
       y = "Somatório dos Valores") +
  scale_x_date(date_labels = "%b %d", date_breaks = "1 day") +  # Formato mês e dia
  scale_y_continuous(labels = scales::number_format(scale = 1e-6, suffix = "M"))  # Evita notação científica no eixo y

############################# TOTAL CARREGADO POR CAMINHÃO ######################################################
# Grafico de barras
total_caminhao <- aggregate(pe_sum_gov ~ ts_vehicle_id, data = ds, sum)
str(dados_agrupados)


ggplot(total_caminhao, aes(x = ts_vehicle_id, y = pe_sum_gov)) +
  geom_bar(stat = "identity", fill = "blue") +
  labs(title = "Somatório dos Valores por Placa",
       x = "Placa",
       y = "Somatório dos Valores") +
  scale_y_continuous(labels = scales::number_format(scale = 1e-6, suffix = "M"))  # Evita notação científica no eixo y

# Nuvem de placas
# Crie a nuvem de palavras
wordcloud(words = total_caminhao$ts_vehicle_id, freq = total_caminhao$pe_sum_gov,
          min.freq = 1, scale = c(3, 0.5), colors = brewer.pal(8, "Dark2"),
          random.order = FALSE, rot.per = 0.35, 
          main = "Nuvem de Palavras - Volume Carregado por Placa de Caminhão")

# Crie o gráfico de barras horizontais ordenado
ggplot(total_caminhao, aes(x = pe_sum_gov, y = reorder(ts_vehicle_id, pe_sum_gov))) +
  geom_bar(stat = "identity", fill = "blue") +
  labs(title = "Somatório dos Valores por Placa de Caminhão",
       x = "Somatório dos Valores",
       y = "Placa de Caminhão") +
  scale_x_continuous(labels = scales::number_format(scale = 1e-6, suffix = "M"))  # Evita notação científica no eixo x

# Placas em bolhas
ggplot(total_caminhao, aes(x = ts_vehicle_id, y = pe_sum_gov, size = pe_sum_gov)) +
  geom_point(color = "blue") +
  labs(title = "Volume Carregado por Placa de Caminhão",
       x = "Placa de Caminhão",
       y = "Volume Carregado") +
  scale_size_continuous(range = c(2, 15))  # Ajuste conforme necessário

############################# TOTAL CARREGADO POR baia ######################################################

# Agrupe os dados por de_name e be_arm_number e calcule o somatório dos valores
total_baia_arm <- aggregate(pe_sum_gov ~ de_name + be_arm_number, data = ds, sum)

# Crie o gráfico de barras empilhadas com rótulos internos
ggplot(total_baia_arm, aes(x = de_name, y = pe_sum_gov, fill = factor(be_arm_number))) +
  geom_bar(stat = "identity", position = "stack", color = "white") +
  geom_text(aes(label = format(pe_sum_gov, scientific = FALSE)), position = position_stack(vjust = 0.5)) +
  labs(title = "Total Carregado por Baia e Braço",
       x = "Baia",
       y = "Total Carregado") +
  scale_fill_brewer(palette = "Set3") +  # Escolha uma paleta de cores
  theme_minimal()




print(total_baia_arm)
# Crie o gráfico de pizza mostrando o total por baia
ggplot(total_baia_arm, aes(x = "", y = pe_sum_gov, fill = de_name)) +
  geom_bar(stat = "identity", width = 1, color = "white") +
  coord_polar(theta = "y") +  # Converta para coordenadas polares para obter um gráfico de pizza
  geom_text(aes(label = format(pe_sum_gov, scientific = FALSE)), 
            position = position_stack(vjust = 0.5)) +
  labs(title = "Total Carregado por Baia",
       x = NULL,
       y = NULL) +
  scale_fill_brewer(palette = "Set3") +  # Escolha uma paleta de cores
  theme_minimal()




##############TOTAL CARREGADO POR braço ######################################################


# Crie o gráfico de pizza com rótulos externos
ggplot(total_braço, aes(x = "", y = pe_sum_gov, fill = factor(be_arm_number))) +
  geom_bar(stat = "identity", width = 1) +
  geom_text(aes(label = pe_sum_gov), position = position_stack(vjust = 0.5)) +
  coord_polar(theta = "y") +
  labs(title = "Distribuição do Total Carregado por Número do Braço") +
  theme_minimal() +
  theme(axis.text = element_blank(), axis.title = element_blank())

##############TOTAL CARREGADO POR PRODUTO #######################################################################################################################

# Agrupe os dados por de_name e be_arm_number e calcule o somatório dos valores
total_produto <- aggregate(pe_sum_gov ~ be_recipe_name, data = ds, sum)

# Crie o gráfico de pizza com rótulos externos
ggplot(total_produto, aes(x = "", y = pe_sum_gov, fill = factor(be_recipe_name))) +
  geom_bar(stat = "identity", width = 1) +
  geom_text(aes(label = pe_sum_gov), position = position_stack(vjust = 0.5)) +
  coord_polar(theta = "y") +
  labs(title = "Distribuição do Total Carregado por Produto") +
  theme_minimal() +
  theme(axis.text = element_blank(), axis.title = element_blank())

# Crie o gráfico de barras empilhadas com rótulos internos
ggplot(total_produto, aes(x = be_recipe_name, y = pe_sum_gov, fill = factor(be_recipe_name))) +
  geom_bar(stat = "identity", position = "stack", color = "white") +
  geom_text(aes(label = format(pe_sum_gov, scale = 1e6, suffix = "M")), position = position_stack(vjust = 0.5)) +
  labs(title = "Total Carregado por produto",
       x = "Produto",
       y = "Total Carregado") +
  scale_fill_brewer(palette = "Set3") +  # Escolha uma paleta de cores
  theme_minimal()



'############################# HORÁRIOS DE PICO ######################################################
# Converta te_started_at para classe POSIXct se ainda não estiver
ds$te_started_at <- as.POSIXct(ds$te_started_at)

# Agrupe e resuma os dados usando dplyr
dados_agrupados <- ds %>%
  group_by(te_started_at_hour = format(te_started_at, "%H:%M")) %>%
  summarise(pe_sum_gov = sum(pe_sum_gov))

# Encontre os horários de pico
horarios_pico <- dados_agrupados[dados_agrupados$pe_sum_gov == max(dados_agrupados$pe_sum_gov), ]

# Crie o gráfico de linhas
ggplot(dados_agrupados, aes(x = as.POSIXct(paste("1970-01-01", te_started_at_hour)), y = pe_sum_gov)) +
  geom_line(color = "blue") +
  geom_point(data = horarios_pico, aes(x = as.POSIXct(paste("1970-01-01", te_started_at_hour)), y = pe_sum_gov), color = "red", size = 3) +
  labs(title = "Horários de Pico",
       x = "Horário",
       y = "Total Carregado") +
  scale_x_datetime(date_labels = "%H:%M", date_breaks = "1 hour") +  # Eixo x a cada hora
  scale_y_continuous(labels = scales::number_format(scale = 1e-4, suffix = "M")) +  # Eixo y a cada 10 mil litros
  theme_minimal()


############################# TOTAL CARREGADO POR turno ######################################################

# Converta te_started_at para classe POSIXct se ainda não estiver
ds$te_started_at <- as.POSIXct(ds$te_started_at)

# Crie uma variável de turno baseada nas horas
ds <- ds %>%
  mutate(turno = case_when(
    hour(te_started_at) >= 6 & hour(te_started_at) < 12 ~ "Manhã",
    hour(te_started_at) >= 12 & hour(te_started_at) < 18 ~ "Tarde",
    TRUE ~ "Noite"
  ))

# Agrupe e resuma os dados usando dplyr
dados_agrupados <- ds %>%
  group_by(turno) %>%
  summarise(pe_sum_gov = sum(pe_sum_gov))

# Ajuste da escala para representar valores na ordem de 2.000.000
escala_y <- max(dados_agrupados$pe_sum_gov) / 5  # Ajuste conforme necessário
ggplot(dados_agrupados, aes(x = turno, y = pe_sum_gov, fill = turno)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Soma Carregada por Turno",
       x = "Turno",
       y = "Soma Carregada") +
  scale_y_continuous(labels = scales::number_format(scale = 1e-6, suffix = "M")) +
  theme_minimal()
