#----------------------------------------
# This script sets out to load all the
# packages and folders necessary for the
# project
#----------------------------------------

#----------------------------------------
# Author: Trent Henderson, 24 August 2021
#----------------------------------------

library(data.table)
library(dplyr)
library(tidyr)
library(readr)
library(ggplot2)
library(tuneR)
library(R.matlab)

# Create important folders if none exist

if(!dir.exists('data')) dir.create('data')
if(!dir.exists('data/raw-signals')) dir.create('data/raw-signals')
if(!dir.exists('data/raw-signals-numeric')) dir.create('data/raw-signals-numeric')
if(!dir.exists('data/features')) dir.create('data/features')
if(!dir.exists('DAW')) dir.create('DAW')
if(!dir.exists('analysis')) dir.create('analysis')
if(!dir.exists('output')) dir.create('output')
