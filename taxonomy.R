#' Récupère la taxonomy d'un dataset dans Mangal
#'
#' @param dataset_name un vecteur contenant le nom du ou des datasets contenant la taxonomy à récupérer dans Mangal. 
#' Les noms doivent être orthographié de la même façon qu'ils sont enregistré dans Mangal
#' @param raw booléen, est-ce que le format de sortie doit être brute de la base de donnée ou sous la forme d'un tidy dataframe ?
#'
#' @return une `list` ou un `dataframe`.

taxonomy <- function(dataset_name, raw = TRUE){
  require(tibble)
  require(purrr)
  require(dplyr) # Packages requis pour la manipulation des listes
  require(tidyr)
  require(httr)
  
  stopifnot(is.character(dataset_name))
  
  taxo <- list()
  nodes <- node(dataset_name, raw = FALSE) %>%
    filter(!duplicated(.$taxonomy_id) & !is.na(.$taxonomy_id))

  # Récupère la taxonomy des nodes
  for(taxo_id in 1:nrow(nodes)){
    uri <- modify_url(url   = "http://poisotlab.biol.umontreal.ca", 
                      path  = paste0("/api/v2/","taxonomy/", nodes$taxonomy_id[taxo_id]))
    
    taxo[taxo_id] <- list(content(GET(url    = uri,
                                      config = httr::add_headers(Authorization = paste("Bearer", readRDS(".httr-oauth"))))))
  }
  
  if(!raw){
    taxo <- map_dfr(taxo, ~flatten_dfc(.x))
  }
  
  return(taxo)
}  
