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
rs_ref <- readRDS("climate_Present.rds")
tree <- crop(tree, extent(rs_ref))

library(sf)
sf_tree <- st_as_sf(tree)
saveRDS(sf_tree, "tree.rds")

# Plot graphic
library(ggplot2)
region <- st_as_sf(readRDS("region.rds"))

ggplot() + geom_sf(data = region, col = "grey50") + geom_sf(data = filter(sf_tree, yr >=1985), aes(color = log(n_occ))) + facet_wrap(~yr) + theme_bw()
ggsave("maple_distribution.png", width = 20, height = 12, dpi = 300)