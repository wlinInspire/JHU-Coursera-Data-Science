library(datasets)
data(iris)
mean(iris$Sepal.Length[iris$Species == 'virginica'])

data(mtcars)
x <- tapply(mtcars$hp,mtcars$cyl,mean)