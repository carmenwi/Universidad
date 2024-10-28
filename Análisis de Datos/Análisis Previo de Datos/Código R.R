# Análisis previo de datos
# ......................................................

# Ejercicio 1. Creación de gráficos adecuados para cada variable.

datos0 <- read.csv("C://Users//witsm//Desktop//Análisis.M//R//almacén.csv", 
                   encoding="latin1", sep=";", dec=",")
attach(datos0)
print(as.numeric(días[1])-2)
# Convierto variables a numeric

datos0$edadendías <- as.numeric(edadendías)
datos0$sueldo <- as.numeric(sueldo)
datos0$años_trab <- as.integer(años_trab)
datos0$días <- as.numeric(días)
datos0$horacompra <- as.numeric(datos0$horacompra)
datos0$ciudad <- as.numeric(datos0$ciudad)

# Filtro las columnas importantes de cara al análisis

library(dplyr)

datos <- datos0 |> select(ciudad, sexo, hijos, casapropia, compra,
                          horacompra, gastomensual, díacompra, edad,
                          compra_A, edadendías, puesto, sueldo, años_trab,
                          días, hora_cod)


# Comienzo con la creación de gráficos
library(Rcmdr)


#.........................................................

# Ejercicio 2: Datos ausentes

# 1) Localizamos datos ausentes en nuestro dataset

sapply(datos0, function(x)(sum(is.na(x)))) 

     # Conclusión: No hay datos ausentes

# ......................................................

# Ejercicio 3: Datos atípicos

# 1) Dibujamos boxplot de cada variable para detectar valores atípicos: 
     # horacompra, gastomensual, edad, sueldo, días

     # horacompra

bp1 <- boxplot(datos0$horacompra, 
              col="lightblue",
              horizontal=T,
              outpch=21, outcol="black", outbg="lightblue",
              col.axis="#0A335D",
              cex.axis=0.8, 
              frame.plot=F)
           # 4 datos atípicos: Por debajo de las 13h
           atipicos1 <- subset(datos0, (horacompra<13) == TRUE)
           head(atipicos1)
           
           
      # gastomensual
           
 bp2 <- boxplot(datos0$gastomensual, 
                col="lightblue",
                horizontal=T,
                outpch=21, outcol="black", outbg="lightblue",
                col.axis="#0A335D",
                cex.axis=0.8, 
                frame.plot=F)
            # No hay valores atípicos

 
      # edad
 bp3 <- boxplot(datos0$edad, 
                col="lightblue",
                horizontal=T,
                outpch=21, outcol="black", outbg="lightblue",
                col.axis="#0A335D",
                cex.axis=0.8, 
                frame.plot=F)
            # No hay valores atípicos
 
 
      # sueldo
 bp4 <- boxplot(datos$sueldo, 
                col="lightblue",
                horizontal=T,
                outpch=21, outcol="black", outbg="lightblue",
                col.axis="#0A335D",
                cex.axis=0.8, 
                frame.plot=F)
            # 1 valor atípico: por encima de 4.250€ 
              atipicos2 <- subset(datos, (sueldo>4.25) == TRUE)
              head(atipicos2) # Pertenece a directivo
              
          
       # días (trabajados)    
 bp5 <- boxplot(datos$días, 
                col="lightblue",
                horizontal=T,
                outpch=21, outcol="black", outbg="lightblue",
                col.axis="#0A335D",
                cex.axis=0.8, 
                frame.plot=F)
             # No hay valores atípicos

 # 2) Reemplazamos dichos valores 
 
     # horacompra
 datos$horacompra <- ifelse(datos$horacompra<13, 13, datos$horacompra)

 boxplot(datos$horacompra, 
         col="lightblue",
         horizontal=T,
         outpch=21, outcol="black", outbg="lightblue",
         col.axis="#0A335D",
         cex.axis=0.8, 
         frame.plot=F)
 
     #sueldo
 datos$sueldo <- ifelse(datos$sueldo>4.215, 4.250, datos$sueldo)
 
 boxplot(datos$sueldo, 
         col="lightblue",
         horizontal=T,
         outpch=21, outcol="black", outbg="lightblue",
         col.axis="#0A335D",
         cex.axis=0.8, 
         frame.plot=F)
 
 # ...........................................................
 
 # Ejercicio 4: Comprobación de supuestos básicos
 
 # 1) Normalidad
 
 knitr::opts_chunk$set(echo = TRUE)
 # cargamos librerías
 library(tidyverse)
 library(mvtnorm) #rmvnorm
 library(mixtools) # ellipse
 library(plotly) # graficos 3d
 library(plot3D)
 library(MASS)  #kde2d
 library(Matrix) #rankMatrix()
 library(flextable)
 library(officer) #fp_border
 library(GGally) #ggpairs
 library(psych)  #pairs.panels
 library(aplpack)  #faces
 library(corrplot) # corrplot
 library(rstatix)  # cor_pmat, cor_mat, cor_get_pval
 library(visdat)  # vis_dat (para ver estructura de datos en form grafica)
 library(MVN) #mvn test de normalidad
 library(car)
 library(NHANES) #para datos ejemplo
 library(naniar)  # para imputación
 library(simputation) #impute_lm para imputación con regresion
 library(outliers) #grubbs.test
 library(plotrix) #draw.circle
 library(nortest) # lillie.test
 library(goftest) #cvm.test y ad.test
 library(biotools) #boxM

 
     # variables numéricas sin datos atípicos
     variables1 <- datos |> select(horacompra,gastomensual)
     variables1 <- names(variables1)
     
     variables <- names(datos0)[!names(datos0) %in% c("DNI","tfno","sexo","hijos",
                                                       "casapropia","compra",
                                                       "díacompra","fecha_nac",
                                                       "edad","compra_A","puesto",
                                                       "fecha_trab","años_trab",
                                                       "hora_cod")]
 head(variables)
 op <- par(mfrow=c(3,2))
 op2 <- par(mfrow=c(2,2))
 

 # Prueba de Shapiro-Wilk

 # 1
for (variable in variables1) {
  d <- datos0[[variable]]
  shapiro_result <- shapiro.test(d)
  cat(paste("Resultado de la prueba Shapiro:", variable), "\n")
  print(shapiro_result)
  cat("\n")
  # Histograma
  hist(d, col="lightblue", main = paste("Histograma de", variable))  # Paréntesis añadido
  # Gráfico Q-Q plot
  op2
  qqnorm(d)
  qqline(d)
}
  # 2

for (variable in variables) {
  d <- datos0[[variable]]
  shapiro_result <- shapiro.test(d)
  cat(paste("Resultado de la prueba Shapiro:", variable), "\n")
  print(shapiro_result)
  cat("\n")
  # Histograma
  hist(d, col="lightblue", main = paste("Histograma de", variable))  # Paréntesis añadido
  # Gráfico Q-Q plot
  op
  qqnorm(d)
  qqline(d)
}

# 2) Linealidad

# Si tuviéramos NA's, los eliminaríamos de los datos:
# d <- NA.comit(datos[variables])

  # - Matriz de correlación (linealidad)
  d <- datos0[variables]
  matriz_cor <- cor(d)
  
  datos_num <- datos0 |> select(ciudad,horacompra, gastomensual,edadendías,sueldo,días)

 
  # ¿Son variables dependientes?
  variables_cat <- names(datos0)[names(datos0) %in% c("sexo","hijos",
                                                   "casapropia","compra",
                                                   "díacompra","fecha_nac",
                                                   "compra_A","puesto",
                                                   "fecha_trab",
                                                   "hora_cod")]
  
  # Inicializar una tabla vacía
  p_valores <- data.frame(variable1 = character(), variable2 = character(), p_valor = numeric())
  
  for (i in 1:length(variables_cat)) {
    for (j in (i + 1):length(variables_cat)) {
      variable1 <- variables_cat[[i]]
      variable2 <- variables_cat[[j]]
      d <- table(datos0[[variable1]], datos0[[variable2]])
      chi_resultado <- chisq.test(d)
      cat(paste("Dependencia entre:", variable1, "y", variable2), "\n")
      
      # Agregar nueva fila a la tabla
      nueva_fila <- data.frame(variable1 = variable1, variable2 = variable2, p_valor = chi_resultado$p.value)
      p_valores <- rbind(p_valores, nueva_fila)
      
      cat("\n")
    }
  }
  
  # Imprimir la tabla final
  print(p_valores)
  library(dplyr)
  
  # Acceder al p-valor del objeto "htest"
  pvalue <- chi_resultado$p.value
  
  # Filtrar si el p-valor es menor al umbral
  if (pvalue < 0.05) {
    cat("Las variables son dependientes (p-valor:", pvalue, ")\n")
  } else {
    cat("Las variables no son dependientes (p-valor:", pvalue, ")\n")
  }
  
  
  # Prueba Chi-cuadrado (independencia)
    chi_result <- chisq.test(datos$sexo,datos$sueldo)
    cat(paste("Resultado de la prueba Chi", variable), "\n")
    print(chi_result)
    cat("\n")
  
    # Si p-valor < 0.05 Rechazamos hipótesis de dependencia
# 3) Homocedasticidad
  
  # Ajustamos el modelo de regresión
  modelo <- lm(edadendías ~ gastomensual + días + sueldo, data = datos0)
  modelo2 <- lm(gastomensual ~ edadendías + días + sueldo, data = datos0)
  modelo3 <- lm(días ~ edadendías + gastomensual + sueldo, data = datos0)
  modelo4 <- lm(sueldo ~ edadendías + gastomensual + días, data = datos0)
  
  # Verificamos la homocedasticidad graficando los residuos estandarizados versus los valores ajustados
  # (Versión R)
  plot(modelo$fitted.values, rstandard(modelo),
       xlab = "Valores Ajustados",
       ylab = "Residuos Estandarizados",
       main = "Gráfico de Homocedasticidad")
  abline(h = 0, col = "red")  # Línea horizontal en y = 0
  
  # Versión ggplot

  library(ggplot2)
  
  # Suponiendo que 'modelo' es tu modelo de regresión lineal y 'datos' son tus datos originales
  # Debes reemplazar 'modelo' y 'datos' con los nombres reales de tu modelo y tus datos
  
  # Calcula los residuos estandarizados
  residuos_estandarizados <- rstandard(modelo)
  residuos_estandarizados2 <- rstandard(modelo2)
  residuos_estandarizados3 <- rstandard(modelo3)
  residuos_estandarizados4 <- rstandard(modelo4)
  
  # Crea un data frame con los residuos estandarizados y los valores ajustados
  datos_residuos <- data.frame(Residuos = residuos_estandarizados, Valores_Ajustados = predict(modelo))
  datos_residuos2 <- data.frame(Residuos = residuos_estandarizados2, Valores_Ajustados = predict(modelo2))
  datos_residuos3 <- data.frame(Residuos = residuos_estandarizados3, Valores_Ajustados = predict(modelo3))
  datos_residuos4 <- data.frame(Residuos = residuos_estandarizados4, Valores_Ajustados = predict(modelo4))
  
  # Grafica la homocedasticidad
  ggplot(datos_residuos, aes(x = Valores_Ajustados, y = Residuos)) +
    geom_point() + 
    geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
    labs(x = "Valores ajustados", y = "Residuos estandarizados") +
    ggtitle("Gráfico de Homocedasticidad")

  ggplot(datos_residuos2, aes(x = Valores_Ajustados, y = Residuos)) +
    geom_point() + 
    geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
    labs(x = "Valores ajustados", y = "Residuos estandarizados") +
    ggtitle("Gráfico de Homocedasticidad")
  
  ggplot(datos_residuos3, aes(x = Valores_Ajustados, y = Residuos)) +
    geom_point() + 
    geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
    labs(x = "Valores ajustados", y = "Residuos estandarizados") +
    ggtitle("Gráfico de Homocedasticidad")
  
  ggplot(datos_residuos4, aes(x = Valores_Ajustados, y = Residuos)) +
    geom_point() + 
    geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
    labs(x = "Valores ajustados", y = "Residuos estandarizados") +
    ggtitle("Gráfico de Homocedasticidad")
  
  # Cargamos del paquete lmtest para utilizar la función bptest()
  library(lmtest)
  
  # Suponiendo que 'modelo' es tu modelo de regresión lineal y 'datos' son tus datos originales
  # Debes reemplazar 'modelo' y 'datos' con los nombres reales de tu modelo y tus datos
  
  # Realiza el test de Breusch-Pagan
  resultado_test <- bptest(modelo)
  resultado_test2 <- bptest(modelo2)
  resultado_test3 <- bptest(modelo3)
  resultado_test4 <- bptest(modelo4)

  