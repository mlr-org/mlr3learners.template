# mlr3learners.template

This packages provides a template for adding new learners for [mlr3](https://mlr3.mlr-org.com).

Creating new learners is covered in section ["Adding new learners"](https://mlr3book.mlr-org.com/extending-learners.html) in the mlr3book.
This package serves as a starting point for learners to share with others.

## Instructions

This repository is a template repository to create a learner that aligns with existing mlr3 learners.
Perform the following tasks to create your learner:

1. Replace all instances of
   1. `<package>` with the name of the underlying package.
   2. `<type>` with the learner type, e.g. `Classif` or `Regr`.
   3. `<algorithm>` with the name of the algorithm, e.g `randomForest`.
1. Rename files following the same scheme as in 1).
2. Check if the learner supports feature importance internally.
   If yes, add a `importance()` method in the respective learner class.
3. Check if the learner supports out-of-bag error estimation internally.
   If yes, add a `oob_error()` method in the respective learner class.
4. Add yourself as the maintainer in `DESCRIPTION`.
5. Set up Continuous Integration (CI).
   To do so, you need admin permission for the repository.
   1. Run `tic::use_ghactions_deploy()`
   2. Run `tic::use_ghactions_yml()`
   3. Fix the badge in `README.md` with the learner name.
6. Run `devtools::document(roclets = c('rd', 'collate', 'namespace'))` to create the NAMESPACE and man/ files.
7. Leave the files in `man-roxygen` as they are - they will just work.
8. Test your learner locally by running `devtools::test()`
9. Check your package by running `rcmdcheck::rcmdcheck()`
10. Check if your learner complies with the [mlr style guide](https://github.com/mlr-org/mlr3/wiki/Style-Guide).

After your learner is accepted, it can be added to [mlr3learners.drat](https://github.com/mlr3learners/mlr3learners.drat), making it installabe via the canonical `install.packages()` function without the need to live on CRAN.

**!Important!**: Delete all instructions up to this point and just leave the part below.

# mlr3learners.\<package\>

<!-- badges: start -->
[![R CMD Check via {tic}](https://img.shields.io/github/workflow/status/mlr3learners/mlr3learners.<package>/R%20CMD%20Check%20via%20%7Btic%7D?logo=github&label=R%20CMD%20Check%20via%20{tic}&style=flat-square)](https://github.com/mlr3learners/mlr3learners.<package>/actions)
[![codecov](https://codecov.io/gh/mlr3learners/mlr3learners.<package>/branch/master/graph/badge.svg)](https://codecov.io/gh/mlr3learners/mlr3learners.<package>)
[![StackOverflow](https://img.shields.io/badge/stackoverflow-mlr3-orange.svg)](https://stackoverflow.com/questions/tagged/mlr3)
<!-- badges: end -->

Adds `<algorithm1>` and `<algorithm2>`  from the {<package>} package to {mlr3}.

Install the latest release of the package via

```r
install.packages("mlr3learners.<package>")
```

by following the instructions in the [mlr3learners.drat README](https://github.com/mlr3learners/mlr3learners.drat).

Alternatively, you can install the latest version of {mlr3learners.<package>} from Github with:

```r
remotes::install_github("mlr3learners/mlr3learners.<package>")
```
