#' @param version Version of the library
#' @rdname fa
#' @importFrom utils download.file
#' @export
download_fa <- function(version = "dev"){
  # Clone repo
  tmpFile <- tempfile("icon_fa")
  dir.create(tmpDir <- tempfile("icon_fa"), showWarnings = FALSE)
  on.exit(unlink(c(tmpFile, tmpDir)))
  if(version == "dev"){
    version <- glue("dev ({Sys.Date()})")
    download.file("https://github.com/FortAwesome/Font-Awesome/archive/master.zip", tmpFile)
  }
  else{
    download.file(glue("https://github.com/FortAwesome/Font-Awesome/archive/{version}.zip"), tmpFile)
  }

  # Find icons
  utils::unzip(tmpFile, exdir = tmpDir)
  path <- file.path(list.dirs(tmpDir), "advanced-options", "raw-svg")
  files <- list_svg(path, recursive = TRUE, full.names = TRUE)

  # Copy icons
  dest_dir <- icon_path("fa")
  dir.create(dest_dir, recursive = TRUE, showWarnings = FALSE)
  file.copy(
    list_svg(path, recursive = TRUE, full.names = TRUE),
    file.path(dest_dir, basename(files)),
    overwrite = TRUE
  )
  saveRDS(
    list(name = "Font Awesome", version = version, licence = "CC BY 4.0"),
    file.path(dest_dir, "meta.rds")
  )

  # Update object
  fa <<- iconset(icon_path("fa"), meta = icon_meta("fa"))
}

#' Font Awesome icons
#'
#' @param name Name of the icon
#' @rdname fa
#' @export
fa <- NULL
