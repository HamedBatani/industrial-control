# Industrial Control — Academic Coursework

**Hamed Batani · Electrical Engineering · Sharif University of Technology**  
**Instructor: Behzad Ahi · Course: Industrial Control (25791) · Final grade: 19.3/20**

I developed analytical solutions and MATLAB/Simulink experiments for this course, connecting digital implementation, system identification, PID design, and active disturbance rejection control (ADRC). This repository presents my selected coursework, with reports, source files, supplied problem data, and saved simulation figures.

My work progressed from discretization and numerical modeling to practical PID design and, finally, a detailed investigation of linear ADRC. I examined how controller and observer tuning, delay, saturation, model uncertainty, and noisy reference signals affect closed-loop behavior. The ADRC assignment is particularly relevant to my subsequent interest in disturbance estimation and model-assisted observers.

## Coursework

| Assignment | My work | Evidence |
|---|---|---|
| [HW1](homework/hw-01) | Discrete-time analysis, controller discretization, linearization, numerical integration, optimization, code-generation exercises, and empirical PID tuning | Written solutions, a simulation report, MATLAB scripts/live scripts, Simulink models, and figures |
| [HW2](homework/hw-02) | PID tuning and synthesis, identification from response data, pole-placement tracking, anti-windup, reduced-order modeling, curve fitting, and numerical controller optimization | An 80-page report, scripts/models, supplied data, MATLAB app sessions, and simulation figures |
| [HW3](homework/hw-03) | First- and second-order LADRC, continuous-plant/digital-controller simulations, robustness sweeps, stability regions, and reference differentiation | A 90-page report, MATLAB scripts, three Simulink models, reference data, and saved figures |

The linked assignment guides explain the question-to-file mapping, methods, and available evidence. Reports contain both derivations and experimental interpretation; figures provide supporting evidence rather than independent validation.

## Reading and running the work

Start with the report and README in each assignment folder. MATLAB and Simulink are required for the corresponding source files. Depending on the exercise, additional toolboxes include Control System, Symbolic Math, Optimization, Global Optimization, System Identification, Curve Fitting, and MATLAB/Simulink Coder. These are exercise-specific requirements, not a claim that every script needs every toolbox.

The source files preserve the submitted work and its original organization. Some scripts depend on workspace variables, saved app sessions, or local paths. See [REPRODUCIBILITY.md](REPRODUCIBILITY.md) before running them. No fresh MATLAB execution or full numerical validation is claimed by this repository review.

## Attribution

The solution reports and student simulation files document my coursework. Assignment sheets and supplied data originate from the course and are included as context, not claimed as my authorship. HW3 follows Gernot Herbst's *A Simulative Study on Active Disturbance Rejection Control (ADRC) as a Control Tool for Practitioners*; its figure numbers refer to that work. The third-party article itself is not redistributed here.

This is an academic portfolio, not an official course resource. No blanket license is asserted over instructor-provided or third-party material. [SOURCE_MANIFEST.json](SOURCE_MANIFEST.json) records the provenance and hashes of the included source files. Generated build/cache files are omitted.
