### Format tree data for PR-GSFE01

library(data.table)
tree <- fread("/home/steve/ownCloud/Labo/Collaborations/MeganeDeziel/tree.csv")
loc <- fread("/home/steve/ownCloud/Labo/Collaborations/MeganeDeziel/localisation.csv")

# Number of ACER by plots with year
library(dplyr)
library(magrittr)
tree %<>% filter(id_spe == '28731-ACE-SAC') %>% group_by(plot_id, year_measured, id_spe) %>% count()

# join with localisation
tree <- merge(tree, loc, by = "plot_id") %>% dplyr::select(-srid, -elevation)
names(tree)[1:4] <- c("plot","yr","species","n_occ")
tree$species <- "Acer saccharum"

# Turn tree into sf
library(sp)
coordinates(tree) <- ~ longitude + latitude
projection(tree) <- CRS("+init=epsg:4326")

# Load raster
library(raster)
rs_ref <- readRDS("/home/steve/Documents/Git/PRStats/PR-GSFE01/INLA/assets/data/climate_Present.rds")
tree <- crop(tree, extent(rs_ref))

sf_tree <- st_as_sf(tree)
saveRDS(sf_tree, "/home/steve/Documents/Git/PRStats/PR-GSFE01/INLA/assets/data/tree.rds")