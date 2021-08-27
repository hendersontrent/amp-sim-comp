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

  # Remove sine sweep files

  removals <- c("data/raw-signals/CSC_sweep_20-20k.wav", "data/raw-signals/CSC_sweep_20-20k.wav.reapeaks")
  files <- files[!(files %in% removals)]

  # Loop through each filepath and parse the data

  storage <- list()

  for(f in files){

    message(paste0("Reading in and parsing: ",f))

    # Read file into R

    d <- readWave(f)

    # Extract mono component and wrangle into tidy dataframe

    tmp <- as.data.frame(d@left) %>%
      rename(amplitude = 1) %>%
      mutate(timepoint = row_number(),
             filename = f)

    # Store tidy dataframe

    storage[[f]] <- tmp
  }

  outData <- data.table::rbindlist(storage, use.names = TRUE)

  # Add ID and group labels

  outData <- outData %>%
    mutate(id = case_when(
            filename == "data/raw-signals/Neural_Nolly_1.wav"         ~ "Neural DSP Nolly 1",
            filename == "data/raw-signals/Neural_Nolly_2.wav"         ~ "Neural DSP Nolly 2",
            filename == "data/raw-signals/Neural_Nolly_3.wav"         ~ "Neural DSP Nolly 3",
            filename == "data/raw-signals/Neural_Nolly_4.wav"         ~ "Neural DSP Nolly 4",
            filename == "data/raw-signals/Neural_Fortin_Nameless.wav" ~ "Neural DSP Fortin Nameless",
            filename == "data/raw-signals/STL_Tonality_1_EL34.wav"    ~ "STL Tonality 1_EL34",
            filename == "data/raw-signals/STL_Tonality_1_6L6.wav"     ~ "STL Tonality 1_6L6",
            filename == "data/raw-signals/STL_Tonality_1_KT88.wav"    ~ "STL Tonality 1_KT88",
            filename == "data/raw-signals/STL_Tonality_2_EL34.wav"    ~ "STL Tonality 2_EL34",
            filename == "data/raw-signals/STL_Tonality_2_6L6.wav"     ~ "STL Tonality 2_6L6",
            filename == "data/raw-signals/STL_Tonality_2_KT88.wav"    ~ "STL Tonality 2_KT88",
            filename == "data/raw-signals/STL_Tonality_3_EL34.wav"    ~ "STL Tonality 3_EL34",
            filename == "data/raw-signals/STL_Tonality_3_6L6.wav"     ~ "STL Tonality 3_6L6",
            filename == "data/raw-signals/STL_Tonality_3_KT88.wav"    ~ "STL Tonality 3_KT88",
            filename == "data/raw-signals/STL_Tonality_4_EL34.wav"    ~ "STL Tonality 4_EL34",
            filename == "data/raw-signals/STL_Tonality_4_6L6.wav"     ~ "STL Tonality 4_6L6",
            filename == "data/raw-signals/STL_Tonality_4_KT88.wav"    ~ "STL Tonality 4_KT88",
            filename == "data/raw-signals/STL_Tonality_4_KT77.wav"    ~ "STL Tonality 4_KT77",
            filename == "data/raw-signals/Neural_CoryWong_1.wav"      ~ "Neural DSP CoryWong 1",
            filename == "data/raw-signals/Neural_CoryWong_2.wav"      ~ "Neural DSP CoryWong 2",
            filename == "data/raw-signals/Neural_CoryWong_3.wav"      ~ "Neural DSP CoryWong 3",
            filename == "data/raw-signals/Neural_Gojira_1.wav"        ~ "Neural DSP Gojira 1",
            filename == "data/raw-signals/Neural_Gojira_2.wav"        ~ "Neural DSP Gojira 2",
            filename == "data/raw-signals/Neural_Gojira_3.wav"        ~ "Neural DSP Gojira 3")) %>%
    mutate(group = case_when(
            grepl("Neural", id) ~ "Neural_DSP",
            grepl("STL", id)    ~ "STL_Tonality")) %>%
    dplyr::select(-c(filename))

  return(outData)
}

# Run function and save file for use in R

amplifiers <- get_waveforms()
save(amplifiers, file = "data/raw-signals-numeric/amplifiers.Rda")

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
    dplyr::select(-c(group)) %>%
    pivot_wider(id_cols = "id", names_from = "timepoint", values_from = "amplitude")

  timeSeriesData <- as.matrix(timeSeriesData)

  # Write matrix

  write.csv(timeSeriesData, "data/raw-signals-numeric/timeSeriesData.csv")

  #-------
  # labels
  #-------

  labels <- c(amp_data %>%
                dplyr::select(c(id)) %>%
                distinct() %>%
                pull(id))

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

  #---------------------
  # Merge all 3 and
  # write MATLAB file
  # for hctsa processing
  #---------------------

  writeMat("data/raw-signals-numeric/amplifiers.mat", timeSeriesData = timeSeriesData,
           labels = labels, keywords = keywords)
}

# Run function

convert_amplifier_matrix(data = amplifiers)
