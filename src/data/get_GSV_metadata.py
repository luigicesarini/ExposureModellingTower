import os
import sys
from pathlib import Path

FILE = Path(__file__).resolve()

ROOT = FILE.parents[1]  
if str(ROOT) not in sys.path:
    sys.path.append(str(ROOT))  # add ROOT to PATH

# ROOT = Path(os.path.relpath(ROOT, Path.cwd()))  # relative
import json
import config
import requests 
from time import *
import numpy as np
import pandas as pd 


os.chdir(FILE.parents[2])

df_tower = pd.read_csv('data/tower/df_4_points_road_distance.csv', sep = ' ', header = 0)
df_tower = pd.read_csv('data/tower/df_4_points_thr_distance.csv', sep = ' ', header = 0)

for i in range(1,6):

    df_tower[f'GSV_lat_{i}']=np.nan
    df_tower[f'GSV_lon_{i}']=np.nan
    df_tower[f'GSV_date_{i}']=np.nan
    df_tower[f'GSV_pano_id_{i}']=np.nan

print(df_tower.head())

meta_base = 'https://maps.googleapis.com/maps/api/streetview/metadata?'
pic_base = 'https://maps.googleapis.com/maps/api/streetview?'
api_key = config.api_key

radius = 500 

for i in [0]:
# for i in np.arange(df_tower.shape[0]):
    if ~np.isnan(df_tower.lon[i]):
        location =  f"{df_tower.lon[i]},{df_tower.lat[i]}"
        # define the params for the metadata reques
        meta_params = {'key': api_key,
                        'location': location,
                        'radius':radius}
        
        meta_response = requests.get(meta_base, params=meta_params)
        
        if meta_response.json()['status'] == 'OK':
            df_tower.loc[i,'GSV_lat_1'] = meta_response.json()['location']['lat']
            df_tower.loc[i,'GSV_lon_1'] = meta_response.json()['location']['lng']
            df_tower.loc[i,'GSV_date_1'] = meta_response.json()['date']
            df_tower.loc[i,'GSV_pano_id_1'] = meta_response.json()['pano_id']
    if ~np.isnan(df_tower.X1[i]):
        location =  f"{df_tower.Y1[i]},{df_tower.X1[i]}"
        # define the params for the metadata reques
        meta_params = {'key': api_key,
                        'location': location,
                        'radius':radius}
        
        meta_response = requests.get(meta_base, params=meta_params)
        
        if meta_response.json()['status'] == 'OK':
            df_tower.loc[i,'GSV_lat_2'] = meta_response.json()['location']['lat']
            df_tower.loc[i,'GSV_lon_2'] = meta_response.json()['location']['lng']
            df_tower.loc[i,'GSV_date_2'] = meta_response.json()['date']
            df_tower.loc[i,'GSV_pano_id_2'] = meta_response.json()['pano_id']
    #SECODN POINT
    if ~np.isnan(df_tower.X2[i]):
        location =  f"{df_tower.Y2[i]},{df_tower.X2[i]}"
        # define the params for the metadata reques
        meta_params = {'key': api_key,
                        'location': location,
                        'radius':radius}
        
        meta_response = requests.get(meta_base, params=meta_params)
        
        if  ['status'] == 'OK':
            df_tower.loc[i,'GSV_lat_3'] = meta_response.json()['location']['lat']
            df_tower.loc[i,'GSV_lon_3'] = meta_response.json()['location']['lng']
            df_tower.loc[i,'GSV_date_3'] = meta_response.json()['date']
            df_tower.loc[i,'GSV_pano_id_3'] = meta_response.json()['pano_id']

    #THIRD POINT
    if ~np.isnan(df_tower.X3[i]):
        location =  f"{df_tower.Y3[i]},{df_tower.X3[i]}"
        # define the params for the metadata reques
        meta_params = {'key': api_key,
                        'location': location,
                        'radius':radius}
        
        meta_response = requests.get(meta_base, params=meta_params)
        
        if meta_response.json()['status'] == 'OK':
            df_tower.loc[i,'GSV_lat_4'] = meta_response.json()['location']['lat']
            df_tower.loc[i,'GSV_lon_4'] = meta_response.json()['location']['lng']
            df_tower.loc[i,'GSV_date_4'] = meta_response.json()['date']
            df_tower.loc[i,'GSV_pano_id_4'] = meta_response.json()['pano_id']

    #FOURTH POINT
    if ~np.isnan(df_tower.X4[i]):
        location =  f"{df_tower.Y4[i]},{df_tower.X4[i]}"
        # define the params for the metadata reques
        meta_params = {'key': api_key,
                        'location': location,
                        'radius':radius}
        
        meta_response = requests.get(meta_base, params=meta_params)
        
        if meta_response.json()['status'] == 'OK':
            df_tower.loc[i,'GSV_lat_5'] = meta_response.json()['location']['lat']
            df_tower.loc[i,'GSV_lon_5'] = meta_response.json()['location']['lng']
            df_tower.loc[i,'GSV_date_5'] = meta_response.json()['date']
            df_tower.loc[i,'GSV_pano_id_5'] = meta_response.json()['pano_id']

df_tower.to_csv("output/df_GSV_positions_points.csv", index = False)









