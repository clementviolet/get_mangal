#' Récupère les attributs d'un dataset dans Mangal
#'
#' @param dataset_name un vecteur contenant le nom du ou des datasets contenant les attributs à récupérer dans Mangal. 
#' Les noms doivent être orthographié de la même façon qu'ils sont enregistré dans Mangal
#' @param raw booléen, est-ce que le format de sortie doit être brute de la base de donnée ou sous la forme d'un tidy dataframe ?
#'
#' @return une `list` ou un `dataframe`.

attribute <- function(dataset_name, raw = TRUE){
  require(tibble)
  require(purrr)
  require(dplyr) # Packages requis pour la manipulation des listes
  require(tidyr)
  require(httr)
  
  stopifnot(is.character(dataset_name))
  
  attrs <- list()
  interactions <- interaction(dataset_name, raw = FALSE) %>%
    filter(!duplicated(.$attr_id) & !is.na(.$attr_id))
  
  # environments <- environment(dataset_name, raw = FALSE) %>%
  #   filter(!duplicated(.$attr_id) & !is.na(.$attr_id))

  for(attr in 1:nrow(interactions)){
    uri <- modify_url(url   = "http://poisotlab.biol.umontreal.ca", 
                      path  = paste0("/api/v2/","attribute/", interactions$attr_id[attr]))
    
    attrs[attr] <- list(content(GET(url    = uri,
                                    config = httr::add_headers(Authorization = paste("Bearer", readRDS(".httr-oauth"))))))
  }
  
  if(!raw){
    attrs <- map_dfr(attrs, ~flatten_dfc(.x))
  }
  
  return(attrs)
}
