

library(targets)

targets::tar_make()

targets::tar_visnetwork()
targets::tar_visnetwork(label = "time")
targets::tar_visnetwork(label = "branches")
targets::tar_visnetwork(label = c("time", "branches"))

targets::tar_read(name = "get_data")
targets::tar_read(name = "data.fix_issues")


