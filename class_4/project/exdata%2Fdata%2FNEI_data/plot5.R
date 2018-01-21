#' How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
vehicle_in_Balt <- NET_SCC[grepl('vehicle', tolower(SCC.Level.Two)) & 
                             fips == '24510']
vehicle_in_Balt <- vehicle_in_Balt[,.(Emissions = sum(Emissions)), by = year]


with(vehicle_in_Balt, barplot(height = Emissions, names.arg = year,
                              xlab = 'year', ylab = 'PM2.5',
                              main = 'Total PM2.5 Emissions from Viehcle in Baltimore City, Maryland'))
dev.copy(png,'plot5.png')
dev.off()
