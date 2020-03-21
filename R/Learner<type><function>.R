#' @title <CLassification/Regression> <Learner Name> Learner
#'
#' @name mlr_learners_<type>.<algorithm>
#'
#' @description
#' A [mlr3::Learner<type>] implementing <algorithm> from package
#'   \CRANpkg{<package>}.
#' Calls [<package>::<algorithm>()].
#'
#' @templateVar id <learner id>
#' @template section_dictionary_learner
#'
#' @references
#' <optional>
#'
#' @template seealso_learner
#' @template example
#' @export
# <Adapt the name to your learner. For regression learners inherit = LearnerRegr>
Learner<type><algorithm> = R6Class("Learner<type><algorithm>",
  inherit = Learner<type>,

  public = list(
    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ParamSet$new(
        params = list(
          <params: See other mlr3learner packages or mlr3book>
        )
      )

      # If you change any defaults for mlr3 compared to the underlying learner,
      # specify them here
      ps$values = list(<param> = <value>)

      super$initialize(
        # see the mlr3book for a description: https://mlr3book.mlr-org.com/extending-mlr3.html
        id = "<type>.<algorithm>",
        packages = "<package>",
        feature_types = "<feature types>"
        predict_types = "<predict types>"
        param_set = ps,
        properties = "<properties>",
        # the help file name is the one used as @name in the roxygen2 block
        man = "<pkgname>::<help file name>"
      )
    },


    # <Add method for importance, if learner supports that>
    # <See mlr3learners.randomForest for an example>

    # <Add method for oob_error, if learner supports that.>

  ),

  private = list(

    .train = function(task) {
      pars = self$param_set$get_values(tags = "train")

      # <Create objects for the train call
      # <At least "data" and "formula" are required>
      formula = task$formula()
      data = task$data()

      # <here is space for some custom adjustments before proceeding to the
      # train call. Check other learners for what can be done here>

      # use the mlr3misc::invoke function (it's similar to do.call())
      mlr3misc::invoke(<package>::<algorithm>, formula = formula, data = data,
       .args = pars)
    },

    .predict = function(task) {
      # get parameters with tag "predict"
      pars = self$param_set$get_values(tags = "predict")
      # get newdata
      newdata = task$data(cols = task$feature_names)
      # <optional: account for different predict types>
      type = ifelse(self$predict_type == "response", "response", "prob")

      pred = mlr3misc::invoke(predict, self$model, newdata = newdata,
        type = type, .args = pars)

      # <Return a prediction object with PredictionClassif$new() or
      # PredictionRegr$new()>
      if (self$predict_type == "response") {
        PredictionClassif$new(task = task, response = pred)
      } else {
        PredictionClassif$new(task = task, prob = pred)
      }
    }
  )
)
