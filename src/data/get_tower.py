import os
import json 
import overpy
import requests
import pandas as pd 

# Select the bounday box inside which extract the data

bbox = (41.0,-8.8,41.4,-8.4)


query_tower =  f"""
[out:json][timeout:60];
(
  node["power"="tower"]{bbox};
  way["power"="tower"]{bbox};
);
out body;
>;
out skel qt;
                    """
                    
"""
TODO: CREATE file with bboxes and univocal id
"""

api=overpy.Overpass()

result = api.query(query_tower)

type_file = f"tower_bbox_porto"
overpass_url = "http://overpass-api.de/api/interpreter" 					 #url of overpass api
response = requests.get(overpass_url,params={'data': query_tower})
json_data = response.json()

if not os.path.exists(f"data/osm_{type_file}.json"):
    with open(f"data/osm_{type_file}.json", "w") as outfile:  									 # writing the json output to a file
        json.dump(json_data, outfile)



# Open the extracted JSON
with open(f"data/osm_{type_file}.json") as f:
    data = json.load(f)

# List of dictionaris
print(data.keys())
print(f"Number of elements: {len(data['elements'])}")
#Two tipes of keys node=tower, way = lines
keyValList = ['node','way']


#Filter by key
list_way_dict = [d for d in data['elements'] if d['type'] in keyValList[1]]
list_node_dict = [d for d in data['elements'] if d['type'] in keyValList[0]]

#Create dataframe of the towers and print to disk
list_of_node_tags = []
for tower in list_node_dict:
	if 'tags' not in tower.keys():
		tower['tags'] =  {'lat':tower['lat'],'lon':tower['lon'],'id':tower['id']}
	else:
		tower['tags'].update({'lat':tower['lat'],'lon':tower['lon'],'id':tower['id']})
	list_of_node_tags.append(tower['tags'])

data_frame = pd.DataFrame(list_of_node_tags)  
data_frame.shape
data_frame.to_csv(f'data/df_all_{type_file}.csv', index_label = 0)