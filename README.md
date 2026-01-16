# amp-sim-comp
Compares various guitar amp simulators on their temporal behaviour.

## Motivation

Many different virtual guitar amplifier simulators exist today. While most musicians and producers *tonally* understand the differences between the characteristics of different amplifiers, little research has been conducted on empirical, quantitative differences between them. This projects seeks to address that gap for a set of Virtual Studio Technology (VST) amplifier guitar heads using a novel [feature-based time-series analysis](https://www.taylorfrancis.com/chapters/edit/10.1201/9781315181080-4/feature-based-time-series-analysis-ben-fulcher) approach made possible by the [`theft`](https://github.com/hendersontrent/theft) package for R.

## Basic methodology

* Each amplifier head's setting are set to noon. All pedals, cabinets and effects are turned off.
* A 20Hz-20kHz sine sweep is fed into each amplifier, producing a standardised output response for each amplifier.
* The waveform is converted to a numerical time series $\times$ amplitude matrix.
* Time-series features are computed on the time series $\times$ amplitude matrix for each amplifier.
* Analysis is conducted on the resulting time series $\times$ feature matrix to reveal empirical structure in the data.

## Other notes

This repository is very large due to the number of audio files.

## Running the code

The `driver.R` script runs everything in the correct order.
