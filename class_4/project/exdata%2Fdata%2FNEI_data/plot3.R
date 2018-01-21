#'our types of sources indicated by the 𝚝𝚢𝚙𝚎 (point, nonpoint, onroad, nonroad) variable, which
#' of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
#' Which have seen increases in emissions from 1999–2008? 
#' Use the ggplot2 plotting system to make a plot answer this question.
library(ggplot2)
balt_by_type_year <- NET[fips == '24510', .(Emissions = sum(Emissions)), by = .(type, year)]
p <- ggplot(balt_by_type_year, aes(x = year, y = Emissions, col = type)) + geom_line() + 
  ggtitle('Total PM2.5 Emissions by Types in Baltimore City, Maryland')
ggsave('plot3.png', p )
