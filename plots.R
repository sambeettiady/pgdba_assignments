rm(list = ls())

library(ggplot2)
library(tidyr)
library(plotly)

simulated_data = data.frame(n = 1:30000)
simulated_data$n_y = simulated_data$n
simulated_data$one = 1
simulated_data$nsquare = simulated_data$n^2
simulated_data$log2n = log2(simulated_data$n)
simulated_data$nlog2n = simulated_data$n*simulated_data$log2n
simulated_data$nsquarelog2n = simulated_data$nsquare*simulated_data$log2n
#simulated_data$ncube = simulated_data$n^3
simulated_data$nlog2nsquare = simulated_data$n*(simulated_data$log2n^2)
simulated_data$one.zeroone = 1.01^simulated_data$n

plot_data = gather(data = simulated_data,key = function_name,value = value,n_y:one.zeroone)

g = ggplot(data = plot_data, mapping = aes(x = n, y = value,col = function_name)) + geom_line()
g
ggplotly(g)
