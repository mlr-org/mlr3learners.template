# mlr3learnertemplate

[![Build Status](https://travis-ci.org/mlr-org/mlr3learnertemplate.svg?branch=master)](https://travis-ci.org/mlr-org/mlr3learnertemplate)

This packages provides a template for adding new learners for [mlr3](https://mlr3.mlr-org.com).

Creating custom learners is covered in the [mlr3book](https://mlr3book.mlr-org.com).


# Instructions

This repository is a minimal working package with the randomForest learner.
Fork this repository and adapt the code to your learner.

## 1) Rename Files
Rename the following files to suit your learner:

- R/LearnerClassifRandomForest.R
- tests/testthat/test_classif_randomForest.R

(For regression use the prefix "Regr" instead of "Classif". For example learners see https://github.com/mlr-org/mlr3learners)

## 2) R/LearnerClassifRandomForest.R

- Adapt the documentation to suit your learner.
- Adapt names and the package, learner properties, etc.

### The Parameter Set

- For the parameter set see https://github.com/mlr-org/paradox for more information.
- For an existing mlr learner, you can follow these rules:
  
`makeIntegerLearnerParam()` &rarr; `ParamInt$new()`

`makeLogicalLearnerParam()` &rarr; `ParamLgl$new()`

`makeNumericVectorLearnerParam()` &rarr; `ParamUty$new()`

`makeIntegerVectorLearnerParam()` &rarr; `ParamUty$new()`

`makeUntypedLearnerParam()` &rarr; `ParamUty$new()`

`makeNumericLearnerParam()` &rarr; `ParamDbl$new()`

- delete the option `tunable`, as it is not needed anymore
- for dependencies, use the method $add_dep() (see https://github.com/mlr-org/paradox for more information)

### The Training Method
The `train_internal` method is a function which takes a task as input and returns the trained model from your learner.
It’s best to work with a test task, e.g.

task = mlr_tasks$get("iris")

You cannot copy paste the mlr source code and use it for the mlr3 learner.
Know your learner. You only have information of the task your defined learner in this method.

### The Prediction Method
Try to work with an example:

```
library(devtools)
load_all()
library(mlr3)
task = mlr_tasks$get("iris")
lrn = LearnerClassifRandomForest$new()
lrn$train(task = task)
```
Then you can write the prediction function and return a prediction object (`PredictionClassif$new()` or `PredictionRegr$new()`).

### Learner Specific Methods
The randomForest function supports `importance` and `oob_error`. You need to write methods for that as they will be tested.


## Test Your Function
If you run `devtools::load_all()` the function `run_autotest()` is available in your global environment.
Change the code in tests/testthat/test_classif_randomForest.R to fit your learner. Make sure that at least the following is tested:

```
learner = LearnerClassifRanger$new()
expect_learner(learner)
result = run_autotest(learner)
expect_true(result, info = result$error)
```

## Check your package
If this runs, your learner should be fine.
```
devtools::check()
```


