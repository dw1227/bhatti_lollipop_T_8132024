# Code Directory

**Author**: Gaurav Bhatti

This directory contains the R and Bash scripts used to generate visualizations for the project.

## Contents

- **plot_ga_line.R**
  - Generates a lollipop plot showing the gestational age (GA) at sampling for individual patients, grouped by preterm status.
  - Creates violin plots to visualize the distribution of GA at sampling across three distinct groups.

- **get_ga_distribution,sh**
  - A script to execute the R scripts for generating the plots. This script automates the process and ensures all necessary steps are followed.

## Usage

To run the analysis and generate the plots, execute the Bash script from the command line:

```bash
bash get_ga_distribution.sh

