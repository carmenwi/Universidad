#             CASO   1 
# ====================================

# 1.1 ================================

# Cargar dataset
library(haven)
datos_fut <- read_sav("fotbal.sav")

# 1.2 ================================

# Seleccionamos las variables
datos_fut <- datos_fut[,c("y","x2", "x7", "x8")]


# Preparamos los conjuntos de entrenamiento y prueba
train_indices <- 1:22  # Índices para entrenamiento (22 observaciones)
test_indices <- 23:28  # Índices para prueba (6 observaciones)
datos_train <- datos_fut[train_indices, ]
datos_test <- datos_fut[test_indices, ]

# Calculamos medias y desviaciones estándar del conjunto de entrenamiento
medias <- apply(datos_train, 2, mean)
desviaciones <- apply(datos_train, 2, sd)

# Estandarizamos los datos de entrenamiento
datos_train_estandarizados <- scale(datos_train, center = medias, scale = desviaciones)
datos_train_estandarizados <- as.data.frame(datos_train_estandarizados)

# Estandarizamos los datos de prueba utilizando las estadísticas del conjunto de entrenamiento
datos_test_estandarizados <- scale(datos_test, center = medias, scale = desviaciones)
datos_test_estandarizados <- as.data.frame(datos_test_estandarizados)

# Cargamos librerías necesarias
library(caret)

# Dividimos nuestras variables
x_train <- datos_train_estandarizados[, c("x2", "x7", "x8")]
y_train <- datos_train_estandarizados$y
x_test <- datos_test_estandarizados[, c("x2", "x7", "x8")]
y_test <- datos_test_estandarizados$y

# Configuramos validación cruzada k-folds
control <- trainControl(method = "cv", number = 10)  # Validación cruzada 10-fold

# Entrenamos el modelo de regresión lineal con validación cruzada
set.seed(123)
modelo_lm <- train(
  x = x_train, y = y_train,
  method = "lm",
  trControl = control
)

# 1.3 ======================================

# Realizar predicciones y calcular el error RMSE en el conjunto de prueba
predicciones_lm <- predict(modelo_lm, newdata = x_test)
rmse_lm <- sqrt(mean((y_test - predicciones_lm)^2))

# Calcular RMSE en el conjunto de entrenamiento
rmse_train <- sqrt(mean((y_train - predict(modelo_lm, newdata = x_train))^2))

cat("RMSE en el conjunto de entrenamiento:", rmse_train, "\n")
cat("RMSE en el conjunto de prueba para la regresión lineal:", rmse_lm, "\n")


# Extraer coeficientes del modelo para evaluar la contribución de cada variable
coeficientes <- coef(modelo_lm$finalModel)
resumen <- summary(modelo_lm$finalModel)

# Imprimir resultados
print(coeficientes)
print(resumen)

# Calculamos los residuos para el conjunto de prueba
residuos <- y_test - predicciones_lm

# Q-Q Plot
qqnorm(residuos)
qqline(residuos, col = "red")

# 1.4 ===============================================

# Nueva predicción
# Almacenamos media y sd de "y" originales
media_y <- mean(datos_fut$y) # Media original de y 
desviacion_estandar_y <- sd(datos_fut$y) # Desviación estándar original de y

# Creamos el df con los nuevos datos
datos_nuevos <- data.frame("x2" = 2300, "x7" = 56, "x8" = 2100)

# Los estandarizamos utilizando las estadísticas del conjunto de entrenamiento
datos_nuevos <- scale(datos_nuevos, center = medias[-1], scale = desviaciones[-1])

# Hacemos predicción
prediccion_nueva <- predict(modelo_lm, newdata = datos_nuevos)
prediccion_nueva

# Desestandarizamos el resultado
num_juegos <- prediccion_nueva * desviacion_estandar_y + media_y

# Resultado final
num_juegos

# 1.5 =============================================

# Dividimos nuestras variables
x_train <- datos_train_estandarizados[, c("x2", "x8")]
y_train <- datos_train_estandarizados$y
x_test <- datos_test_estandarizados[, c("x2", "x8")]
y_test <- datos_test_estandarizados$y

# Configuramos validación cruzada k-folds
control <- trainControl(method = "cv", number = 10)  # Validación cruzada 10-fold

# Entrenamos el modelo de regresión lineal con validación cruzada
set.seed(123)
modelo_2 <- train(
  x = x_train, y = y_train,
  method = "lm",
  trControl = control
)

# Realizar predicciones y calcular el error RMSE en el conjunto de prueba
predicciones_2 <- predict(modelo_2, newdata = x_test)
rmse_lm2 <- sqrt(mean((y_test - predicciones_2)^2))

# Extraer coeficientes del modelo para evaluar la contribución de cada variable
coeficientes <- coef(modelo_2$finalModel)
resumen <- summary(modelo_2$finalModel)

# Imprimir resultados
cat("RMSE en el conjunto de prueba para la regresión lineal:", rmse_lm2, "\n")
print(coeficientes)
print(resumen)

# Explicación del código:
# - trainControl() configura una validación cruzada 10-fold para ajustar el modelo lineal.
# - train() ajusta un modelo de regresión lineal con las variables predictoras especificadas.
# - predict() evalúa el modelo en el conjunto de prueba y calcula el RMSE para medir el error.
# - coef() extrae los coeficientes del modelo, mostrando la contribución de cada variable predictora.
