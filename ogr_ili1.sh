#!/bin/bash
set -e


DIR=$(git rev-parse --show-toplevel)

# Prefix for local GDAL build, not needed for 2.0.4+ / 2.1.2+
#PREFIX=${DIR}/gdal-build
#export PATH=$PREFIX/bin:$PATH
#export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH
#export GDAL_DATA=$PREFIX/share/gdal

# Create model file
#java -jar ili2c-4.7.2/ili2c.jar --ilidirs '%ILI_DIR;http://models.interlis.ch/;%JAR_DIR' -oIMD --out moch.imd model/DM.01-AV-CH_LV95_24f_ili1.ili

# Define PGSERVICE to import data
export PGSERVICE=cadastre_update


# VAUD
psql -c "DROP SCHEMA IF EXISTS vaud CASCADE; CREATE SCHEMA vaud;"
#echo "*** VD-1 ***"
ogr2ogr -lco SCHEMA=vaud --config OGR_STROKE_CURVE TRUE -a_srs "EPSG:2056" -gt 20000 -append -f PostgreSQL "PG:dbname=cadastre_update active_schema=vaud" data/vd-1.itf,moch.imd
#echo "*** VD-2 ***"
ogr2ogr -lco SCHEMA=vaud --config OGR_STROKE_CURVE TRUE -a_srs "EPSG:2056" -gt 20000 -append -f PostgreSQL "PG:dbname=cadastre_update active_schema=vaud" data/vd-2.itf,moch.imd
#echo "*** VD-3 ***"
ogr2ogr -lco SCHEMA=vaud --config OGR_STROKE_CURVE TRUE -a_srs "EPSG:2056" -gt 20000 -append -f PostgreSQL "PG:dbname=cadastre_update active_schema=vaud" data/vd-3.itf,moch.imd
#echo "*** VD-4 ***"
ogr2ogr -lco SCHEMA=vaud --config OGR_STROKE_CURVE TRUE -a_srs "EPSG:2056" -gt 20000 -append -f PostgreSQL "PG:dbname=cadastre_update active_schema=vaud" data/vd-4.itf,moch.imd

# VALAIS
psql -c "DROP SCHEMA IF EXISTS valais CASCADE; CREATE SCHEMA valais;"
#echo "*** Port-Valais ***"
ogr2ogr -lco SCHEMA=valais --config OGR_STROKE_CURVE TRUE -a_srs "EPSG:2056" -gt 20000 -append -f PostgreSQL "PG:dbname=cadastre_update active_schema=valais" data/vs-1.itf,moch.imd


# FRIBOURG
psql -c "DROP SCHEMA IF EXISTS fribourg CASCADE; CREATE SCHEMA fribourg;"
#echo "*** Fribourg Attalens, Remaufens, Chatel ***"
ogr2ogr -lco SCHEMA=fribourg --config OGR_STROKE_CURVE TRUE -a_srs "EPSG:2056" -gt 20000 -append -f PostgreSQL "PG:dbname=cadastre_update active_schema=fribourg" data/fr-1-attalens.itf,moch.imd
ogr2ogr -lco SCHEMA=fribourg --config OGR_STROKE_CURVE TRUE -a_srs "EPSG:2056" -gt 20000 -append -f PostgreSQL "PG:dbname=cadastre_update active_schema=fribourg" data/fr-2-remaufens.itf,moch.imd
ogr2ogr -lco SCHEMA=fribourg --config OGR_STROKE_CURVE TRUE -a_srs "EPSG:2056" -gt 20000 -append -f PostgreSQL "PG:dbname=cadastre_update active_schema=fribourg" data/fr-3-chatel.itf,moch.imd



# CREATE MATERIALIZED VIEWS
psql -v ON_ERROR_STOP=1 -f sql/ab_rue.sql
psql -v ON_ERROR_STOP=1 -f sql/bf_immeuble.sql
psql -v ON_ERROR_STOP=1 -f sql/bf_point_limite.sql
psql -v ON_ERROR_STOP=1 -f sql/cs_couverture_sol.sql
psql -v ON_ERROR_STOP=1 -f sql/lc_communes.sql
psql -v ON_ERROR_STOP=1 -f sql/no_nomenclature.sql
psql -v ON_ERROR_STOP=1 -f sql/od_element_lineaire.sql
psql -v ON_ERROR_STOP=1 -f sql/od_element_surfacique.sql
psql -v ON_ERROR_STOP=1 -f sql/od_entree_batiment.sql
psql -v ON_ERROR_STOP=1 -f sql/pf_points_fixes.sql
