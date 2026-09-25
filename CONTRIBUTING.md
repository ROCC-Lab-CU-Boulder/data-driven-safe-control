# Contributing

This repository is an experimental benchmark for data-driven control and safety-filtering methods.

Contributions should be reproducible, self-contained, and consistent with the existing benchmark structure.

## Where to add a method

Place new methods under:

```text
Unconstrained/     Data-driven control without explicit safety constraints
Constrained/       Data-driven control with safety or constraint handling
```

Use a short descriptive folder name, for example:

```text
Constrained/CBF_new_method/
Constrained/CG_robust_direct/
Unconstrained/Indirect_new_method/
```

Add functions to `DDD-safe-functions/` only when they are reusable across multiple experiments. Keep method-specific functions inside the corresponding experiment folder.

## Recommended files

Include the files required by your method.

| File | Purpose |
| --- | --- |
| `README.md` | Describes the method, assumptions, dependencies, and workflow. |
| `datagen.slx` | Collects experimental data. |
| `datagen_a.slx`, `datagen_b.slx` | Collect two datasets when required. |
| `initialize.mlx` | Performs offline calculations and initializes the experiment. |
| `simulation.mlx` | Runs the simulation. |
| `experiment.slx` | Runs the real-time hardware experiment. |
| `postprocessing.mlx` | Generates figures and analyzes the results. |
| Example dataset | Allows the method to be tested without new hardware data collection. |

Not every method requires every file. Explain any different workflow in the local `README.md`.

## Document the method

Clearly describe:

- whether the method is direct or indirect.
- the required data matrices.
- the nominal controller.
- the safety filter, if applicable.
- the assumptions on data, rank, excitation, and noise.
- whether `Gx` and `Gu` are used.
- whether `(A,B)` or only closed-loop dynamics are required.
- the state and input constraints.
- the main theoretical or algorithmic reference.

Clearly distinguish theoretical guarantees from experimental observations.

## Preserve benchmark settings

Use the existing benchmark settings whenever possible, including:

- state ordering and units.
- sampling time.
- initial conditions.
- reference signals.
- state and input constraints.
- experiment duration.
- plotting conventions.

When comparing methods, use the same dataset and experiment settings whenever possible.

## Data and initialization
- Document how the dataset is generated and saved.
- The initialization file should perform all required offline calculations and prepare the variables needed by the simulation and experiment.
- A user should be able to run the workflow from a clean MATLAB session.
- Do not rely on variables left in the workspace from previous runs.
- Do not hard-code machine-specific paths.

## Dependencies
List all required software, including:

- MathWorks toolboxes.
- YALMIP.
- MPT3.
- the optimization solver.
- Quanser QUARC when hardware experiments are used.
- any other third-party packages.

Record the MATLAB and package versions used to produce the submitted results when possible.

## Hardware experiments

For hardware experiments, document:

- the hardware configuration.
- sampling time.
- sensor calibration.
- actuator limits.
- safe initial conditions.
- experiment stopping procedure.
- emergency-stop procedure.

Hardware experiments must require explicit user action before starting.

## Results

The post-processing script should reproduce the main figures and numerical results from saved data.

Clearly show relevant references, states, inputs, constraints, and units.

Report solver failures or infeasibility when they occur.

When comparing methods, use equivalent experimental conditions and clearly state the comparison metric.

## Checklist

Before submitting, confirm that:

- [ ] The method is placed in the correct folder.
- [ ] The method and assumptions are documented.
- [ ] Required data and dependencies are listed.
- [ ] The initialization runs from a clean MATLAB session.
- [ ] No machine-specific paths are included.
- [ ] Simulation and hardware workflows are clearly separated.
- [ ] Hardware limits and safety procedures are documented when applicable.
- [ ] Post-processing reproduces the main results.
- [ ] Solver failures are checked.
- [ ] Known limitations are documented.
- [ ] Existing benchmark cases still run after shared-function changes.
- [ ] The root `README.md` is updated when necessary.

## Pull request summary

Please include:

1. The purpose of the method.
2. The main reference.
3. The implementation folder.
4. Required dependencies.
5. Steps to reproduce the result.
6. Main differences from existing benchmark methods.
7. Known limitations.