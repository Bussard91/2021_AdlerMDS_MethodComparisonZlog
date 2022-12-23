# Method comparison with zlog values - RShiny Web-App

## Packages
library(shiny)
library(shinythemes)
library(mcr)

## User Interface

ui <- fluidPage(
  h3("Adler Medical Data Science - Method comparison using zlog-values"),
  # theme for style of the web app
  theme = shinytheme("cosmo"),
  # navigation bar layout
  sidebarLayout(
    sidebarPanel(width = 2,
                 fileInput("File", "Choose file:", multiple = FALSE, accept = c("text/csv", "text/comma-separated-values,text/plain",".csv")),
                 radioButtons("Sep", "Column separator", choices = c(Komma = ",", Semikolon = ";"), selected = ";"),
                 tags$hr(),
                 textInput("Method1", "Name of old method:", ""),
                 textInput("Method2", "Name of new method:", ""),
                 textInput("Name", "Name of parameter:", ""),
                 textInput("Unit", "Unit:", ""),
                 tags$hr(),
                 "Only for documentation if printed:",
                 tags$br(),
                 tags$br(),
                 textInput("NameUser1", "Name of user:", value = ""),
                 textInput("Sign1", "Signature of user:", value = ""),
                 tags$hr(),
                 tags$br(),
                 tags$strong("Copyright by Jakob Adler")
                 #downloadButton("DownloadReport1", "Download Auswertung")
                ),
    mainPanel(
      tabsetPanel(
        tabPanel("Introduction",
          tags$br(),
          h4("Dear user,"),
          "This is a RShiny-based Web-App for method comparison in the clinical laboratory.
          The basic functions for method comparison are using the", tags$strong("mcr-Package"), ".",
          tags$br(),
          tags$br(),
          "In this Web-App we implemented a new approach, which is using zlog-values to bring method comparison closer
          to the clinical interpretation. The theoretical basis for zlog-values, published by G. Hoffmann, F. Klawonn,
          R. Lichtinghagen and M. Orth can be found under the following link:",
          tags$br(),
          tags$br(),
          uiOutput("Link"),
          tags$hr(),
          h4("Notes on usage of this Web-App"),
          "After uploading a file for the method comparison you can take a look at your data using the tab", tags$strong("Imported data"), ".",
          tags$br(),
          tags$br(),
          "Using the tab", tags$strong("Regression"), ", this app will give you the opportunity to choose the columns of your dataset and
          to choose your preferred regression method.",
          tags$br(),
          tags$br(),
          "The", tags$strong("Coefficients"), "tab will give you some information about the correlation coefficent, the determination
          coefficent and the variation coefficient. Further it will estimate a correlation test and will give you a summary of
          the differences between the measurements.",
          tags$br(),
          tags$br(),
          "The", tags$strong("Bland-Altman-Plot"), "tab shows the classic Bland-Altman-Plot for your method comparison.",
          tags$br(),
          tags$br(),
          "The last two tabs", tags$strong("Zlog-Plot"), "and", tags$strong("Deming regression using zlog-values"), "will show you
          a plot of the zlog-values to compare the measured values in relation to their reference intervals to get more information
          for the clinical interpretation of your method comparison and it will perform a Deming-regression using the zlog-values of
          the measured values.",
          tags$br(),
          tags$br(),
          "I hope, this little Web-App will make future method comparisons easier for you and contribute to a better interpretation
          of such method comparisons in the clinical laboratory.",
          tags$hr(),
          "For critics and questions, please contact", tags$strong("Jakob Adler:"),
          tags$br(),
          tags$br(),
          uiOutput("Link2"),
          tags$br(),
          tags$strong("Copyright by Jakob Adler")
        ),
        tabPanel("Imported data",
          fluidRow(
            h4("This table shows the imported data:"),
            column(6, dataTableOutput("Cleaned"))
          ),
          tags$br(),
          tags$strong("Copyright by Jakob Adler")
        ),
        tabPanel("Regression",
          tags$br(),
          fluidRow(
            uiOutput("Colold")
          ),
          fluidRow(
            uiOutput("Colnew"),
          ),
          fluidRow(
            radioButtons("Method", "Select regression method:", c("Linear regression" = "Linear", "Deming regression" = "Deming",
                                                                 "Passing-Bablock regression" = "Passing"))
          ),
          fluidRow(
            column(10, plotOutput("RegPlot"))
          ),
          tags$br(),
          tags$strong("Copyright by Jakob Adler")
        ),
        tabPanel("Coefficients",
          tags$br(),
          "Correlation coefficient:",
          fluidRow(
            column(6, verbatimTextOutput("CorCoeff"))
          ),
          tags$br(),
          "Results of correlation test:",
          fluidRow(
            column(6, verbatimTextOutput("CorTest"))
          ),
          tags$br(),
          "Determination coefficient:",
          fluidRow(
            column(6, verbatimTextOutput("DetCoeff"))
          ),
          tags$br(),
          "Summary of the differences between new and old method:",
          fluidRow(
            column(6, verbatimTextOutput("DiffSumm"))
          ),
          tags$br(),
          "Variation coefficient (%):",
          fluidRow(
            column(6, verbatimTextOutput("VarCoeff"))
          ),
          tags$br(),
          tags$strong("Copyright by Jakob Adler")
        ),
        tabPanel("Bland-Altman-Plot",
          tags$br(),
          fluidRow(
            column(10, plotOutput("BlandPlot"))
          ),
          tags$br(),
          tags$strong("Copyright by Jakob Adler")
        ),
        tabPanel("Zlog-Plot",
          tags$br(),
          inputPanel(
            numericInput("LL1", "Lower limit old method:", value = NULL),
            numericInput("UL1", "Upper limit old method:", value = NULL),
            numericInput("LL2", "Lower limit old method:", value = NULL),
            numericInput("UL2", "Upper limit old method:", value = NULL)
          ),
          tags$br(),
          "Zlog-Plot to compare measured values in relation to their reference intervals:",
          fluidRow(
            column(12, plotOutput("ZlogPlot"))
          ),
          tags$br(),
          tags$strong("Copyright by Jakob Adler")
        ),
        tabPanel("Deming regression using zlog-values",
          tags$br(),
          fluidRow(
            column(12, plotOutput("ZlogRegPlot"))
          ),
          tags$br(),
          tags$strong("Copyright by Jakob Adler")
        )
      )
    )
  )
)

## Server

server <- function(input, output){
  # Link
  output$Link <- renderUI({
    url <- a("The zlog value as a basis for the standardization of laboratory results", href = "https://www.degruyter.com/document/doi/10.1515/labmed-2017-0135/html")
    tagList(url)
  })
  # Link2
  output$Link2 <- renderUI({
    url <- a("Adler Medical Data Science on GitHub", href = "https://github.com/Bussard91")
    tagList(url)
  })
  # File upload
  output$Cleaned <- renderDataTable({
    req(input$File)
    tryCatch(
      {
        df <- read.csv(input$File$datapath, header = T, sep = input$Sep)
        df
      },
      error = function(e) {
        stop(safeError(e))
      }
    )
  })
  # Rendering dropdown for selection of columns from dataset
  output$Colold <- renderUI({
    req(input$File)
    tryCatch(
      {
        df <- read.csv(input$File$datapath, header = T, sep = input$Sep)
        if (is.null(df)) return("The data frame is empty.")
        selectInput("Coldropold", "Select column for old method:", names(df))
      },
      error = function(e) {
        stop(safeError(e))
      }
    )
  })
  output$Colnew <- renderUI({
    req(input$File)
    tryCatch(
      {
        df <- read.csv(input$File$datapath, header = T, sep = input$Sep)
        if (is.null(df)) return("The data frame is empty.")
        selectInput("Coldropnew", "Select column for new method:", names(df))
      },
      error = function(e) {
        stop(safeError(e))
      }
    )
  })
  # Regression plot
  output$RegPlot <- renderPlot({
    req(input$File)
    tryCatch({
        df <- read.csv(input$File$datapath, header = T, sep = input$Sep)
        MethodChoosed <- switch(input$Method, "Linear" = "WLinReg", "Deming" = "Deming", "Passing" = "PaBa")
        Model <- mcreg(df[,input$Coldropold], df[,input$Coldropnew], method.reg = MethodChoosed)
        xaxis <- paste(input$Name, "old method (", input$Unit, ")")
        yaxis <- paste(input$Name, "new method (", input$Unit, ")")
        title1 <- paste("Method comparison", input$Name)
        Regplot1 <- MCResult.plot(Model, x.lab = xaxis, y.lab = yaxis, main = title1)
        Regplot1
    },
    error = function(e){
      stop(safeError(e))
    })
  }, height = 800)
  # Statistics
  ## Correlation coefficient
  output$CorCoeff <- renderPrint({
    req(input$File)
    tryCatch({
      df <- read.csv(input$File$datapath, header = T, sep = input$Sep)
      cor(df[,input$Coldropold], df[,input$Coldropnew])
    },
    error = function(e){
      stop(safeError(e))
    })
  })
  ## Correlation test:
  output$CorTest <- renderPrint({
    req(input$File)
    tryCatch({
      df <- read.csv(input$File$datapath, header = T, sep = input$Sep)
      cor.test(df[,input$Coldropold], df[,input$Coldropnew])
    },
    error = function(e){
      stop(safeError(e))
    })
  })
  ## Determination coefficient
  output$DetCoeff <- renderPrint({
    req(input$File)
    tryCatch({
      df <- read.csv(input$File$datapath, header = T, sep = input$Sep)
      Deter <- cor(df[,input$Coldropold], df[,input$Coldropnew])
      Deter^2
    },
    error = function(e){
      stop(safeError(e))
    })
  })
  ## Summary of differences
  output$DiffSumm <- renderPrint({
    req(input$File)
    tryCatch({
      df <- read.csv(input$File$datapath, header = T, sep = input$Sep)
      df$difference <- df[,input$Coldropnew] - df[,input$Coldropold]
      summary(df$difference)
    },
    error = function(e){
      stop(safeError(e))
    })
  })
  ## Variation coefficient
  output$VarCoeff <- renderPrint({
    req(input$File)
    tryCatch({
      df <- read.csv(input$File$datapath, header = T, sep = input$Sep)
      df$differenceperc <- ((df[,input$Coldropnew])*100)/df[,input$Coldropold]
      VC <- (sd(df$differenceperc)*100/mean(df$differenceperc))
      VC
    },
    error = function(e){
      stop(safeError(e))
    })
  })
  ## Bland-Altman-plot
  output$BlandPlot <- renderPlot({
    req(input$File)
    tryCatch({
      df <- read.csv(input$File$datapath, header = T, sep = input$Sep)
      MethodChoosed <- switch(input$Method, "Linear" = "WLinReg", "Deming" = "Deming", "Passing" = "PaBa")
      Model2 <- mcreg(df[,input$Coldropold], df[,input$Coldropnew], method.reg = MethodChoosed)
      title2 <- paste("Bland-Altman-Plot", input$Name)
      BlandPlot <- MCResult.plotDifference(Model2, main = title2)
      BlandPlot
    },
    error = function(e){
      stop(safeError(e))
    })
  }, height = 800)
  # Method comparison using zlog-values
  ## Zlog-Plot
  output$ZlogPlot <- renderPlot({
    req(input$File)
    tryCatch({
      df <- read.csv(input$File$datapath, header = T, sep = input$Sep)
      
      zlog.old <- function(x){
        zlogvalue.old <- (log(x) - (log(input$LL1) + log(input$UL1))/2) * (3.92 / (log(input$UL1) - log(input$LL1)))
        return(round(zlogvalue.old,2))
      }
      df$zlog.old2 <- sapply(df[,input$Coldropold], zlog.old)
      
      zlog.new <- function(x){
        zlogvalue.new <- (log(x) - (log(input$LL2) + log(input$UL2))/2) * (3.92 / (log(input$UL2) - log(input$LL2)))
        return(round(zlogvalue.new,2))
      }
      df$zlog.new2 <- sapply(df[,input$Coldropnew], zlog.new)
      
      df$Index <- seq(from = 1, to = length(df[,input$Coldropold]), by = 1)
      
      plot(df$Index, df$zlog.old2, pch = 16, col = "blue",
           main = paste("Zlog-values as an expression of the deviation in standard deviations", input$Name), xlab = "Measuring pair",
           ylab = paste("zlog-value", input$Name), ylim = c(-10, 10), las = T)
      points(df$zlog.new2, pch = 16, col = "red")
      abline(h = 1.96, lwd = 2)
      abline(h = -1.96, lwd = 2)
      text(df$zlog.old2, labels = rownames(df), pos = 4)
      text(df$zlog.new2, labels = rownames(df), pos = 4)
      legend(x = 1, y = -8, legend = c("old method", "new method"), col = c("blue", "red"), pch = 16, cex = 1.2)
    },
    error = function(e){
      stop(safeError(e))
    })
  }, height = 800)
  ## Zlog-regression-plot
  output$ZlogRegPlot <- renderPlot({
    req(input$File)
    tryCatch({
      df <- read.csv(input$File$datapath, header = T, sep = input$Sep)
      
      zlog.old <- function(x){
        zlogvalue.old <- (log(x) - (log(input$LL1) + log(input$UL1))/2) * (3.92 / (log(input$UL1) - log(input$LL1)))
        return(round(zlogvalue.old,2))
      }
      df$zlog.old3 <- sapply(df[,input$Coldropold], zlog.old)
      
      zlog.new <- function(x){
        zlogvalue.new <- (log(x) - (log(input$LL2) + log(input$UL2))/2) * (3.92 / (log(input$UL2) - log(input$LL2)))
        return(round(zlogvalue.new,2))
      }
      df$zlog.new3 <- sapply(df[,input$Coldropnew], zlog.new)
      
      df$Index <- seq(from = 1, to = length(df[,input$Coldropold]), by = 1)
      
      Model3 <- mcreg(df$zlog.old3, df$zlog.new3, method.reg = "Deming")
      xaxis <- paste(input$Name, "old method (", input$Unit, ")")
      yaxis <- paste(input$Name, "new method (", input$Unit, ")")
      title1 <- paste("Method comparison", input$Name, "zlog-values")
      Regplot2 <- MCResult.plot(Model3, x.lab = xaxis, y.lab = yaxis, main = title1)
      Regplot2
    },
    error = function(e){
      stop(safeError(e))
    })
  }, height = 800)
}

shinyApp(ui = ui, server = server)
