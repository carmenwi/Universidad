#                Caso 2
# ============================================================

# =============== 2.1 ===============================

# Instalar y cargar las librerías necesarias

library(tidyverse) # Manipulación de datos
library(broom) # Limpieza/Ordenación de modelos
library(caret) # Creación y evaluación de modelos
library(haven) # Lectura de archivos SPSS

datos_cred <- read_sav("tarea5.sav")

# Quitamos variable ZRE_1
datos_cred <- datos_cred[-10]

# Asegurar que la variable objetivo es un factor
datos_cred <- datos_cred %>%
  mutate(default = as.factor(default))

# ========== 2.2. MODELO CON TODAS VARIABLES ======================

# Ajustar el modelo de regresión logística
log_model <- glm(default ~ ., data = datos_cred, family = binomial)

# Resumen del modelo
summary(log_model)

# Dividir los datos en conjuntos de entrenamiento y prueba
set.seed(42)
split <- createDataPartition(datos_cred$default, p = 0.7, list = FALSE)
train_data <- datos_cred[split, ]
test_data <- datos_cred[-split, ]

# Ajustar un modelo de regresión logística
log_model <- train(default ~ ., data = train_data, method = "glm", family = binomial, trControl = trainControl(method = "cv", number = 10))

# Ver los p-valores para determinar la importancia de las variables
tidy(log_model$finalModel) %>%
  filter(p.value < 0.05) %>%
  arrange(p.value)
# Variables significativas: employ,creddebt,address,debtinc

# ========== 2.3. MODELO CON VARIABLES SIGNIFICATIVAS  ======================

datos_cred2 <- datos_cred %>% select(c("employ","creddebt","address","debtinc","default"))

# -- SIN CV
# Ajustar el modelo de regresión logística
log_model2 <- glm(default ~ ., data = datos_cred2, family = binomial)

# Resumen del modelo
summary(log_model2)

# -- CON CV
# Dividir los datos en conjuntos de entrenamiento y prueba
set.seed(42)
split <- createDataPartition(datos_cred2$default, p = 0.7, list = FALSE)
train_data <- datos_cred2[split, ]
test_data <- datos_cred2[-split, ]

# Ajustar un modelo de regresión logística
log_model2 <- train(default ~ ., data = train_data, method = "glm", family = binomial, trControl = trainControl(method = "cv", number = 10))
summary(log_model2)

# =================== 2.4. ==================================

# Predicciones en el conjunto de entrenamiento
train_preds <- predict(log_model2, newdata = train_data, type = "prob")[,2]
train_preds_class <- ifelse(train_preds > 0.5, 1, 0)

# Matriz de confusión y métricas de rendimiento en el conjunto de entrenamiento
matriz <- confusionMatrix(as.factor(train_preds_class), train_data$default)
m <- matriz$table
total <- sum(m)
precision <- m[1,1] / (m[1,1] + m[1,2])
recall <- m[1,1] / (m[1,1] + m[2,1])
f1_s <- 2 * (precision * recall / (precision + recall))



# Predicciones en el conjunto de prueba
test_preds <- predict(log_model2, newdata = test_data, type = "prob")[,2]
test_preds_class <- ifelse(test_preds > 0.5, 1, 0)

# Matriz de confusión y métricas de rendimiento en el conjunto de prueba
matriz <- confusionMatrix(as.factor(test_preds_class), test_data$default)
m <- matriz$table
total <- sum(m)
precision <- m[1,1] / (m[1,1] + m[1,2])
recall <- m[1,1] / (m[1,1] + m[2,1])
f1_s <- 2 * (precision * recall / (precision + recall))

# ============================ 2.5. ====================================

# Datos del nuevo cliente
nuevo_cliente <- tibble(
  age = 37,
  ed = 1,
  employ = 20,
  address = 13,
  income = 41,
  debtinc = 12.9,
  creddebt = 0.9,
  othdebt = 4.49
)

# Predecir la probabilidad de default para el nuevo cliente
nuevo_cliente_pred <- predict(log_model2, newdata = nuevo_cliente, type = "prob")[,2]
nuevo_cliente_pred_class <- ifelse(nuevo_cliente_pred > 0.5, 1, 0)

# Mostrar la predicción
if (nuevo_cliente_pred_class == 1) {
  print("No se aprueba el crédito (default)")
} else {
  print("Se aprueba el crédito (no default)")
}

# Explicación del código:
# - glm(): Ajusta un modelo de regresión logística.
# - trainControl(): Configura una validación cruzada 10-fold.
# - train(): Ajusta un modelo de regresión logística con validación cruzada.
# - tidy(): Extrae los p-valores del modelo.
# - select(): Selecciona las variables significativas.
# - predict(): Realiza predicciones y retorna las probabilidades de default.
# - ifelse(): Convierte las probabilidades en clases binarias.
# - confusionMatrix(): Calcula la matriz de confusión y las métricas de rendimiento.
