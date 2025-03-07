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
```

```r
# 1. Load library and set API key
library(rmistral)
set_mistral_api_key("<YOUR MISTRAL AI API KEY>")


# 2. Specify URL to your pdf file
#    To convert a local PDF file use instead the file argument
#    in your mistral_ocr call.

url = "https://raw.githubusercontent.com/skranz/rmistral/main/pdf_example/paper_excerpt.pdf"

# 3. Convert the PDF at the URL to result object
#    Most relevant information are in ocr$pages.

ocr = mistral_ocr(url=url,timeout_sec = 120, include_images = TRUE)

# 4. Save results as markdown file and all 
#    extracted images as separate files

md_file = "mydir/myfile.md"
mistral_ocr_save_md(ocr,md_file, by_page=FALSE, overwrite = TRUE, save_images=TRUE)

# 5. To convert to a different format, you can use e.g. pandoc.
#    Here an example that converts to an HTML file

library(rmarkdown)
html_file = "mydir/myfile.html"
pandoc_convert(md_file, ouput=html_file)
```
