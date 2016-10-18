#!/bin/bash
set -e


PREFIX=/home/drouzaud/Documents/data/cadastre/interlis/gdal-build

export PATH=$PREFIX/bin:$PATH
export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH
export GDAL_DATA=$PREFIX/share/gdal

# java -jar ili2c-4.5.22/ili2c.jar --ilidirs '%ILI_DIR;http://models.interlis.ch/;%JAR_DIR' -oIMD --out bdco.imd DM.01-AV-CH_LV95_24f_ili1.ili

export PGSERVICE=cadastre

psql -c "DROP SCHEMA IF EXISTS cadastre CASCADE"
psql -c "CREATE SCHEMA cadastre"


./gdal-build/bin/ogr2ogr -a_srs "EPSG:2056" -gt 20000 -lco schema=cadastre                 -f PostgreSQL PG:dbname=cadastre data/vd-1.itf,bdco.imd
./gdal-build/bin/ogr2ogr -a_srs "EPSG:2056" -gt 20000 -lco schema=cadastre -update -append -f PostgreSQL PG:dbname=cadastre data/vd-2.itf,bdco.imd
./gdal-build/bin/ogr2ogr -a_srs "EPSG:2056" -gt 20000 -lco schema=cadastre -update -append -f PostgreSQL PG:dbname=cadastre data/port-valais.itf,bdco.imd


