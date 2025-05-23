#! /home/lcesarini/project/repo_power/env/bin/python
import os 
import sys
from pathlib import Path

FILE = Path(__file__).resolve()

ROOT = FILE.parents[1]  
if str(ROOT) not in sys.path:
    sys.path.append(str(ROOT))  # add ROOT to PATH

import json
import config
import requests 
import numpy as np 
import pandas as pd 

os.chdir(FILE.parents[2])
df_tower = pd.read_csv('data/tower/df_tower_parameters.txt', sep = '\t', header = 0)

# print(df_tower.head())

pic_base = 'https://maps.googleapis.com/maps/api/streetview?'
api_key = config.api_key

# random_index = np.random.randint(0,5869)

# for i in np.arange(df_tower.shape[0]):
for i in [0]:
    
    id_tower = df_tower.id[i]
    size = "640x640"

    for n_pov in np.arange(1,6):
        # Create directory (including parents) if it doesn't exist
        directory = Path(f'data/gsv_images/{n_pov}/')
        directory.mkdir(parents=True, exist_ok=True)    
        if pd.isna(df_tower[f"GSV_pano_id_{n_pov}"][i]):
            next
        else:
            location = f'{df_tower[f"GSV_lat_{n_pov}"][i]},{df_tower[f"GSV_lon_{n_pov}"][i]}'
            heading  = f'{df_tower[f"heading_{n_pov}"][i]}'
            fov      = f'{df_tower[f"fov_{n_pov}"][i]}'
            pitch    = f'{df_tower[f"pitch_{n_pov}"][i]}'

            # define the params for the picture request
            pic_params = {'key': api_key,
                        'location': location,
                        'heading':heading,
                        'fov':fov,
                        'pitch':pitch,
                        'size': size}
                
            pic_response = requests.get(pic_base, params=pic_params)

            if pic_response.ok:
                with open(f'data/gsv_images/{n_pov}/tow{id_tower}.jpg', 'wb') as image:
                    image.write(pic_response.content)
                    # remember to close the response connection to the API
                    pic_response.close()


if __name__=='__main__':
    print('fucking hell')