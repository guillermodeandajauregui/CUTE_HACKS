library(tidyverse)

#generar un dataset mínimo tipo matriz de expresión. 
set.seed(725)
x <- tibble(gene = c("A", "A", "A", "B", "C", "C", "D"),
            S1   = rnorm(7),
            S2   = rnorm(7),
            S3   = rnorm(7)
            )

# notar que la matriz es un dataframe, con id de genes en la columna 1

x_reducida <- 
  x |> 
  group_by(gene) %>% #para cada gene con el mismo id
  summarize(across(where(is.numeric), \(i) median(i, na.rm = TRUE) #puede ser otra fn, 
                                                                   #como max, mean, etc 
                                                                   #segun se necesito
                   )
            )

            
