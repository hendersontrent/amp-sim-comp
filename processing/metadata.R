#-----------------------------------------
# This script defines a reusable dataframe
# of amplifier names, their brands, and
# a qualitative definition of their gain
# structure/type
#-----------------------------------------

#-----------------------------------------
# Author: Trent Henderson, 8 December 2022
#-----------------------------------------

metadata <- data.frame(id = c("Neural DSP Cory Wong 1", "Neural DSP Cory Wong 2", "Neural DSP Cory Wong 3",
                               "Neural DSP Fortin Nameless", "Neural DSP Fortin Cali Clean", "Neural DSP Fortin Cali Overdrive 1",
                               "Neural DSP Fortin Cali Overdrive 2", "Neural DSP Fortin NTS Clean", "Neural DSP Fortin NTS Overdrive",
                               "Neural DSP Gojira 1", "Neural DSP Gojira 2", "Neural DSP Gojira 3", "Neural DSP Nolly 1", "Neural DSP Nolly 2",
                               "Neural DSP Nolly 3", "Neural DSP Nolly 4", "Neural DSP Petrucci 1", "Neural DSP Petrucci 2",
                               "Neural DSP Petrucci 3", "Neural DSP Petrucci 4", "Neural DSP Plini 1", "Neural DSP Plini 2",
                               "Neural DSP Plini 3", "Neural DSP Rabea 1", "Neural DSP Rabea 2_6L6", "Neural DSP Rabea 2_EL34",
                               "Neural DSP Rabea 3_6L6", "Neural DSP Rabea 3_EL34", "Neural DSP Soldano Normal",
                               "Neural DSP Soldano Overdrive", "Neural DSP Tim Henson 1", "Neural DSP Tim Henson 2",
                               "Neural DSP Tim Henson 3", "Neural DSP Tone King Lead", "Neural DSP Tone King Rhythm",
                               "STL Tonality 1_6L6", "STL Tonality 1_EL34", "STL Tonality 1_KT88", "STL Tonality 2_6L6",
                               "STL Tonality 2_EL34", "STL Tonality 2_KT88", "STL Tonality 3_6L6", "STL Tonality 3_EL34",
                               "STL Tonality 3_KT88", "STL Tonality 4_6L6", "STL Tonality 4_EL34", "STL Tonality 4_KT77", "STL Tonality 4_KT88")) %>%
  mutate(brand = ifelse(grepl("Neural", id), "Neural DSP", "STL Tonality")) %>%
  mutate(plugin = case_when(
          grepl("STL", id)      ~ "STL Tonality",
          grepl("Cory", id)     ~ "Archetype: Cory Wong",
          grepl("Nameless", id) ~ "Fortin Nameless",
          grepl("Gojira", id)   ~ "Archetype: Gojira",
          grepl("Nolly", id)    ~ "Archetype: Nolly",
          grepl("Plini", id)    ~ "Archetype: Plini",
          grepl("Henson", id)   ~ "Archetype: Tim Henson",
          grepl("Cali", id)     ~ "Fortin Cali Suite",
          grepl("NTS", id)      ~ "Fortin NTS Suite",
          grepl("Rabea", id)    ~ "Archetype: Rabea",
          grepl("Tone King", id) ~ "Tone King Imperial MKII",
          grepl("Petrucci", id) ~ "Archetype: Petrucci",
          grepl("Soldano", id)  ~ "Soldano SLO-100")) %>%
  mutate(amp_type = case_when(
    id == "Neural DSP Cory Wong 1"             ~ "Acoustic/Other",
    id == "Neural DSP Cory Wong 2"             ~ "Clean",
    id == "Neural DSP Cory Wong 3"             ~ "Low Gain",
    id == "Neural DSP Fortin Nameless"         ~ "High Gain",
    id == "Neural DSP Gojira 1"                ~ "Clean",
    id == "Neural DSP Gojira 2"                ~ "High Gain",
    id == "Neural DSP Gojira 3"                ~ "High Gain",
    id == "Neural DSP Nolly 1"                 ~ "Clean", # Crunch
    id == "Neural DSP Nolly 2"                 ~ "Mid Gain", # Crunch
    id == "Neural DSP Nolly 3"                 ~ "High Gain", # Rhythm
    id == "Neural DSP Nolly 4"                 ~ "High Gain", # Lead
    id == "Neural DSP Plini 1"                 ~ "Clean",
    id == "Neural DSP Plini 2"                 ~ "Mid Gain",
    id == "Neural DSP Plini 3"                 ~ "High Gain",
    id == "Neural DSP Tim Henson 1"            ~ "Acoustic/Other",
    id == "Neural DSP Tim Henson 2"            ~ "Low Gain",
    id == "Neural DSP Tim Henson 3"            ~ "Mid Gain",
    id == "STL Tonality 1_6L6"                 ~ "High Gain",
    id == "STL Tonality 1_EL34"                ~ "High Gain",
    id == "STL Tonality 1_KT88"                ~ "High Gain",
    id == "STL Tonality 2_6L6"                 ~ "High Gain",
    id == "STL Tonality 2_EL34"                ~ "High Gain",
    id == "STL Tonality 2_KT88"                ~ "High Gain",
    id == "STL Tonality 3_6L6"                 ~ "High Gain",
    id == "STL Tonality 3_EL34"                ~ "High Gain",
    id == "STL Tonality 3_KT88"                ~ "High Gain",
    id == "STL Tonality 4_6L6"                 ~ "High Gain",
    id == "STL Tonality 4_EL34"                ~ "Mid Gain",
    id == "STL Tonality 4_KT77"                ~ "Mid Gain",
    id == "STL Tonality 4_KT88"                ~ "Mid Gain",
    id == "Neural DSP Fortin Cali Clean"       ~ "Clean",
    id == "Neural DSP Fortin Cali Overdrive 1" ~ "High Gain",
    id == "Neural DSP Fortin Cali Overdrive 2" ~ "High Gain",
    id == "Neural DSP Fortin NTS Clean"        ~ "Clean",
    id == "Neural DSP Fortin NTS Overdrive"    ~ "High Gain",
    id == "Neural DSP Petrucci 1"              ~ "Acoustic/Other",
    id == "Neural DSP Petrucci 2"              ~ "Clean",
    id == "Neural DSP Petrucci 3"              ~ "High Gain",
    id == "Neural DSP Petrucci 4"              ~ "High Gain",
    id == "Neural DSP Rabea 1"                 ~ "Clean",
    id == "Neural DSP Rabea 2_6L6"             ~ "High Gain",
    id == "Neural DSP Rabea 2_EL34"            ~ "High Gain",
    id == "Neural DSP Rabea 3_6L6"             ~ "High Gain",
    id == "Neural DSP Rabea 3_EL34"            ~ "High Gain",
    id == "Neural DSP Soldano Normal"          ~ "Clean",
    id == "Neural DSP Soldano Overdrive"       ~ "High Gain",
    id == "Neural DSP Tone King Lead"          ~ "Low Gain",
    id == "Neural DSP Tone King Rhythm"        ~ "Low Gain"))
