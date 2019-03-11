Fonctions pour télécharger les données de Mangal
================================================

Introduction
------------

Cet ensemble de fonction a pour but de télécharger les données de Mangal et les rendre accessible à l'utilisateur.

To do : \[\] Ajouter la table environnement ; \[\] Simplifier la fonction `mangal()` ; \[\] Ajouter la posibilité de rechercher les informations dans Mangal par d'autres moyen (id d'un dataset, network ou autre) ; \[\] Rendre plus explicite le nom des fonctions pour éviter les erreurs de frappe.

Vignette
--------

Attention, ces fonctions ont besoin des packages suivant installé sur votre machine : \* `tibble` ; \* `purrr` ; \* `dplyr` ; \* `tidyr` ; \* `httr`.

Pour le moment, les fonctions utilisent uniquement le nom du dataset tel qu'il est entré dans Mangal. Pour cet exemple, on va utiliser le dataset dont le nom est `woodwell_1967`.

``` r
# Chargement des fonctions
source("attribute.R")
source("dataset.R")
source("interaction.R")
source("network.R")
source("node.R")
source("reference.R")
source("taxonomy.R")
source("user.R")

nom_dataset <- "woodwell_1967"
```

Chaque fonction récupère la table dont elle porte le nom, par exemple `node()` permet de récupérer tous les nodes d'un dataset simplement.

``` r
node_woodwell <- node(dataset_name = nom_dataset)
```

Par défaut toutes fonctions renvoies la sortie brute de la base de donnée, mais il également possible d'obtenir un `dataframe` plus simple à manipuler en spécifiant `raw = FALSE`.

``` r
node_woodwell <- node(dataset_name = nom_dataset, raw = FALSE)
```

|    id| original\_name       | node\_level |  network\_id|  taxonomy\_id| created\_at              | updated\_at              |
|-----:|:---------------------|:------------|------------:|-------------:|:-------------------------|:-------------------------|
|  4473| organic debris       | taxon       |           26|          3774| 2019-02-22T20:28:39.585Z | 2019-02-22T20:28:39.585Z |
|  4474| plankton             | taxon       |           26|          3775| 2019-02-22T20:28:39.629Z | 2019-02-22T20:28:39.629Z |
|  4475| water plant          | taxon       |           26|          3776| 2019-02-22T20:28:39.659Z | 2019-02-22T20:28:39.659Z |
|  4476| marsh plants         | taxon       |           26|          3777| 2019-02-22T20:28:39.694Z | 2019-02-22T20:28:39.694Z |
|  4477| bay shrimp           | taxon       |           26|          3778| 2019-02-22T20:28:39.723Z | 2019-02-22T20:28:39.723Z |
|  4478| silversides          | taxon       |           26|          3779| 2019-02-22T20:28:39.761Z | 2019-02-22T20:28:39.761Z |
|  4479| mud snail            | taxon       |           26|          3780| 2019-02-22T20:28:39.792Z | 2019-02-22T20:28:39.792Z |
|  4480| clam                 | taxon       |           26|          3781| 2019-02-22T20:28:39.829Z | 2019-02-22T20:28:39.829Z |
|  4481| billfish             | taxon       |           26|          3782| 2019-02-22T20:28:39.862Z | 2019-02-22T20:28:39.862Z |
|  4482| eel                  | taxon       |           26|          3783| 2019-02-22T20:28:39.892Z | 2019-02-22T20:28:39.892Z |
|  4483| blowfish             | taxon       |           26|          3784| 2019-02-22T20:28:39.926Z | 2019-02-22T20:28:39.926Z |
|  4484| minnow 1             | taxon       |           26|          3785| 2019-02-22T20:28:39.959Z | 2019-02-22T20:28:39.959Z |
|  4485| minnow 2             | taxon       |           26|          3785| 2019-02-22T20:28:39.993Z | 2019-02-22T20:28:39.993Z |
|  4486| fluke                | taxon       |           26|          3786| 2019-02-22T20:28:40.026Z | 2019-02-22T20:28:40.026Z |
|  4487| cricket              | taxon       |           26|          3787| 2019-02-22T20:28:40.060Z | 2019-02-22T20:28:40.060Z |
|  4488| mosquito             | taxon       |           26|          3788| 2019-02-22T20:28:40.096Z | 2019-02-22T20:28:40.096Z |
|  4489| tern                 | taxon       |           26|          3789| 2019-02-22T20:28:40.127Z | 2019-02-22T20:28:40.127Z |
|  4490| Osprey               | taxon       |           26|          3790| 2019-02-22T20:28:40.160Z | 2019-02-22T20:28:40.160Z |
|  4491| Green Heron          | taxon       |           26|          3791| 2019-02-22T20:28:40.202Z | 2019-02-22T20:28:40.202Z |
|  4492| merganser            | taxon       |           26|          3792| 2019-02-22T20:28:40.237Z | 2019-02-22T20:28:40.237Z |
|  4493| cormorant            | taxon       |           26|          3793| 2019-02-22T20:28:40.269Z | 2019-02-22T20:28:40.269Z |
|  4494| gull                 | taxon       |           26|          3789| 2019-02-22T20:28:40.307Z | 2019-02-22T20:28:40.307Z |
|  4495| kingfisher           | taxon       |           26|          3794| 2019-02-22T20:28:40.342Z | 2019-02-22T20:28:40.342Z |
|  4496| Red-winged Blackbird | taxon       |           26|          3795| 2019-02-22T20:28:40.376Z | 2019-02-22T20:28:40.376Z |

La fonction `mangal()` permet quant à elle de récupérer toutes les tables liées à un dataset, dans une `nested list` de `list` ou de `dataframe` comme pour les autres fonctions.

``` r
source("mangal.R")
all_woodwell <- mangal(nom_dataset, raw = FALSE)
```
