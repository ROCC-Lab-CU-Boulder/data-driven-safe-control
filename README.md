# Data-Driven Safety Filters

*MATLAB/Simulink code for data-driven LQR design, equilibrium-informed modeling, and safety filtering on a Quanser Rotary Flexible Joint Module*

## Overview

This repository accompanies the manuscript:

> Yi-Chun Liao, Valentina Breschi, and Marco M. Nicotra, *Experimental Demonstration and Benchmarking of Data-Driven Safety Filters*.

The benchmark studies data-driven control and safety filtering for an unknown linear system using experiments on the **Quanser Rotary Flexible Joint Module**. The benchmark uses the known equilibrium-subspace information, represented by the matrices `Gx` and `Gu`, to reduce steady-state mismatch and improve the construction of safety filters.

The package includes examples of:
- Classic indirect data-driven LQR based on least-squares system identification
- Equilibrium-informed indirect data-driven LQR
- Direct data-driven LQR using cross-covariance data
- Command Governor (CG) safety filtering
- Control Barrier Function (CBF) safety filtering

## Repository layout

```text
DDD-safe-functions/                     Shared MATLAB functions and solvers

Unconstrained/
├── Direct_covariance/                  Cross-covariance direct DD-LQR
├── Indirect_classic/                   Classic indirect identification + LQR
└── Indirect_equilibrium/               Equilibrium-informed identification + LQR

Constrained/
├── CBF_indirect_classic/               CBF with the classic indirect method
├── CBF_indirect_equilibrium/           CBF with equilibrium-informed identification
├── CG_direct_covariance/               CG with the cross-covariance direct method
├── CG_indirect_classic/                CG with the classic indirect method
└── CG_indirect_equilibrium/            CG with equilibrium-informed identification
```

## Experiment-folder convention

A typical experiment folder contains the following files.

| File | Role |
| --- | --- |
| `datagen.slx` | Runs the Quanser data-collection experiment and records the state/input dataset required by the selected method. |
| `datagen_a.slx`, `datagen_b.slx` | Collect two compatible datasets for a cross-covariance workflow. Use the same reference and compatible experiment conditions for both runs. |
| `initialize.mlx` or `initialize.m` | Loads data, defines parameters, performs offline calculations, and prepares the variables required by the Simulink experiment. |
| `experiment.slx` | Runs the Simulink real-time hardware experiment. |
| `simulation.mlx` | Runs the simulation experiment. |
| `postprocessing.m` or `postprocessing.mlx` | Generates figures and compares references, states, inputs, simulations, measurements, and constraint boundaries. |
## Methods represented in the benchmark

### Unconstrained control
- **Classic indirect method:** estimates the open-loop matrices from data and then designs an LQR controller.
- **Equilibrium-informed indirect method:** constrains the identified model to satisfy the known equilibrium subspace defined by `Gx` and `Gu`.
- **Cross-covariance direct method:** designs the controller from cross-covariance data without first identifying a separate open-loop model.

### Constrained control
The constrained examples use closed/open-loop dynamics and state/input constraints to construct a MOAS and apply one of two safety filters:

- **Command Governor:** modifies the requested reference before it is passed to the nominal controller.
- **Control Barrier Function:** modifies the nominal control input through an online optimization problem.
## Software requirements

### Required MathWorks products

- MATLAB
- Simulink


Depending on the selected experiment, the following toolboxes may also be required:

- Control System Toolbox
- Optimization Toolbox
- Signal Processing Toolbox
- Symbolic Math Toolbox

Not every experiment requires every toolbox.
### Third-party software

Some workflows also require:
- **YALMIP**
- **MPT3**
- **MOSEK or another compatible solver**
- **Quanser QUARC** — required only for real-time hardware experiments

Install each package according to its official instructions and add your own installation locations to the MATLAB path.
## Installation and path setup
### 1. Open the repository in MATLAB
Set MATLAB's current folder to the repository root, then add the repository folders to the path:
```matlab
addpath(genpath(pwd));
```

### 2. Add third-party packages
Add your local YALMIP, MPT3, and solver installations according to their own installation instructions. For hardware experiments, install Quanser QUARC and confirm that its Simulink blocks are available.
### 3. Verify the MATLAB path
The following checks provide a quick indication that the main dependencies are visible:

```matlab
checks = {
    'dlqr',       'Control System Toolbox';
    'linprog',    'Optimization Toolbox';
    'xcorr',      'Signal Processing Toolbox';
    'sym',        'Symbolic Math Toolbox';
    'sdpvar',     'YALMIP';
    'Polyhedron', 'MPT3';
    'mosekopt',   'MOSEK (or another compatible solver)'
};

for i = 1:size(checks, 1)
    location = which(checks{i, 1});
    if isempty(location)
        fprintf('[missing] %s: %s\n', checks{i, 2}, checks{i, 1});
    else
        fprintf('[found]   %s: %s\n', checks{i, 2}, location);
    end
end
```

For QUARC, open the Simulink Library Browser and verify that the Quanser/QUARC libraries and required hardware blocks are present.

## Running an experiment
### 1. Verify the MATLAB path
Set MATLAB's current folder to the repository root and add the repository folders to the path with:
```matlab
addpath(genpath(pwd));
```

### 2. Select a workflow
Choose an experiment under `Unconstrained/` or `Constrained/`. Run the workflow from that experiment folder unless its initialization file states otherwise.

### 3. Prepare the dataset
Use the path supported by the selected example:

- Run `datagen.slx` for a standard hardware dataset.
- Run both `datagen_a.slx` and `datagen_b.slx` for a cross-covariance dataset.
- Or load an existing dataset, example_data.mat, to skip the data-generation process.

Before running a hardware model, verify the sample time, initial condition, units, reference, state and input limits, sensor calibration, and emergency-stop procedure. 
**Recommendation:** The data-generation procedure is the same across workflows. Saving the collected dataset is recommended for different methods.

### 4. Run the initialization file
Run `initialize.mlx`. Depending on the example, this stage may:

- Load and format the dataset.
- Initialize setting variables.
- Construct the data matrices used by the selected method.
- Incorporate the equilibrium prior `Gx` and `Gu`.
- Identify an open-loop or closed-loop model.
- Compute an indirect or direct data-driven LQR controller.
- Reconstruct closed-loop dynamics.
- Compute a MOAS and remove redundant inequalities.
- Initialize the online CG or CBF optimization problem.

**Reminder:** The LMI problem may occasionally be infeasible or numerically difficult for a particular dataset. If this occurs, collect a new dataset and rerun the initialization.

### 5. Run the simulation model
This step is optional but **highly recommended** before running the real-time experiment.

Open and run `simulation.mlx` to verify the simulation results. Check the results are as expected and the **average solve time is approximately 2 ms**. A slightly higher solve time may still be acceptable for the real-time experiment. If the solve time is too high, reducing the `max_newton_iters` setting in `initialize.mlx` may help reduce the online computation time.

### 6. Run the experiment model
Open and run `experiment.slx` to collect the experimental dataset.

**Before starting the experiment, make sure the emergency power shutoff is accessible and ready to use in case the system behaves unexpectedly.**

### 7. Post-process the results
Run `postprocessing.mlx` to compare the experimental results with the simulation results. **The simulation results are required for the post-process scripts**

**Optional:** The `Extra_PostProcessing` folder contains additional plotting and analysis scripts.

## References

> Yi-Chun Liao, Valentina Breschi, and Marco M. Nicotra, *Experimental Demonstration and Benchmarking of Data-Driven Safety Filters*.