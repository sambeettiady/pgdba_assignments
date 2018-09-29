rm(list = ls())

library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(car)
library(caret)
library(corrplot)


setwd('data/')

randdata = read_csv(file = 'randData.csv')
randvars = read_csv(file = 'randVars.csv')

#summary(randdata)

randdata_missing = randdata[!complete.cases(randdata),]
randdata = randdata[complete.cases(randdata),]
names(randdata) = tolower(names(randdata))
randvars$`Variable or Feature` = tolower(randvars$`Variable or Feature`)

table(randdata$census_division,randdata$census_division)

randdata_state = randdata %>% select(u_state,store_no) %>% unique(.) %>% group_by(u_state) %>% 
    summarise(num_stores_in_state = n())
randdata_city = randdata %>% select(u_city,store_no) %>% unique(.) %>% group_by(u_city) %>% 
    summarise(num_stores_in_city = n())
randdata_region = randdata %>% select(census_region,store_no) %>% unique(.) %>% group_by(census_region) %>% 
    summarise(num_stores_in_region = n())
randdata_division = randdata %>% select(census_division,store_no) %>% unique(.) %>% group_by(census_division) %>% 
    summarise(num_stores_in_division = n())
randdata_zip = randdata %>% select(zip,store_no) %>% unique(.) %>% group_by(zip) %>% 
    summarise(num_stores_in_zip = n())
median_salary = median(randdata$avg_pay_rate_pay_type_s[randdata$avg_pay_rate_pay_type_s != 0])

randdata$avg_pay_rate_pay_type_s_mutated = ifelse(randdata$avg_pay_rate_pay_type_s == 0,median_salary,randdata$avg_pay_rate_pay_type_s)
randdata = randdata %>% 
    mutate(profit = revenue_2016 - marketing_exp_2016 -
               (num_assistant_managers + num_cust_acc_reps + num_store_managers)*avg_pay_rate_pay_type_s_mutated -
               num_emp_pay_type_h*avg_pay_rate_pay_type_h*2100) %>% left_join(randdata_state,'u_state') %>%
    left_join(randdata_city,'u_city') %>% left_join(randdata_region,'census_region') %>%
    left_join(randdata_division,'census_division') %>% left_join(randdata_zip,'zip')

write.csv(randdata,'randdata_cleaned.csv',row.names = F)

hist_and_boxplot = function(variable_name){
    par(mfrow = c(1,2))
    hist(randdata[,variable_name][[1]])
    boxplot(randdata[variable_name])
    par(mfrow = c(1,1))
    summary(randdata[variable_name])
}

#Univariate analysis
hist_and_boxplot('revenue_2016')
hist(log(randdata$revenue_2016))
hist_and_boxplot('square_feet')
#3 missing values - square_feet
barchart(randdata$u_state)
#highest num stores in tx,pa,oh,ny,fl,ca
barchart(randdata$census_region)
#highest in south region
barchart(randdata$census_division)
#south atlantic, east north central, west south central have the highest
hist_and_boxplot('tot_attrition_2015')
hist_and_boxplot('tot_attrition_2016')
hist_and_boxplot('num_assistant_managers')
hist_and_boxplot('num_cust_acc_reps')
hist(log1p(randdata$num_cust_acc_reps))
hist_and_boxplot('num_store_managers')
hist_and_boxplot('num_emp_pay_type_h')
hist_and_boxplot('avg_pay_rate_pay_type_s_mutated')
hist(log(randdata$avg_pay_rate_pay_type_s_mutated))
hist_and_boxplot('avg_pay_rate_pay_type_h')
hist_and_boxplot('nat_curr_robbery')
hist(log(randdata$nat_curr_robbery))
hist_and_boxplot('nat_curr_burglary')
hist(log(randdata$nat_curr_burglary))
hist_and_boxplot('nat_curr_mot_veh_theft')
hist(log(randdata$nat_curr_mot_veh_theft))
hist_and_boxplot('nat_past_robbery')
hist(log(randdata$nat_past_robbery))
hist_and_boxplot('nat_past_burglary')
hist(log(randdata$nat_past_burglary))
hist_and_boxplot('nat_past_mot_veh_theft')
hist(log(randdata$nat_past_mot_veh_theft))
barchart(randdata$frontage_road)
#Yes No would be unable to determine
barchart(randdata$num_parking_spaces)
barchart(randdata$signage_visibility_ind)
barchart(factor(randdata$autozone_ind))
barchart(factor(randdata$target_ind))
barchart(factor(randdata$walmart_ind))
barchart(factor(randdata$payless_ind))
barchart(factor(randdata$comp_presence_ind))
barchart(factor(randdata$strip_shop_center_ind))
barchart(factor(randdata$single_tenant_ind))
barchart(factor(randdata$pad_in_shop_center_ind))
hist_and_boxplot('marketing_exp_2016')
hist(log1p(randdata$marketing_exp_2016))
hist_and_boxplot('marketing_exp_2015')
hist(log1p(randdata$marketing_exp_2015))
hist_and_boxplot('tot_num_leads')
hist(log(randdata$tot_num_leads))
hist_and_boxplot('num_converted_to_agreement')
hist(log(randdata$num_converted_to_agreement))
hist_and_boxplot('perc_converted_to_agreement')
hist(log10(randdata$perc_converted_to_agreement))
barchart(factor(randdata$urbanicity))
hist_and_boxplot('profit')
hist_and_boxplot('num_stores_in_state')
hist_and_boxplot('num_stores_in_city')
hist_and_boxplot('num_stores_in_region')
hist_and_boxplot('num_stores_in_division')

corr_mat = cor(randdata[,sapply(FUN = is.numeric,X = randdata)])
write.csv(corr_mat,'correlation_matrix2.csv')             

randdata$frontage_road_present <- ifelse(randdata$frontage_road == 'Yes', 1,0)
randdata$num_parking_spaces_greater10 <- ifelse(randdata$num_parking_spaces == 'Greater than 10', 1,0)
randdata$num_parking_spaces_btw1and10 <- ifelse(randdata$num_parking_spaces == 'Between 1 and 10', 1,0)
randdata$num_parking_spaces_0 <- ifelse(randdata$num_parking_spaces == '0 (e.g., street parking, structure/lot more than 2 doors down, parking in back)' | randdata$num_parking_spaces == 'Unable to determine', 1,0)
randdata$signage_visibility_ind_yes <- ifelse(randdata$signage_visibility_ind == 'Yes', 1,0)
randdata$urbanicity_urban <- ifelse(randdata$urbanicity == 'Urban', 1,0)
randdata$urbanicity_superurban <- ifelse(randdata$urbanicity == 'Superurban', 1,0)
randdata$urbanicity_suburban <- ifelse(randdata$urbanicity == 'Suburban', 1,0)
randdata$urbanicity_rural <- ifelse(randdata$urbanicity == 'Rural', 1,0)
randdata$urbanicity_E_suburban <- ifelse(randdata$urbanicity == 'Emerging suburban', 1,0)

num_vars = randdata[,!names(randdata) %in% c("store_no","zip","u_city","u_state","census_region","census_division","frontage_road",
                                                "num_parking_spaces" , "signage_visibility_ind","autozone_ind","target_ind",
                                                "walmart_ind","payless_ind","comp_presence_ind","strip_shop_center_ind",
                                                "single_tenant_ind","pad_in_shop_center_ind","urbanicity")]

numeric_no_attrition_numstores = num_vars[,!names(num_vars) %in% tolower(c("TOT_ATTRITION_2015","TOT_ATTRITION_2016","NUM_ASSISTANT_MANAGERS",
                                                                            "NUM_CUST_ACC_REPS",
                                                                            "NUM_STORE_MANAGERS",
                                                                            "NUM_EMP_PAY_TYPE_H","num_stores_in_city","num_stores_in_state","num_stores_in_division",
                                                                            "num_stores_in_region","urbanicity"))]

demographic_variables = unique(randdata[,names(randdata) %in% tolower(c("zip","u_city","u_state","census_region","census_division","nat_curr_robbery",
                                                                           "nat_curr_burglary" , "nat_curr_mot_veh_theft","nat_past_robbery","nat_past_burglary",
                                                                           "nat_past_mot_veh_theft","num_stores_in_city","num_stores_in_state","num_stores_in_division",
                                                                           "num_stores_in_region","urbanicity","CYA01V001","CYB02V001","CYA12V001","CYA12V002",
                                                                           "CYA12V003","CYA12V007","CYA12V008","CYA21V001","CYB07VBASE","XCX03V069","PERC_CYEA07V001",
                                                                           "PERC_CYEA07V004","PERC_CYEA07V007","PERC_CYEA07V010","PERC_CYB11V006","PERC_CYB11V007",
                                                                           "PERC_CYC13VV01","AUTOZONE_IND","TARGET_IND","WALMART_IND","PAYLESS_IND","COMP_PRESENCE_IND",
                                                                           "STRIP_SHOP_CENTER_IND","profit", "revenue_2016"))])

randdata_grouped_zip_and_city = randdata %>% group_by(zip,u_city) %>% 
    summarise(num_stores_in_zip_and_city = n(),revenue_2016 = sum(revenue_2016),square_feet = sum(square_feet),
              state = unique(u_state),census_region = unique(census_region),census_division = unique(census_division),
              tot_attrition_2015 = sum(tot_attrition_2015),tot_attrition_2016 = sum(tot_attrition_2016),
              num_assistant_managers = sum(num_assistant_managers),num_cust_acc_reps = sum(num_cust_acc_reps),
              num_store_managers = sum(num_store_managers),num_emp_pay_type_h = sum(num_emp_pay_type_h),
              avg_pay_rate_pay_type_s_mutated = mean(avg_pay_rate_pay_type_s_mutated),
              avg_pay_rate_pay_type_h = mean(avg_pay_rate_pay_type_h),nat_curr_robbery = sum(nat_curr_robbery),
              nat_curr_burglary = sum(nat_curr_burglary),nat_curr_mot_veh_theft = sum(nat_curr_mot_veh_theft),
              nat_past_robbery = sum(nat_past_robbery),nat_past_burglary = sum(nat_past_burglary),
              nat_past_mot_veh_theft = sum(nat_past_mot_veh_theft),autozone_ind = ifelse(sum(autozone_ind) >= 1,1,0),
              target_ind = ifelse(sum(target_ind) >= 1,1,0),walmart_ind = ifelse(sum(walmart_ind) >= 1,1,0),
              payless_ind = ifelse(sum(payless_ind) >= 1,1,0),comp_presence_ind = ifelse(sum(comp_presence_ind) >= 1,1,0),
              strip_shop_center_ind = ifelse(sum(strip_shop_center_ind) >= 1,1,0),
              single_tenant_ind = sum(single_tenant_ind),pad_in_shop_center_ind = sum(pad_in_shop_center_ind),
              marketing_exp_2016 = sum(marketing_exp_2016),marketing_exp_2015 = sum(marketing_exp_2015),
              tot_num_leads = sum(tot_num_leads),num_converted_to_agreement = sum(num_converted_to_agreement),
              cya01v001 = mean(cya01v001),cyb02v001 = mean(cyb02v001),cya12v001 = mean(cya12v001),
              cya12v002 = mean(cya12v002),cya12v003 = mean(cya12v003),cya12v007 = mean(cya12v007),
              cya12v008 = mean(cya12v008),cya21v001 = mean(cya21v001),xcx03v069 = mean(xcx03v069),
              perc_cyea07v001 = sum(cya01v001*perc_cyea07v001)/sum(cya01v001),perc_cyea07v004 = sum(cya01v001*perc_cyea07v004)/sum(cya01v001),
              perc_cyea07v007 = sum(cya01v001*perc_cyea07v007)/sum(cya01v001),perc_cyea07v010 = sum(cya01v001*perc_cyea07v010)/sum(cya01v001),
              perc_cyb11v006 = sum(cya01v001*perc_cyb11v006)/sum(cya01v001),perc_cyb11v007 = sum(cya01v001*perc_cyb11v007)/sum(cya01v001),
              perc_cyc13vv01 = sum(cya01v001*perc_cyc13vv01)/sum(cya01v001),profit = sum(profit),
              num_stores_in_city = unique(num_stores_in_city),num_stores_in_zip = unique(num_stores_in_zip),
              num_stores_in_state = unique(num_stores_in_city),num_stores_in_region = unique(num_stores_in_region),
              num_stores_in_division = unique(num_stores_in_division),frontage_road_present = sum(frontage_road_present),
              num_parking_spaces_greater10 = sum(num_parking_spaces_greater10),num_parking_spaces_btw1and10 = sum(num_parking_spaces_btw1and10),
              num_parking_spaces_0 = sum(num_parking_spaces_0),signage_visibility_ind_yes = sum(signage_visibility_ind_yes),
              urbanicity_urban = sum(urbanicity_urban),urbanicity_superurban = sum(urbanicity_superurban),
              urbanicity_suburban = sum(urbanicity_suburban),urbanicity_rural = sum(urbanicity_rural),
              urbanicity_E_suburban = sum(urbanicity_E_suburban)) %>%
    mutate(perc_converted_to_agreement = 100*num_converted_to_agreement/tot_num_leads)

randdata_grouped_zip_and_city_corr = randdata %>% group_by(zip,u_city) %>% 
    summarise(num_stores_in_zip_and_city = n(),revenue_2016 = sum(revenue_2016),square_feet = sum(square_feet),
              tot_attrition_2015 = sum(tot_attrition_2015),tot_attrition_2016 = sum(tot_attrition_2016),
              num_assistant_managers = sum(num_assistant_managers),num_cust_acc_reps = sum(num_cust_acc_reps),
              num_store_managers = sum(num_store_managers),num_emp_pay_type_h = sum(num_emp_pay_type_h),
              avg_pay_rate_pay_type_s_mutated = mean(avg_pay_rate_pay_type_s_mutated),
              avg_pay_rate_pay_type_h = mean(avg_pay_rate_pay_type_h),nat_curr_robbery = sum(nat_curr_robbery),
              nat_curr_burglary = sum(nat_curr_burglary),nat_curr_mot_veh_theft = sum(nat_curr_mot_veh_theft),
              marketing_exp_2016 = sum(marketing_exp_2016),marketing_exp_2015 = sum(marketing_exp_2015),
              tot_num_leads = sum(tot_num_leads),num_converted_to_agreement = sum(num_converted_to_agreement),
              cya01v001 = mean(cya01v001),cyb02v001 = mean(cyb02v001),cya12v001 = mean(cya12v001),
              cya12v002 = mean(cya12v002),cya12v003 = mean(cya12v003),cya12v007 = mean(cya12v007),
              cya12v008 = mean(cya12v008),cya21v001 = mean(cya21v001),xcx03v069 = mean(xcx03v069),
              perc_cyea07v001 = sum(cya01v001*perc_cyea07v001)/sum(cya01v001),perc_cyea07v004 = sum(cya01v001*perc_cyea07v004)/sum(cya01v001),
              perc_cyea07v007 = sum(cya01v001*perc_cyea07v007)/sum(cya01v001),perc_cyea07v010 = sum(cya01v001*perc_cyea07v010)/sum(cya01v001),
              perc_cyb11v006 = sum(cya01v001*perc_cyb11v006)/sum(cya01v001),perc_cyb11v007 = sum(cya01v001*perc_cyb11v007)/sum(cya01v001),
              perc_cyc13vv01 = sum(cya01v001*perc_cyc13vv01)/sum(cya01v001),num_stores_in_city = unique(num_stores_in_city)) %>%
    mutate(perc_converted_to_agreement = 100*num_converted_to_agreement/tot_num_leads) %>% ungroup() %>% select(-zip)

corr_mat = cor(randdata_grouped_zip_and_city_corr[,sapply(FUN = is.numeric,X = randdata_grouped_zip_and_city_corr)])
corrplot.mixed(abs(corr_mat), order = "hclust",tl.pos = 'lt',diag = 'u')

randdata_grouped_zip_and_city$NM <- ifelse(randdata_grouped_zip_and_city$state == 'NM', 1, 0)
randdata_grouped_zip_and_city$MO <- ifelse(randdata_grouped_zip_and_city$state == 'MO', 1, 0)
randdata_grouped_zip_and_city$MD <- ifelse(randdata_grouped_zip_and_city$state == 'MD', 1, 0)
randdata_grouped_zip_and_city$KY <- ifelse(randdata_grouped_zip_and_city$state == 'KY', 1, 0)
randdata_grouped_zip_and_city$IN <- ifelse(randdata_grouped_zip_and_city$state == 'IN', 1, 0)
randdata_grouped_zip_and_city$CO <- ifelse(randdata_grouped_zip_and_city$state == 'CO', 1, 0)
randdata_grouped_zip_and_city$OR <- ifelse(randdata_grouped_zip_and_city$state == 'OR', 1, 0)
randdata_grouped_zip_and_city$AZ <- ifelse(randdata_grouped_zip_and_city$state == 'AZ', 1, 0)
randdata_grouped_zip_and_city$WY <- ifelse(randdata_grouped_zip_and_city$state == 'WY', 1, 0)
randdata_grouped_zip_and_city$WA <- ifelse(randdata_grouped_zip_and_city$state == 'WA', 1, 0)
randdata_grouped_zip_and_city$TN <- ifelse(randdata_grouped_zip_and_city$state == 'TN', 1, 0)
randdata_grouped_zip_and_city$FL <- ifelse(randdata_grouped_zip_and_city$state == 'FL', 1, 0)
randdata_grouped_zip_and_city$other <- ifelse(!randdata_grouped_zip_and_city$state %in% c('NM', 'MO', 'MD', 'KY', 'IN', 'CO', 'OR', 'AZ', 'WY', 'WA', 'TN', 'FL'), 1, 0)

randdata_grouped_zip_and_city$census_region_northeast <- ifelse(randdata_grouped_zip_and_city$census_region == 'Northeast', 1, 0)
randdata_grouped_zip_and_city$census_region_midwest <- ifelse(randdata_grouped_zip_and_city$census_region == 'Midwest', 1, 0)

randdata_grouped_zip_and_city$census_division_mountain <- ifelse(randdata_grouped_zip_and_city$census_division == 'Mountain', 1, 0)
randdata_grouped_zip_and_city$census_division_middleatlantic <- ifelse(randdata_grouped_zip_and_city$census_division == 'Middle Atlantic', 1, 0)
randdata_grouped_zip_and_city$census_division_other <- ifelse(!randdata_grouped_zip_and_city$census_division %in% c('Middle Atlantic','Mountain'), 1, 0)
randdata_grouped_zip_and_city$population_density <- randdata_grouped_zip_and_city$cya01v001/randdata_grouped_zip_and_city$cya21v001

#Split into test and train
set.seed(37)
intrain = sample(as.numeric(row.names(randdata_grouped_zip_and_city)),replace = F,size = 0.75*(nrow(randdata_grouped_zip_and_city)))
train = randdata_grouped_zip_and_city[intrain,]
test = randdata_grouped_zip_and_city[-intrain,]

corr_mat = cor(train[,sapply(FUN = is.numeric,X = train)])
corrplot.mixed(abs(corr_mat), order = "hclust",tl.pos = 'n',diag = 'u')
corrplot.mixed(corr_mat,tl.pos = 'lt',diag = 'u')
write.csv(corr_mat,'correlation_matrix3.csv')             

z = data.frame(column = names(train))
#First model
lmfit1 = lm(formula = revenue_2016~.-profit-u_city-zip-state-census_region-census_division-pred_rev,
            data = train)
summary(lmfit1)
plot(lmfit1)
vif(lmfit1)

lmfit2 = lm(formula = revenue_2016~square_feet+num_cust_acc_reps+num_store_managers+num_emp_pay_type_h+
                nat_curr_robbery+nat_curr_burglary+avg_pay_rate_pay_type_s_mutated+avg_pay_rate_pay_type_h+
                num_converted_to_agreement+num_stores_in_city+population_density+OR+WA+other+
                census_region_midwest,
            data = train)
summary(lmfit2)
plot(lmfit2)
vif(lmfit2)

crPlots(lmfit2)

#Cook's distance based outlier removal doesn't improve the model any further
train_outliers_removed = train[cooks.distance(lmfit2) < 4/nrow(train),]
lmfit3 = lm(formula = revenue_2016~square_feet+num_cust_acc_reps+num_store_managers+num_emp_pay_type_h+
                nat_curr_robbery+nat_curr_burglary+avg_pay_rate_pay_type_s_mutated+avg_pay_rate_pay_type_h+
                num_converted_to_agreement+num_stores_in_city+population_density+census_region_northeast+
                OR+WA+other+census_region_midwest,
            data = train_outliers_removed)
summary(lmfit3)

#Cross-validation and regularisation
set.seed(3737)
seeds = vector(mode = "list", length = 31)
for(i in 1:30) seeds[[i]] = sample.int(1000,70)
seeds[[31]] = sample.int(1000,1)
lm_ctrl = trainControl(method = 'repeatedcv',repeats = 3,number = 10,search = 'grid')
lambda.grid = 0.1
alpha.grid = 0.04
search_grid = expand.grid(.alpha = alpha.grid,.lambda = lambda.grid)
lm_regularised = train(data = train,revenue_2016~square_feet+num_cust_acc_reps+num_store_managers+
                           num_emp_pay_type_h+nat_curr_robbery+nat_curr_burglary+avg_pay_rate_pay_type_s_mutated+
                           avg_pay_rate_pay_type_h+num_converted_to_agreement+num_stores_in_city+
                           population_density+census_region_northeast+OR+WA+other+census_region_midwest,
                       method = 'glmnet',trControl = lm_ctrl,tuneGrid = search_grid,metric = 'Rsquared')
plot(lm_regularised)
lm_regularised
test$predicted_revenue = predict(object = lm_regularised,newdata = test)
RMSE(test$revenue_2016,test$predicted_revenue)
print(paste('R2 on test data:',1 - (var(test$revenue_2016 - test$predicted_revenue)/var(test$revenue_2016))))
tmp_coeffs = coef(lm_regularised$finalModel,s=0.1)
z2 = data.frame(name = tmp_coeffs@Dimnames[[1]][tmp_coeffs@i + 1], coefficient = tmp_coeffs@x)

#We will simulate the scenario of opening a store in each new location (zip and city) assuming 
#avg.number of employees and salary, avg. marketing expenses and avg. number of leads per store converted 
#for that area for the new store
simulation_data = randdata_grouped_zip_and_city[c("state","u_city","zip","revenue_2016","num_stores_in_zip_and_city","square_feet",
                                                  "num_cust_acc_reps","num_store_managers","num_assistant_managers",
                                                  "num_emp_pay_type_h","nat_curr_robbery","nat_curr_burglary",
                                                  "avg_pay_rate_pay_type_s_mutated","avg_pay_rate_pay_type_h",
                                                  "num_converted_to_agreement","num_stores_in_city",
                                                  "marketing_exp_2016","marketing_exp_2015","population_density",
                                                  "census_region_northeast","OR","WA","other","census_region_midwest")]

simulation_data$pred_revenue = predict(lm_regularised,simulation_data)

simulation_data = simulation_data %>% 
    mutate(num_stores_in_city = num_stores_in_city + 1,
           avg_num_cust_acc_reps_per_store = round(num_cust_acc_reps/num_stores_in_zip_and_city,0),
           avg_num_assistant_managers_per_store = round(num_assistant_managers/num_stores_in_zip_and_city,0),
           avg_num_store_managers_per_store = round(num_store_managers/num_stores_in_zip_and_city,0),
           avg_num_hourly_employees = round(num_emp_pay_type_h/num_stores_in_zip_and_city),
           avg_marketing_expense_2016 = marketing_exp_2016/num_stores_in_zip_and_city,
           square_feet = square_feet*(num_stores_in_zip_and_city+1)/num_stores_in_zip_and_city,
           num_cust_acc_reps = num_cust_acc_reps*(num_stores_in_zip_and_city+1)/num_stores_in_zip_and_city,
           num_store_managers = num_store_managers*(num_stores_in_zip_and_city+1)/num_stores_in_zip_and_city,
           num_assistant_managers = num_assistant_managers*(num_stores_in_zip_and_city+1)/num_stores_in_zip_and_city,
           num_emp_pay_type_h = num_emp_pay_type_h*(num_stores_in_zip_and_city+1)/num_stores_in_zip_and_city,
           num_converted_to_agreement = num_converted_to_agreement*(num_stores_in_zip_and_city+1)/num_stores_in_zip_and_city) %>%
    mutate(avg_expense_for_new_store_for_each_zip_and_city = avg_marketing_expense_2016 +
               (avg_num_assistant_managers_per_store + avg_num_cust_acc_reps_per_store + avg_num_store_managers_per_store)*avg_pay_rate_pay_type_s_mutated +
               avg_num_hourly_employees*avg_pay_rate_pay_type_h*2100)

simulation_data$new_pred_revenue = predict(lm_regularised,simulation_data)
simulation_data$revenue_increment_due_to_new_store = simulation_data$new_pred_revenue - simulation_data$pred_revenue
simulation_data$profit_from_new_store = simulation_data$revenue_increment_due_to_new_store - simulation_data$avg_expense_for_new_store_for_each_zip_and_city

library(ggplot2)
ggplot(simulation_data, aes(x = state, y = profit_from_new_store)) + geom_boxplot()
