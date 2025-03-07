# R interface to Mistral AI's to convert PDF to markdown

Mistral AI has great capabilities to tranform PDF to markdown and extract images, see https://mistral.ai/news/mistral-ocr  

This R package is a simple interface for this OCR functionality. This is a new package in development and specification may change.


# Installation

Soon it should be available on r-universe. Then call:

```r
install.packages('rmistral', repos = c('https://skranz.r-universe.dev', 'https://cloud.r-project.org'))
```

If that does not yet work, download the ZIP and build locally the R project.

# Usage Example

# Examples

Load library and specify Mistral API key.

```r
library(rmistral)
set_mistral_api_key("<YOUR MISTRAL AI API KEY>")
```

```r
# URL to your pdf file
url = "https://raw.githubusercontent.com/skranz/rmistral/main/pdf_example/paper_excerpt.pdf"

# Convert the PDF at the URL to result object
# Most relevant information are in ocr$pages.
# To convert a local PDF file use instead the file argument
ocr = mistral_ocr(url=url,timeout_sec = 120, include_images = TRUE)

# Save as markdown file and all extracted images as separate files
mistral_ocr_save_md(ocr, "mydir/myfile.md", by_page=FALSE, overwrite = TRUE, save_images=TRUE)
```

Note that mistral returns the document per default as markdown. To convert it to other formats, you can use e.g. [pandoc](https://pandoc.org/). You can conveniently call pandoc from R with the `pandoc_convert` function from the `RMarkdown` package.
