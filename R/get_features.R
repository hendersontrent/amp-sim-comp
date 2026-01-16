#' Function to loop over every amp, parse waveform, and calculate features
#'
#' @param paths \code{character} denoting the filepath to find waveforms in. Defaults to \code{"data/raw-signals"}
#' @param ... arguments to be passed to \code{theft::calculate_features}
#' @return \code{feature_calculations} object
#' @author Trent Henderson
#'

get_features <- function(paths = "data/raw-signals", ...){

  # List all the waveform filepaths

  files <- list.files(paths, full.names = TRUE, pattern = "\\.wav", all.files = TRUE)

  # Remove sine sweep files

  removals <- c("data/raw-signals/CSC_sweep_20-20k.wav", "data/raw-signals/CSC_sweep_20-20k.wav.reapeaks")
  files <- files[!(files %in% removals)]

  # Iterate over every amp and parse waveform then calculate features

  outs <- vector(mode = "list", length = length(files))

  for(f in files){

    message(paste0("Processing: ", match(f, files), "/", length(files)))
    clean_name <- gsub(".*\\/", "\\1", f)
    clean_name <- gsub("\\.wav", "\\1", clean_name)
    clean_name <- gsub("_", " ", clean_name)

    # Read file into R

    tmp <- readWave(f)

    # Extract mono component and wrangle into tsibble

    tmp <- as.data.frame(tmp@left) %>%
      rename(values = 1) %>%
      mutate(timepoint = row_number(),
             id = clean_name) %>%
      as_tsibble(key = "id", index = "timepoint")

    # Calculate features

    features <- calculate_features(tmp, ...)
    outs[[match(f, files)]] <- features
  }

  outs <- do.call("rbind", outs)
  return(outs)
}
