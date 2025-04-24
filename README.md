# Optimality-Based Plant C-N Allocation Model
 
 [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10481394.svg)](https://doi.org/10.5281/zenodo.10481394)
[![Twitter](https://img.shields.io/twitter/url/https/twitter.com/cloudposse.svg?style=social&label=Follow%20@ArjunChakrawal)](https://twitter.com/ArjunChakrawal)

This repository contains the codebase for simulating and visualizing plant responses to nitrogen (N) limitation via dynamic carbon (C) allocation strategies in plant–soil–microbe systems. The model supports the manuscript "Modelling the acclimative value of root growth and exudation to low soil nitrogen" by  Chakrawal et al., 2025.

## 🌱 Model Overview
Plants must trade off C allocation between leaves, roots, and root exudates to forage for N under low availability. Our model captures these tradeoffs using an eco-evolutionary optimality framework that dynamically adapts C allocation strategies to maximize aboveground growth.

**Key Features:**
- Stoichiometrically constrained plant-microbe interactions
- Dynamic C allocation between leaves, roots, and exudation
- Optimization of plant growth under variable soil N availability
- Integration of plant traits (e.g., root N uptake capacity, leaf/root C:N)


---

## 📁 Repository Structure

\`\`\`
├── data/                     # Input data and parameter files
├── src/                      # Core model implementation
│   ├── model.py              # Model equations and solver
│   └── optimization.py       # Optimality routine
├── figures/                  # Output figures for the manuscript
├── notebooks/                # Jupyter notebooks for analysis and plotting
│   ├── fig1_tradeoff.ipynb
│   ├── fig2_soil_response.ipynb
│   └── fig3_trait_influence.ipynb
├── requirements.txt          # Required Python packages
└── README.md                 # This file
\`\`\`

---


In our study, we investigated optimal control problems related to ligninolytic activity during plant litter decomposition. We utilized a MATLAB-based tool developed by Viktor Leek at the Division of Vehicular Systems, Linköping University. 
For detailed installation guidelines and examples, please visit [Yoptimization](https://www.yoptimization.com/). To ensure the reproducibility of our work, we have archived the specific Yoptimization version used in our repository. It's important to note that another necessary component for Yoptimization is CasADi; specifically, we utilized the [casadi-windows-matlabR2016a-v3.5.5 version](https://github.com/casadi/casadi/releases/download/3.5.5/casadi-windows-matlabR2016a-v3.5.5.zip).