library(InspireR)
library(MASS)
head(shuttle)
fit <- glm(use ~ wind, family = binomial, shuttle)
exp(fit$coefficients[2])

fit <- glm(use ~ wind + magn, family = binomial, shuttle)

exp(fit$coefficients[2])


glm(use ~ wind, family = binomial, shuttle)

glm(use ~ wind, family = binomial, 
    shuttle %>% mutate(use = 2 - as.numeric(use)))

head(InsectSprays)

fit <- glm(count ~ spray, data = InsectSprays, family = 'poisson')
1 / exp(fit$coefficients)


x <- -5:5
y <- c(5.12, 3.93, 2.67, 1.87, 0.52, 0.08, 0.93, 2.05, 2.54, 3.87, 4.97)




fit <- lm(y ~ I(x * (x>0)) + x + 1)

predict(fit, data.frame(x = 0))

plot(x[x>=0],y[x>=0])
