library(rsconnect)
library(tidyverse)
library(readxl) # to load xls files 
library(gtools) # to sort data in the order found in folder 
library(shiny)
library(echarts4r)
library(reactable)


ui <- fluidPage(
  titlePanel("Referral to Treatment (RTT) Waiting Times"),
  tags$br(),
  tags$br(),
  sidebarLayout(
    sidebarPanel(
      tags$head(tags$style(type="text/css", "
             #loadmessage {
               position: fixed;
               top: 0px;
               left: 0px;
               width: 100%;
               padding: 5px 0px 5px 0px;
               text-align: center;
               font-weight: bold;
               font-size: 100%;
               color: #000000;
               background-color: #CCFF66;
               z-index: 105;
             }
          ")),
      conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                       tags$div("Loading...",id="loadmessage")),
      uiOutput("selectGroup"),
      uiOutput("selectMetric"),
      uiOutput("selectField")
    ),
    mainPanel(
      echarts4rOutput("plot")
    )
  )

)


server <- function(input, output) {
  
  output$selectGroup <- renderUI({
    selectInput("group",
                "RTT Type",
                choices = c("Admissions")
    )
  })
  
  output$selectMetric <- renderUI({
    selectInput("metric",
                "Metric",
                choices = c("",
                            "Average (median) waiting time (in weeks)",
                            "95th percentile waiting time (in weeks)")
    )
  })
  
  output$selectGroup <- renderUI({
    selectInput("field",
                "Treatment Function",
                choices = c("","General Surgery","Urology","Trauma & Orthopaedic","ENT","Ophthalmology",
                            "Oral Surgery","Neurosurgery","Plastic Surgery","Cardiothoracic Surgery",
                            "General Medicine","Gastroenterology","Cardiology","Dermatology","Thoracic Medicine",
                            "Neurology","Rheumatology","Geriatric Medicine","Gynaecology","Other","Total"),
                multiple = T
    )
  })
  
  output$plot <- renderEcharts4r({

    validate(need(input$metric, 'Please select a metric and treatment function'))
    validate(need(input$field, 'Please select a metric and treatment function'))

    rtt_plotFUN(input$metric,input$field)

  })

  
  
}


shinyApp(ui = ui, server = server)













