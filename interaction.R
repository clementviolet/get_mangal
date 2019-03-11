#' Récupère les interactions d'un dataset dans Mangal
#'
#' @param dataset_name un vecteur contenant le nom du ou des datasets contenant les interactions à récupérer dans Mangal. 
#' Les noms doivent être orthographié de la même façon qu'ils sont enregistré dans Mangal
#' @param raw booléen, est-ce que le format de sortie doit être brute de la base de donnée ou sous la forme d'un tidy dataframe ?
#'
#' @return une `list` ou un `dataframe`.

interaction <- function(dataset_name, raw = TRUE){
  require(tibble)
  require(purrr)
  require(dplyr) # Packages requis pour la manipulation des listes
  require(tidyr)
  require(httr)
  
  stopifnot(is.character(dataset_name))
  
  interactions <- list()
  networks <- network(dataset_name, raw = FALSE)
  
  # Récupère les interactions
  for(nb_inter in 1:nrow(networks)){
    uri <- modify_url(url   = "http://poisotlab.biol.umontreal.ca", 
                      path  = paste0("/api/v2/","interaction"), 
                      query = paste0("network_id=", networks$id[nb_inter]))
    
    interactions[nb_inter] <- list(content(GET(url    = uri,
                                              config = httr::add_headers(Authorization = paste("Bearer", readRDS(".httr-oauth"))))))
  }
  interactions <- flatten(interactions)
  
  if(!raw){
    interactions <- interactions %>%
      map(~discard(.x, is.list)) %>%
      map_dfr(~flatten_dfc(.x))
  }
  
  return(interactions)
}
