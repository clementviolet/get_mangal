#' Récupèrer un dataset dans Mangal
#'
#' @param dataset_name un vecteur contenant le nom du ou des datasets à récupérer dans Mangal. 
#' Les noms doivent être orthographié de la même façon qu'ils sont enregistré dans Mangal
#' @param raw booléen, est-ce que le format de sortie doit être brute de la base de donnée ou sous la forme d'un tidy dataframe ?
#'
#' @return une `list` ou un `dataframe`.

dataset <- function(dataset_name, raw = TRUE){
  require(tibble)
  require(purrr)
  require(dplyr) # Packages requis pour la manipulation des listes
  require(tidyr)
  require(httr)
  
  stopifnot(is.character(dataset_name))
  
  datasets <- list()
  
  # Récupère les dataset
  for(data in 1:length(dataset_name)){
    uri <- modify_url(url   = "http://poisotlab.biol.umontreal.ca", 
                      path  = paste0("/api/v2/","dataset"), 
                      query = paste0("name=", dataset_name[data]))
    
    datasets[data] <- content(GET(url    = uri,
                                  config = httr::add_headers(Authorization = paste("Bearer", readRDS(".httr-oauth")))))
  }
  
  if(!raw){
    datasets <- datasets %>%
      map(~discard(.x, is.list)) %>% # Retrait de la list network dans le partie datasets
      map_dfr(~flatten_dfc(.x))
  }
  
  return(datasets)
}
