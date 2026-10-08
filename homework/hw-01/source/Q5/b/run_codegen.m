% run_codegen.m
cfg = coder.config('lib');
cfg.GenCodeOnly = true; % skip compiling, just generate c code
codegen -config cfg my_system -args {0}
