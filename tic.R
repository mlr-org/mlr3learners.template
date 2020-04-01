# R CMD check
if (!ci_has_env("PARAMTEST")) {
  do_package_checks()

  do_drat("mlr3learners/mlr3learners.drat")
} else {
  # PARAMTEST
  get_stage("install") %>%
    add_step(step_install_deps())
}
