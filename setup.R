#----------------------------------------
# This script sets out to load all the
# packages and folders necessary for the
# project
#----------------------------------------

#----------------------------------------
# Author: Trent Henderson, 24 August 2021
#----------------------------------------

library(data.table)
library(tibble)
library(dplyr)
library(tidyr)
library(purrr)
library(readr)
library(stringr)
library(ggplot2)
library(ggrepel)
library(broom)
library(tuneR)
library(R.matlab)
library(theft)

# Create important folders if none exist

if(!dir.exists('data')) dir.create('data')
if(!dir.exists('data/raw-signals')) dir.create('data/raw-signals')
if(!dir.exists('data/raw-signals-numeric')) dir.create('data/raw-signals-numeric')
if(!dir.exists('data/features')) dir.create('data/features')
if(!dir.exists('DAW')) dir.create('DAW')
if(!dir.exists('analysis')) dir.create('analysis')
if(!dir.exists('output')) dir.create('output')
if(!dir.exists('R')) dir.create('R')
if(!dir.exists('processing')) dir.create('processing')
if(!dir.exists('report')) dir.create('report')

# Load custom functions

r_files <- list.files("R", full.names = TRUE, pattern = "\\.[Rr]")

for(f in r_files){
  source(f)
}

# Load amplifier metadata

source("processing/metadata.R")
