#!/bin/bash
set -e


# DATA="data/6154_MD01MOCHv24_f.itf"

# PortValais - MDVS
DATA="data/6154_MD01MOVSv2_f.ITF"
MODEL="/home/drouzaud/Documents/data/cadastre/interlis/model --models MD01MOVSMN952F"

# VD ILI1 MDCH
DATA=data/vd-1.itf
DATA="/home/drouzaud/Documents/data/cadastre/interlis/data/vd-new/Cad_MO/218456_16111711295719.itf"
MODEL="http://models.geo.admin.ch --models MD01MOCH24MN95F"

# VD ILI1 MDVD 95
#DATA=data/vd_movd.itf
#MODEL="/home/drouzaud/Documents/data/cadastre/interlis/model --models MD01MOVDMN95V24"

# VD ILI1 MDVD 03
DATA=/home/drouzaud/Documents/data/cadastre/interlis/data/data_carto/MO/8.itf
MODEL="/home/drouzaud/Documents/data/cadastre/interlis/model --models MD01MOVD"

# VD ILI2 MDCH
# DATA=data-ili2/2060_16091216013451.xml
# MODEL="http://models.geo.admin.ch --models MD01MOCH24MN95F"

#TRACE=--trace

java -jar ili2pg-3.4.1/ili2pg.jar --dbhost 172.24.171.203 --dbport 5432 --dbdatabase cadastre --dbusr sige --dbpwd db4wat$ --skipPolygonBuilding --nameByTopic --sqlEnableNull --createFkIdx --createGeomIdx --defaultSrsAuth EPSG --defaultSrsCode 2056 --modeldir $MODEL --dbschema vaud --import $TRACE $DATA
