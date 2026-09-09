# Project Root
ENV_PATH=`realpath ${0//-}` # In tmux, $0 will become -bash, so we need to remove -
export AUTOWARE_CARLA_ROOT=`dirname ${ENV_PATH}`

# Setup environmental variables for different environments
shell=`cat /proc/$$/cmdline | tr -d '\0' | tr -d '-'`
if [ -f /opt/zenoh-carla-bridge ]; then   # Python agent & zenoh_carla_bridge

    # Export Carla simulator IP
    export CARLA_SIMULATOR_IP=127.0.0.1

    # pyenv path (Only needed while using docker)
    if [ -f /.dockerenv ]; then
        PYENV_PATH=${AUTOWARE_CARLA_ROOT}/pyenv

        export PYENV_ROOT="${PYENV_PATH}"
        export PATH="${PYENV_ROOT}/bin:$PATH"
    fi

    # Environmental variables to build carla-sys
    export LLVM_CONFIG_PATH=/usr/bin/llvm-config-12
    export LIBCLANG_PATH=/usr/lib/llvm-12/lib
    export LIBCLANG_STATIC_PATH=/usr/lib/llvm-12/lib
    export CLANG_PATH=/usr/bin/clang-12

    # Export the config of zenoh-carla-bridge
    export ZENOH_CARLA_BRIDGE_CONFIG=${AUTOWARE_CARLA_ROOT}/config/zenoh-carla-bridge-conf.json5
    export RMW_ZENOH_CARLA_BRIDGE_CONFIG=${AUTOWARE_CARLA_ROOT}/config/rmw-zenoh-carla-bridge-conf.json5

else  # zenoh-bridge-ros2dds & Autoware

    # Source workspace after build
    if [ -f ${AUTOWARE_CARLA_ROOT}/install/setup.${shell} ]; then
        source ${AUTOWARE_CARLA_ROOT}/install/setup.${shell}
    fi

    # Export the config of zenoh-bridge-ros2dds
    export ZENOH_BRIDGE_ROS2DDS_CONFIG=${AUTOWARE_CARLA_ROOT}/config/zenoh-bridge-ros2dds-conf.json5

    # ROS configuration
    export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
    export ROS_AUTOMATIC_DISCOVERY_RANGE=LOCALHOST
    # Workaround for Cyclone DDS participant limit in Jazzy: https://github.com/autowarefoundation/autoware/issues/6759
    export CYCLONEDDS_URI='<CycloneDDS><Domain><Discovery><ParticipantIndex>auto</ParticipantIndex><MaxAutoParticipantIndex>1000</MaxAutoParticipantIndex></Discovery></Domain></CycloneDDS>'
    # Enable multicast for DDS (done by base image's /docker-entrypoint.sh since 1.8.0)
    # sudo ip link set lo multicast on
fi

# Able to access binary after pip install
export PATH="$HOME/.local/bin:$PATH"

# Export Map path
export CARLA_MAP_NAME="${CARLA_MAP_NAME:-Town01}"
export CARLA_MAP_PATH=${AUTOWARE_CARLA_ROOT}/carla_map/${CARLA_MAP_NAME}

# Vehicle blueprint filter (CARLA blueprint ID)
# VEHICLE_BLUEPRINTS = [
#     "vehicle.audi.a2",
#     "vehicle.audi.etron",
#     "vehicle.audi.tt",
#     "vehicle.bh.crossbike",
#     "vehicle.bmw.grandtourer",
#     "vehicle.carlamotors.carlacola",
#     "vehicle.carlamotors.european_hgv",
#     "vehicle.carlamotors.firetruck",
#     "vehicle.chevrolet.impala",
#     "vehicle.citroen.c3",
#     "vehicle.diamondback.century",
#     "vehicle.dodge.charger_2020",
#     "vehicle.dodge.charger_police",
#     "vehicle.dodge.charger_police_2020",
#     "vehicle.ford.ambulance",
#     "vehicle.ford.crown",
#     "vehicle.ford.mustang",
#     "vehicle.gazelle.omafiets",
#     "vehicle.harley-davidson.low_rider",
#     "vehicle.jeep.wrangler_rubicon",
#     "vehicle.kawasaki.ninja",
#     "vehicle.lincoln.mkz_2017",
#     "vehicle.lincoln.mkz_2020",
#     "vehicle.mercedes.coupe",
#     "vehicle.mercedes.coupe_2020",
#     "vehicle.mercedes.sprinter",
#     "vehicle.micro.microlino",
#     "vehicle.mini.cooper_s",
#     "vehicle.mini.cooper_s_2021",
#     "vehicle.mitsubishi.fusorosa",
#     "vehicle.nissan.micra",
#     "vehicle.nissan.patrol",
#     "vehicle.nissan.patrol_2021",
#     "vehicle.seat.leon",
#     "vehicle.tesla.cybertruck",
#     "vehicle.tesla.model3",
#     "vehicle.toyota.prius",
#     "vehicle.vespa.zx125",
#     "vehicle.volkswagen.t2",
#     "vehicle.volkswagen.t2_2021",
#     "vehicle.yamaha.yzf",
# ]

export CARLA_VEHICLE_FILTER="${CARLA_VEHICLE_FILTER:-vehicle.tesla.model3}"

# Weather preset name (must match a carla.WeatherParameters attribute)
# WEATHER_PRESETS = [
#     "Default",
#     "ClearNoon",
#     "CloudyNoon",
#     "WetNoon",
#     "WetCloudyNoon",
#     "MidRainyNoon",
#     "HardRainNoon",
#     "SoftRainNoon",
#     "ClearSunset",
#     "CloudySunset",
#     "WetSunset",
#     "WetCloudySunset",
#     "MidRainSunset",
#     "HardRainSunset",
#     "SoftRainSunset",
#     "ClearNight",
#     "CloudyNight",
#     "WetNight",
#     "WetCloudyNight",
#     "SoftRainNight",
#     "MidRainyNight",
#     "HardRainNight",
#     "DustStorm",
# ]
# Set to empty string or "Default" to use CARLA's default weather

export CARLA_WEATHER="${CARLA_WEATHER:-ClearNoon}"

# Set Autoware Settings (Can be overwritten by CLI)
export ROS_DOMAIN_ID=0
export VEHICLE_NAME="v1"

# Set the ccache directory to /tmp to avoid permission issue
export CCACHE_DIR=/tmp/ccache

# Enable/Disable lidar detection model functionality ("centerpoint", "apollo", "transfusion", or "disable")
export LIDAR_DETECTION_MODEL="clustering"

# Set centerpoint model ("centerpoint", "centerpoint_tiny")
# It is used when LIDAR_DETECTION_MODEL is set as "centerpoint"
export CENTERPOINT_MODEL_NAME="centerpoint_tiny"

# Rust & uv path (Only needed while using docker)
if [ -f /.dockerenv ]; then
    RUST_PATH=${AUTOWARE_CARLA_ROOT}/rust
    UV_PATH=${AUTOWARE_CARLA_ROOT}/uv

    export RUSTUP_HOME=${RUST_PATH}
    export CARGO_HOME=${RUST_PATH}
    export UV_INSTALL_DIR=${UV_PATH}/bin
    export PATH="${RUST_PATH}/bin:${UV_PATH}/bin:$PATH"
fi
