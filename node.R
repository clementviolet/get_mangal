#' Récupère les nodes d'un dataset dans Mangal
#'
#' @param dataset_name un vecteur contenant le nom du ou des datasets contenant les nodes à récupérer dans Mangal. 
#' Les noms doivent être orthographié de la même façon qu'ils sont enregistré dans Mangal
#' @param raw booléen, est-ce que le format de sortie doit être brute de la base de donnée ou sous la forme d'un tidy dataframe ?
#'
#' @return une `list` ou un `dataframe`.

node <- function(dataset_name, raw = TRUE){
  require(tibble)
  require(purrr)
  require(dplyr) # Packages requis pour la manipulation des listes
  require(tidyr)
  require(httr)
  
  stopifnot(is.character(dataset_name))
  
  nodes <- list()
  networks <- network(dataset_name, raw = FALSE)
  
  # Récupère les nodes
  for(nb_node in 1:nrow(networks)){
    uri <- modify_url(url   = "http://poisotlab.biol.umontreal.ca", 
                      path  = paste0("/api/v2/","node"), 
                      query = paste0("network_id=", networks$id[nb_node]))
    
    nodes[nb_node] <- list(content(GET(url    = uri,
                             config = httr::add_headers(Authorization = paste("Bearer", readRDS(".httr-oauth"))))))
  }
  
  nodes <- flatten(nodes) # Retire le niveau de liste ajouté pour encapsuler les résultats de la partie content(GET)
  
  if(!raw){
    nodes <- nodes %>%
      map(~discard(.x, is.list)) %>%
      map_dfr(~flatten_dfc(.x))
  }
  
  return(nodes)
}
