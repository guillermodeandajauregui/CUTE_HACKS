################################################################################
################################################################################
# percolation based on edge weights 

################################################################################
#libraries ----
library(tidyverse)
library(igraph)

################################################################################

# generate network (for example purposes) ----
# ignore if you have your own network ----

set.seed(725)
m <- matrix(data = abs(rnorm(n = 1000*1000)), nrow = 1000, ncol = 1000)

rownames(m) <- paste0("g", 1:1000)
colnames(m) <- paste0("g", 1:1000)

m[upper.tri(m)] <- t(m)[upper.tri(m)]
diag(m) <- 0

# m[1:5, 1:5]

df <- 
  m |> 
  as.data.frame() |> 
  rownames_to_column(var = "n1") |> 
  pivot_longer(cols = -n1, names_to =  "n2", values_to = "weight") |> 
  as_tibble()

################################################################################

# read network (if you have a node-node-weight data frame) ----

# df <- read_delim(file = "path/to/file", delim = "your_delim")

################################################################################

# make igraph object ----

g <- graph_from_data_frame(d = df, directed = F)



################################################################################

# define cut thresholds ----

weight_vector <- E(g)$weight

# let's say, quantiles 10, 25, 50, 75, 90, 95, 99, 99.9

my_thresholds <- c(0.01, 0.05, 0.1, 0.25, 0.5, 0.75, 0.90, 0.95, 0.99, 0.991, 0.993, 0.995, 0.997, 0.999)
names(my_thresholds) <- my_thresholds


my_th_values <- quantile(weight_vector, my_thresholds)
names(my_th_values) <- my_thresholds
################################################################################

# calculate component sizes -----



# g1 <- delete_edges(graph = g, edges = E(g)[weight <= my_th_values[8]])
# 
# g
# g1
# 
# max(components(g1)$csize)

my_component_sizes <- 
  lapply(my_th_values, function(i){
    g_prime <- delete_edges(graph = g, edges = E(g)[weight <= i])
    csi <- max(components(g_prime)$csize)
    return(csi)
    
  })
    

my_component_sizes
################################################################################

# plot ----


df_csize <- tibble(x = names(my_component_sizes),
                   y = 100*as.numeric(my_component_sizes)/vcount(g)
                     )


df_csize |> 
  ggplot() + 
  aes(x, y) + 
  geom_point(color = "red") + 
  geom_line(color = "blue", group=1) + 
  ylab("% nodes in LCC") + 
  xlab("weight quantile threshold")
