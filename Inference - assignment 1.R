rm(list = ls())

setwd('/Users/sambeet/Desktop/')

library(readr)
library(ggplot2)
library(dplyr)
library(tidyr)

data_inference = read_csv(file = 'effort_data.csv')
names(data_inference) = c('itil_process_type','complexity','effort','service_domain_type')

#1
mean(data_inference$effort)
median(data_inference$effort)
min(data_inference$effort)
max(data_inference$effort)
quantile(data_inference$effort,0.25)
quantile(data_inference$effort,0.75)
IQR(data_inference$effort)
sd(data_inference$effort)

#2
data_summary = data_inference %>% group_by(itil_process_type,complexity,service_domain_type) %>%
    summarise(mean_effort = mean(effort),median_effort = median(effort),
              stddev_effort = sd(effort)) %>%
    mutate(ipt = abbreviate(itil_process_type,use.classes = T,minlength = T),
           sdt = abbreviate(service_domain_type,use.classes = T,minlength = T),
           c = abbreviate(complexity,use.classes = T,minlength = T)) %>%
    unite(sep = '-',col = 'strata',remove = F,ipt,sdt,c)

tag = xtabs(data = data_summary,formula = round(mean_effort,1)~itil_process_type+service_domain_type+complexity)

#3
bar_plot = ggplot(data = data_summary,mapping = aes(x = strata,y = median_effort,fill = strata)) + geom_bar(stat = 'identity') + xlab('Strata') + ylab('Median Effort') + theme_grey(base_size = 25) + ggtitle('Median Effort by Strata') + theme(legend.text=element_text(size=50));bar_plot

#4
overall_hist = ggplot(data = data_inference) + geom_histogram(mapping = aes(x = effort,y = ..count../sum(..count..)),fill = 'grey',col = 'black',bins = 25) + ylab('Relative Frequency') + theme_grey(base_size = 25) + xlab('Effort') + ggtitle('Histogram of Effort - Overall');overall_hist

#5
data_stratified = data_inference %>% 
    mutate(ipt = abbreviate(itil_process_type,use.classes = T,minlength = T),
           sdt = abbreviate(service_domain_type,use.classes = T,minlength = T),
           c = abbreviate(complexity,use.classes = T,minlength = T)) %>% 
    unite(sep = '-',col = 'strata',remove = F,ipt,sdt,c)

stratified_hist = ggplot(data = data_stratified,aes(x = effort)) + ylab('Relative Frequency') + 
    xlab('Effort') + ggtitle('Histogram of Effort - Stratified') + 
    facet_grid(ipt + sdt ~ complexity) + theme_grey(base_size = 30) +
    geom_histogram(aes(y = ..count.. / sapply(PANEL, FUN=function(x) sum(count[PANEL == x]))),fill = 'grey',col = 'black',bins = 20);stratified_hist

#6
overall_cdf = ggplot(data = data_stratified) + 
    stat_ecdf(mapping = aes(x = effort),col = 'black') + ylab('Cumulative Relative Frequency') + 
    xlab('Effort') + ggtitle('Ogive of Effort - Overall') + theme_grey(base_size = 20);overall_cdf

strata_cdf_complexity = ggplot(data = data_stratified) + stat_ecdf(mapping = aes(x = effort,col = c)) + 
    ylab('Cumulative Relative Frequency') + theme_grey(base_size = 20) + xlab('Effort') +
    stat_ecdf(mapping = aes(x = effort,col = 'Overall')) + ggtitle('Complexity')
strata_cdf_ipt = ggplot(data = data_stratified) + stat_ecdf(mapping = aes(x = effort,col = ipt)) +
    xlab('Effort') + theme_grey(base_size = 20) + ggtitle('Process Type') +
    stat_ecdf(mapping = aes(x = effort,col = 'Overall'))
strata_cdf_sdt = ggplot(data = data_stratified) + stat_ecdf(mapping = aes(x = effort,col = sdt)) +
    xlab('Effort') + theme_grey(base_size = 20) + stat_ecdf(mapping = aes(x = effort,col = 'Overall')) + ggtitle('Domain Type')
grid.arrange(strata_cdf_complexity,strata_cdf_ipt,strata_cdf_sdt,ncol = 3)
