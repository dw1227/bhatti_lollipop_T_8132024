# Data Directory

This directory contains the input data necessary for generating the visualizations in this project.

## Contents

- **Input Excel File**
  - This file includes key information for each patient, organized in a wide format:
    - **Patient Identifier**: A unique ID for each patient.
    - **Gestational Ages at Sampling**: Up to five sampling points recorded for each patient.
    - **Gestational Age at Delivery**: The gestational age at which each patient delivered.

## Data Format

- **Gestational Age Representation**: 
  - The gestational age is recorded in a `weeks.days` format. This must be converted to a fractional format (e.g., 37.5 weeks) for analysis and visualization.

- **Data Structure**: 
  - Each row in the Excel file represents a single patient, with multiple columns for the gestational ages at different sampling points.


