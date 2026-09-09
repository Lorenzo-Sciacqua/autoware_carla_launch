#!/usr/bin/env bash
set -e

MAP_NAME="${1:-${CARLA_MAP_NAME:-Town01}}"
MAP_PATH="carla_map/${MAP_NAME}"

# Google Drive folder IDs for each town map
declare -A MAP_FOLDER_IDS
MAP_FOLDER_IDS[Town01]="1bZfKbq6H9dF1DveuW7iIJiJKN0-W5l03"
MAP_FOLDER_IDS[Town02]="1CKW8eLOFJ_crfejqmSv1EgAFJT_gmijc"
MAP_FOLDER_IDS[Town03]="1rt1pKEfY-hqC2pMrHfajg1EVfjlIcAX5"
MAP_FOLDER_IDS[Town04]="1ZZYgqQJ8l2VRAZxYVt4shTU_PMzF9C7Y"
MAP_FOLDER_IDS[Town05]="1y5dYpL6o3dp_nSo79ar-MMwDpvdcQOY8"
MAP_FOLDER_IDS[Town06]="1B_oZ_pn6zM3G83kUgzUo-YlcLws5GG5h"
MAP_FOLDER_IDS[Town07]="1ZTZ_bhQX3ACOu8cWhPAHVRf3YpR7uvPm"
MAP_FOLDER_IDS[Town10HD]="1TsDKcTkZ7ROF2QI-7vs82YaRK8MG3MEq"

# Validate map name
if [ -z "${MAP_FOLDER_IDS[$MAP_NAME]+x}" ]; then
    echo "Error: Unknown map '${MAP_NAME}'"
    echo "Available maps: ${!MAP_FOLDER_IDS[*]}"
    exit 1
fi

# Download if map files are not already present
if [ ! -f "${MAP_PATH}/lanelet2_map.osm" ] || [ ! -f "${MAP_PATH}/pointcloud_map.pcd" ]; then
    echo "Downloading map ${MAP_NAME} from Google Drive..."
    FOLDER_ID="${MAP_FOLDER_IDS[$MAP_NAME]}"
    
    # Instructions for installing gdown:
    # sudo apt install pipx
    # pipx ensurepath
    # pipx install gdown

    # gdown --folder creates a subfolder matching the Drive folder name,
    # so it will download into carla_map/ and gdown will create the Town subfolder.
    gdown --folder "https://drive.google.com/drive/folders/${FOLDER_ID}" -O "carla_map/"
    echo "Download complete: ${MAP_PATH}"
else
    echo "Map ${MAP_NAME} already exists at ${MAP_PATH}, skipping download."
fi
