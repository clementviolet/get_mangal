#' Récupèrer les networks d'un datasets dans Mangal
#'
#' @param dataset_name un vecteur contenant le nom du ou des datasets contenant les networks à récupérer dans Mangal. 
#' Les noms doivent être orthographié de la même façon qu'ils sont enregistré dans Mangal
#' @param raw booléen, est-ce que le format de sortie doit être brute de la base de donnée ou sous la forme d'un tidy dataframe ?
#'
#' @return une `list` ou un `dataframe`.

network <- function(dataset_name, raw = TRUE){
  require(tibble)
  require(purrr)
  require(dplyr) # Packages requis pour la manipulation des listes
  require(tidyr)
  require(httr)
  
  stopifnot(is.character(dataset_name))
  
  datasets <- dataset(dataset_name, raw = TRUE)
  networks <- list()
  
  for(data in 1:length(dataset_name)){
    uri <- modify_url(url   = "http://poisotlab.biol.umontreal.ca", 
                      path  = paste0("/api/v2/","network"), 
                      query = paste0("dataset_id=", datasets[[data]]$id))
    
    networks[data] <- list(content(GET(url    = uri,
                                       config = httr::add_headers(Authorization = paste("Bearer", readRDS(".httr-oauth"))))))
  }
  
  
  if(raw){
    networks <- networks %>%
      map(~keep(.x, is.list)) %>%
      flatten() %>% # Retire le premier niveau de list
      flatten() # Retire le second
  }else{
    # Récupère les infos des networks dont le type de coordonés et NULL ou des points
    net_point <- networks %>% #Fonctionne sauf pour les polygones
      flatten() %>%
      map(~compact(.x)) %>%
      map_if(is.list, ~flatten(flatten(flatten(.x)))) %>%
      discard(unlist(map(., ~has_element(.x, "Polygon")))) %>% # Cette ligne retire les poly
      map_dfr(~flatten_dfc(.x)) %>%
      rename(longitude = V1, lattitude = V2) %>% # Renomme les colones V1 et V2 en plus explicite
      mutate_at(c("longitude", "lattitude"), as.list)
    
    # Récupère toutes les métadonnées des networks dont le type de coordonés est Polygon, mais sans les coordonés 
    
    net_poly_no_coord <- networks %>%
      flatten() %>%
      map(~compact(.x)) %>%
      keep(.p = map(., ~.x$geom$type) == "Polygon") %>%
      map(~map_at(.x, .at = "geom", ~discard(.x, .p = function(x){return(TRUE)}))) %>%
      map_dfr(~flatten_dfc(.x))
    
    # Récupère les coordonés des networks dons le type de coordonés est "Polygon"
    net_poly_coord <- networks %>% 
      flatten() %>%
      map(~compact(.x)) %>%
      keep(.p = map(., ~.x$geom$type) == "Polygon") %>%
      map(~keep(.x, is.list)) %>%
      flatten() %>%
      map_if(is.list, ~flatten(.x)) %>%
      map_depth(2, ~unlist(.x)) %>%
      map(~enframe(.x)) %>%
      map(~spread(.x, name, value = value)) %>%
      map(~unnest(.x, type)) %>%
      map(~unnest(.x, coordinates)) %>%
      map(~mutate(.x, long_lat = rep(c("longitude", "lattitude"), times = nrow(.x)/2),
                  nb_point = sort(rep(seq.int(1:(nrow(.x)/2)),2)))) %>%
      map(~spread(.x, key = long_lat, value = coordinates)) %>%
      map_dfr(~tribble(~type, ~longitude, ~lattitude,
                       "Polygon", .x$longitude, .x$lattitude))
    
    
    # Fussionne les deux net_poly
    net_poly <- bind_cols(net_poly_coord, net_poly_no_coord)
    
    # Fusionne les deux tibble dont le type de geom est le point 
    networks <- bind_rows(net_point, net_poly)
  }
  
  return(networks)
}
