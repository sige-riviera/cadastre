#!/bin/bash
set -e


# DATA="data/6154_MD01MOCHv24_f.itf"

# PortValais - MDVS
DATA="data/6154_MD01MOVSv2_f.ITF"
MODEL="/home/drouzaud/Documents/data/cadastre/interlis/ --models MD01MOVSMN952F"

# VD ILI1 MDCH
DATA=data/vd-1.itf
MODEL="http://models.geo.admin.ch --models MD01MOCH24MN95F"

# VD ILI2 MDCH
# DATA=data-ili2/2060_16091216013451.xml
# MODEL="http://models.geo.admin.ch --models MD01MOCH24MN95F"

TRACE=

java -jar ili2pg-3.4.0/ili2pg.jar --dbhost 172.24.171.203 --dbport 5432 --dbdatabase cadastre --dbusr sige --dbpwd db4wat$ --nameByTopic --sqlEnableNull --createFkIdx --createGeomIdx --defaultSrsAuth EPSG --defaultSrsCode 2056 --modeldir $MODEL --dbschema av_2495 --import $TRACE $DATA
