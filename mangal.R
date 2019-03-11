#' Récupère toutes les tables de Mangal en lien avec un ou plusieurs datasets. 
#' 
#' \code{mangal} est en gros un wrapper autour des autres fonctions.
#' 
#' @param dataset_name un vecteur contenant le nom du ou des datasets dont les information sur l'utilisateur qui a téléchargé les données sur Mangal sont à récupérer. 
#' Les noms doivent être orthographié de la même façon qu'ils sont enregistré dans Mangal
#' @param raw booléen, est-ce que le format de sortie doit être brute de la base de donnée ou sous la forme d'un tidy dataframe ?

mangal <- function(dataset_name, raw = TRUE){
  require(tibble)
  require(purrr)
  require(dplyr) # Packages requis pour la manipulation des listes
  require(tidyr)
  require(httr)
  
  datasets <- dataset(dataset_name, raw)
  
  networks <- network(dataset_name, raw)
  
  nodes <- node(dataset_name, raw)
  
  interactions <- interaction(dataset_name, raw)
  
  taxo <- taxonomy(dataset_name, raw)
  
  attrs <- attribute(dataset_name, raw)
  
  ref <- reference(dataset_name, raw)
  
  uploader <- user(dataset_name, raw)
  
  return(list(dataset = datasets, 
              network = networks,
              node = nodes,
              interaction = interactions, 
              attribute = attrs, 
              reference = ref,
              user = uploader))
}
