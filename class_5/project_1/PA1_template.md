# Reproducible Research: Peer Assessment 1

## Loading and preprocessing the data

```r
setwd('~/Library/Mobile Documents/com~apple~CloudDocs/DataScience/JHUDataScience/Class_5_reproducible_research/project_1/RepData_PeerAssessment1/')
data <- read.csv('./activity.csv')
data$date <- as.Date(data$date)
```


## What is mean total number of steps taken per day?

```r
library(data.table)
library(ggplot2)
data <- data.table(data)
steps_by_day <- data[,.(steps = sum(steps, na.rm = TRUE)), by = .(date)]
print(ggplot(steps_by_day, aes(x = date, weight = steps)) + geom_bar())
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

```r
print(paste0('Mean is: ', mean(steps_by_day[,steps])))
```

```
## [1] "Mean is: 9354.22950819672"
```

```r
print(paste0('Median is: ', median(steps_by_day[,steps])))
```

```
## [1] "Median is: 10395"
```

## What is the average daily activity pattern?

```r
steps_by_5min_interval <- data[,.(steps = mean(steps, na.rm = TRUE)), by = .(interval)]
max_steps <- steps_by_5min_interval[steps == max(steps),]
print(ggplot(steps_by_5min_interval, aes(x = interval, y = steps)) + geom_line() + 
        geom_point(data = max_steps, aes(x = interval, y = steps), col = 'red', size = 3))
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

```r
print(paste0('Maximum Steps occurs in interval ', max_steps$interval))
```

```
## [1] "Maximum Steps occurs in interval 835"
```


## Imputing missing values


```r
print(paste0('Total number of rows with NAs is ',
             sum(rowSums(is.na(data)) != 0)))
```

```
## [1] "Total number of rows with NAs is 2304"
```

```r
library(dplyr)
data_na_filled <- group_by(data, interval) %>%
  mutate(steps = ifelse(is.na(steps), mean(steps, na.rm = TRUE), steps))
data_na_filled <- data.table(data_na_filled)
steps_by_day <- data_na_filled[,.(steps = sum(steps, na.rm = TRUE)), by = .(date)]
print(ggplot(steps_by_day, aes(x = date, weight = steps)) + geom_bar())
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

```r
print(paste0('Mean is: ', mean(steps_by_day[,steps])))
```

```
## [1] "Mean is: 10766.1886792453"
```

```r
print(paste0('Median is: ', median(steps_by_day[,steps])))
```

```
## [1] "Median is: 10766.1886792453"
```
Both mean and median increase


## Are there differences in activity patterns between weekdays and weekends?

```r
data_na_filled <- data_na_filled[, weekdays_weekend := weekdays(date)][
  , weekdays_weekend := ifelse(weekdays_weekend %in% c('Saturday', 'Sunday'),
                               'weekends', 'weekdays')]
steps_by_5min_interval_by_weekdays_weekend <- data_na_filled[
  ,.(steps = mean(steps, na.rm = TRUE)), by = .(interval, weekdays_weekend)]

print(ggplot(steps_by_5min_interval_by_weekdays_weekend, 
             aes(x = interval, y = steps)) + geom_line() + 
        facet_grid(.~ weekdays_weekend))
```

![](PA1_template_files/figure-html/unnamed-chunk-5-1.png)<!-- -->
