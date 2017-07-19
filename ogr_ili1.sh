#!/bin/bash
set -e


DIR=$(git rev-parse --show-toplevel)

# Prefix for local GDAL build, not needed for 2.0.4+ / 2.1.2+
PREFIX=${DIR}/gdal-build
export PATH=$PREFIX/bin:$PATH
export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH
export GDAL_DATA=$PREFIX/share/gdal

# java -jar ili2c-4.5.22/ili2c.jar --ilidirs '%ILI_DIR;http://models.interlis.ch/;%JAR_DIR' -oIMD --out moch.imd model/DM.01-AV-CH_LV95_24f_ili1.ili
# java -jar ili2c-4.5.22/ili2c.jar --ilidirs '%ILI_DIR;http://models.interlis.ch/;%JAR_DIR;${DIR}/model' -oIMD --out movd.imd model/MD01MOVDMN95V24.ili

export PGSERVICE=cadastre


# VAUD
psql -c "DROP SCHEMA IF EXISTS vaud CASCADE; CREATE SCHEMA vaud;"
#echo "*** VD-1 ***"
./gdal-build/bin/ogr2ogr -lco SCHEMA=vaud   --config OGR_STROKE_CURVE TRUE -a_srs "EPSG:2056" -gt 20000 -append -f PostgreSQL "PG:dbname=cadastre active_schema=vaud" data/vd-1.itf,moch.imd
#echo "*** VD-2 ***"
./gdal-build/bin/ogr2ogr -lco SCHEMA=vaud   --config OGR_STROKE_CURVE TRUE -a_srs "EPSG:2056" -gt 20000 -append -f PostgreSQL "PG:dbname=cadastre active_schema=vaud" data/vd-2.itf,moch.imd
#echo "*** VD-3 ***"
./gdal-build/bin/ogr2ogr -lco SCHEMA=vaud   --config OGR_STROKE_CURVE TRUE -a_srs "EPSG:2056" -gt 20000 -append -f PostgreSQL "PG:dbname=cadastre active_schema=vaud" data/vd-3.itf,moch.imd
#echo "*** VD-4 ***"
./gdal-build/bin/ogr2ogr -lco SCHEMA=vaud   --config OGR_STROKE_CURVE TRUE -a_srs "EPSG:2056" -gt 20000 -append -f PostgreSQL "PG:dbname=cadastre active_schema=vaud" data/vd-4.itf,moch.imd

# VALAIS
psql -c "DROP SCHEMA IF EXISTS valais CASCADE; CREATE SCHEMA valais;"
#echo "*** Port-Valais ***"
./gdal-build/bin/ogr2ogr -lco SCHEMA=valais --config OGR_STROKE_CURVE TRUE -a_srs "EPSG:2056" -gt 20000 -append -f PostgreSQL "PG:dbname=cadastre active_schema=valais" data/vs.itf,moch.imd


# FRIBOURG
psql -c "DROP SCHEMA IF EXISTS fribourg CASCADE; CREATE SCHEMA fribourg;"
#echo "*** Fribourg Attalens, Remaufens ***"
./gdal-build/bin/ogr2ogr -lco SCHEMA=fribourg --config OGR_STROKE_CURVE TRUE -a_srs "EPSG:2056" -gt 20000 -append -f PostgreSQL "PG:dbname=cadastre active_schema=fribourg" data/fr-1.itf,moch.imd
./gdal-build/bin/ogr2ogr -lco SCHEMA=fribourg --config OGR_STROKE_CURVE TRUE -a_srs "EPSG:2056" -gt 20000 -append -f PostgreSQL "PG:dbname=cadastre active_schema=fribourg" data/fr-2.itf,moch.imd



# CREATE MATERIALIZED VIEWS
psql -v ON_ERROR_STOP=1 -f ab_rue.sql
psql -v ON_ERROR_STOP=1 -f bf_immeuble.sql
psql -v ON_ERROR_STOP=1 -f bf_point_limite.sql
psql -v ON_ERROR_STOP=1 -f cs_couverture_sol.sql
psql -v ON_ERROR_STOP=1 -f no_nomenclature.sql
psql -v ON_ERROR_STOP=1 -f od_element_lineaire.sql
psql -v ON_ERROR_STOP=1 -f od_element_surfacique.sql
psql -v ON_ERROR_STOP=1 -f od_entree_batiment.sql
psql -v ON_ERROR_STOP=1 -f pf_points_fixes.sql
