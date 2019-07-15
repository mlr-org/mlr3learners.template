context("classif.randomForest")

test_that("autotest", {
  learner = LearnerClassifRandomForest$new()
  learner$param_set$values = list(ntree = 30L, importance = "gini")
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})
