

Ce document détaille comment importer les données cadastrales dans la base PostGIS au SIGE.
Le but est d'avoir une procédure uniformisée pour l'import des données sur les 3 cantons (VD / FR / VS).


1. Commander les données au format **Interlis 1 au format national MD01MOCH24MN95F** et dans le système **MN95**.

	1.1 Vaud: sur le site de l'asit-vd

		* Commander la MO + le NPCS
		* En raison de la taille faire 2 commandes:

		  * Riviera (Chardonne, Chexbres, Rivaz, Saint-Saphorin (Lavaux), Puidoux, Corseaux, Jongny, Corsier-sur-Vevey, Vevey, Saint-Légier-La Chiésaz, La Tour-de-Peilz, Blonay, Montreux)
		  * Haut-Lac (Veytaux, Villeneuve (Vaud), Noville, Chessel, Rennaz, Roche (Vaud))

		* Dans le compte SIGE, il est possible de *remettre au panier* les anciennes commandes (date_mo_ch_region)

	1.2 Fribourg
		* Faire une demande au bureau Geosud (veveyse@geosud.ch) pour la commune d'Attalens selon le cadrage suivant: https://github.com/sige-riviera/cadastre/sige/zone_attalens.pdf

	1.3 Valais
	 	* Faire une commande auprès du bureau Vuadens (info@jmvuadens.ch) pour la commune de Port-Valais


2.  Intégrer les données dans la base PostGIS

  * L'intégration dans la base se fait via ogr2ogr (pour autre solutions voir (1)).
	* Cette solution nécessite GDAL minimum 2.0.4+ / 2.1.2+ (2)
	* Pour compiler en local, voir notes (3)
	* Lancer le script `ogr_ili1.sh`


(1) D'autres solutions sont envisageables pour importer les données
* **ili2pg** Solution interlis 1 (-> itf2xml -> interlis 2) -> ili2pg -> postgis
	* CETTE SOLUTION NE FONCTIONNE PAS ACTUELLEMENT (décembre 2016)
	voir https://www.interlis2.ch/index.php?p=/discussion/13/dangling-references
	1. Faire un fichier zip avec les fichiers ITF et ILI
	2. Lancer le script itf2xml.sh avec le nom du zip comme paramètre (voir doc itf2xml)
	3. Utiliser l'outil ili2pg avec `ili2pg_ili2.sh`
* **FME**
	* Le driver Interlis existe, mais cette voie n'a pas été explorée (non opensource, lenteur et no-CLI)

(2) Deux bugs ont été corrigé https://trac.osgeo.org/gdal/ticket/6688 et https://trac.osgeo.org/gdal/ticket/6728

(3) Compilation GDAL:
	- Télécharger source
	- Compiler avec prefix et xerces installé
		./configure --prefix=/home/drouzaud/Documents/data/cadastre/interlis/gdal-build
		make && make install
	- contrôler avec ogrinfo --formats | grep Interlis