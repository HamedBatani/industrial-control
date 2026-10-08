# Reproducibility and Archive Review

This review checked the supplied reports, scripts, model filenames, and directory contents. MATLAB was not run, so numerical correctness and full execution are not independently certified.

## Known limitations

1. **HW3 missing model:** the report's unmodeled-dynamics experiment refers to `ladrc_model_T2`; only `ladrc_model`, `ladrc_model_2nd`, and `ladrc_model_dt` were supplied. Reproducing that configuration requires recovering the additional model or explicitly rebuilding it. A saved figure alone does not resolve the dependency.
2. **Workspace setup:** `Q1_b_4.m` calls `load_system(mdl)` without first defining `mdl`. Set `mdl = 'ladrc_model_2nd'` when reproducing that exercise. Other scripts use `assignin` or model workspace parameters; inspect the corresponding model and script before running.
3. **Absolute paths:** several scripts write figures to the original author's Desktop archive or load `RefData.mat` through an absolute path. Update these paths to your checkout. The published copies preserve the submitted code, rather than silently claiming portability.
4. **App-based work:** `.sid`, `.sfit`, and saved `.mat` sessions may require compatible MATLAB/toolbox versions and interactive loading. Their reports provide context where no independent script exists.
5. **Variants and duplicates:** alternate script and figure names are preserved. They should not be interpreted as additional independent results. Nested figure directories reflect the original export locations.
6. **Assignment-to-file mapping:** some questions are represented in reports rather than separate source files; some script names do not match their assignment subpart. Consult the guides and report.
7. **Generated artifacts:** Simulink caches, `slprj`, autosaves, and generated build/report libraries are excluded. HW1's student code-generation inputs remain available; regenerate build output locally with the appropriate Coder toolbox.

## Suggested workflow

Read the relevant report, open the corresponding source directory in MATLAB, add it to the MATLAB path if needed, adjust input/output paths, and inspect model variables before running one exercise at a time. For HW3 reference differentiation, use `homework/hw-03/assignment-data/RefData.mat`. Treat MATLAB app sessions and original plots as archival evidence until reproduced.

Course grade: **19.3/20**, reported by Hamed Batani. This is the final course grade, not a per-assignment grade or numerical verification score.
