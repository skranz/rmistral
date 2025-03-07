#' Set the Mistral API key
#'
#' This function sets the Mistral API key, either from a provided string or by reading from a file.
#'
#' @param key Optional. The API key as a string.
#' @param file Optional. A file path containing the API key.
#'
#' @export
set_mistral_api_key = function(key=NULL, file=NULL) {
  if (is.null(key)) {
    key = suppressWarnings(readLines(file))
  }
  options(mIstrAl_apI_key = key)
}

#' Retrieve the Mistral API key
#'
#' This function retrieves the Mistral API key stored in the R options.
#'
#' @return The stored API key as a string.
#' @export
mistral_api_key = function() {
  getOption("mIstrAl_apI_key")
}
