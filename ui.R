#idea: user picks an NYSE index, a time period,
#a forecast model, and a forecast horizon -- 
#the shiny app gets the data, plots it, fits a model, and
#forecasts the closing price over the horizon 
library(plotly)
library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Stock Indices Tool - NYSE"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      h2('Getting Started'),
      p('This tool uses the quantmod package to download and plot weekly stock prices
        of the NYSE symbol of your choice. Yahoo Finance is the source of closing 
        prices, (Since Google Finance stopped providing results). After choosing your symbol, you can pick a prediction model to 
        forecast 5 days into the future.'),
      h2('Pick a symbol'),
      p('Type the name of your symbol into the box below (e.g.: MSFT,
        GOOG, AAPL, SBUX), and click "Submit Symbol" to update the plot.'),
      textInput('symbol', 'Symbol', value = 'MSFT'),
      actionButton('submitSymbol', 'Submit Symbol'),
      br(),
      
      h2('Pick a Forecast Model'),
      p("The three options in the dropdown below are three options for forecast 
        models: ARIMA, Neural Network, and Holt's Exponential Smoothing. Each of
        these models has its benefits, but the implementation of each is the 
        same in this context. Choose your desired model and click the 
        'Submit Model Selection' button to generate your forecasts."),
      selectInput('models','Models', choices = 
                    c('ARIMA','Neural Network', "Holt's Exponential Smoothing")),
      actionButton('submitModel', 'Submit Model Selection')
    ),
    
    mainPanel(
      h1('Time Plot'),
      plotlyOutput("time_plot"),
      br(),
      h1('Forecasts from Selected Model'),
      tableOutput('forecastTable'),
      br(),
      br(),
      p('The information supplied in this application is strictly informational
        and is not intended to serve as financial advice in any context whatsoever. 
        If you feel that you need investment advice, please consult with a professional.')
    )
  )
))
