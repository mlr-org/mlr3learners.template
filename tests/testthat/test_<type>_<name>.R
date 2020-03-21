context("<type>.<algorithm>")

test_that("autotest", {
  learner = Learner<algorithm>$new()
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})
