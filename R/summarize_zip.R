#' Summarize one or more ZIP archives
#'
#' @param zip_paths Character vector of ZIP file paths
#' @export
summarize_zip <- function(zip_paths) {
  purrr::map_dfr(zip_paths, \(p) {
    cont <- list_zip_contents(p)
    
    tibble::tibble(
      archive        = basename(p),
      n_files        = nrow(cont),
      total_bytes    = sum(cont$size),
      largest_file_b = max(cont$size),
      n_dupe_filenames = sum(duplicated(cont$filename))
    )
  }) |>
    dplyr::arrange(dplyr::desc(total_bytes))
}
