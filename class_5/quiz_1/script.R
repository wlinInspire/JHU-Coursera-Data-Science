#' Make a plot that answers the question: what is the relationship between mean covered charges (Average.Covered.Charges) and 
#' mean total payments (Average.Total.Payments) in New York?
#' Make a plot (possibly multi-panel) that answers the question: how does the relationship between mean covered charges (Average.Covered.Charges) and 
#' mean total payments (Average.Total.Payments) vary by medical condition (DRG.Definition) and the state in which care was received (Provider.State)?

temp <- fread('~/Library/Mobile Documents/com~apple~CloudDocs/DataScience/JHUDataScience/Class_5/quiz_1/payments.csv')
temp_NY <- filter(temp, Provider.State == 'NY')
library(ggplot2)
p <- ggplot(data = temp_NY, aes(x = Average.Covered.Charges, y = Average.Total.Payments))
p <- p + geom_point()


p <- ggplot(data = temp, aes(x = Average.Covered.Charges, y = Average.Total.Payments))
p <- p + geom_point(alpha = 0.1) + facet_grid(DRG.Definition ~ Provider.State,
                                              scales = 'free') 

+ geom_smooth()
