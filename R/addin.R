#' RStudio Addin for Rchive
#'
#' @export
#' @examples
#' if (interactive()) {
#'   rchive()
#' }
#' @import shiny
rchive <- function() {
  title_zh <- readLines(system.file(package = "rchive", "dic", "dic.txt"), encoding = "UTF-8")
  ui <- fluidPage(
    tags$head(
      tags$style(
        HTML(".shiny-notification {
              width: 500px;
              position:fixed;
              top: 50%;
              left: calc(50% - 250px);
              font-size: 20px;
           }"
        )
      )
    ),


    titlePanel(
      paste0("Rchive (", title_zh , "): A Shiny Tool for R-devel, R-help and COS Archives")
    ),
    actionButton("update", "Update!"), textOutput("filetime"),
    tabsetPanel(
      tabPanel(title = 'COS',
               sliderInput('month_cos', 'Month Range',
                           min = as.Date("2006-05-01","%Y-%m-%d"),
                           max = Sys.Date(),
                           value = c(as.Date("2006-05-01", "%Y-%m-%d"), Sys.Date()), timeFormat="%Y-%m", width = '100%'),
               sidebarLayout(
                 mainPanel(
                   dataTableOutput('cos'),
                   p(), hr()
                 ),
                 sidebarPanel(
                   plotOutput('cos_d', height = "200px"),
                   p(),
                   plotOutput('cos_a', height = "200px"),
                   p(),
                   dygraphs::dygraphOutput('cos_m', height = "200px"),
                   p(),
                   plotOutput('cos_h', height = "300px")
                 )
               )),

      tabPanel(title = 'R-devel',
               sliderInput('month_rdevel', 'Month Range',
                           min = as.Date("1997-04-01","%Y-%m-%d"),
                           max = Sys.Date(),
                           value = c(as.Date("1997-04-01", "%Y-%m-%d"), Sys.Date()), timeFormat="%Y-%m", width = '100%'),
               sidebarLayout(
                 mainPanel(
                   dataTableOutput('rdevel'),
                   p(), hr()
                 ),
                 sidebarPanel(
                   plotOutput('rdev_d', height = "200px"),
                   p(),
                   plotOutput('rdev_a', height = "200px"),
                   p(),
                   dygraphs::dygraphOutput('rdev_m', height = "200px")
                 )
               )),
      tabPanel(title = 'R-help',
               sliderInput('month_rhelp', 'Month Range',
                           min = as.Date("1997-04-01","%Y-%m-%d"),
                           max = Sys.Date(),
                           value = c(as.Date("1997-04-01", "%Y-%m-%d"), Sys.Date()), timeFormat="%Y-%m", width = '100%'),
               sidebarLayout(
                 mainPanel(
                   dataTableOutput('rhelp'),
                   p(), hr()
                 ),
                 sidebarPanel(
                   plotOutput('rhelp_d', height = "200px"),
                   p(),
                   plotOutput('rhelp_a', height = "200px"),
                   p(),
                   dygraphs::dygraphOutput('rhelp_m', height = "200px")
                 )
               ))

    )
  )
  server <- function(input, output, session) {

    withProgress(message = 'Hodor', value = 0, {
      incProgress(0.618, detail = "Loading database... ")
    # Load old database ------------------------------------
    datapath <- rappdirs::user_data_dir("rchive", "pzhaonet")
    dbfile <- file.path(datapath, "db.RData")
    url <- 'https://github.com/pzhaonet/travis-mini/raw/master/data/db.RData'
    if (!dir.exists(datapath)) dir.create(datapath, showWarnings = FALSE, recursive = TRUE)
    if (!file.exists(dbfile)) curl::curl_download(url, destfile = dbfile, mode = "wb")
    output$filetime <- renderText({
      paste('(Updated at ',  file.mtime(dbfile), ")")
    })
    incProgress(1, detail = "Loading database... ")

    # Update the database ----------------------------------
    observeEvent(input$update, {
      withProgress(message = 'Hodor', value = 1, {
      incProgress(0.618, detail = "Updating database... ")

      curl::curl_download(url, destfile = dbfile, mode = "wb")
      output$filetime <- renderText({
        paste('(Updated at ',  file.mtime(dbfile), ")")
      })
      incProgress(1, detail = "Updating database... ")
      })
    })
    load(dbfile)
    df_coscsv <- df_coscsv[!is.na(df_coscsv$time), ]

    df_rdevelcsv$time <- as.Date(paste0(df_rdevelcsv$Month, '-01'))
    df_rhelpcsv$time <- as.Date(paste0(df_rhelpcsv$Month, '-01'))

    # Render the table of posts - R-devel ------------------
    df_rdevel <- reactive({
      df_rdevelcsv[df_rdevelcsv$time >= input$month_rdevel[1] - 30 & df_rdevelcsv$time <= input$month_rdevel[2], c("Month", "Replies", "Title")]
    })
    output$rdevel = renderDataTable({
      df_rdevel()
    },
    options = list(
      lengthMenu = c(10, 20, 50, 100, nrow(df_rdevel())),
      pageLength = 15,
      columnDefs = list(list(width = '10px', targets = c(0,1)))
    ),
    escape = FALSE
    )

    # Render the table of posts - R-help ------------------
    df_rhelp <- reactive({
      df_rhelpcsv[df_rhelpcsv$time >= input$month_rhelp[1] - 30 & df_rhelpcsv$time <= input$month_rhelp[2], c("Month", "Replies", "Title")]
    })
    output$rhelp = renderDataTable({
      df_rhelp()
    },
    options = list(
      lengthMenu = c(10, 20, 50, 100, nrow(df_rhelp())),
      pageLength = 15,
      columnDefs = list(list(width = '10px', targets = c(0,1)))
    ),
    escape = FALSE
    )

    # Render the table of posts - COS ------------------
    df_cos <- reactive({
      df_coscsv[df_coscsv$time >= input$month_cos[1] - 30 & df_coscsv$time <= input$month_cos[2] + 30, ]
    })
    output$cos = renderDataTable({
      df_cos()[, c( "Month", "Replies", "Title", "Participants","Update","Active_Days")]
    },
    options = list(
      lengthMenu = c(10, 20, 50, 100, nrow(df_cos())),
      pageLength = 15,
      columnDefs = list(list(width = '10px', targets = c(0,1)))
    ),
    escape = FALSE
    )

    # Render figures ------------------
    observe({

      # rdev
      output$rdev_a <- renderPlot({plot_annual(df_rdevel())})
      output$rdev_m <- dygraphs::renderDygraph({plot_monthly(df_rdevel())})
      output$rdev_d <- renderPlot({plot_dist(df_rdevel())})

      # rhelp
      output$rhelp_a <- renderPlot({plot_annual(df_rhelp())})
      output$rhelp_m <- dygraphs::renderDygraph({plot_monthly(df_rhelp())})
      output$rhelp_d <- renderPlot({plot_dist(df_rhelp())})

      # COS
      output$cos_a <- renderPlot({plot_annual(df_cos())})
      output$cos_m <- dygraphs::renderDygraph({plot_monthly(df_cos())})
      output$cos_d <- renderPlot({plot_dist(df_cos())})
      output$cos_h <- renderPlot(plot_hour(df_cos()))

    })

    })
  }

  # Run the addin
  shinyApp(ui = ui, server = server)
}
