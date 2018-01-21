#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(highcharter)
library(forecast)
library(dplyr)
library(lubridate)
library(tidyr)
library(data.table)

us_china_gdp <- fread('us_china_gdp.csv', nrows = 2, colClasses = 'character')
us_china_gdp <- gather(us_china_gdp, year, GDP, contains('YR'))
setDT(us_china_gdp)
us_china_gdp[, year := sapply(year, function(x) strsplit(x, 'YR')[[1]][2])]
us_china_gdp[, year := sapply(year, function(x) strsplit(x, ']')[[1]][1])]
us_china_gdp[, year := as.numeric(year)]
us_china_gdp[, GDP := round(as.numeric(GDP)/1000000000)]
us_china_gdp[, year := ymd(paste0(year, '-01-01'))]
us_china_gdp <- us_china_gdp %>% 
  .[order(year)] %>% 
  .[, GDP_previous_year := lag(GDP), `Country Code`] %>% 
  .[, GDP_previous_year := coalesce(GDP_previous_year, GDP)]

us_china_gdp[, gdp_change := GDP - GDP_previous_year]
us_china_gdp[, gdp_change_percent := gdp_change / GDP_previous_year]

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("US and China GDP Comparison"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      dateRangeInput(inputId = "date_range",
                     label = "Please Select a Time Range:",
                     min = min(us_china_gdp$year),
                     start = min(us_china_gdp$year),
                     max = max(us_china_gdp$year),
                     end = max(us_china_gdp$year),
                     format = 'yyyy', 
                     startview = 'decade'),
      selectInput(inputId = "metric",
                  label = "Please Select a Comparison Metric:",
                  choices = c('$', '$ Change', '% Change', 
                              "China/US"),
                  selected = '$')
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      h3('Welcome to the US and China GDP Comparison Tool'),
      h4('Inputs:'),
      tags$ul(
        tags$li(tags$b("Time Range:"), 
                "Year From and Year To for Comparison. 
                You have to select a date in the UI but it will be the whole year's GDP
                but not partial year's."), 
        tags$li(tags$b("Comparison Metric"),
                tags$ul(
                  tags$li(tags$b('$:'), "The absolute $ amount"),
                  tags$li(tags$b('$ Change:'), "Year-over-Year (Current Year over Previous Year) $ chnage"),
                  tags$li(tags$b('% Change:'), "Year-over-Year (Current Year over Previous Year) % chnage"),
                  tags$li(tags$b("China/US:"), "The Ratio of China's GDP over US's in %")
                )), 
        tags$li(tags$b("Forecast Method"),
                tags$ul(
                  tags$li(tags$b('none:'), "No Forecasting"),
                  tags$li(tags$b('ARIMA:'), "Use Auto-Regression Integrated Moving Average (ARIMA) 
                          Model to Forecast")
                ))
      ),
      h4('Output:'),
      tags$ul(
        tags$li("Line Chart Shown Below")),
      hr(),
      highchartOutput("distPlot")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  output$distPlot <- renderHighchart({
    us_china_gdp_effective <- us_china_gdp %>% 
      .[between(year, 
                rollback(input$date_range[1], roll_to_first = TRUE), 
                rollback(input$date_range[2], roll_to_first = TRUE))]
      
    value_var <- switch(input$metric,
                        '$' = 'GDP',
                        '$ Change' = 'gdp_change',
                        '% Change' = 'gdp_change_percent',
                        'China/US' = 'GDP')
    
    us_china_gdp_effective <- us_china_gdp_effective %>% 
      dcast.data.table(year ~ `Country Code`, value.var = value_var) %>% 
      .[, china_us_ratio := CHN/USA]
    
      
      # draw the histogram with the specified number of bins
      if (input$metric %in% c('$', '$ Change')) {
        p <- highchart() %>% 
          hc_add_series_times_values(dates = us_china_gdp_effective$year, 
                                     values = us_china_gdp_effective$USA,
                                     name = 'US') %>% 
          hc_add_series_times_values(dates = us_china_gdp_effective$year, 
                                     values = us_china_gdp_effective$CHN,
                                     name = 'China') %>% 
          hc_yAxis(title = list(text = 'GDP $ in Billions')) %>% 
          hc_tooltip(crosshairs = TRUE, shared = TRUE)  
      } else if (input$metric == '% Change') {
        p <- highchart() %>% 
          hc_add_series_times_values(dates = us_china_gdp_effective$year, 
                                     values = us_china_gdp_effective$USA * 100,
                                     name = 'US') %>% 
          hc_add_series_times_values(dates = us_china_gdp_effective$year, 
                                     values = us_china_gdp_effective$CHN * 100,
                                     name = 'China') %>% 
          hc_yAxis(title = list(text = '%')) %>% 
          hc_tooltip(crosshairs = TRUE, shared = TRUE)  
      } else {
        p <- highchart() %>% 
          hc_add_series_times_values(dates = us_china_gdp_effective$year, 
                                     values = us_china_gdp_effective$china_us_ratio * 100,
                                     name = 'CHN/US') %>% 
          hc_yAxis(title = list(text = '%')) %>% 
          hc_tooltip(crosshairs = TRUE, shared = TRUE)  
        
      }
    p
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

