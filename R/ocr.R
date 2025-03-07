#' Call Mistral OCR API
#'
#' This function calls the Mistral OCR API to perform optical character recognition
#' on a document specified by URL.
#'
#' @param url Character string. URL of the document to process.
#' @param model Character string. The OCR model to use (default: "mistral-ocr-latest").
#' @param include_image_base64 Logical. Whether to include base64-encoded images (default: TRUE).
#' @param api_key Character string. Your Mistral API key. Best set globabally via calling \code{set_mistral_api_key}.
#'
#' @return List containing the result. The field \code{is_ok} should be TRUE if everything worked nicely. The element \code{pages} contains the extracted pages.
#'
#' @export
mistral_ocr <- function(url=NULL, file=NULL, model = "mistral-ocr-latest", include_image_base64 = TRUE, timeout_sec = 60*5, api_key = mistral_api_key()) {
  restore.point("mistral_ocr")

  # Validate inputs
  if (is.null(api_key)) {
    stop("API key is required")
  }
  if (is.null(url)) {
    if (is.null(file)) {
      stop("You must provide an url or an file argument for the PDF file.")
    }
    if (is.character(file)) {
      file = mistral_upload_file(file)
    }
    if (!is.null(file$id)) {
      url = mistral_get_file_url(file,expiry = 1)
    }
  }
  if (is.list(url)) url = url$url
  if (is.null(url)) {
    stop("No url could be generated")
  }

  # Prepare the request body
  body <- list(
    model = model,
    document = list(
      type = "document_url",
      document_url = url
    ),
    include_image_base64 = include_image_base64
  )

  # Create a configuration with timeout
  config <- httr::config(
    connecttimeout = timeout_sec,
    timeout = timeout_sec
  )

  # Set up headers
  headers <- c(
    "Content-Type" = "application/json",
    "Authorization" = paste("Bearer", api_key)
  )

  # Make the API call
  response <- httr::POST(
    url = "https://api.mistral.ai/v1/ocr",
    httr::add_headers(.headers = headers),
    body = jsonlite::toJSON(body, auto_unbox = TRUE),
    encode = "json",
    config = config
  )

  restore.point("post_processing")
  # Check for HTTP errors
  #httr::stop_for_status(response)

  # Parse the response
  content = try(httr::content(response, "text", encoding = "UTF-8"))
  if (is(content,"try-error")) {
    response$is_ok = FALSE
    response$url = url
    return(response)
  }
  result <- try(jsonlite::fromJSON(content))
  if (is(result, "try-error")) {
    content$status_code = response$status_code
    content$url = url
    content$is_ok = FALSE
    return(content)
  }
  result$status_code = response$status_code
  result$is_ok = TRUE
  result$url = url
  result
}
