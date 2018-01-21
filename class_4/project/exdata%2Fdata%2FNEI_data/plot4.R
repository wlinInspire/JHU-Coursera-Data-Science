#' Across the United Sta' Across the United States, how have emissions from coal 
#' combustion-related sources changed from 1999–2008?
library(dplyr)
NET_SCC <- left_join(NET, SCC)
NET_SCC <- data.table(NET_SCC)
combustion_related <- NET_SCC$SCC.Level.Four[grep('combustion', tolower(NET_SCC$SCC.Level.Four))]
coal_combustion_related <- combustion_related[grep('coal', tolower(combustion_related))]
coal_combustion_by_year <- NET_SCC[SCC.Level.Four %in% coal_combustion_related,
                                   .(Emissions = sum(Emissions)), year]
with(coal_combustion_by_year, barplot(height = Emissions, names.arg = year,
                                      xlab = 'year', ylab = 'PM2.5',
                                      main = 'Total PM2.5 Emissions from Coal Combustion Related Source'))
dev.copy(png,'plot4.png')
dev.off()
