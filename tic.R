# R CMD check
if (!ci_has_env("PARAMTEST")) {
  do_package_checks()

  # comment this line in once the learner has been approved
  # this deploys to mlr3learners.drat
  # do_drat("mlr3learners/mlr3learners.drat")
} else {
  # PARAMTEST
  get_stage("install") %>%
    add_step(step_install_deps())

  get_stage("script") %>%
    add_code_step(remotes::install_dev('mlr3')) %>%
    add_code_step(testthat::test_dir(system.file("paramtest", package = "<package>"),
      stop_on_failure = TRUE))
}
