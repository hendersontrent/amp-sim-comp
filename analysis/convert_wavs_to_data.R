#----------------------------------------
# This script sets out to load all the
# waveforms for each amplifier in and
# convert to a time-amplitude matrix
#
# NOTE: This script requires setup.R to
# have been run first
#----------------------------------------

#----------------------------------------
# Author: Trent Henderson, 24 August 2021
#----------------------------------------

#' Function to read in all wav forms and append into a dataframe
#'
#' @return an object of class dataframe
#' @author Trent Henderson
#'

get_waveforms <- function(){

  # List all the waveform filepaths

  files <- list.files("data/raw-signals", full.names = TRUE, pattern = "\\.wav", all.files = TRUE)

  storage <- list()

  for(f in files){

    message(paste0("Reading in and parsing: ",f))

    # Read file into R

    d <- readWave(f)

    # Extract mono component and wrangle into tidy dataframe

    tmp <- as.data.frame(d@left) %>%
      rename(amplitude = 1) %>%
      mutate(amplifier = "XXX",
             timepoint = seq_along(amplitude))

    # Store tidy dataframe

    storage[[f]] <- tmp
  }

  outData <- data.table::rbindlist(storage, use.names = TRUE)

  # Add group labels

  outData <- outData %>%
    mutate(group = case_when(
            x == "" ~ "",
            x == "" ~ "",
            x == "" ~ "",
            x == "" ~ "",
            x == "" ~ "",
            x == "" ~ "",
            x == "" ~ "",
            x == "" ~ "",
            x == "" ~ "",
            x == "" ~ "",
            x == "" ~ "",
            x == "" ~ "",
            x == "" ~ "",
            x == "" ~ "",
            x == "" ~ "",
            x == "" ~ "",
            x == "" ~ "",
            x == "" ~ "")) %>%
    mutate(group_meta = case_when(
            agrepl("Neural", group) ~ "Neural DSP",
            agrepl("STL", group) ~ "STL Tonality"))

  return(outData)
}

# Save file for use in R

amplifiers <- save(get_waveforms, file = "data/raw-signals-numeric/amplifiers.Rda")

#------------------ Exports for general use --------------

#' Function to convert data matrix from long to wide and save it + metadata
#'
#' @param amp_data the dataframe object containing the time series data for all amps
#' @author Trent Henderson
#'

convert_amplifier_matrix <- function(amp_data){

  message("Converting data. This may take a while...")

  #---------------
  # timeSeriesData
  #---------------

  # Wrangle from long to wide

  timeSeriesData <- amp_data %>%
    dplyr::select(-c(group, group_meta)) %>%
    pivot_wider(id_cols = "amplifier", names_from = "timepoint", values_from = "amplitude")

  timeSeriesData <- as.matrix(timeSeriesData)

  # Write matrix

  write.csv(timeSeriesData, "data/raw-signals-numeric/timeSeriesData.csv")

  #-------
  # labels
  #-------

  labels <- c(amp_data %>%
                dplyr::select(c(amplifier)) %>%
                distinct() %>%
                pull(Name))

  # Write metadata

  write.csv(labels, "data/raw-signals-numeric/labels.csv")

  #---------
  # keywords
  #---------

  keywords <- c(amp_data %>%
                  dplyr::select(c(group)) %>%
                  distinct() %>%
                  pull(group))

  # Write group labels

  write.csv(keywords, "data/raw-signals-numeric/keywords.csv")

  #------------------
  # Merge all 3 and
  # write MATLAB file
  #------------------

  writeMat("data/raw-signals-numeric/amplifiers.mat", timeSeriesData = timeSeriesData,
           labels = labels, keywords = keywords)
}

# Run function

convert_amplifier_matrix(data = amplifiers)
