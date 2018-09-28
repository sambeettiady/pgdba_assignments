#Problem 5:
library(fitdistrplus)
set.seed(37)
gamma_sample = rgamma(n = 100,shape = 2,scale = 5)

#a.
fitdistr(x = gamma_sample,densfun = 'gamma')
#Shape = 2.07, Rate = 0.22

#b.
set.seed(373)
ks.test(x = gamma_sample,y = pgamma,shape = 2.07,rate = 0.22)

#c.
fitdistr(x = gamma_sample,densfun = 'normal')
#Mean = 9.34,sd = 6.55

#d.
set.seed(373737)
ks.test(x = gamma_sample,y = pnorm,mean = 9.34,sd = 6.55)

#e.
gamma_sample = sort(gamma_sample)
y = (1:(100-1))/100
par(mfrow=c(1,1))
plot(c(rep(gamma_sample,each=2)),c(0,rep(y,each=2),1),type="l")
lines((-30000:30000)*.001,pnorm((-30000:30000)*.001,mean = 9.34,sd = 6.55),col=2)
lines((-30000:30000)*.001,pgamma((-30000:30000)*.001,shape = 2.07,rate = 0.22),col=3)

#f.
shapiro.test(gamma_sample)

#g.
transformed_gamma = pgamma(gamma_sample,shape = 2.07,rate = 0.22)
twice_transformed_gamma = qnorm(transformed_gamma)
qqnorm(twice_transformed_gamma)
abline(a = 0,b = 1)
shapiro.test(twice_transformed_gamma)

#h.
#pgamma converted to probabilites and then converted to quantlies of normal distribution.
#Hence a sample from gamma dist. has been transformed to normal distribution


#Problem 6:
traffic_sample = c(0,1,1,0,2,2,2,3,1,0,1,1,1,5,0,1,1,4,1,3,0,1,2,3,7,1,1,4,2,4)
obscount = hist(x = traffic_sample,breaks=(c(0:8)-0.5),plot=F)$counts
prob = dpois(0:(length(obscount) - 1),lambda = 1)
chisq.test(obscount,p = prob,rescale.p = T)
