# mlr3learners.template

This packages provides a template for adding new learners for [mlr3](https://mlr3.mlr-org.com).

Creating new learners is covered in detail in section ["Adding new learners"](https://mlr3book.mlr-org.com/extending-learners.html) in the mlr3book.
This package serves as a starting point for learners to share with others.

## Instructions

This repository is a template repository to create a learner that aligns with existing mlr3 learners.
Perform the following tasks to create your learner:

1. Replace all instances of
   1. `<package>` with the name of the underlying package.
   1. `<type>` with the learner type, e.g. `Classif` or `Regr`.
   1. `<algorithm>` with the name of the algorithm, e.g `randomForest`.
1. Rename files following the same scheme as in 1).
1. Check if the learner supports feature importance internally.
   If yes, add a `importance()` method in the respective learner class.
1. Check if the learner supports out-of-bag error estimation internally.
   If yes, add a `oob_error()` method in the respective learner class.
1. Add yourself as the maintainer in `DESCRIPTION`.
1. Set up Continuous Integration (CI).
   The GitHub Actions YAML files live in `.github/workflows`.
   1. Replace `<package>` in l.13 of `tic.R` with the name of the package.
   1. Update the "Paramtest" files in `inst/paramtest/` to ensure no parameter was forgotten in the learner.
      Make sure that the CI test passes for "Param Check".
   1. Update the badge in `README.md` with the package name.
1. Run `devtools::document(roclets = c('rd', 'collate', 'namespace'))` to create the NAMESPACE and man/ files.
1. Leave the files in `man-roxygen` as they are - they will just work.
1. Run `usethis::use_tidy_description()` to format `DESCRIPTION`.
1. Test your learner locally by running `devtools::test()`
1. Check your package by running `rcmdcheck::rcmdcheck()`
1. Check if your learner complies with the [mlr style guide](https://github.com/mlr-org/mlr3/wiki/Style-Guide).
1. Ensure that the CI builds complete successfully (via the "Actions" menu in the repo).
1. Check on last small details like the name of the learner package and for possible leftovers of the placeholders used in the template.

Last but not least go through

 :point_right: [this checklist](https://github.com/mlr-org/mlr3learners.template/issues/5) :page_facing_up:

 to make sure your learner is ready for review.

After your learner is accepted, it can be added to [mlr3learners.drat](https://github.com/mlr3learners/mlr3learners.drat), making it installabe via the canonical `install.packages()` function without the need to live on CRAN.

**Resources for adding a new learner (summary)**

- [mlr3learners.template](https://github.com/mlr-org/mlr3learners.template)
- [mlr3book section "Adding new learners" including FAQ](https://mlr3book.mlr-org.com/extending-learners.html)
- [Checklist prior to requesting a review](https://github.com/mlr-org/mlr3learners.template/issues/5)

**!Important!**: Delete all instructions up to this point and just leave the part below.

# mlr3learners.\<package\>

<!-- badges: start -->

[![R CMD Check via {tic}](https://github.com/mlr3learners/mlr3learners.<package>/workflows/R%20CMD%20Check%20via%20{tic}/badge.svg?branch=master)](https://github.com/mlr3learners/mlr3learners.<package>/actions)
[![Parameter Check](https://github.com/mlr3learners/mlr3learners.<package>/workflows/Parameter%20Check/badge.svg?branch=master)](https://github.com/mlr3learners/mlr3learners.<package>/actions)
[![codecov](https://codecov.io/gh/mlr3learners/mlr3learners.<package>/branch/master/graph/badge.svg)](https://codecov.io/gh/mlr3learners/mlr3learners.<package>)
[![StackOverflow](https://img.shields.io/badge/stackoverflow-mlr3-orange.svg)](https://stackoverflow.com/questions/tagged/mlr3)

<!-- badges: end -->

Adds `<algorithm1>` and `<algorithm2>` from the {<package>} package to {mlr3}.

Install the latest release of the package via

```r
install.packages("mlr3learners.<package>")
```

by following the instructions in the [mlr3learners.drat README](https://github.com/mlr3learners/mlr3learners.drat).

Alternatively, you can install the latest version of {mlr3learners.<package>} from Github with:

```r
remotes::install_github("mlr3learners/mlr3learners.<package>")
```
