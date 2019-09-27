# mlr3learnertemplate

[![Build Status](https://travis-ci.org/mlr-org/mlr3learnertemplate.svg?branch=master)](https://travis-ci.org/mlr-org/mlr3learnertemplate)

This packages provides a template for adding new learners for [mlr3](https://mlr3.mlr-org.com).

Creating the actual learners is covered in the [mlr3book](https://mlr3book.mlr-org.com/extending-mlr3.html).
This package serves as a starting point for learners to share with others.


# Instructions

This repository is a minimal working package with the randomForest learner.
Fork this repository and adapt the code to your learner.

## Rename Files
Rename the following files to suit your learner:

- `R/LearnerClassifRandomForest.R`
- `tests/testthat/test_classif_randomForest.R`

(For regression use the prefix "Regr" instead of "Classif". For example learners see https://github.com/mlr-org/mlr3learners)

## Edit `R/Learner[YourLearner].R`

- Adapt the documentation to suit your learner.
- Adapt names and the package, learner properties, etc.
  This is outlined in the [book](https://mlr3book.mlr-org.com/extending-mlr3.html)
- Adapt `R/zzz.R`. The code in the `.onLoad` function is executed on package load and adds the learner to the `mlr_learners` dictionary.

## Test Your Learner
If you run `devtools::load_all()` the function `run_autotest()` is available in your global environment.
The autotest query the learner for its properties to create a custom test suite of tasks for it.
Make sure that **at least** the following is executed in the unit test `tests/testthat/test_classif_your_learner.R` (adept names to your learner):

```r
learner = LearnerClassifRanger$new()
expect_learner(learner)
result = run_autotest(learner)
expect_true(result, info = result$error)
```

## Check your package
If this runs, your learner should be fine:
```r
devtools::check()
```
