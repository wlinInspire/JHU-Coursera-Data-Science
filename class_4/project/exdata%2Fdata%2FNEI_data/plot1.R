#' Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
#' Using the base plotting system, make a plot showing the total PM2.5 emission 
#' from all sources for each of the years 1999, 2002, 2005, and 2008.

library(data.table)
NET <- data.table(NET)
pm_by_year <- NET[, .(Emissions = sum(Emissions)), year]
with(pm_by_year, barplot(height = Emissions, names.arg = year,
                         xlab = 'year', ylab = 'PM2.5',
                         main = 'Total PM2.5 Emissions'))
dev.copy(png,'plot1.png')
dev.off()
