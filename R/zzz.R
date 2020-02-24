#' @import data.table
#' @import paradox
#' @import mlr3misc
#' @importFrom R6 R6Class
#' @importFrom mlr3 mlr_learners LearnerClassif LearnerRegr
"_PACKAGE"

dummy_import = function() {
  # R CMD check does not detect the usage of randomForest in R6 classes
  # This function is a workaround to suppress check notes about
  # "All declared imports should be used"
  randomForest::randomForest()
}

.onLoad = function(libname, pkgname) {
  # nocov start
  # get mlr_learners dictionary from the mlr3 namespace
  x = utils::getFromNamespace("mlr_learners", ns = "mlr3")

  # add the learner to the dictionary
  x$add("classif.randomForest", LearnerClassifRandomForest)
} # nocov end
