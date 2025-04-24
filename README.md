# Optimality-Based Plant C-N Allocation Model

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10481394.svg)](https://doi.org/10.5281/zenodo.10481394) Change this badge
[![Bluesky](https://img.shields.io/badge/Bluesky-0285FF?style=for-the-badge&logo=Bluesky&logoColor=white&label=Follow%20@ArjunChakrawal)](https://t.co/qixbogmjmO)

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
```sh
└── root_opt/
    └── figs/ # Output directory for figures
        ├── Figure2.png
        ├── Figure3.png
        ├── Figure4.png
        └── Figure5.png
    ├── .gitattributes 
    ├── df_soilCN_inorgN_leafCN.mat 
    ├── df_soilCN_inorgN_Vmax_IN_to_root.mat 
    ├── df_soilCN_inorgN_Vmax_SOM.mat 
    ├── Figure2.m 
    ├── Figure_3_soilCN_soil_N.m 
    ├── Figure_4_soil_plant.m 
    ├── Figure_5_soil_plant.m     
    ├── LICENSE 
    ├── out.txt 
    ├── params_base_condition.m
    ├── plotting.m 
    ├── README.md 
    └── solve_ocp.m
```
---

## 🧪 Requirements
- MATLAB 2022
- [Yoptimization](https://www.yoptimization.com/)
- [casadi-windows-matlabR2016a-v3.5.5 version](https://github.com/casadi/casadi/releases/download/3.5.5/casadi-windows-matlabR2016a-v3.5.5.zip)

For detailed installation guidelines and examples, please visit [Yoptimization](https://www.yoptimization.com/). To ensure the reproducibility of our work, we have archived the specific Yoptimization version used in our repository. It's important to note that another necessary component for Yoptimization is CasADi; specifically, we utilized the [casadi-windows-matlabR2016a-v3.5.5 version](https://github.com/casadi/casadi/releases/download/3.5.5/casadi-windows-matlabR2016a-v3.5.5.zip).

---

## 📄 License

This code is shared under the [MIT License](LICENSE). For academic or commercial use, please cite the corresponding paper.

---
## ✏️ Citation

```bibtex
@article{YourLastName2025,
  title = {Modelling the acclimative value of root growth and exudation to low soil nitrogen},
  author = {YourLastName, FirstName and Others},
  journal = {Journal Name},
  year = {2025},
  doi = {DOI}
}
```