#' Function to read in all wav forms and append into a dataframe
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
      filename == "data/raw-signals/Neural_Nolly_1.wav"                     ~ "Neural DSP Nolly 1",
      filename == "data/raw-signals/Neural_Nolly_2.wav"                     ~ "Neural DSP Nolly 2",
      filename == "data/raw-signals/Neural_Nolly_3.wav"                     ~ "Neural DSP Nolly 3",
      filename == "data/raw-signals/Neural_Nolly_4.wav"                     ~ "Neural DSP Nolly 4",
      filename == "data/raw-signals/Neural_Fortin_Nameless.wav"             ~ "Neural DSP Fortin Nameless",
      filename == "data/raw-signals/STL_Tonality_1_EL34.wav"                ~ "STL Tonality Will Putney 1_EL34",
      filename == "data/raw-signals/STL_Tonality_1_6L6.wav"                 ~ "STL Tonality Will Putney 1_6L6",
      filename == "data/raw-signals/STL_Tonality_1_KT88.wav"                ~ "STL Tonality Will Putney 1_KT88",
      filename == "data/raw-signals/STL_Tonality_2_EL34.wav"                ~ "STL Tonality Will Putney 2_EL34",
      filename == "data/raw-signals/STL_Tonality_2_6L6.wav"                 ~ "STL Tonality Will Putney 2_6L6",
      filename == "data/raw-signals/STL_Tonality_2_KT88.wav"                ~ "STL Tonality Will Putney 2_KT88",
      filename == "data/raw-signals/STL_Tonality_3_EL34.wav"                ~ "STL Tonality Will Putney 3_EL34",
      filename == "data/raw-signals/STL_Tonality_3_6L6.wav"                 ~ "STL Tonality Will Putney 3_6L6",
      filename == "data/raw-signals/STL_Tonality_3_KT88.wav"                ~ "STL Tonality Will Putney 3_KT88",
      filename == "data/raw-signals/STL_Tonality_4_EL34.wav"                ~ "STL Tonality Will Putney 4_EL34",
      filename == "data/raw-signals/STL_Tonality_4_6L6.wav"                 ~ "STL Tonality Will Putney 4_6L6",
      filename == "data/raw-signals/STL_Tonality_4_KT88.wav"                ~ "STL Tonality Will Putney 4_KT88",
      filename == "data/raw-signals/STL_Tonality_4_KT77.wav"                ~ "STL Tonality Will Putney 4_KT77",
      filename == "data/raw-signals/Neural_CoryWong_1.wav"                  ~ "Neural DSP Cory Wong 1",
      filename == "data/raw-signals/Neural_CoryWong_2.wav"                  ~ "Neural DSP Cory Wong 2",
      filename == "data/raw-signals/Neural_CoryWong_3.wav"                  ~ "Neural DSP Cory Wong 3",
      filename == "data/raw-signals/Neural_Gojira_1.wav"                    ~ "Neural DSP Gojira 1",
      filename == "data/raw-signals/Neural_Gojira_2.wav"                    ~ "Neural DSP Gojira 2",
      filename == "data/raw-signals/Neural_Gojira_3.wav"                    ~ "Neural DSP Gojira 3",
      filename == "data/raw-signals/Neural_Plini_1.wav"                     ~ "Neural DSP Plini 1",
      filename == "data/raw-signals/Neural_Plini_2.wav"                     ~ "Neural DSP Plini 2",
      filename == "data/raw-signals/Neural_Plini_3.wav"                     ~ "Neural DSP Plini 3",
      filename == "data/raw-signals/Neural_TimHenson_1.wav"                 ~ "Neural DSP Tim Henson 1",
      filename == "data/raw-signals/Neural_TimHenson_2.wav"                 ~ "Neural DSP Tim Henson 2",
      filename == "data/raw-signals/Neural_TimHenson_3.wav"                 ~ "Neural DSP Tim Henson 3",
      filename == "data/raw-signals/Neural_FortinCali_Clean.wav"            ~ "Neural DSP Fortin Cali Clean",
      filename == "data/raw-signals/Neural_FortinCali_Overdrive_1.wav"      ~ "Neural DSP Fortin Cali Overdrive 1",
      filename == "data/raw-signals/Neural_FortinCali_Overdrive_2.wav"      ~ "Neural DSP Fortin Cali Overdrive 2",
      filename == "data/raw-signals/Neural_FortinNTS_Clean.wav"             ~ "Neural DSP Fortin NTS Clean",
      filename == "data/raw-signals/Neural_FortinNTS_Overdrive.wav"         ~ "Neural DSP Fortin NTS Overdrive",
      filename == "data/raw-signals/Neural_Petrucci_1.wav"                  ~ "Neural DSP Petrucci 1",
      filename == "data/raw-signals/Neural_Petrucci_2.wav"                  ~ "Neural DSP Petrucci 2",
      filename == "data/raw-signals/Neural_Petrucci_3.wav"                  ~ "Neural DSP Petrucci 3",
      filename == "data/raw-signals/Neural_Petrucci_4.wav"                  ~ "Neural DSP Petrucci 4",
      filename == "data/raw-signals/Neural_Rabea_1.wav"                     ~ "Neural DSP Rabea 1",
      filename == "data/raw-signals/Neural_Rabea_2_6L6.wav"                 ~ "Neural DSP Rabea 2_6L6",
      filename == "data/raw-signals/Neural_Rabea_2_EL34.wav"                ~ "Neural DSP Rabea 2_EL34",
      filename == "data/raw-signals/Neural_Rabea_3_6L6.wav"                 ~ "Neural DSP Rabea 3_6L6",
      filename == "data/raw-signals/Neural_Rabea_3_EL34.wav"                ~ "Neural DSP Rabea 3_EL34",
      filename == "data/raw-signals/Neural_Soldano_Normal.wav"              ~ "Neural DSP Soldano Normal",
      filename == "data/raw-signals/Neural_Soldano_Overdrive.wav"           ~ "Neural DSP Soldano Overdrive",
      filename == "data/raw-signals/Neural_ToneKing_Lead.wav"               ~ "Neural DSP Tone King Lead",
      filename == "data/raw-signals/Neural_ToneKing_Rhythm.wav"             ~ "Neural DSP Tone King Rhythm",
      filename == "data/raw-signals/STL_Tonality_AndyJames_1_6L6.wav"       ~ "STL Tonality Andy James 1_6L6",
      filename == "data/raw-signals/STL_Tonality_AndyJames_1_EL34.wav"      ~ "STL Tonality Andy James 1_EL34",
      filename == "data/raw-signals/STL_Tonality_AndyJames_1_KT88.wav"      ~ "STL Tonality Andy James 1_KT88",
      filename == "data/raw-signals/STL_Tonality_AndyJames_2_6L6.wav"       ~ "STL Tonality Andy James 2_6L6",
      filename == "data/raw-signals/STL_Tonality_AndyJames_2_EL34.wav"      ~ "STL Tonality Andy James 2_EL34",
      filename == "data/raw-signals/STL_Tonality_AndyJames_2_KT88.wav"      ~ "STL Tonality Andy James 2_KT88",
      filename == "data/raw-signals/STL_Tonality_AndyJames_3_Lo.wav"        ~ "STL Tonality Andy James 3_Lo",
      filename == "data/raw-signals/STL_Tonality_AndyJames_3_Hi.wav"        ~ "STL Tonality Andy James 3_Hi",
      filename == "data/raw-signals/STL_Tonality_HowardBenson_1.wav"        ~ "STL Tonality Howard Benson 1",
      filename == "data/raw-signals/STL_Tonality_HowardBenson_2_Clean.wav"  ~ "STL Tonality Howard Benson 2_Clean",
      filename == "data/raw-signals/STL_Tonality_HowardBenson_2_Lead.wav"   ~ "STL Tonality Howard Benson 2_Lead",
      filename == "data/raw-signals/STL_Tonality_HowardBenson_3.wav"        ~ "STL Tonality Howard Benson 3",
      filename == "data/raw-signals/STL_Tonality_HowardBenson_4.wav"        ~ "STL Tonality Howard Benson 4",
      filename == "data/raw-signals/STL_Tonality_HowardBenson_5.wav"        ~ "STL Tonality Howard Benson 5",
      filename == "data/raw-signals/STL_Tonality_LasseLammert_1.wav"        ~ "STL Tonality Lasse Lammert 1",
      filename == "data/raw-signals/STL_Tonality_LasseLammert_2.wav"        ~ "STL Tonality Lasse Lammert 2",
      filename == "data/raw-signals/STL_Tonality_LasseLammert_3.wav"        ~ "STL Tonality Lasse Lammert 3",
      filename == "data/raw-signals/Neural_Abasi_1.wav"                     ~ "Neural DSP Abasi 1",
      filename == "data/raw-signals/Neural_Abasi_2.wav"                     ~ "Neural DSP Abasi 2",
      filename == "data/raw-signals/Neural_Abasi_3.wav"                     ~ "Neural DSP Abasi 3",
      filename == "data/raw-signals/Neural_Granophyre_6L6.wav"              ~ "Neural DSP Omega Granophyre_6L6",
      filename == "data/raw-signals/Neural_Granophyre_EL34.wav"             ~ "Neural DSP Omega Granophyre_EL34",
      filename == "data/raw-signals/Neural_Granophyre_KT66.wav"             ~ "Neural DSP Omega Granophyre_KT66")) %>%
    dplyr::select(-c(filename))

  return(outData)
}
