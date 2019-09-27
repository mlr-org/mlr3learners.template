#' @title Classification Random Forest Learner
#'
#' @aliases mlr_learners_classif.randomForest
#' @format [R6::R6Class] inheriting from [LearnerClassif].
#'
#' @description
#' A [LearnerClassif] for a classification random forest implemented in randomForest::randomForest()] in package \CRANpkg{randomForest}.
#'
#' @references
#' Breiman, L. (2001).
#' Random Forests
#' Machine Learning
#' \url{https://doi.org/10.1023/A:1010933404324}
#'
#' @export
LearnerClassifRandomForest = R6Class("LearnerClassifRandomForest", inherit = LearnerClassif, # Adapt the name to your learner. For regression learners inherit = LearnerRegr.
  public = list(
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

    train_internal = function(task) {
      pars = self$param_set$get_values(tags = "train")

      # Setting the importance value to logical
      if (pars[["importance"]] != "none") {
        pars[["importance"]] = TRUE
      } else {
        pars[["importance"]] = FALSE
      }

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

    predict_internal = function(task) {
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
    },

    # Add method for importance, if learner supports that. 
    # It must return a sorted (decreasing) numerical, named vector.
    importance = function() {
      if (is.null(self$model)) {
        stopf("No model stored")
      }
      imp = data.frame(self$model$importance)
      pars = self$param_set$get_values()
      if (pars[["importance"]] == "accuracy") {
        x = setNames(imp[["MeanDecreaseAccuracy"]], rownames(imp))
        return(sort(x, decreasing = TRUE))
      }
      if (pars[["importance"]] == "gini") {
        x = setNames(imp[["MeanDecreaseGini"]], rownames(imp))
        return(sort(x, decreasing = TRUE))
      }
      if (pars[["importance"]] == "none") return(message("importance was set to 'none'. No importance available."))
    },

    # Add method for oob_error, if learner supports that.
    oob_error = function() {
      mean(self$model$err.rate[, 1])
    }
  )
)
