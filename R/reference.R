#' Récupère la référence bibliographique d'un dataset dans Mangal
#'
#' @param dataset_name un vecteur contenant le nom du ou des datasets dont la référence est à récupérer dans Mangal. 
#' Les noms doivent être orthographié de la même façon qu'ils sont enregistré dans Mangal
#' @param raw booléen, est-ce que le format de sortie doit être brute de la base de donnée ou sous la forme d'un tidy dataframe ?
#'
#' @return une `list` ou un `dataframe`.

reference <- function(dataset_name, raw = TRUE){
  require(tibble)
  require(purrr)
  require(dplyr) # Packages requis pour la manipulation des listes
  require(tidyr)
  require(httr)
  
  stopifnot(is.character(dataset_name))
  
  refs <- list()
  datasets <- dataset(dataset_name, raw = FALSE) %>%
    filter(!duplicated(.$ref_id) & !is.na(ref_id))
  
  for(ref in 1:nrow(datasets)){
    uri <- modify_url(url   = "http://poisotlab.biol.umontreal.ca", 
                      path  = paste0("/api/v2/","reference/", datasets$ref_id[ref]))
    
    refs[ref] <- list(content(GET(url    = uri,
                             config = httr::add_headers(Authorization = paste("Bearer", readRDS(".httr-oauth"))))))
  }
  
  if(!raw){
    refs <- refs %>%
      map(~discard(.x, is.list)) %>%
      map_dfr(~flatten_dfc(.x))
  }
  
  return(refs)
}
