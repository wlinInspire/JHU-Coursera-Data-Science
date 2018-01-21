#'m motor vehicle sources in Baltimore City with emissions from 
#'motor vehicle sources in Los Angeles County, California (𝚏𝚒𝚙𝚜 == "𝟶𝟼
#'𝟶𝟹𝟽"). Which city has seen greater changes over time in motor vehicle emissions?


vehicle_in_Balt_LA <- NET_SCC[grepl('vehicle', tolower(SCC.Level.Two)) & 
                                fips %in% c('24510', '06037')]
vehicle_in_Balt_LA <- vehicle_in_Balt_LA[,.(Emissions = sum(Emissions)), by = .(fips, year)]
vehicle_in_Balt_LA <- mutate(vehicle_in_Balt_LA, Location = ifelse(fips == '24510',
                                                                   'Baltimore City, Maryland',
                                                                   'Los Angeles County, California'))
vehicle_in_Balt_LA <- group_by(vehicle_in_Balt_LA, Location) %>%
  arrange(year) %>%
  mutate(change_from_1999 = Emissions / Emissions[1])

p <- ggplot(vehicle_in_Balt_LA, aes(x = year, y = change_from_1999, col = Location)) + geom_line() + 
  ggtitle('PM2.5 EmiChange frPM2.5 om Yee from 1999more City, MarylanAngeles County, ('balt_la_cplot6