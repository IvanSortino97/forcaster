box::use(shiny[observe, reactive, reactiveVal, moduleServer, NS, tags, renderText, req],
         bslib[..., page_sidebar, page_fillable],
         shinybrowser[get_device, detect],
         shinyjs[useShinyjs],
         shinytoastr[toastr_warning, useToastr],
         shiny.router[get_page, router_ui, route, router_server])

box::use(app / view[...],
         app / logic / general_utils[onStart, onEnd, header])



#' @export
ui <- function(id) {
  ns <- NS(id)

  page_sidebar(fillable_mobile = TRUE,
               useToastr(),
               detect(), # shinybrowser
               head$html, # head script and style
               useShinyjs(),

    title = header("Forcaster", idtextOutput = ns("stockTicker")),

    sidebar = sidebar$sidebar_component(ns("sidebarId")),

    page_fillable(router_ui(
      route("/", homepage$ui(ns("homepage"))),
      route("stockInfo", stockInfo$ui(ns("stockInfo"))),
      route("stockAnalysis", stockAnalysis$ui(ns("stockAnalysis"))),

      route("garchFit", garchFit$ui(ns("garchFit")))
    ))
  )

}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    onStart()
    onEnd()

    start_page <- "/"
    router_server(start_page)

    homepage$server("homepage")
    op_stockInfo <- stockInfo$server("stockInfo")
    stockAnalysis$server("stockAnalysis", reactive(op_stockInfo))

    garchFit$server("garchFit", reactive(op_stockInfo))


    # -------------------------------------------------------------------------

    # Close sidebar when in Mobile mode + scroll on top when pages are changed
    active_page <- reactiveVal(start_page)
    observe({
      req(get_page() != active_page())
      session$sendCustomMessage("scrollToTop", list())
      active_page(get_page())
      req(get_device() != "Desktop")
      sidebar_toggle(id = "sidebarId", open = FALSE, session = session )
    })

    # Stock name printed top right of the header
    output$stockTicker <- renderText({
      req(op_stockInfo$name())
      sub("-.*", "", op_stockInfo$name())
    })


  })
}
