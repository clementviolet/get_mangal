#' Récupère les données de l'utilisateur qui a télécharger un dataset dans Mangal
#'
#' @param dataset_name un vecteur contenant le nom du ou des datasets dont les information sur l'utilisateur qui a téléchargé les données sur Mangal sont à récupérer. 
#' Les noms doivent être orthographié de la même façon qu'ils sont enregistré dans Mangal
#' @param raw booléen, est-ce que le format de sortie doit être brute de la base de donnée ou sous la forme d'un tidy dataframe ?
#'
#' @return une `list` ou un `dataframe`.

user <- function(dataset_name, raw = TRUE){
  require(tibble)
  require(purrr)
  require(dplyr) # Packages requis pour la manipulation des listes
  require(tidyr)
  require(httr)
  
  stopifnot(is.character(dataset_name))
  
  users <- list()
  datasets <- dataset(dataset_name, raw = FALSE) %>%
    filter(!duplicated(.$user_id) & !is.na(user_id))
  
  for(user in 1:nrow(datasets)){
    uri <- modify_url(url   = "http://poisotlab.biol.umontreal.ca", 
                      path  = paste0("/api/v2/","user/", datasets$user_id[user]))
    
    users[user] <- list(content(GET(url    = uri,
                                    config = httr::add_headers(Authorization = paste("Bearer", readRDS(".httr-oauth"))))))
  }
  
  if(!raw){
    users <- users %>%
      map(~discard(.x, is.list)) %>%
      map_dfr(~flatten_dfc(.x))
  }
  
  return(users)
}
