# amp-sim-comp
Compares various guitar amp simulators on their quantitative characteristics.

## Motivation

Many different virtual guitar amplifier simulators exist today. While most musicians and producers *tonally* understand the differences between the characteristics of different amplifiers, little research has been conducted on empirical, quantitative differences between them. This projects seeks to address that gap for a set of Virtual Studio Technology (VST) amplifier guitar heads.

## Included amplifiers

Currently, analysis includes the following amplifiers:

* Archetype Nolly (Neural DSP) - 4 amplifiersx
* Archetype Gojira (Neural DSP) - 3 amplifiers
* Archetype Cory Wong (Neural DSP) - 3 amplifiers
* Archetype Plini (Neural DSP) - 3 amplifiers
* Archetype Tim Henson (Neural DSP) - 3 amplifiers
* Fortin Nameless (Neural DSP) - 1 amplifier
* STL Tonality Will Putney (STL) - 4 amplifiers with 3-4 tube settings for each

## Basic methodology

* Each amplifier head's setting are set to noon. All pedals, cabinets and effects are turned off.
* A 20Hz-20kHz sine sweep is fed into each amplifier, producing a standardised output response for each amplifier.
* The waveform is converted to a numerical time series x amplitude matrix.
* Time-series features are computed on the time series x amplitude matrix for each amplifier.
* Analysis is conducted on the feature space to identify any empirical structure in the data.

## Other notes

This repository is very large due to the number of .wav and .mp3 files and the [Reaper](https://www.reaper.fm) project files.
