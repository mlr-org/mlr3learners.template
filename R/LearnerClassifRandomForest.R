#' @title Classification Random Forest Learner
#'
#' @name mlr_learners_classif.randomForest
#'
#' @description
#' A [mlr3::LearnerClassif] for a classification random from package \CRANpkg{randomForest}.
#' Calls [randomForest::randomForest()].
#'
#' @references
#' Breiman, L. (2001).
#' Random Forests
#' Machine Learning
#' \url{https://doi.org/10.1023/A:1010933404324}
#'
#' @export
LearnerClassifRandomForest = R6Class("LearnerClassifRandomForest", # Adapt the name to your learner. For regression learners inherit = LearnerRegr.
  inherit = LearnerClassif,
  public = list(
    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ParamSet$new( # parameter set using the paradox package
        params = list(
          ParamInt$new(id = "ntree", default = 500L, lower = 1L, tags = c("train", "predict")),
          ParamInt$new(id = "mtry", lower = 1L, tags = "train"),
          ParamLgl$new(id = "replace", default = TRUE, tags = "train"),
          ParamUty$new(id = "classwt", default = NULL, tags = "train"), #lower = 0
          ParamUty$new(id = "cutoff", tags = "train"),
          ParamUty$new(id = "strata", tags = "train"),
          ParamUty$new(id = "sampsize", tags = "train"),
          ParamInt$new(id = "nodesize", default = 1L, lower = 1L, tags = "train"),
          ParamInt$new(id = "maxnodes", lower = 1L, tags = "train"),
          ParamFct$new(id = "importance", default = "none", levels = c("accuracy", "gini", "none"), tag = "train"), #importance is a logical value in the randomForest package.
          ParamLgl$new(id = "localImp", default = FALSE, tags = "train"),
          ParamLgl$new(id = "proximity", default = FALSE, tags = "train"),
          ParamLgl$new(id = "oob.prox", tags = "train"),
          ParamLgl$new(id = "norm.votes", default = TRUE, tags = "train"),
          ParamLgl$new(id = "do.trace", default = FALSE, tags = "train"),
          ParamLgl$new(id = "keep.forest", default = TRUE, tags = "train"),
          ParamLgl$new(id = "keep.inbag", default = FALSE, tags = "train")
        )
      )

      ps$values = list(importance = "none") # Change the defaults. We set this here, because the default is FALSE in the randomForest package.

      super$initialize(
        # see the mlr3book for a description: https://mlr3book.mlr-org.com/extending-mlr3.html
        id = "classif.randomForest",
        packages = "randomForest",
        feature_types = c("numeric", "factor", "ordered"),
        predict_types = c("response", "prob"),
        param_set = ps,
        properties = c("weights", "twoclass", "multiclass", "importance", "oob_error")
      )
    },


    # Add method for importance, if learner supports that.
    # It must return a sorted (decreasing) numerical, named vector.

    #' @description
    #' The importance scores are extracted from the slot `importance`.
    #' Parameter 'importance' must be set to either `"accuracy"` or `"gini"`.
    #' @return Named `numeric()`.
    importance = function() {
      if (is.null(self$model)) {
        stopf("No model stored")
      }
      imp = data.frame(self$model$importance)
      pars = self$param_set$get_values()

      scores = switch(pars[["importance"]],
        "accuracy" = imp[["MeanDecreaseAccuracy"]],
        "gini"     = imp[["MeanDecreaseGini"]],
        stop("No importance available. Try setting 'importance' to 'accuracy' or 'gini'")
      )

      sort(setNames(scores, rownames(imp)), decreasing = TRUE)
    },

    #
    # Add method for oob_error, if learner supports that.

    #' @description
    #' OOB errors are extracted from the model slot `err.rate`.
    #' @return `numeric(1)`.
    oob_error = function() {
      mean(self$model$err.rate[, 1])
    }
  ),

  private = list(

    .train = function(task) {
      pars = self$param_set$get_values(tags = "train")

      # Setting the importance value to logical
      pars[["importance"]] = (pars[["importance"]] != "none")

      # Get formula, data, classwt, cutoff for the randomForest
      f = task$formula() #the formula is available in the task
      data = task$data() #the data is avail
      levs = levels(data[[task$target_names]])
      n = length(levs)

      if (!"cutoff" %in% names(pars))
        cutoff = rep(1 / n, n)
      if ("classwt" %in% names(pars)) {
        classwt = pars[["classwt"]]
        if (is.numeric(classwt) && length(classwt) == n && is.null(names(classwt)))
          names(classwt) = levs
      } else {
        classwt = NULL
      }
      if (is.numeric(cutoff) && length(cutoff) == n && is.null(names(cutoff)))
        names(cutoff) = levs
      invoke(randomForest::randomForest, formula = f, data = data, classwt = classwt, cutoff = cutoff, .args = pars) # use the mlr3misc::invoke function (it's similar to do.call())
    },

    .predict = function(task) {
      pars = self$param_set$get_values(tags = "predict") # get parameters with tag "predict"
      newdata = task$data(cols = task$feature_names) # get newdata
      type = ifelse(self$predict_type == "response", "response", "prob") # this is for the randomForest package

      p = invoke(predict, self$model, newdata = newdata,
        type = type, .args = pars)

      # Return a prediction object with PredictionClassif$new() or PredictionRegr$new()
      if (self$predict_type == "response") {
        PredictionClassif$new(task = task, response = p)
      } else {
        PredictionClassif$new(task = task, prob = p)
      }
    }
  )
)
