% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ocr.R
\name{mistral_ocr}
\alias{mistral_ocr}
\title{Perform OCR using the Mistral API}
\usage{
mistral_ocr(
  url = NULL,
  file = NULL,
  model = "mistral-ocr-latest",
  include_images = TRUE,
  timeout_sec = 60 * 5,
  api_key = mistral_api_key()
)
}
\arguments{
\item{url}{Optional. The URL of the document to be processed.}

\item{file}{Optional. A local file path or an uploaded file object.}

\item{model}{The OCR model to use. Defaults to `"mistral-ocr-latest"`.}

\item{include_images}{Logical. Whether to include images in the response. Defaults to `TRUE`.}

\item{timeout_sec}{The timeout for the API request in seconds. Defaults to 300 (5 minutes).}

\item{api_key}{Character string. Your Mistral API key. Best set globabally via calling \code{set_mistral_api_key}.}
}
\value{
List containing the result. The field \code{is_ok} should be TRUE if everything worked nicely. The element \code{pages} contains the extracted pages.
}
\description{
This function sends a document (either via URL or file upload) to the Mistral OCR API for text extraction.
}
