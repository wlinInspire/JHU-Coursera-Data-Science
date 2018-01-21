#' Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
#' (𝚏𝚒𝚙𝚜 == "𝟸𝟺𝟻𝟷𝟶") from 1999
#'  to 2008? Use the base plotting system to make a plot answering this question.
balt_by_year <- NET[fips == '24510', .(Emissions = sum(Emissions)), year]
with(pm_by_year, barplot(height = Emissions, names.arg = year,
                         xlab = 'year', ylab = 'PM2.5',
                         main = 'Total PM2.5 Emissions in Baltimore City, Maryland'))
dev.copy(png,'plot2.png')
dev.off()
