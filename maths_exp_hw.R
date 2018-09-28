rm(list = ls())

setwd('Desktop/Inference - maths experiment/')

library(readr)
library(dplyr)
library(ggplot2)

df_group_1 = read_csv(file = 'group_1.csv')
df_group_2 = read_csv(file = 'group_2.csv')

df_group_1$group = 'A'
df_group_2$group = 'B'

df_group = rbind(df_group_1,df_group_2)

dot_diagram_1 = ggplot(data = df_group_1,mapping = aes(x = Time,y = 0)) + geom_point(alpha = 0.5,col = 'blue',size = 5)
dot_diagram_1

dot_diagram_2 = ggplot(data = df_group_2,mapping = aes(x = Time,y = 0)) + geom_point(alpha = 0.5,col = 'blue')
dot_diagram_2

dot_diagram_overall = ggplot(data = df_group,mapping = aes(x = Time,y = 0,col = group)) + geom_jitter(alpha = 0.7,size = 5) + ylim(c(-1,10))
dot_diagram_overall

df_group_summary = df_group %>% group_by(group) %>% summarise(mean_time = mean(Time),mean_mistake_rate = 100/51*mean(Mistakes))

set.seed(1)
group_1_split = sample(x = 1:nrow(df_group_1),size = 10,replace = F)
df_group_11 = df_group_1[group_1_split,]
df_group_11$group = 'A1'
df_group_12 = df_group_1[-group_1_split,]
df_group_12$group = 'A2'
df_group_1 = rbind(df_group_11,df_group_12)

set.seed(2)
group_2_split = sample(x = 1:nrow(df_group_2),size = 15,replace = F)
df_group_21 = df_group_2[group_2_split,]
df_group_21$group = 'B1'
df_group_22 = df_group_2[-group_2_split,]
df_group_22$group = 'B2'
df_group_2 = rbind(df_group_21,df_group_22)

dot_diagram_1_split = ggplot(data = df_group_1,mapping = aes(x = Time,y = 0,col = group)) + geom_jitter(alpha = 0.7,size = 5) + ylim(c(-1,10))
dot_diagram_1_split
df_group_1_summary = df_group_1 %>% group_by(group) %>% summarise(mean_time = mean(Time),mean_mistake_rate = 100/51*mean(Mistakes))

dot_diagram_2_split = ggplot(data = df_group_2,mapping = aes(x = Time,y = 0,col = group)) + geom_jitter(alpha = 0.7,size = 5) + ylim(c(-1,10))
dot_diagram_2_split
df_group_2_summary = df_group_2 %>% group_by(group) %>% summarise(mean_time = mean(Time),mean_mistake_rate = 100/51*mean(Mistakes))

hist(df_group_1$Time)
hist(df_group_2$Time)

for(i in 1:10){
    z = runif(n = 1,min = 0,max = 1)
    print(z)
}
