box::use(shiny[ actionButton, tags, HTML, observe, reactiveVal, moduleServer, req],
         bslib[sidebar, accordion, accordion_panel, sidebar_toggle],
         shiny.router[route_link, get_page],
         shinybrowser[get_device],
         bsicons[bs_icon])

# Custom class for accordion sections
accordion_section <- function(title, icon = NULL, page, custom_class = "custom-accordion-section") {
  tags$a(
    href = route_link(page),
    class = custom_class,
    if (!is.null(icon)) { bs_icon(icon) },
    tags$h6(title, style = "display: inline; margin-left: 5px;")
  )
}

#' @export
sidebar_component <- function(idSd) {
  sidebar(
    id = idSd,

    # Home
    accordion_section(
      title = "Home",
      page = "/",
      icon = "house"
    ),

    # Stock info
    accordion(
      open = TRUE,
      accordion_panel(
        "Stock info",
        icon = bs_icon("graph-up"),
        accordion_section(
          title = "Stock Selection",
          page = "stockInfo",
          icon = "list-task"
        ),
        accordion_section(
          title = "Stock Analysis",
          page = "stockAnalysis",
          icon = "clipboard2-data"
        )
      ),

      # Test buttons
      accordion_panel(
        "GARCH Model",
        icon = bs_icon("apple"),
       accordion_section(
          title = "Fit Models",
          page = "garchFit",
          icon = "list-check"
        )
      ),
    )
  )
}

#' @export
#' define style of a components and appear like pushed buttons
#' moved to app/view/head.R

