#' @title Upload a file for OCR processing
#' @param file_path Path to the local file to upload
#' @param purpose Purpose of the upload, default is "ocr"
#' @param api_key Your MistralAI API key
#' @return The file metadata as a list
mistral_upload_file = function(file_path, purpose = "ocr", api_key = mistral_api_key()) {

  if (is.null(api_key) || api_key == "") {
    stop("API key is required")
  }

  if (!file.exists(file_path)) {
    stop("File does not exist: ", file_path)
  }

  # Make the API call
  response = httr::POST(
    url = "https://api.mistral.ai/v1/files",
    httr::add_headers(
      "Authorization" = paste("Bearer", api_key)
    ),
    body = list(
      purpose = purpose,
      file = httr::upload_file(file_path)
    ),
    encode = "multipart"
  )

  # Check for HTTP errors
  httr::stop_for_status(response)

  # Parse the response
  result = httr::content(response, "parsed")

  return(result)
}

#' @title Get a signed URL for file access
#' @param file_id ID of the file to get URL for
#' @param expiry Expiry time in hours, default is 24
#' @param api_key Your MistralAI API key
#' @return The signed URL information as a list
mistral_get_file_url = function(file_id, expiry = 24, api_key = mistral_api_key()) {

  if (is.null(api_key) || api_key == "") {
    stop("API key is required")
  }
  if (is.list(file_id)) {
    file_id = file_id$id
  }
  if (is.null(file_id)) stop("file id required")

  # Make the API call
  response = httr::GET(
    url = paste0("https://api.mistral.ai/v1/files/", file_id, "/url"),
    query = list(expiry = expiry),
    httr::add_headers(
      "Accept" = "application/json",
      "Authorization" = paste("Bearer", api_key)
    )
  )

  # Check for HTTP errors
  httr::stop_for_status(response)

  # Parse the response
  result = httr::content(response, "parsed")

  return(result)
}
