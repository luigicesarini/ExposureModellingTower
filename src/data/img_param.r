library(sf)

library(dplyr)
library(data.table)
library(raster)
library(tmap)
library(stringr)
library(nngeo)
library(glue)

df <- read.csv('new_points_gsv.csv', sep = ",")

# compute fov, pithc etc,.
a_retta <- -15/118 
b_retta <- 5385/59

# Load the DEM
dem <- raster('data/n40w010_elv.tif')
# Compute parameteres ----
elev_tower <- extract(dem,df[,c('lon','lat')])
elev_GSV_2   <- extract(dem,df[,c('GSV_lon_2','GSV_lat_2')])
elev_GSV_3   <- extract(dem,df[,c('GSV_lon_3','GSV_lat_3')])
elev_GSV_4   <- extract(dem,df[,c('GSV_lon_4','GSV_lat_4')])
elev_GSV_5   <- extract(dem,df[,c('GSV_lon_5','GSV_lat_5')])

df %>% 
  mutate(#DISTANCE
    distance   = sqrt((lon-GSV_lon)^2+(lat-GSV_lat)^2)*111*1000,
    distance_2 = sqrt((lon-GSV_lon_2)^2+(lat-GSV_lat_2)^2)*111*1000,
    distance_3 = sqrt((lon-GSV_lon_3)^2+(lat-GSV_lat_3)^2)*111*1000,
    distance_4 = sqrt((lon-GSV_lon_3)^2+(lat-GSV_lat_3)^2)*111*1000,
    distance_5 = sqrt((lon-GSV_lon_3)^2+(lat-GSV_lat_3)^2)*111*1000,
    #HEADING
    heading_2  = atan2((lon-GSV_lon_2),(lat-GSV_lat_2))*180/pi,
    heading_2  = case_when(heading_2 < 0 ~ 360+heading_2,
                           TRUE ~ heading_2),
    heading_3  = atan2((lon-GSV_lon_3),(lat-GSV_lat_3))*180/pi,
    heading_3  = case_when(heading_3 < 0 ~ 360+heading_3,
                           TRUE ~ heading_3 ),
    heading_4  = atan2((lon-GSV_lon_4),(lat-GSV_lat_4))*180/pi,
    heading_4  = case_when(heading_4 < 0 ~ 360+heading_4,
                         TRUE ~ heading_4 ),
    heading_5  = atan2((lon-GSV_lon_5),(lat-GSV_lat_5))*180/pi,
    heading_5  = case_when(heading_5 < 0 ~ 360+heading_5,
                           TRUE ~ heading_5 ),
    # FIELD OF VIEW
    fov_2      = case_when(distance_2 > 600 ~ 15,
                           distance_2 < 10 ~ 90,
                           distance_2 >= 10 & distance_2 <= 600 ~ a_retta*distance_2+b_retta),
    fov_3      = case_when(distance_3 > 600 ~ 15,
                           distance_3 < 10 ~ 90,
                           distance_3 >= 10 & distance_3 <= 600 ~ a_retta*distance_3+b_retta),
    fov_4      = case_when(distance_4 > 600 ~ 15,
                           distance_4 < 10 ~ 90,
                           distance_4 >= 10 & distance_4 <= 600 ~ a_retta*distance_4+b_retta),
    fov_5      = case_when(distance_5 > 600 ~ 15,
                           distance_5 < 10 ~ 90,
                           distance_5 >= 10 & distance_4 <= 600 ~ a_retta*distance_5+b_retta),
    
    #ELEVATIONS
    elev_tower = elev_tower,
    elev_GSV_2 = elev_GSV_2,
    elev_GSV_3 = elev_GSV_3,
    elev_GSV_4 = elev_GSV_4,
    elev_GSV_5 = elev_GSV_5,
    
    # DIFFERENTIAL ELEVATION
    diff_elev_2 = elev_tower-elev_GSV_2,
    diff_elev_3 = elev_tower-elev_GSV_3,
    diff_elev_4 = elev_tower-elev_GSV_4,
    diff_elev_5 = elev_tower-elev_GSV_5,
    
    # PITCH
    pitch_2    = atan(diff_elev_2/distance_2)*180/pi,
    pitch_3    = atan(diff_elev_3/distance_3)*180/pi,
    pitch_4    = atan(diff_elev_4/distance_4)*180/pi, 
    pitch_5    = atan(diff_elev_5/distance_5)*180/pi) -> df_new

if (!file.exists('data/tower/df_tower_bbox_4_POV._2txt')) write.table(df_new,'data/tower/df_tower_bbox_4_POV_2.txt', quote = FALSE, sep = '\t', row.names = FALSE,col.names = TRUE)


df_new[df_new$GSV_pano_id_2 == df_new$GSV_pano_id_3,] %>% slice(1) %>% View
  mutate(diff = heading_2 == heading_3 )

tmap_mode('view')
tm_shape(df_new[df_new$GSV_pano_id_2 == df_new$GSV_pano_id_3,] %>% slice(1) %>% st_as_sf(coords=c("X1","Y1")))+tm_dots()+
tm_shape(df_new[df_new$GSV_pano_id_2 == df_new$GSV_pano_id_3,] %>% slice(1) %>% st_as_sf(coords=c("X2","Y2")))+tm_dots()+
tm_shape(df_new[df_new$GSV_pano_id_2 == df_new$GSV_pano_id_3,] %>% slice(1) %>% st_as_sf(coords=c("X3","Y3")))+tm_dots()+
#tm_shape(df_new[df_new$GSV_pano_id_2 == df_new$GSV_pano_id_3,] %>% slice(1) %>% st_as_sf(coords=c("X4","Y4")))+tm_dots()+
tm_shape(df_new[df_new$GSV_pano_id_2 == df_new$GSV_pano_id_3,] %>% slice(1) %>% st_as_sf(coords=c("lon","lat")))+tm_markers()

df_new$X2 == df_new$X3 
# st_as_sf(coords = c('GSV_lon','GSV_lat'),crs = 4326,remove = FALSE) -> sf_obj_tower_complete
# 
# df_new$GSV_pano_id_2==df_new$GSV_pano_id_3
# 
# df_new %>% 
#   filter(id == 4026814590)
# 
# 
# 
# tm_shape(sf_obj_tower_complete)+tm_dots()+
#   tm_shape(sf_obj_tower_complete %>% dplyr::filter(!duplicated(id)))+
#   tm_markers(clustering = FALSE)
# 
# sf_obj_tower_complete %>% 
#   st_set_geometry(NULL) %>% 
#   filter(distance_3 < 10) %>% 
#   st_as_sf(coords = c('lon','lat'), crs = 4326) %>% st_distance(.,sf_obj_tower_complete) %>% 
#   t() %>% 
#   data.frame(row.names = sf_obj_tower_complete$id) -> df_distance
# 
# colnames(df_distance) <- paste0((sf_obj_tower_complete %>% filter(distance < 10) %>% pull(id)))
# 
# df_distance %>% 
#   tibble::rownames_to_column(var = 'id') %>% 
#   reshape::melt(id.vars = 'id') %>% 
#   mutate(value = units::drop_units(value)) %>% 
#   filter(value > 10 ) %>% 
#   group_by(variable) %>% 
#   filter(value == min(value)) %>% 
#   slice_max(1) %>% 
#   rename('id_alternative'='id',
#          'id' = 'variable',
#          'distance_alternative' = 'value') %>% 
#   mutate(id = as.numeric(as.character(id))) -> df_alternative_view
# 
# 
# df_alternative_view$id 
# 
# sf_obj_tower_complete %>% 
#   st_set_geometry(NULL) %>% 
#   mutate(id = as.double(id)) %>% 
#   left_join(.,df_alternative_view, by = 'id') -> df_joined
# 
# 
# df_joined %>% 
#   write.table('data/tower/df_tower_w_alternative_bbox_2_all.txt', quote = FALSE, sep = '\t', row.names = FALSE,col.names = TRUE)
# 
# #Download image
# tow8267923292_2_14072021.jpg
# 
# 
# dfdf <- read.csv('data/tower/df_tower_bbox_2_3POV.txt', sep = "\t")
# dfdf %>% filter(id == 6721713483)
# 
# 
# df_server <- read.csv('/Users/lcesarini/repo/server_IUSS/2021_milk/output/metrics_milk.csv')
# 
# df_server %>% 
#   group_by(model,country) %>% 
#   filter(r2 == max(r2)) %>% View
