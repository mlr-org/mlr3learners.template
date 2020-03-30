library(mlr3learners.<package>)

test_that("<type>.<algorithm>", {
  learner = lrn("<type>.<algorithm>")
  fun = <package>::<algorithm> # replace!
  exclude = c(
    # Examples how to exclude certain parameters. Always comment why a parameter
    # was excluded!
    "formula", # handled via mlr3
    "data", # handled via mlr3
    "weights", # handled via mlr3
    "control", # handled to mboost::boost_control
    "..." # not used
  )

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0("\nMissing parameters:\n",
    paste0("- '", ParamTest$missing,"'", collapse = "\n")))
})

# example for checking a "control" function of a learner
test_that("<type>.<algorithm>_control", {
  learner = lrn("<type>.<algorithm>")
  fun = <package>::boost_control # replace!
  exclude = c(
    "center", # deprecated
  )

  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest, info = paste0("\nMissing parameters:\n",
    paste0("- '", ParamTest$missing,"'", collapse = "\n")))
})
