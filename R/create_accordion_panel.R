#' Create a Bootstrap 5 Accordion Panel
#'
#' Internal helper function for the Titanic SurvivR Shiny app.
#' Generates a Bootstrap 5 accordion panel with customizable header text and content.
#'
#' @param id Unique ID for the accordion panel.
#' @param header_text Text displayed on the accordion header button.
#' @param body_content UI elements to display inside the accordion body.
#' @param show Logical. If TRUE, the panel is expanded by default. Defaults to FALSE.
#' @param parent_id Optional ID of the accordion group parent for coordinated collapse behavior.
#'
#' @keywords internal
#' @noRd

create_accordion_panel <- function(id,
                                   header_text,
                                   body_content,
                                   show = FALSE,
                                   parent_id = NULL) {
  collapse_class <- if (show) "accordion-collapse collapse show" else "accordion-collapse collapse"
  button_class <- if (show) "accordion-button" else "accordion-button collapsed"
  data_bs_parent <- if (!is.null(parent_id)) parent_id else NA

  htmltools::div(
    class = "accordion-item",
    shiny::tags$h2(
      class = "accordion-header", id = paste0("heading_", id),
      shiny::tags$button(
        class = button_class,
        type = "button",
        `data-bs-toggle` = "collapse",
        `data-bs-target` = paste0("#", id),
        `aria-expanded` = if (show) "true" else "false",
        `aria-controls` = id,
        header_text
      )
    ),
    shiny::tags$div(
      id = id,
      class = collapse_class,
      `aria-labelledby` = paste0("heading_", id),
      shiny::tags$div(class = "accordion-body", body_content)
    )
  )
}
