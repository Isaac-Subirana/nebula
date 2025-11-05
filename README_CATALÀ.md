# Requeriments mínims del sistema
Siusplau, tingui present que aquests eren els requisits del sistema durant l'última actualització d'aquest README. Podria ser que haguessin canviat amb el temps.
* Un ordinador d'arquitectura x86-64 amb, com a mínim, 8 GB DE RAM. Es recomana tenir més de 16 GB de RAM, i tot i així el temps de compilació serà molt llarg. Més de 64 GB no són excessives, així com una CPU amb més de 20 nuclis tampoc no és excessiva.
* Com a mínim 100GB d'expai lliure al disc dur (en podeu trobar una descripció més detallada a les instruccions del projecte Chromium per al vostre sistema operatiu). Es recomana un SSD, per a un temps de descàrrega i compilació més petit.
* Tenir Git instal·lat (o [Git per a Windows](https://gitforwindows.org/) si compilarà Nebula des d'un ordinador amb Windows).

# Aplicacions recomanades
* [Everything](https://www.voidtools.com/downloads/) (si compilarà el Projecte des d'un ordinador amb Windows), molt útil per a trobar fitxers específics en carpetes grans (com ara Chromium).
* [Visual Studio Code](https://code.visualstudio.com/Download), per a buscar cadenes de text específiques i modificar-les en bloc. 
* [MSYS2](https://www.msys2.org/) (si compilarà Nebula des d'un ordinador amb Windows), per a executar _scripts_ `.sh` (relacionats amb canvis d'icones o alguns tests).

# Preparar-se i descarregar el codi font

Llegeixi i segueixi les instruccions sobre com descarregar-se el codi per al seu sistema operatiu, recollides a [la documentació del projecte Chromium (en anglès)](https://github.com/chromium/chromium/blob/main/docs/get_the_code.md).

### Si el seu ordinador utilitza Windows
Si el seu ordinador utilitza Windows com a sistema operatiu, a l'hora d'instal·lar els complements de `Visual Studio` necessaris, pot fer-ho des d'una interfície gràfica: 
* Obri `Visual Studio Installer` (Si ja el té instal·lat. Si no, se'l pot descarregar [des d'aquest enllaç](https://visualstudio.microsoft.com/downloads/)).
* Vagi a la pestanya "**_Workloads_**" (o "**_Cargas de trabajo_**") i seleccioni "**_Desktop development with C++_**" (o "**_Desarrollo de escritorio con C++_**").Asseguri's que els subcomponents on es mencioni "**_MFC_**" i "**_ATL_**" estiguin seleccionats. Asseguri's també que els components on es mencioni "**_SDK_**" i **la seva versió del sistema operatiu** estiguin seleccionats.

Segueixi tots els passos per a configurar el seu sistema i descarregar-se el codi, fins a arribar a l'apartat `Setting up the build`.

# Modificacions
**Tot seguit, llistarem les modificacions a aplicar a al codi font de Chromium per a obtenir Nebula. Si només vol compilar Chromium, o si vol compilar Chromium abans de aplicar les modificacions al codi font i recompilar-lo després, pot anar directament [a l'apartat corresponent d'aquest README]().

# Compilació de Chromium
Un cop dutes a terme les modificacions al codi font proposades, ja pot compilar el projecte, i obtindrà el navegador Nebula.

Per fer-ho, segueixi les instruccions proporcionades [al document referent al seu sistema operatiu](https://github.com/chromium/chromium/blob/main/docs/get_the_code.md) des de l'apartat `Setting up the build`.