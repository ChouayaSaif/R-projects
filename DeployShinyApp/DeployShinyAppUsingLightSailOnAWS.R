# Import libraries
library(shiny)
library(shinythemes)
library(data.table)
library(RCurl)
library(randomForest)

# Read data
weather <- read.csv(text = getURL("https://raw.githubusercontent.com/dataprofessor/data/master/weather-weka.csv"))

# Convert categorical variables to factors
#!!!!! In R, a factor is a data type used to represent categorical variables.
weather$outlook <- as.factor(weather$outlook)  # Convert outlook to factor
weather$play <- as.factor(weather$play)        # Convert play to factor

# Build model
model <- randomForest(play ~ ., data = weather, ntree = 500, mtry = 4, importance = TRUE)

# Save model to RDS file
# saveRDS(model, "model.rds")

# Read in the RF model
# model <- readRDS("model.rds")

####################################
# User interface                   #
####################################

ui <- fluidPage(theme = shinytheme("united"),
                
                # Page header
                headerPanel('Play Golf?'),
                
                # Input values
                sidebarPanel(
                  HTML("<h3>Input parameters</h3>"),
                  
                  selectInput("outlook", label = "Outlook:", 
                              choices = list("Sunny" = "sunny", "Overcast" = "overcast", "Rainy" = "rainy"), 
                              selected = "Rainy"),
                  sliderInput("temperature", "Temperature:",
                              min = 64, max = 86,
                              value = 70),
                  sliderInput("humidity", "Humidity:",
                              min = 65, max = 96,
                              value = 90),
                  selectInput("windy", label = "Windy:", 
                              choices = list("Yes" = TRUE, "No" = FALSE), 
                              selected = TRUE),
                  
                  actionButton("submitbutton", "Submit", class = "btn btn-primary")
                ),
                
                mainPanel(
                  tags$label(h3('Status/Output')), # Status/Output Text Box
                  verbatimTextOutput('contents'),
                  tableOutput('tabledata') # Prediction results table
                )
)

####################################
# Server                           #
####################################

server <- function(input, output, session) {
  
  # Input Data
  datasetInput <- reactive({  
    df <- data.frame(
      outlook = factor(input$outlook, levels = levels(weather$outlook)),  # Ensure factor levels match
      temperature = as.numeric(input$temperature),
      humidity = as.numeric(input$humidity),
      windy = as.logical(input$windy)  # Convert to logical
    )
    
    # Make prediction
    Output <- data.frame(Prediction = predict(model, df), 
                         round(predict(model, df, type = "prob"), 3))
    
    return(Output)
  })
  
  # Status/Output Text Box
  output$contents <- renderPrint({
    if (input$submitbutton > 0) { 
      isolate("Calculation complete.") 
    } else {
      return("Server is ready for calculation.")
    }
  })
  
  # renderTable({...}): This function tells Shiny to create a table output, It reactively updates whenever the input data (datasetInput()) changes.
  # Prediction results table
  output$tabledata <- renderTable({
    if (input$submitbutton > 0) { 
      isolate(datasetInput()) # isolate(...) ensures that datasetInput() is only called when the button is clicked, preventing unnecessary updates.
    } 
  })
}

####################################
# Create the shiny app             #
####################################
shinyApp(ui = ui, server = server)