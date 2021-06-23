

Ce document détaille comment importer les données cadastrales dans la base PostGIS au SIGE.
Le but est d'avoir une procédure uniformisée pour l'import des données sur les 3 cantons (VD / FR / VS).


## 1. Commander les données cadastrales

Les données doivent être commandées au format **Interlis 1 au format national MD01MOCH24MN95F** et dans le système **MN95**.

### 1.1. Vaud

Sur le site de l'Asit-VD, faire une commande **MO + NPCS**. En raison du volume de données, deux commandes doivent être réalisées

	- Riviera (Chardonne, Chexbres, Rivaz, Saint-Saphorin (Lavaux), Puidoux, Corseaux, Jongny, Corsier-sur-Vevey, Vevey, Saint-Légier-La Chiésaz, La Tour-de-Peilz, Blonay, Montreux)
	- Haut-Lac (Veytaux, Villeneuve (Vaud), Noville, Chessel, Rennaz, Roche (Vaud))

Dans le compte SIGE d'administration, il est possible de *remettre au panier* les anciennes commandes (date_mo_ch_region).

### 1.2. Fribourg

Depuis le 1er janvier 2021, il est possible de commander gratuitement les géodonnées de la mensuration officielle du canton de Fribourg au format Interlis, notamment à l'aide de l'extracteur cantonal de géodonnées de la MO : 
https://adm.appls.fr.ch/sit/extracteurmo/

Pour plus d'informations :
https://www.fr.ch/territoire-amenagement-et-constructions/cartes-plans-cadastre-et-geomatique/acces-aux-geodonnees-de-la-mensuration-officielle
https://www.fr.ch/dfin/scg/actualites/gratuite-des-geodonnees-pour-le-canton-de-fribourg) et d’un article  publiés sur le site fr.ch.

Le périmètre de commande doit comprendre les communes d'Attalens, de Remaufens et de Châtel-St-Denis.

Alternativement, il est possible de faire une demande au bureau Geosud (veveyse@geosud.ch) selon le cadrage suivant: https://github.com/sige-riviera/cadastre/blob/master/sige/zone_attalens.pdf

### 1.3. Valais

Les données cadastrales sont dorénavant centralisées au canton. Il est possible de commander les données pour la commune de Port-Valais auprès du service cantonal SITVS : SITVS@admin.vs.ch
Il est aussi possible de les commander depuis https://www.vs.ch/web/egeo/commande-geodonnees, un contrat doit toutefois être conclu.
Alternativement, il est possible de faire une commande auprès du bureau Vuadens (jmvuadens@geo4me.ch).


## 2. Intégrer les données dans la base PostGIS

L'intégration dans la base se fait via ogr2ogr (pour autre solutions voir 2.3).

	* Cette solution nécessite GDAL minimum 2.0.4+ / 2.1.2+ (2.2)
	* Pour compiler en local, voir notes (3)
	* Optionnellement, il est possible de recréer le fichier modèle (disponible sous  model/DM.01-AV-CH_LV95_24f_ili1.ili):
		* installer Java
		* télécharger ili2c sur cette page https://www.interlis.ch/interlis2/download23_f.php
		* activer la ligne commentée dans le script `ogr_ili1.sh`
		* ou lancer ̀directement ̀ java -jar ili2c-4.7.2/ili2c.jar --ilidirs '%ILI_DIR;http://models.interlis.ch/;%JAR_DIR' -oIMD --out moch.imd model/DM.01-AV-CH_LV95_24f_ili1.ili`
	* Déposer les fichiers sources dans le dossier data du dépot et les renommer comme suit (l'ordre n'a pas d'importance):
		* data/vd-1.itf (Riviera MO)
		* data/vd-2.itf (Riviera NPCS)
		* data/vd-3.itf (Haut-Lac MO)
		* data/vd-4.itf (Haut-Lac NPCS)
		* data/vs-1.itf (Port-Valais)
		* data/fr-1.itf (Attalens)
		* data/fr-2.itf (Remaufens)
		* data/fr-3.itf (Chatel-St-Denis)
	* Lancer le script `ogr_ili1.sh`


## 2.1. GDAL minimum 2.0.4+ / 2.1.2+

Deux bugs ont été corrigés par Even Rouault (Spatialys)

* https://trac.osgeo.org/gdal/ticket/6688
* https://trac.osgeo.org/gdal/ticket/6728

## 2.3 Compilation GDAL:
	- Télécharger source
	- Compiler avec prefix et xerces installé
		./configure --prefix=/home/drouzaud/Documents/data/cadastre/interlis/gdal-build
		make && make install
	- contrôler avec ogrinfo --formats | grep Interlis



### 2.3 Autres solutions

D'autres solutions sont envisageables pour importer les données

#### ili2pg

Solution interlis 1 (-> itf2xml -> interlis 2) -> ili2pg -> postgis
Cette solution ne fonctionne pas actuellement (décembre 2016), voir https://www.interlis2.ch/index.php?p=/discussion/13/dangling-references
Une nouvelle option -skipGeometryErros (mars 2017) permet peut-être de régler le problème.qui

	1. Faire un fichier zip avec les fichiers ITF et ILI
	2. Lancer le script itf2xml.sh avec le nom du zip comme paramètre (voir doc itf2xml)
	3. Utiliser l'outil ili2pg avec `ili2pg_ili2.sh`

#### FME

Le driver Interlis existe, mais cette voie n'a pas été explorée.
