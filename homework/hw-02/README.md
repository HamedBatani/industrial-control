# HW2 — PID Design, Identification, and Optimization

I compared several routes to controller design, from response-based tuning to model-based synthesis and numerical optimization. I also studied actuator saturation and anti-windup, connecting controller design to implementation constraints.

## Question guide

| Question | Method or experiment | Files / evidence |
|---|---|---|
| 1 | Chien–Hrones–Reswick (CHR) tuning and response comparisons | `source/Q1.m`, alternate `source/Q_1.m`, report |
| 2 | Response approximation and residence-time analysis | `source/Q2.m` |
| 3 | Method-of-moments identification using simulated input/output | `source/Q3.m` |
| 4 | Reaction-curve and ultimate-gain tuning methods | `source/Q4.m` |
| 5 | PID synthesis by transfer-function matching | Report derivations |
| 6 | Setpoint tracking and pole-placement designs | `source/Q6/Q6_f.m`–`Q6_i.m`, figures and report |
| 7 | Windup and anti-windup behavior | `source/Q7.m`, `source/Q7_d.slx`, figures |
| 8 | System Identification Toolbox | `source/Q8.sid`, supplied `assignment-data/Ident.mat`, report |
| 9 | Model order reduction | `source/ModelReducerSession.mat`, report |
| 10 | Curve fitting | `source/Q10.sfit`, supplied `assignment-data/GrowthData*.csv`, report |
| 11 | Controller optimization with a separate objective function and robustness experiment | `source/Q11/objectiveFunction.m`, `test.m`, `Q11_i.m` |
| 12 | Derivative-on-output and setpoint-weighting study | Report |

## Contents and interpretation

The [80-page solution report](reports/HW2_402101339_Batani.pdf) contains derivations, simulation results, and discussion. [Assignment data](assignment-data) includes the instructor's question sheet and supplied identification/growth data. [Source](source) includes scripts, Simulink models, and saved app sessions; [figures](figures) preserves the exported plots.

Some exercises were performed interactively in MATLAB apps. A saved session or report is evidence of that work, but is not equivalent to a standalone automated script. Alternate versions are retained under their original filenames; they are not represented as independent experiments.
