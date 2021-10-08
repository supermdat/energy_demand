library(targets)
library(tarchetypes)
# This is an example _targets.R file. Every
# {targets} pipeline needs one.
# Use tar_script() to create _targets.R and tar_edit()
# to open it again for editing.
# Then, run tar_make() to run the pipeline
# and tar_read(summary) to view the results.


# Define custom functions and other global objects.
# This is where you write source(\"R/functions.R\")
# if you keep your functions in external scripts.
base::source(paste0(here::here(), "/Src/Functions/function01_get_data.R"))
base::source(paste0(here::here(), "/Src/Functions/function02_data_fix_issues.R"))


# Set target-specific options such as packages.
targets::tar_option_set(packages = c("tidyverse",
                                     "jsonlite",
                                     "lubridate",
                                     "timetk"
                                     )
                        )

# End this file with a list of target objects.
list(
  targets::tar_target(
    name = get_data,
    command = f.get_data()
  ),
  targets::tar_target(
    name = data.fix_issues,
    command = f.data_fix_issues(data = get_data$data.raw)
  )
)
