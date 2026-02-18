#' Find files with same name + size across ZIPs
#' @param zip_paths Character vector of paths
#' @export
detect_duplicates <- function(zip_paths) {
  purrr::map_dfr(zip_paths, \(p) {
    list_zip_contents(p) |> dplyr::mutate(archive = basename(p))
  }) |>
    dplyr::group_by(filename, size) |>
    dplyr::filter(dplyr::n() > 1) |>
    dplyr::ungroup() |>
    dplyr::arrange(dplyr::desc(size), filename)
}
