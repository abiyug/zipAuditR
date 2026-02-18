#' List metadata of files inside a ZIP archive
#'
#' @param zip_path Path to a .zip file
#' @export
list_zip_contents <- function(zip_path) {
  stopifnot(
    file.exists(zip_path),
    tolower(tools::file_ext(zip_path)) %in% c("zip", "ZIP")
  )
  
  info <- utils::unzip(zip_path, list = TRUE)
  
  tibble::tibble(
    filename = info$Name,
    size     = info$Length,
    date     = as.POSIXct(info$Date, tz = "UTC")
  )  |>
    dplyr::arrange(dplyr::desc(size))
}
