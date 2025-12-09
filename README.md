# Optimality-Based Plant C-N Allocation Model
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.971859751.svg)](https://doi.org/10.5281/zenodo.15367433)

This repository contains the codebase for simulating and visualizing plant responses to nitrogen (N) limitation via dynamic carbon (C) allocation strategies in plant–soil–microbe systems. The model supports the manuscript "Modelling belowground plant acclimation to low soil nitrogen – An eco-evolutionary approach" by Chakrawal et al., 2025.

## 🌱 Model Overview
Plants facing nitrogen limitation must dynamically allocate carbon between competing sinks—leaf growth, root growth, and root exudation—to maintain C:N homeostasis while maximizing fitness. Our model employs **optimal control theory** to determine time-dependent allocation strategies that maximize cumulative aboveground biomass over a growing season, subject to:

- **Stoichiometric constraints**: Michaelis-Menten N uptake kinetics and fixed tissue C:N ratios
- **Plant-soil-microbe coupling**: Exudation-driven priming of soil N mineralization
- **Nested control structure**: Exudation as a fraction of net root C assimilation (biologically coupled)

The optimal control framework provides a mechanistic, forward-looking alternative to fixed allocation rules, revealing emergent trade-offs between short-term substrate provision (exudation) and long-term capacity building (root growth) under N stress.

**Key Features:**
- **9-state dynamical system**: Tracks C and N pools in leaves, roots, exudates, soil organic matter, and microbes
- **2-control optimization**: Root C supply from leaves + exudation fraction (hierarchical structure)
- **Physiological realism**: Enforces minimum allocation constraints and tissue stoichiometry
- **Scenario analysis**: Tests responses to varying initial soil N, SOM C:N, and plant traits


---

## 📁 Repository Structure
```
root_opt/
├── figs/                                   # Output directory for generated figures
│   ├── Figure2_revised.png                # Main allocation dynamics figure
│   ├── Figure2_SI.png                     # Supplementary state variables
│   ├── Figure2_N_uptake_controls.png      # N uptake controls figure
│   ├── Figure3.png                        # Soil C:N and N availability effects
│   ├── Figure4.png                        # Soil-plant trait interactions
│   └── Figure5.png                        # Root N uptake capacity effects
│
├── tight_subplot/                         # Utility for subplot layout control
│   ├── license.txt
│   └── tight_subplot.m
│
├── Core Model Files
│   ├── solve_ocp_nested.m                # Main OCP solver (nested control structure)
│   ├── params_base_condition.m           # Default parameter set and initial conditions
│   └── plotting.m                        # Diagnostic plotting utility
│
├── Manuscript Figure Scripts
│   ├── Figure2.m                         # Fig 2: Allocation strategies across scenarios
│   ├── Figure_3_soilCN_soil_N.m         # Fig 3: Soil C:N × initial N matrix
│   ├── Figure_4_soil_plant.m            # Fig 4: Soil × plant trait interactions
│   └── Figure_5_soil_plant.m            # Fig 5: Root uptake capacity sensitivity
│
├── Pre-computed Results (for reproducibility)
│   ├── df_soilCN_inorgN_leafCN.mat      # Leaf C:N variation results
│   ├── df_soilCN_inorgN_Vmax_IN_to_root.mat  # Root uptake capacity results
│   └── df_soilCN_inorgN_Vmax_SOM.mat    # SOM decomposition rate results
│
├── Setup and Dependencies
│   ├── start_setup.m                     # Automated setup script (run first!)
│   ├── test_yop.m                        # Yoptimization installation test
│   ├── yop-master.zip                    # Archived Yoptimization package
│   └── casadi-windows-matlabR2016a-v3.5.5.zip  # CasADi dependency
│
├── .gitignore                            # Excludes temporary/development files
├── LICENSE                               # MIT License
└── README.md                             # This file
```

### Key Files Explained

- **`solve_ocp_nested.m`**: Core optimal control problem solver implementing the nested control structure (exudation as fraction of net root C)
- **`params_base_condition.m`**: Defines ~30 biological parameters (uptake rates, C:N ratios, turnover rates) and initial state conditions
- **`Figure*.m`**: Self-contained scripts that run OCP scenarios and generate publication figures
- **Pre-computed `.mat` files**: Store results from computationally intensive parameter sweeps (optional for quick figure regeneration)
---
##  Getting Started

### 🧪 Requirements

Before getting started with root_opt, ensure your runtime environment meets the following requirements:
- **Programming Language:** MATLAB 2022
- [Yoptimization](https://www.yoptimization.com/)
- [casadi-windows-matlabR2016a-v3.5.5 version](https://github.com/casadi/casadi/releases/download/3.5.5/casadi-windows-matlabR2016a-v3.5.5.zip)

For detailed installation guidelines and examples, please visit [Yoptimization](https://www.yoptimization.com/). To ensure the reproducibility of our work, we have archived the specific Yoptimization version used in our repository. It's important to note that another necessary component for Yoptimization is CasADi; specifically, we utilized the [casadi-windows-matlabR2016a-v3.5.5 version](https://github.com/casadi/casadi/releases/download/3.5.5/casadi-windows-matlabR2016a-v3.5.5.zip).



### Setup Instructions

Follow the steps below to set up the repository and generate the figures used in the manuscript:

### 1. Download the repository
Download the repository as a ZIP file.

### 2. Extract the ZIP file
Once downloaded, extract the ZIP file to a directory of your choice.

### 3. Open MATLAB and navigate to the project directory:
In MATLAB, change the current working directory to the extracted folder. You can do this by using the `cd` command in MATLAB:
```matlab
>> cd('path_to_extracted_folder');
```
### 4.  Run the start_setup.m script:
In the MATLAB command window, run the `start_setup.m` script by typing:
```matlab
>> start_setup
```

---

## 📄 License

This code is shared under the [MIT License](LICENSE). For academic or commercial use, please cite the corresponding paper.

---
## ✏️ Citation

```bibtex
@article{YourLastName2025,
  title = {Modelling belowground plant acclimation to low soil nitrogen – An eco-evolutionary approach},
  author = {Arjun Chakrawal, Sacha J. Mooney, and Tino Colombi},
  journal = {Journal Name},
  year = {2025},
  doi = {DOI}
}
```
---
## 📫 Contact

**Arjun Chakrawal** arjun.chakrawal@pnnl.gov

[![Bluesky](https://img.shields.io/badge/Bluesky-0285FF?style=for-the-badge&logo=Bluesky&logoColor=white&label=%20@ArjunChakrawal)](https://t.co/qixbogmjmO)  
