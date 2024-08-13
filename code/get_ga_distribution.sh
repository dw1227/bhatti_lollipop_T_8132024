#!/usr/bin/env bash

# author: Gaurav Bhatti
# inputs: data with patient identifier (ID), GA at sample (GA), GA at delivery, and group
# outputs: line plots and violen plots showing the distribution of GA @ sample.

module load r/4.4.0
Rscript  code/plot_ga_line.R


 
