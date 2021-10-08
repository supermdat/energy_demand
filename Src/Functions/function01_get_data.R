### title: "Energy Demand - function01_get_data"
### author: "M Daniel A Turse"
### date: "2021-10-04"

# Get the data

f.get_data <-
  function(eia_api_key = NULL, ...) {
    
    # setup the region-code mapping
    regions <-
      tibble::tibble(
        name = c("california", "carolinas", "central", "florida", "mid_atlantic", "midwest",
                 "new_england", "new_york", "northwest", "southeast", "southwest", "tennessee",
                 "texas"
        ),
        code = c("EBA.CAL-ALL.D.HL", "EBA.CAR-ALL.D.HL", "EBA.CENT-ALL.D.HL", "EBA.FLA-ALL.D.HL",
                 "EBA.MIDA-ALL.D.HL", "EBA.MIDW-ALL.D.HL", "EBA.NE-ALL.D.HL", "EBA.NY-ALL.D.HL", 
                 "EBA.NW-ALL.D.HL", "EBA.SE-ALL.D.HL", "EBA.SW-ALL.D.HL", "EBA.TEN-ALL.D.HL",
                 "EBA.TEX-ALL.D.HL"
        )
      ) %>% 
      dplyr::mutate(
        series_id = paste0("&series_id=", code)
      )
    
    # download the data as json files
    data.json <-
      purrr::pmap(
        .l = list(a = regions %>% dplyr::pull(series_id)),
        .f = function(a) {
          url_pre <- "http://api.eia.gov/series/?api_key="
          url_full <- paste0(url_pre, Sys.getenv("eia_api_key"), a)
          
          data_json <- jsonlite::fromJSON(txt = url_full)
          
          return(data_json)
        }
      )
    
    names(data.json) <- regions$name
    
    # pull out the meta data
    data.meta <-
      purrr::pmap_dfr(
        .l = list(a = data.json),
        .id = "region",
        .f = function(a) {
          
          data_meta <- a$series %>%
            dplyr::select(
              -data
            )
          
          return(data_meta)
        }
      )
    
    # pull out the time series data
    data.raw <-
      purrr::pmap_dfr(
        .l = list(a = data.json),
        .id = "region",
        .f = function(a) {
          
          data_raw <-
            a$series %>%
            dplyr::pull(data) %>%
            tibble::as_tibble(.name_repair = ~ c("temp_col")) %>%
            dplyr::pull(temp_col) %>%
            tibble::as_tibble(.name_repair = ~ c("datetime", "demand_MWHrs")) %>%
            dplyr::mutate(
              datetime = lubridate::as_datetime(datetime, format = "%Y%m%dT%H-%M"),
              demand_MWHrs = as.integer(demand_MWHrs)
            )
          
          return(data_raw)
        }
      )
    
    data.raw$region <- factor(data.raw$region)
    
    # return meta and raw
    lst <- 
      list(
        data.meta = data.meta,
        data.raw = data.raw
      )
    
    return(lst)
  }
