# Get closest roads
# TIME 7286.946s
select <- dplyr::select
filter <- dplyr::filter
# Load CSV with tower's coordinates
df_tower <- fread('data/tower/df_tower_w_alternative_bbox_2_all.txt')

sf_tower <- st_as_sf(df_tower,coords = c('lon','lat'),crs = 4326,remove=FALSE)
#Longitude
sf_tower$X1 <-  NA
sf_tower$X2 <-  NA
sf_tower$X3 <-  NA
sf_tower$X4 <-  NA
#Latitude
sf_tower$Y1 <-  NA
sf_tower$Y2 <-  NA
sf_tower$Y3 <-  NA
sf_tower$Y4 <-  NA

df_roads_sf <- st_read("data/roads/roads_study_case.gpkg")
system.time(
for (i in 1:length(sf_tower$id)){ #
  if (i %% 500 == 0) print(glue::glue("{i}-esima iteration {Sys.time()}"))
  x <- nngeo::st_nn(sf_tower[i,],df_roads_sf, k = 50,returnDist = TRUE, progress = FALSE) %>% suppressMessages()
  dist_mat <- cbind(x$nn %>% unlist(),x$dist %>% unlist())
  # Closest point on the closest roads
  st_nearest_points(sf_tower[i,],
                    df_roads_sf %>% 
                      slice(dist_mat[,1])) %>%
    st_coordinates() %>% 
    data.frame() %>% 
    slice(seq(2,length(.data[["X"]]),by = 2)) %>%
    mutate(dist = dist_mat[,2]) %>% 
    filter(!duplicated(paste0(X,Y))) %>% 
      dplyr::select(-L1) %>% 
    suppressMessages()-> closest_points_roads
  
  #Check position of the closest points with respect to the tower
  
  df_tower <- sf_tower[i,c("lon","lat")] %>% st_set_geometry(NULL)
  
  closest_points_roads %>% 
    mutate(position = case_when(X <= df_tower$lon[1] & Y < df_tower$lat[1] ~ "SW",
                                X < df_tower$lon[1]  & Y >= df_tower$lat[1] ~ "NW",
                                X >= df_tower$lon[1] & Y > df_tower$lat[1] ~ "NE",
                                X > df_tower$lon[1]  & Y <= df_tower$lat[1] ~ "SE")) %>% 
    filter(!is.na(position)) %>%  
    group_by(position) %>% 
    filter(dist > 50) %>% 
    slice_min(n=1,order_by = "dist") %>% #data.frame() %>% mutate(paste0(X,',',Y))
    data.frame() %>% 
    dplyr::select(-position,-contains("dist")) %>% 
    unlist() %>% 
    t() -> df_closest
  
    sf_tower[i,] %>% 
            st_set_geometry(NULL) %>% 
            dplyr::select(power,lat,lon,id,contains("GSV"),distance,heading,fov,elev_tower,elev_GSV,diff_elev,pitch,starts_with("X"),starts_with("Y")) %>% 
      data.frame()-> line_df_tower

    line_df_tower[,match(colnames(df_closest),colnames(line_df_tower))] <- df_closest
    
   write.table(line_df_tower,"output/df_4_points_thr_distance.csv",quote = FALSE, row.names = FALSE, append = TRUE, col.names = !file.exists("output/df_4_points_thr_distance.csv"))
}  
)

df <- fread("output/df_4_points.csv", fill = TRUE)