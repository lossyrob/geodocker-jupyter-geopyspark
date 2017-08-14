#!/usr/bin/env bash

USER=$1
GROUP=$2
BLOB=$3
GEOPYSPARK=$4
GEOPYSPARK_NETCDF=$5

export CPPFLAGS="-I$HOME/local/gdal/include"
export CFLAGS="-I$HOME/local/gdal/include"
export LDFLAGS="-I$HOME/local/gdal/lib"

# aquire
chown -R root:root $HOME/.local

set -x

# install geopsypark
cd $HOME
unzip -q /archives/geopyspark-${GEOPYSPARK}.zip
unzip -q /archives/geopyspark-netcdf-${GEOPYSPARK_NETCDF}.zip
cd ../geopyspark-netcdf-${GEOPYSPARK_NETCDF}/
pip3 install --user .
cd geopyspark-${GEOPYSPARK}/
make wheel
pip3 install --user --force dist/*

set +x

# archive libraries
cd $HOME/.local/lib/python3.4/site-packages
tar acf /archives/$BLOB $(find | grep geopyspark)

# release
chown -R $USER:$GROUP /archives $HOME/.local
