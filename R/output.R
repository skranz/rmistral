#' Save OCR results as a Markdown file
#'
#' This function saves the extracted OCR text in Markdown format, either as a single file or split by pages.
#'
#' @param ocr A list containing OCR results, including extracted text and images.
#' @param file The file path where the Markdown content should be saved.
#' @param by_page Logical. If `TRUE`, saves each page as a separate file. Defaults to `FALSE`.
#' @param save_images Logical. If `TRUE`, also saves extracted images. Defaults to `TRUE`.
#' @param overwrite Logical. If `TRUE`, overwrites existing files. Defaults to `FALSE`.
#' @param img_dir Directory where images should be saved. Defaults to the directory of `file`.
#'
#' @export
mistral_ocr_save_md = function(ocr, file, by_page=FALSE, save_images=TRUE, overwrite=FALSE, img_dir = dirname(file)) {
  pages = ocr$pages
  if (NROW(pages)==0) {
    cat("\nNo pages were extracted.")
    return(NULL)
  }
  if (!by_page) {
    md = pages$markdown
    if (length(md)>0)
    if (!file.exists(file)  | overwrite)
      writeLines(md, file)
  } else {
    no_ext_file = tools::file_path_sans_ext(file)
    file_ext = tools::file_ext(file)
    for (i in 1:NROW(pages)) {
      pfile = paste0(no_ext_file, "--",i,".", file_ext)
      if (!file.exists(pfile) | overwrite)
        writeLines(pages$markdown[[i]], pfile)
    }
  }
  if (save_images) {
    mistral_ocr_save_images(ocr, img_dir, overwrite)
  }
}

#' Save extracted images from OCR results
#'
#' This function extracts and saves images from OCR results to a specified directory.
#'
#' @param ocr A list containing OCR results, including extracted images.
#' @param img_dir Directory where images should be saved.
#' @param overwrite Logical. If `TRUE`, overwrites existing image files. Defaults to `FALSE`.
#'
#' @return The number of images saved.
#' @export
mistral_ocr_save_images = function(ocr, img_dir, overwrite=FALSE) {
  df = do.call(rbind,ocr$pages$images)
  if (NROW(df)==0) return(0)
  for (i in 1:NROW(df)) {
    file = file.path(img_dir, df$id[[i]])
    save_base64_image(df$image_base64[[i]], file, overwrite=overwrite)
  }
  return(NROW(df))
}

save_base64_image <- function(base64_string, output_file, overwrite = FALSE) {
  restore.point("save_base64_image")
  library(base64enc)

  # Check if file exists and handle overwrite parameter
  if (file.exists(output_file) && !overwrite) {
    return(FALSE)
  }

  # Check if the base64 string is empty
  if (is.null(base64_string) || base64_string == "") {
    stop("Base64 string is empty or NULL")
  }

  # Strip MIME type prefix if present
  # Common prefixes: "data:image/jpeg;base64,", "data:image/png;base64,", etc.
  if (grepl("^data:image/[^;]+;base64,", base64_string)) {
    # Extract the actual base64 content after the prefix
    base64_content <- sub("^data:image/[^;]+;base64,", "", base64_string)
  } else {
    # If no prefix, use the string as is
    base64_content <- base64_string
  }

  tryCatch({
    # Decode base64 to raw bytes
    image_data <- base64enc::base64decode(base64_content)

    # Write binary data to file
    writeBin(image_data, output_file)

    #message(paste("Image successfully saved to", output_file))
    return(invisible(TRUE))

  }, error = function(e) {
    stop(paste("Failed to save image:", e$message))
  })
}
