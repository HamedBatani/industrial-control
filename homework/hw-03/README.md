# HW3 — Active Disturbance Rejection Control

I investigated linear ADRC through mathematical analysis and MATLAB/Simulink experiments. I reproduced specified examples from Gernot Herbst's ADRC study and explored variations in plant parameters, disturbance rejection, observer tuning, saturation, delay, and unmodeled dynamics.

## 1. LADRC performance and robustness

I studied first- and second-order plants and discrete implementations. The submitted report explains the extended state observer, the control law, and their implementation using MATLAB Function blocks and sampled feedback.

| Exercise | Investigation | Main scripts |
|---|---|---|
| 1.a.1–2 | First-order plant parameter changes and response comparisons | `source/Q1_a_1.m`, `Q1_a_2.m` |
| 1.a.3 | Actuator saturation | `source/Q1_a_3.m` |
| 1.a.4 | Delay and observer-pole variations | `source/Q1_a_4.m` |
| 1.a.5 | Unmodeled higher-order dynamics | `source/Q1_a_5.m` (additional model referenced in report is absent) |
| 1.a.6 | Robustness parameter sweeps | `source/Q1_a_6.m` |
| 1.a.7 | Disturbance rejection and comparison with PI | `source/Q1_a_7.m` |
| 1.b.1–4 | Second-order dynamics, parameter sensitivity, robustness, and comparison with PI/PID | `source/Q1_b_1.m`–`Q1_b_4.m` |
| 1.c.1–2 | Discrete first-order LADRC and observer tuning | `source/Q1_c_1.m`, `Q1_c_2.m` |

The three supplied models are `ladrc_model.slx`, `ladrc_model_2nd.slx`, and `ladrc_model_dt.slx`. See the reproducibility notes for workspace initialization and missing-model limitations.

## 2. Stability analysis

I compared analytical stability conditions with simulated responses and eigenvalue-based stable regions in controller/observer parameter space. I considered unstable plants and the effect of using a lower-order controller for a higher-order plant. The report contains the derivations and interpretation; scripts include `Q2_a.m`, `Q2_b.m`, `Q2_b2.m`, `Q2_bbb.m`, and `Q2_e.m`. Original filenames do not always match the assignment subpart letters, so the report should guide interpretation.

## 3. Noisy reference differentiation and tracking

I compared backward-Euler differentiation with filtering, linear tracking differentiation, and nonlinear tracking differentiators using supplied reference data. I then explored their use in DC-motor LADRC tracking with step/sinusoidal references, noise, and setpoint weighting. See `source/Q3_a.m`, `source/Q3_b.m`, and `assignment-data/RefData.mat`.

## Evidence and attribution

- [90-page report](reports/IC_HW3_402101339.pdf): derivations, implementation explanation, and 51 numbered figures.
- [Assignment sheet](assignment-data/Assignment%203%20%286%29.pdf): instructor-provided instructions.
- [Source](source) and [saved figures](figures): student work, including alternate scripts and figure variants.
- Reference: Gernot Herbst, *A Simulative Study on Active Disturbance Rejection Control (ADRC) as a Control Tool for Practitioners*. Reproduced examples are coursework based on this publication; they are not claimed as original research findings.

`source/Q1.m` concerns correlated-noise generation rather than the ADRC question sequence. It was present in the supplied HW3 folder and is retained as an auxiliary file, not presented as ADRC evidence.
