# amp-sim-comp
Compares various guitar amp simulators on their temporal behaviour.

## Motivation

Many different virtual guitar amplifier simulators exist today. While most musicians and producers *tonally* understand the differences between the characteristics of different amplifiers, little research has been conducted on empirical, quantitative differences between them. This projects seeks to address that gap for a set of Virtual Studio Technology (VST) amplifier guitar heads using a novel [feature-based time-series analysis](https://arxiv.org/abs/1709.08055) approach.

## Included amplifiers

Currently, analysis includes the entire [Neural DSP](https://neuraldsp.com/plugins) product line and the four guitar amplifiers included in [STL Tonality Will Putney](https://www.stltones.com/products/stl-tonality-will-putney-guitar-plug-in).

## Basic methodology

* Each amplifier head's setting are set to noon. All pedals, cabinets and effects are turned off.
* A 20Hz-20kHz sine sweep is fed into each amplifier, producing a standardised output response for each amplifier.
* The waveform is converted to a numerical time series x amplitude matrix.
* Time-series features are computed on the time series x amplitude matrix for each amplifier.
* Analysis is conducted on the feature space to identify any empirical structure in the data.

## Other notes

This repository is very large due to the number of .wav and .mp3 files and the [Reaper](https://www.reaper.fm) project files.
