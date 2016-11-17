#!/bin/bash
set -e


PREFIX=/home/drouzaud/Documents/data/cadastre/interlis/gdal-build

export PATH=$PREFIX/bin:$PATH
export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH
export GDAL_DATA=$PREFIX/share/gdal

# java -jar ili2c-4.5.22/ili2c.jar --ilidirs '%ILI_DIR;http://models.interlis.ch/;%JAR_DIR' -oIMD --out moch.imd model/DM.01-AV-CH_LV95_24f_ili1.ili
# java -jar ili2c-4.5.22/ili2c.jar --ilidirs '%ILI_DIR;http://models.interlis.ch/;%JAR_DIR;/home/drouzaud/Documents/data/cadastre/interlis/model' -oIMD --out movd.imd model/MD01MOVDMN95V24.ili

export PGSERVICE=cadastre

psql -c "DROP SCHEMA IF EXISTS vaud CASCADE; CREATE SCHEMA vaud;"
psql -c "DROP SCHEMA IF EXISTS valais CASCADE; CREATE SCHEMA valais;"
psql -c "DROP SCHEMA IF EXISTS fribroug CASCADE; CREATE SCHEMA fribroug;"

#echo "*** Port-Valais ***"
./gdal-build/bin/ogr2ogr -lco SCHEMA=valais --config OGR_STROKE_CURVE TRUE -a_srs "EPSG:2056" -gt 20000 -append -f PostgreSQL "PG:dbname=cadastre active_schema=valais" data/vs_moch.itf,moch.imd
#echo "*** VD-1 ***"      
./gdal-build/bin/ogr2ogr -lco SCHEMA=vaud   --config OGR_STROKE_CURVE TRUE -a_srs "EPSG:2056" -gt 20000 -append -f PostgreSQL "PG:dbname=cadastre active_schema=vaud" data/vd-1.itf,moch.imd
#echo "*** VD-2 ***"      
./gdal-build/bin/ogr2ogr -lco SCHEMA=vaud   --config OGR_STROKE_CURVE TRUE -a_srs "EPSG:2056" -gt 20000 -append -f PostgreSQL "PG:dbname=cadastre active_schema=vaud" data/vd-2.itf,moch.imd

#./gdal-build/bin/ogr2ogr -lco SCHEMA=vaud   --config OGR_STROKE_CURVE TRUE -a_srs "EPSG:2056" -gt 20000 -append -f PostgreSQL "PG:dbname=cadastre active_schema=vaud" data/vd_movd.itf,movd.imd

psql -f cadastre.sql -v ON_ERROR_STOP=ON
