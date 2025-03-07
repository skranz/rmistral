set_mistral_api_key = function(key=NULL, file=NULL) {
  if (is.null(key)) {
    key = suppressWarnings(readLines(file))
  }
  options(mIstrAl_apI_key = key)
}

mistral_api_key = function() {
  getOption("mIstrAl_apI_key")
}
