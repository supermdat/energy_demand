
library(tidyverse)
library(targets)

targets::tar_make()

targets::tar_visnetwork()
targets::tar_visnetwork(label = "time")
targets::tar_visnetwork(label = "branches")
targets::tar_visnetwork(label = c("time", "branches"))

targets::tar_read(name = "get_data")
targets::tar_read(name = "data.fix_issues")


na_vals <-
  targets::tar_read(name = "data.fix_issues") %>% 
  dplyr::filter(
    # region == "california" &
      is.na(demand_MWHrs)
  )

p <- 
  targets::tar_read(name = "data.fix_issues") %>% 
  ggplot2::ggplot(
    ggplot2::aes(
      x = datetime,
      y = demand_MWHrs,
      color = region
    )
  ) +
  ggplot2::geom_line(
    na.rm = TRUE
  ) +
  ggplot2::geom_vline(
    data = na_vals,
    ggplot2::aes(
      xintercept = datetime
    ),
    color = "black"
  ) +
  ggplot2::facet_wrap(
    vars(region),
    scales = "free",
    ncol = 4
  ) +
  ggplot2::theme_minimal() +
  ggplot2::theme(
    legend.position = "none"
  ) +
  NULL

p

plotly::ggplotly(p)
