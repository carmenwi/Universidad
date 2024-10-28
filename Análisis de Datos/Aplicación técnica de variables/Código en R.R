df <- read.csv("C:/Users/witsm/Desktop/Análisis.M/Actividades/vinos_modif.csv", 
                  header = TRUE, encoding = "latin1", sep = ";")
library(Rcmdr)

# 1.1. Análisis factorial sin rotación de factores

  fa_result <- factanal(df[,2:8], factors = 2, rotation = "none")
  fa_result


# 1.2. Análisis factorial con rotación Varimax

  fav_result <- factanal(df[,2:8], factors = 2, rotation = "varimax")
  fav_result

# 1.3. Análisis factorial sin puntuacion
  
  library(stats)

  # Dataframe de solo factores
  df_factors <- df[,2:8]

  # Análisis
  fa2_result <- factanal(df_factors, factors = 2, scores = "none", 
                        rotation = "varimax")
  fa2_result


# 2. N de factores a extraer

  library(psych)

  # Subset de datos numéricos
  df_numeric <- df[2:8]

  # Estimamos el nº de factores usando los valores eigen
  ev <- eigen(cor(df_numeric))$values
  ev

  # Análisis paralelo para determinar el nº de factores
  pa <- fa.parallel(df_numeric, fm = "minres", fa = "both", n.iter = 100)
  pa

# 3. Conclusiones
  
  # Cargar librerías necesarias
  library(psych)
  library(GPArotation)
  
  # Realizar análisis factorial exploratorio
  fa_result <- fa(r = cor(df_numeric), 
                  nfactors = 2, rotate = "varimax")
  
  # Imprimir la carga de los factores y la varianza explicada
  print(fa_result$loadings)
  print(fa_result$Vaccounted)
  
  # El número de factores a extraer es 2 basado en el criterio de Kaiser 
  # (autovalores mayores que 1) y el análisis de la pantalla (scree plot).
  # Estos dos factores representan las dimensiones subyacentes más 
  # significativas que explican la variabilidad en los datos.
  
  
