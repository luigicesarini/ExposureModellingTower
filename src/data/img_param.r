library(sf)
library(glue)
library(dplyr)
library(raster)
library(stringr)
library(data.table)


df <- read.csv('data/tower/df_GSV_positions_points.csv', sep = ",")

# compute fov, pithc etc,.
a_retta <- -15/118 
b_retta <- 5385/59

# Load the DEM
dem <- raster('data/dem/n40w010_dem.tif')
# Compute parameteres ----
elev_tower <- extract(dem,df[,c('lon','lat')])
elev_GSV_1   <- extract(dem,df[,c('GSV_lon_1','GSV_lat_1')])
elev_GSV_2   <- extract(dem,df[,c('GSV_lon_2','GSV_lat_2')])
elev_GSV_3   <- extract(dem,df[,c('GSV_lon_3','GSV_lat_3')])
elev_GSV_4   <- extract(dem,df[,c('GSV_lon_4','GSV_lat_4')])
elev_GSV_5   <- extract(dem,df[,c('GSV_lon_5','GSV_lat_5')])

df %>% 
  mutate(#DISTANCE
    distance_1 = sqrt((lon-GSV_lon_1)^2+(lat-GSV_lat_1)^2)*111*1000,
    distance_2 = sqrt((lon-GSV_lon_2)^2+(lat-GSV_lat_2)^2)*111*1000,
    distance_3 = sqrt((lon-GSV_lon_3)^2+(lat-GSV_lat_3)^2)*111*1000,
    distance_4 = sqrt((lon-GSV_lon_4)^2+(lat-GSV_lat_4)^2)*111*1000,
    distance_5 = sqrt((lon-GSV_lon_5)^2+(lat-GSV_lat_5)^2)*111*1000, 
    #HEADING
    heading_1    = atan2((lon-GSV_lon_1),(lat-GSV_lat_1))*180/pi,
    heading_1    = case_when(heading_1 < 0 ~ 360+heading_1,
                                TRUE ~ heading_1 ),

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
    fov_1      = case_when(distance_1 > 600 ~ 15,
                           distance_1 < 10 ~ 90,
                           distance_1 >= 10 & distance_1 <= 600 ~ a_retta*distance_1+b_retta,
                           TRUE ~ NA), 
    fov_2      = case_when(distance_2 > 600 ~ 15,
                           distance_2 < 10 ~ 90,
                           distance_2 >= 10 & distance_2 <= 600 ~ a_retta*distance_2+b_retta,
                           TRUE ~ NA),
    fov_3      = case_when(distance_3 > 600 ~ 15,
                           distance_3 < 10 ~ 90,
                           distance_3 >= 10 & distance_3 <= 600 ~ a_retta*distance_3+b_retta,
                           TRUE ~ NA),
    fov_4      = case_when(distance_4 > 600 ~ 15,
                           distance_4 < 10 ~ 90,
                           distance_4 >= 10 & distance_4 <= 600 ~ a_retta*distance_4+b_retta,
                           TRUE ~ NA),
    fov_5      = case_when(distance_5 > 600 ~ 15,
                           distance_5 < 10 ~ 90,
                           distance_5 >= 10 & distance_4 <= 600 ~ a_retta*distance_5+b_retta,
                           TRUE ~ NA),  
    #ELEVATIONS
    elev_tower = elev_tower,
    elev_GSV_1 = elev_GSV_1,
    elev_GSV_2 = elev_GSV_2,
    elev_GSV_3 = elev_GSV_3,
    elev_GSV_4 = elev_GSV_4,
    elev_GSV_5 = elev_GSV_5,
    
    # DIFFERENTIAL ELEVATION
    diff_elev_1 = elev_tower-elev_GSV_1,
    diff_elev_2 = elev_tower-elev_GSV_2,
    diff_elev_3 = elev_tower-elev_GSV_3,
    diff_elev_4 = elev_tower-elev_GSV_4,
    diff_elev_5 = elev_tower-elev_GSV_5,
    
    # PITCH
    pitch_1    = atan(diff_elev_1/distance_1)*180/pi,
    pitch_2    = atan(diff_elev_2/distance_2)*180/pi,
    pitch_3    = atan(diff_elev_3/distance_3)*180/pi,
    pitch_4    = atan(diff_elev_4/distance_4)*180/pi, 
    pitch_5    = atan(diff_elev_5/distance_5)*180/pi) -> df_new

if (!file.exists('data/tower/df_tower_parameters.txt')) write.table(df_new,'data/tower/df_tower_parameters.txt', quote = FALSE, sep = '\t', row.names = FALSE,col.names = TRUE)
