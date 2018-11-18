library(forecast)
library(quantmod)
library(shiny)
library(plotly)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  getData <- eventReactive(input$submitSymbol, {
    sym <- input$symbol
    getSymbols(sym, src = 'yahoo')
    close <- Cl(get(sym))
    close
  })
  
  y <- list(title = 'Closing Price (USD)')
  output$time_plot <- renderPlotly({
    df <- as.data.frame(getData())
    colnames(df) <- 'Close'
    df <- df %>% mutate(Date = as.Date(rownames(df))) 
    plot_ly(data = df, x = ~Date, y = ~Close, type = 'scatter', 
            mode = 'markers+lines') %>%
      layout(title = paste0(input$symbol, ' Time Plot'),
             yaxis = y)
  })
  
  
  predictions <- eventReactive(input$submitModel, {
    if(input$models == 'ARIMA'){
      model <- auto.arima(as.ts(getData()))
      forecasts <- forecast(model, h = 5, level = 95)
    }else if(input$models == 'Neural Network'){
      model <- nnetar(getData())
      forecasts <- forecast(model, h = 5, level = 95)
    }else{
      model <- holt(getData(), level = 95)
      forecasts <- forecast(model, h = 5)
    }
  })
  
  output$forecastTable <- renderTable(predictions(), striped = T, bordered = T)
})
