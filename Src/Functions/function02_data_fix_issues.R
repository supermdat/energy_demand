### title: "Energy Demand - function01_data_fix_issues
### author: "M Daniel A Turse"
### date: "2021-10-04"

# fix data issues

f.data_fix_issues <-
  function(data, ...) {
    
    data.fix_issues <-
      data %>% 
      dplyr::group_by(
        region
      ) %>% 
      dplyr::mutate(
        datetime = lubridate::floor_date(x = datetime, unit = "hours")
      ) %>% 
      timetk::pad_by_time(
        .date_var = datetime,
        .by = "hour",
        .pad_value = NA
      ) %>% 
      dplyr::ungroup() %>% 
      dplyr::arrange(
        region,
        datetime
      )
    
    return(data.fix_issues)
  }
