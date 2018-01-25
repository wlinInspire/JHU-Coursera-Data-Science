#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(quanteda)
library(data.table)
library(ggplot2)
library(DT)

predict_next_word <- function(input, max_gram = 3,
                              freq_table = n_gram_frequency_table_trim) {
  # convert last 3 words of input sentense to 1 to 3 gram

  if (input == "") {
    return(data.table())
  } else {
    input <- tolower(input)
    ng_list <- data.table()
    for (ng in 1:max_gram) {
      features <- tokens(input, remove_numbers = T, remove_symbols = T,
                         remove_punct = T, ngrams = ng)
      if (length(features$text1) > 0) {
        temp <- data.table(preceding_words = features$text1 %>% tail(1),
                           type = paste0(ng + 1,'_gram'))
        ng_list <- ng_list %>% rbind(temp)
      }
    }

    # Predict using model that has 1 order higher than the input word vector
    output <- freq_table[ng_list, on = .(preceding_words, type)] %>%
      .[!is.na(frequency)] %>%
      .[order(type, frequency, decreasing = TRUE)] %>%
      head(10)

    if (nrow(output) == 0) {
      return(data.table())
    } else {
      return(output)
    }

  }
}

# Define UI for application that draws a histogram
ui <- fluidPage(

  # Application title
  titlePanel("Next Word Prediction Algorithm Demo"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      textInput(inputId = "words",
                label = "Please Enter Words:",
                value = "",
                width = "100%")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      h4('Algorithm Introducation:'),
      "The n-gram model was pre-trained using 10% randomly sampled SwiftKey data set,
      where n is 2, 3, 4. To Predict the next word, we use Back-Off algorithm. Basically,
      the algorithm tries to find matched 4-gram model first. if not, it will
back off to find matched 3-gram model. The process continues.
      ",
      h4('Algorithm Decomposition:'),
      tags$ul(
        tags$li("4-Gram Match:",
                tags$b(textOutput('output_4_gram',inline = T))),
        tags$li("3-Gram Match:",
                tags$b(textOutput('output_3_gram',inline = T))),
        tags$li("2-Gram Match:",
                tags$b(textOutput('output_2_gram',inline = T)))
      ),
      h4('Final Output:'),
      dataTableOutput('output_final'),
      h4('N-Gram Distribution:'),
      plotOutput("prob_distribution")
    )
  )
)

# Define server logic
server <- function(input, output) {

  # Load trained model
  load(file = 'n_gram_model_freq_table_2_to_4.rda')
  output_raw <- reactive({
    predict_next_word(input$words,
                      freq_table = n_gram_frequency_table_trim)
  })

  output$prob_distribution <- renderPlot({
    output_raw <- output_raw()
    if (nrow(output_raw) > 0) {
      ggplot(output_raw) + geom_bar(aes(x = reorder(n_gram, -frequency),
                                        weight = frequency,
                                        fill = type)) +
        xlab("N-Gram") + ylab("Frequency") +
        scale_y_continuous(labels = scales::comma) +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    }
  })
  output$output_final <- renderDataTable({
    output_raw <- output_raw()
    if(nrow(output_raw) == 0) {
      datatable(data.table())
    } else {
      output <- data.table(choices = c("choice 1","choice 2","choice 3"),
                           options = output_raw$last_words %>% unique() %>%
                             head(3))
      datatable(output, rownames = F, class = "display compact",
                options = list(paging = FALSE, searching = FALSE))
    }
  })
  output$output_4_gram <- renderText({
    output_raw <- output_raw()
    if(nrow(output_raw) == 0) {
      return(NA)
    } else if (nrow(output_raw[type == '4_gram']) == 0) {
      return(NA)
    } else {
      output <- output_raw[type == '4_gram']
      paste0(output$last_words, collapse = '; ')
    }
  })
  output$output_3_gram <- renderText({
    output_raw <- output_raw()
    if(nrow(output_raw) == 0) {
      return(NA)
    } else if (nrow(output_raw[type == '3_gram']) == 0) {
      return(NA)
    } else {
      output <- output_raw[type == '3_gram']
      paste0(output$last_words, collapse = '; ')
    }
  })
  output$output_2_gram <- renderText({
    output_raw <- output_raw()
    if(nrow(output_raw) == 0) {
      return(NA)
    } else if (nrow(output_raw[type == '2_gram']) == 0) {
      return(NA)
    } else {
      output <- output_raw[type == '2_gram']
      paste0(output$last_words, collapse = '; ')
    }
  })
}

# Run the application
shinyApp(ui = ui, server = server)

