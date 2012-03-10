=======================================================================================================================================
ICOS Carbon Data Portal: Repositorio integrado de mediciones sobre gases de efecto invernadero a disposición de la comunidad científica
﻿=======================================================================================================================================

.. rubric::
   O. Fonts, M. García, F. González :sup:`(1)`, J. Piera, J. Sorribas, J. Olivé :sup:`(2)`

.. highlights::
   :sup:`(1)` Red de desarrolladores SIG independientes geomati.co. http://www.geomati.co {oscar.fonts, micho.garcia, fernando.gonzalez} @geomati.co.

   :sup:`(2)` Unidad de Tecnología Marina, Departamento de Telemática. Centro Superior de Investigaciones Científicas. http://www.utm.csic.es utmtel@utm.csic.es


.. epigraph::

   **RESUMEN**

   La infraestructura europea `ICOS (Integrated Carbon Observation System) <http://www.icos-infrastructure.eu>`_, tiene como misión proveer de mediciones de gases de efecto invernadero a largo plazo, lo que ha de permitir estudiar el estado actual y comportamiento futuro del ciclo global del carbono.

   En este contexto, `geomati.co <http://geomati.co>`_ ha desarrollado un portal de búsqueda y descarga de datos que integre las mediciones realizadas en los ámbitos terrestre, marítimo y atmosférico, disciplinas que hasta ahora habían gestionado los datos de forma separada.

   El portal permite hacer búsquedas por múltiples ámbitos geográficos, por rango temporal, por texto libre o por un subconjunto de magnitudes, realizar vistas previas de los datos, y añadir los conjuntos de datos que se crean interesantes a un “*carrito*” de descargas.

   En el momento de realizar la descarga de una colección de datos, se le asignará un identificador universal que permitirá referenciarla en eventuales publicaciones, y repetir su descarga en el futuro (de modo que los experimentos publicados sean reproducibles).

   El portal se apoya en formatos abiertos de uso común en la comunidad científica, como el formato `NetCDF <http://www.unidata.ucar.edu/software/netcdf/>`_ para los datos, y en el `perfil ISO de CSW <http://www.opengeospatial.org/standards/cat>`_, estándar de catalogación y búsqueda propio del ámbito geoespacial. El portal se ha desarrollado partiendo de componentes de software libre existentes, como `Thredds Data Server <http://www.unidata.ucar.edu/projects/THREDDS/>`_, `GeoNetwork Open Source <http://geonetwork-opensource.org/>`_ y `GeoExt <http://geoext.org/>`_, y su código y documentación quedarán publicados bajo una licencia libre para hacer posible su reutilización en otros proyectos.

   **Palabras clave:** ICOS, Carbon, data portal, Thredds, Geonetwork.


Introducción
============

This is a footnote [#]_. This is a citation [CITE]_.


.. [#] The autonumeric footnote.

.. [CITE] A citation.



Escenario
---------

Partimos de una colección compleja y heterogénea de de datasets. Se diferencian dos grandes grupos:

1. Datos del contínuo (underway): Sets de datos más sencillos, que no son los que nos interesan en esta primera aproximación. Almacenados en bases de datos PostGIS, accessibles mediante servicios web OGC (WMS, WFS y WCS) publicados en un GeoServer.

2. Datos más complejos (4 o más dimensiones): ficheros netCDF con un contenido muy diverso: datos marinos, atmosféricos, y terrestres. Los ficheros netCDF se sirven con Thredds. Estos ficheros son los que nos interesan. La lástima es que no podemos servir todo con GeoServer, por ejemplo.


Portal
------

El portal consistiría en una primera pantalla de login para validar el usuario. A continuación habría dos opciones:

 1. Realizar una búsqueda de datos.
 2. Recuperar búsqueda guardada por su identificador QI (Query Identifier).


Pantalla de búsqueda
--------------------

Permite seleccionar por:
 
 * Rango temporal: fecha inicial – fecha final.
 * Boundig Box: buscar en un área geográfica. La particularidad en este caso sería permitir definir múltiples cajas de búsqueda simultáneas.
 * Selección de variables: qué variables queremos recuperar: temperatura, salinidad, velocidad del viento, etc. Las variables se han de buscar dentro del fichero netCDF (¿definiendo consultas con ncML?). El listado de posibles variables se lee de un fichero XML del tipo::

    <term>
      <sado_term>salinidad</sado_term>
      <nc_term>sea_water_salinity</nc_term>
      <nc_long_term>sea water salinity</nc_long_term>
      <nc_units>psu</nc_units>
      <nc_data_type>DOUBLE</nc_data_type>
      <nc_coordinate_axis_type></nc_coordinate_axis_type>
    </term>
    <term>
      <sado_term>temperatura</sado_term>
      <nc_term>sea_water_temperature</nc_term>
      <nc_long_term>sea water temperature</nc_long_term>
      <nc_units>degree_Celsius</nc_units>
      <nc_data_type>DOUBLE</nc_data_type>
      <nc_coordinate_axis_type></nc_coordinate_axis_type>
    </term>
    [...]

Una vez realizada la búsqueda, se descargan los datos que corresponden al filtro. Con otro botón se genera un identificador de búsqueda (QI) de manera que se pueda reproducir la búsqueda y recuperar la misma colección de datos posteriormente. El QI se genera llamando a un servicio externo. La aplicación de búsqueda deberá almacenar el QI junto con los datos recuperados y los criterios de búsqueda utilizados, el usuario que ha realizado la búsqueda, etc.


Recuperar la búsqueda a partir de un QI
---------------------------------------

Otro usuario podría introducir el QI, de modo que el formulario muester los criterios de búsqueda utlizados, así como un enlace a la colección de datos que se recuperaron en su momento. El objetivo es que las búsquedas sean reproducibles, y los criterios de búsqueda recuperables.


Report
------

Report en PDF: Un usuario validado puede ver con cuántos QI está relacionado. O, dicho de otro modo, un publicador de datos puede ver en qué búsquedas aparecen datos suyos, y un consumidor de datos puede consultar sus búsquedas y descargas anteriores.


Esquema de bloques
------------------

.. image:: img/dataportal.*
   :width: 900 px
   :alt: esquema de bloques de la aplicación *data portal*
   :align: center
﻿.. |TDS| replace:: *Thredds*
.. |GN|  replace:: *GeoNetwork*
.. |GS|  replace:: *GeoServer*
.. |PG|  replace:: *PostgreSQL*
.. |DP|  replace:: *Data Portal*
.. |TCT| replace:: *Tomcat*


Instalación
===========

|TCT| y Java
-------------

Instalación de JAVA de SUN
^^^^^^^^^^^^^^^^^^^^^^^^^^

Utilizando los repositorios de Ubuntu
"""""""""""""""""""""""""""""""""""""

Primero instalaremos la versión necesaria de Java, en este caso la 6. Para ello teclearemos en la terminal::

	$ sudo apt-get install sun-java6-jdk sun-java6-bin sun-java6-jre

Comprobaremos que Ubuntu está utilizando la versión que nos interesa de Java y no la que lleva instalada por defecto. Para ello indicamos en la terminal::

	$ java -version

que nos mostrará el mensaje::

	java version "1.6.0_26"
	Java(TM) SE Runtime Environment (build 1.6.0_26-b03)
	Java HotSpot(TM) Client VM (build 20.1-b02, mixed mode, sharing)

indicando nuestra versión de Java. En caso contrario será necesario instalar nuestra vesión como alternativa. Para ello primero comprobamos las alternativas que está utilizando. Accedemos a la ruta::
	
	$ cd /etc/alternatives

y mostramos las que nos interesan::

	$ ls -la ja*

podremos observar que alternativa de java está disponible::

	java -> /usr/lib/jvm/java-6-openjdk/jre/bin/java

para modificar esta debemos primero instalar nuestra versión de java como alternativa::

	$ sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-6-sun/jre/bin/java 1

y después asignaremos esta alternativa::

	$ sudo update-alternatives --set java /usr/lib/jvm/java-6-sun/jre/bin/java

ahora podemos comprobar a que máquina de Java apunta::

	java -> /usr/lib/jvm/java-6-sun/jre/bin/java

    
Descargando Java
""""""""""""""""

.. WARNING::
   Si ya se ha instalado java mediante apt-get (apartado anterior), esto no hace falta.

Primero descargaremos la versión de Java que nos interesa desde::

	http://www.oracle.com/technetwork/java/javase/downloads/jdk-6u27-download-440405.html

Accedemos a la carpeta de descarga del archivo y modificamos su permiso de ejecución::

	$ sudo chmod +x <nombre del archivo>

y ejecutamos::
	
	$ sudo ./<nombre del archivo>

este paso nos solicitará nuestra confirmación y descomprimirá los archivos en una carpeta en el mismo directorio donde lo hayamos ejecutado. Movemos esa carpeta a una localización mas acorde::

	$ mv <ruta de la carpeta> /usr/lib/jvm

después realizaremos los mismos pasos para asignar la alternativa que en el caso anterior.

 
**Referencias**

*	Cambiar las preferencias de Java (alternatives) en Debian/Ubuntu [1]_
*	Instalación de Java Guia-Ubuntu [2]_

	
Instalación de Tomcat
^^^^^^^^^^^^^^^^^^^^^

Instalación desde los repositorios
""""""""""""""""""""""""""""""""""

Abrimos un terminal y tecleamos::
	
	$ sudo apt-get install tomcat6

de esta manera instalaremos |TCT|. Para comprobar que la instalación es correcta::

	http://localhost:8080

apareciendo el mensaje **It works!**.
Esta instalación de |TCT| crea la siguiente estructura de directorios que mas adelante nos hará falta conocer::

	Directorio de logs; logs --> /var/lib/tomcat6/logs
	Directorio de configuracion; conf --> /var/lib/tomcat6/conf
	Directorio de aplicaciones; webapps --> /var/lib/tomcat6/webapps

La instalación creara un usuario y un grupo, tomcat6::tomcat6. Para arrancar/parar o reiniciar esta instancia de |TCT|::

	$ sudo /etc/init.d/tomcat6 [start|stop|restart]

Para acceder al manager de |TCT| primero instalaremos la aplicación necesaria para gestionar el servidor. Para ello tecleamos desde una terminal::

	$ sudo apt-get install tomcat6-admin

Una vez instalado incluiremos en el archivo /var/lib/tomcat6/conf/tomcat-users.xml el rol y el usuario necesario para acceder a la aplicación. Para ello incluiremos bajo la raiz <tomcat-users> lo siguiente::

	<role rolename="tomcat"/>
	<role rolename="manager"/>
	<user username="icos" password="XXXX" roles="tomcat,manager"/>

Reiniciaremos el servidor y probamos el acceso a través de::

	http://localhost:8080/manager/html

e introduciremos los datos incluidos en el fichero tomcat-users.xml

La configuración de GeoServer se hará entrando como admin en: http://localhost:8080/geoserver/web/


|GS|
----

Publicación de capas base para |GN| y |DP|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Tanto la interfaz web de |GN| como el |DP| utilizan de un par de capas de base:

* gn:world: Capa de origen raster con el Blue Marble de la NASA.
* gn:gboundaries: Capa de origen vectorial con las fronteras de los países.

La forma más cómoda de incorporar estas capas es a partir de una distribución *con instalador* de |GN|. El instalador incluye un directorio **geoserver_data** que puede copiarse tal cual en algún lugar del servidor. El usuario tomcat6 debe tener permisos de escritura sobre todo el contenido del directorio::

    $ chown -R tomcat6:tomcat6 .
    
Además, debe editarse el parámetro GEOSERVER_DATA_DIR dentro de la instalación de GeoServer, en WEB-INF/web.xml::

    <web-app>
      ...
      <context-param>
        <param-name>GEOSERVER_DATA_DIR</param-name>
        <param-value>/home/icos/data/geoserver_data</param-value>
      </context-param>
      ...
    </web-app>

.. WARNING::
   La copia directa del **geoserver_data** se ha probado con las versiones de |GN| 2.6.4 y |GS| 2.1.x.


Configuración inicial
^^^^^^^^^^^^^^^^^^^^^

Metadatos de servicio
"""""""""""""""""""""

En Servidor => Información de Contacto, pondremos los datos de contacto que queremos que aparezcan en los documentos de GetCapabilities de los servicios OGC.
 
.. image:: img/geoserver-contactinfo.png
    :width: 480 px
    :alt: Servidor => Información de contacto
    :align: center

Por ejemplo:

    * Persona de contacto: Jordi Sorribas
    * Organización: Unidad de Tecnología Marina, CSIC
    * Posición: Responsable servicios telemáticos
    * Tipo de dirección: postal
    * Dirección: Pg. Maritim de la Barceloneta 37-49
    * Ciudad: Barcelona
    * Estado o provincia: Barcelona
    * Código postal o ZIP: E-08003
    * País: Spain
    * Teléfono: (+34)932309500
    * Fax: (+34)932309555
    * Correo electrónico: sorribas at utm.csic.es
    
Borrado de datos de ejemplo
"""""""""""""""""""""""""""

En caso de querer publicar nuestros propios datos, en algún momento deberemos proceder al borrado de los datos iniciales que vienen de ejemplo. Para evitar conflictos, deben borrarse por este orden:

    #. Datos => Grupos de capas
    #. Datos => Capas
    #. Datos => Almacenes de datos
    #. Datos => Espacios de trabajo
    #. Datos => Estilos (excepto los estilos 'point', 'line', 'polygon' y 'raster', que deben conservarse porque son los que se usarán al publicar nuevas capas de datos)
    
Servicios
"""""""""

En Servicios => WCS, poner la información (para los metadatos del servicio) que se crea necesaria: responsable de mantenimiento, recurso en línea, título, resumen, tasas, restricciones de acceso, palabras clave. Además conviene tener en cuenta:

    * Procesado de coberturas: Para una calidad óptima, utilizar submuestreo y overviews de mayor resolución.
    * Imponer limitaciones en el consumo de recursos para evitar peticiones absurdamente grandes. Por ejemplo, limitar la memoria a 65 536 Kb (64 Mb) en ambos casos.

En  Servicios => WFS, rellenar también los metadatos del servicio. Además:

    * Features => Máximo número de features: Esto también impedirá peticiones absurdamente grandes. Por ejemplo, se puede limitar a 100 000.
    
En Servicios => WMS, rellenar también los metadatos del servicio. Además:

    * Lista de SRS limitada: Para evitar que el GetCapabilities contenga *todos* los posibles SRS (cientos de ellos), es recomendable poner aquí la lista de SRS que es razonable ofrecer. Dependiendo del área geográfica de los datos, esta lista puede cambiar, pero se recomienda que contenga:
        * Proyección UTM en los husos que corresponda. Para Europa, será habitual usar los datums ED50, ETRS89 y WGS84. Por ejemplo, para el Huso UTM 31N, serían: 23031, 25831, 32431.
        * Latitud, longitud en WGS84 (las “coordenadas típicas” de los no profesionales): Es decir, 4326.
        * La “proyección” de Google Maps. Tiene dos códigos EPSG: el oficial (3857), y el no oficial (900913).
    * Opciones de renderizado raster: Escoger método de interpolación según la calidad deseada:
        * Bicúbica (máxima calidad, mayor tiempo de respuesta)
        * Bilineal (calidad media, tiempo de respuesta medio)
        * Vecino más próximo (calidad baja, velocidad alta)
    * Opciones de KML. Se recomienda estos valores:
        * Modo per defecto del reflector: Superoverlay.
        * Método de superoverlay: Auto.
        * Generar placemarks de todo tipo.
        * Umbral raster/vector: 40.
    * Límites en el consumo de recursos:
        * Memoria máxima para renderizado (KB): 65 536.
        * Máximo tiempo de renderizado (s): 60.
        * Máximo número de errores de renderizado: 1000.
    * Configuración de la filigrana: Permite añadir un logo o “firma” en cada respuesta de GetMap. No se recomienda utilizarlo, porque es muy intrusivo (por ejemplo, da al traste con cualquier técnica de teselado).


.. image:: img/geoserver-WMS.png
    :width: 480 px
    :alt: Algunas de las opciones de Servicios => WMS
    :align: center

Settings => Global
""""""""""""""""""

En Configuración Gobal, poner:

    * Cantidad de decimales: Si se trabaja en coordenadas geográficas y con precisiones del orden de un metro (escalas no mayores que 1: 5 000), puede cambiarse este valor a  6.
    * Codificación de caracteres: Como regla general para cualquier aplicación informática, se recomienda, siempre que se pueda, usar UTF-8. Es la codificación universal, que incorpora todos los alfabetos mundiales.
    * Perfil del registro: En un servidor de verdad, se cambiaría a PRODUCTION_LOGGING.properties

Seguridad
"""""""""

Se propone aquí una configuración de seguridad simple, donde cualquiera tenga acceso de lectura, pero sólo el administrador pueda hacer cambios en los datos. Obviamente, esta configuración puede cambiarse para hacerla tan compleja como se quiera, creando diversos grupos de usuarios con diversos niveles de acceso a los datos y servicios.

**Seguridad de los datos**

    * Conservar regla de lectura \*.\*.r para todos (*).
    * Cambiar regla de escritura \*.\*.w para que sólo tenga derechos de edición ROLE_ADMINISTRATOR.

.. image:: img/geoserver-security.png
    :width: 600 px
    :alt: Reglas mínimas de acceso a datos
    :align: center
    
**Seguridad del catálogo**

Se recomienda el método CHALLENGE, el más compatible con diversos clientes.

Referencias
"""""""""""

Para más información sobre cómo diseñar y configurar entornos de producción reales, y sus implicaciones en seguridad y rendimiento, consultar el documento de OpenGeo Geoserver In Production: http://opengeo.org/publications/geoserver-production/


|TDS|
-----

Instalación de Thredds Data Server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

En este apartado se explicará la instalación y configuración del servidor |TDS|. En primer lugar necesitaremos descargarnos la versión adecuada del servidor, en nuestro caso será la versión 4.2.8::

	ftp://ftp.unidata.ucar.edu/pub/thredds/4.2/thredds.war

Descargamos un archivo .war que deberemos desplegar en nuestro servidor |TCT|. Antes de ello debemos efectuar unas configuraciones previas. 
Crearemos una variable de entorno que apunte a nuestro directorio de |TCT|. Editamos el archivo .bashrc de la sesión con la que estemos trabajando. Este archivo lo encontraremos en::

	$ cd ~

.. WARNING::
   Si se ha isntalado el tomcat vía apt-get, y se inicia mediante /etc/init.d/tomcat6, entonces debe editarse dicho fichero y poner en $JAVA_OPTS los valores que corresponda, en lugar de editar .bashrc y setenv.sh
   
    
Modificamos el archivo **.bashrc** con un editor de texto::

	$ nano .bashrc

e incluiremos la siguiente linea::

	export TOMCAT_HOME=/usr/share/tomcat6

Aplicamos los cambios escribiendo en el terminal::

	$ source .bashrc

y comprobamos que aparece nuestra variable::

	$ echo $TOMCAT_HOME

que nos mostrará el valor que hemos introducido en el archivo **.bashrc**, /usr/share/tomcat6

Crearemos un script en la carpeta bin del |TCT| ($TOMCAT_HOME/bin) que permita a este encontrar unas determinadas variables que necesitará para arrancar |TDS|::

	$ sudo nano $TOMCAT_HOME/bin/setenv.sh

e incluiremos lo siguiente::

	#!/bin/sh
	#
	# ENVARS for Tomcat and TDS environment
	#
	JAVA_HOME="/usr/lib/jvm/java-6-sun"
	export JAVA_HOME

	JAVA_OPTS="-Xmx1500m -Xms512m -XX:MaxPermSize=180m -server -Djava.awt.headless=true -Djava.util.prefs.systemRoot=$CATALINA_HOME/content/thredds/javaUtilPrefs"
	export JAVA_OPTS

	CATALINA_HOME="/usr/share/tomcat6"
	export CATALINA_HOME

Donde le indicamos la memoria máxima 1500 en caso de sistemas de 32-bit o 4096 o más en sistemas de 64-bit, y en caso de usar WMS con |TDS| debemos añadirle la localización de javaUtilPrefs asignandole a ``-Djava.util.prefs.systemRoot`` la ruta.
Una vez realizado esto, reiniciaremos |TCT| y comprobamos que los cambios se han producido::

	$ ps -ef | grep tomcat

que nos mostrará::

	tomcat6   7376     1 45 14:48 ?        00:00:03 /usr/lib/jvm/java-6-sun/bin/java -Djava.util.logging.config.file=/var/lib/tomcat6/conf/logging.properties
	-Xmx1500m -Xms512m -XX:MaxPermSize=180m -server -Djava.awt.headless=true -Djava.util.prefs.systemRoot=/usr/share/tomcat6/content/thredds/javaUtilPrefs 
	-Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djava.endorsed.dirs=/usr/share/tomcat6/endorsed -classpath /usr/share/tomcat6/bin/bootstrap.jar 
	-Dcatalina.base=/var/lib/tomcat6 -Dcatalina.home=/usr/share/tomcat6 -Djava.io.tmpdir=/tmp/tomcat6-tmp org.apache.catalina.startup.Bootstrap start

Donde podemos observar los valores que hemos introducido en nuestro script y que |TCT| ha incluido en el arranque.

Antes de realizar el despliegue de |TDS| crearemos la carpeta donde la instalación crea todos los archivos necesarios para la instalación y configuración del mismo. Para ello navegamos hasta el directorio donde el despliegue del war busca dicha carpeta por defecto::

	$ cd /var/lib/tomcat

y creamos la carpeta con el nombre por defecto::

	$ mkdir content

seguidamente le asignaremos permisos al usuario y grupo tomcat6::

	$ sudo chmod tomcat6:tomcat6 content

Una vez hecho esto procederemos al despliegue de |TDS| bien desde la pestaña manager de |TCT|, o copiando directamente el archivo thredds.war en la carpeta webapps de nuestra instancia de |TCT|. Es recomendable realizar un seguimiento de los cambios producidos en el servidor para comprobar que el despliegue de |TDS| se realiza correctamente, para ello ejecutaremos previamente en una consola::

	$ tail -f /var/lib/tomcat6/logs/catalina.out

de esta manera veremos por consola los mensajes que nos envia |TCT|.
Para comprobar que la instalación ha ido correctamente::

	http://localhost:8080/thredds

y accederemos al catalogo de ejemplo que viene en |TDS| por defecto.

Configuración de módulos en |TDS|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

TDS Remote Management
"""""""""""""""""""""

Desde el Remote Management de |TDS| podemos acceder a información acerca del estado del servidor, reiniciar catálogos... Para porder acceder a este deberemos previamente configurar |TCT| para que permita el acceso mediante SSL. Lo primero que haremos será crear un certificado autofirmado en el servidor (keystore) y configuraremos |TCT| para utilizar un conector que permita el acceso mediante este protocolo.

.. WARNING::
   En lugar de utilizar ssl (en nuestro caso, el puerto SSL 443 no es accessible desde fuera), puede editarse el web.xml para cambiar las restricciones de acceso de este servicio de "CONFIDENTIAL" a "NONE".

Lo primero que haremos será utilizar la herramienta keytool para generar el certificado. Esta herramienta viene suministrada con el JDK de Java y la encontraremos en::
	
	$ $JAVA_HOME/bin/

y la ejecutaremos indicandole la ruta donde generaremos el archivo .keystore ($USER_HOME/.keystore por defecto)::

	$JAVA_HOME/bin/keytool -genkey -alias tomcat -keyalg RSA -validity 365 -keystore ~/.keystore

y responderemos a las cuestiones que plantea. Respecto al password, por defecto |TCT| tiene definida *changeit* como contraseña por defecto, así que deberemos modificar en los valores del conector el valor de esta, indicandole la que hayamos definido en la creación del certificado. Para introducir esta y modificar algunos otros valores necesarios modificaremos el archivo server.xml de nuestra instancia de |TCT|::

	$ sudo nano /etc/tomcat6/server.xml

descomentaremos las lineas que activan el conector::

	  <!-- Define a SSL Coyote HTTP/1.1 Connector on port 8443 -->
    <Connector port="8443" 
               maxThreads="150" minSpareThreads="25" maxSpareThreads="75"
               enableLookups="false" disableUploadTimeout="true"
               acceptCount="100" debug="0" scheme="https" secure="true"
               clientAuth="false" sslProtocol="TLS" keystoreFile="<ruta al .keystore creado>" keystorePass="<contraseña al crear el keystore>"/>

introduciendo la ruta al archivo .keystore creado e indicandole la contraseña que hemos indicado en la creación del mismo. Una vez realizada esta modificación, reiniciaremos el |TCT| comprobaremos que los cambios se han realizado correctamente accediendo a::

	http://localhost:8443

Finalmente, para poder acceder al gestor remoto del |TDS| deberemos crear el usuario y el rol en |TCT| que permite este acceso. Para ello modificaremos el archivo tomcat-users.xml incluyendo lo siguiente::

	<role rolename="tdsConfig"/>
	<user username="<nombre usuario>" password="<password usuario>" roles="tdsConfig"/>

Está será la clave de acceso del usuario, por lo que no es necesario que sea igual a la que se ha definido en el conector de |TCT|. Reiniciaremos el |TCT| de nuevo y comprobamos el acceso a través de::

	http://localhost:8443/thredds/admin/debug

**Referencias**

* SSL Configuration HOW-TO [3]_
* Enabling TDS Remote Management [6]_

Configuración de servicios WMS y WCS
""""""""""""""""""""""""""""""""""""

|TDS| tiene por defecto los servicios WMS y WCS desactivados. Para poder hacer uso de estos servicios tendremos que activarlos. Deberemos modificar el archivo ``threddsConfig.xml`` que encontraremos en la carpeta ``content`` de la instalación de |TDS|. Modificaremos el archivo activando los servicios descomentando las etiquetas ``WMS`` y ``WCS`` y modificando el valor de la etiqueta ``allow`` a ``true``::
	
	<WMS>
  	<allow>true</allow>
	</WMS>

para el servicio WMS y::

	<WCS>
  	<allow>true</allow>
	</WCS>

para el WCS. Ahora ya podremos indicar en nuestros catálogos que los servicios WMS y WCS se encuentran activos.

**Referencias**

* OGC/ISO services (WMS, WCS and ncISO) [4]_

Configuración de ncISO
""""""""""""""""""""""

Desde la versión 4.2.4 de |TDS| se incluye el paquete ``ncISO`` que permite mostrar los metadatos de los datasets como fichas ISO. Para activar dicho servicio será necesario realizar unas modificaciones en el archivo ``threddsConfig.xml`` como en el caso de los servicios anteriores. Buscaremos en el archivo la linea que hace referencia el servicio ncISO las descomentaremos y modificaremos el valor a ``true`` para los tres casos::

	<NCISO>
		<ncmlAllow>true</ncmlAllow>
		<uddcAllow>true</uddcAllow>
		<isoAllow>true</isoAllow>
	</NCISO>

En caso de que estas lineas no apareciesen en nuestro archivo las creariamos. Después debemos acceder al archivo ``web.xml`` de nuestra instalación de |TDS| y descomentaremos las lineas que activan el servicio ``ncISO`` de manera que quede así::

	<filter-mapping>
		<filter-name>RequestQueryFilter</filter-name>
		<servlet-name>metadata</servlet-name>
	</filter-mapping>

	<servlet>
		<servlet-name>metadata</servlet-name>
		<servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
		<load-on-startup>3</load-on-startup>
	</servlet>

	<servlet-mapping>
		<servlet-name>metadata</servlet-name>
		<url-pattern>/ncml/*</url-pattern>
	</servlet-mapping>
	<servlet-mapping>
		<servlet-name>metadata</servlet-name>
		<url-pattern>/uddc/*</url-pattern>
	</servlet-mapping>
	<servlet-mapping>
		<servlet-name>metadata</servlet-name>
		<url-pattern>/iso/*</url-pattern>
	</servlet-mapping>

Ahora será posible añadir estos servicios a nuestros catálogos.

**Referencias**

* TDS and ncISO: Metadata Services [5]_

Inclusión de servicios OGC/ISO en los catálogos
"""""""""""""""""""""""""""""""""""""""""""""""

Una vez que hemos activado los servicios OGC/ISO será posible la utilización de estos en nuestros catálogos. |TDS| utiliza archivos catalog.xml para definir las carpetas donde se almacenan los datasets, así como la estructura que tendrá el arbol que muestra dichos datasets. También se encarga de definir los servicios que están disponibles en el servidor y que permite el acceso a estos datasets.

Existe la posibilidad de definir un tipo de servicio ``compound`` que lo que nos permite es asignar todos los servicios activos a los datasets que incluyan este servicio. Para definir esto, en nuestro ``catalog.xml`` incluiremos el siguiente elemento::

	<service name="all" base="" serviceType="compound">
		<service name="odap" serviceType="OpenDAP" base="/thredds/dodsC/" />
		<service name="http" serviceType="HTTPServer" base="/thredds/fileServer/" />
		<service name="wcs" serviceType="WCS" base="/thredds/wcs/" />
		<service name="wms" serviceType="WMS" base="/thredds/wms/" />
		<service name="ncml" serviceType="NCML" base="/thredds/ncml/"/>
		<service name="uddc" serviceType="UDDC" base="/thredds/uddc/"/>
		<service name="iso" serviceType="ISO" base="/thredds/iso/"/>
	</service>

así podremos indicar a los datasets que utilicen este servicio compuesto::

	<dataset ID="sample" name="Sample Data" urlPath="sample.nc">
  	<serviceName>all</serviceName>
	</dataset>

A través del ``servicename`` es como enlazaremos el servicio con los datasets. Podemos reinicializar nuestros catálogos accediendo a través de la aplicación TDS Remote Management.

**Referencias**

* TDS Configuration Catalogs [7]_
* Dataset Inventory Catalog Specification, Version 1.0.2 [8]_

|GN|
----

Para el |DP| será necesario utilizar una versión de |GN| 2.7 o superior, debido a los procesos que son necesarios para realizar el harvesting. Una vez descargada la versión de |GN| indicada, se desplegará en nuestra instancia de |TCT| bien desde el manager o bien moviendo el archivo .war descargado a la carpeta webapps de servidor. 
Será necesario modificar los permisos de la carpeta ``/var/lib/tomcat6`` para que el usuario tomcat6 que ejecuta el despliegue tenga permisos a la hora de desplegar |GN| y pueda crear en dicha carpeta los archivos necesarios para la instalación de |GN|. Para ello ejecutamos::

	$ sudo chown tomcat6:tomcat6 /var/lib/tomcat6

y haremos el despliegue de |GN|. Si tenemos monitorizada la salida del archivo de log ``catalina.out`` podremos comprobar que el despliegue se ha realizado de manera correcta si aparece un mensaje como::

	2011-08-22 18:21:29,004 INFO  [jeeves.engine] - === System working =========================================

Podremos acceder a nuestro |GN| a través de::

	http://localhost:8080/geonetwork

Harvesting |TDS| a |GN|
-----------------------

|GN| permite, a partir de su versión 2.7, realizar procesos de harvesting a servidores |TDS|. De esta manera es posible incorporar en nuestro servidor de catálogo la información de los metadatos de los datasets que tengamos publicados a través de nuestro servidor |TDS|. Para configurar correctamente este proceso de Harvesting es necesario realizar dos operaciones diferentes:

* Creación y configuración del proceso de Harvesting
* Creación de las plantillas de extracción de la información

Creación y configuración del proceso de Harvesting
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Para dar de alta un proceso de harvesting debemos acceder a |GN| como administradores y dirigirnos a la pestaña de ``Administration``. Desde allí nos dirigiremos a ``Harvesting Management``. Esto nos abrirá una nueva ventana desde donde podemos crear nuestro proceso de harvesting. Para ello pulsaremos sobre ``Add`` y elegiremos del desplegable el ``Thredds Catalog`` para después volver a pulsar ``Add``. Rellenaremos los campos como se indica a continuación:

.. image:: img/harvesting-management.png
		:width: 600 px
		:alt: Configuración de proceso harvest
		:align: center
 
* **Name**; nombre que le queremos dar al proceso
* **Catalog URL**; URL del catalog de |TDS|. Importante que la dirección apunte al .xml::
	
	http://localhost:8080/thredds/catalog.xml

* **Create ISO19119 metadata for all services in the catalog**; crearia una plantilla ISO19119 para todos los servicios que hayamos definido en nuestro catalog.xml
* **Create metadata for Collection Datasets**; si seleccionamos esta opción, el proceso de harvesting creará un registro en |GN| también para las colecciones de datasets incluidas en el catalog.xml. Dentro de esta opción existen varias opciones:
	* **Ignore harvesting attribute**: Que no tiene en cuenta el valor del atributo harvest en el archivo catalog.xml. En caso de no seleccionar esta opción, solo incorporarán en el catálogo aquellas colecciones que tengan este valor igual a ``true`` en el catalog.xml.
	* **Extract DIF metadata elements and create ISO metadata**: Extrae metadatos DIF y crea un metadato ISO. Habrá que seleccionar el esquema en el que se desea realizar la extracción.
	* **Extract Unidata dataset discovery metadata using fragments**: indicaremos que el proceso extraiga el valor de los metadatos que se definen utilizando la NetCDF Attribute Convention for Dataset Discovery. Nos permite el uso de fragmentos en la extracción de la información. Nos solicita el esquema de salida de la información, la plantilla que queremos utilizar para la creación de los fragmentos y la plantilla sobre la que se van a crear dichos fragmentos. Un detalle de este proceso se explica más adelante.
* **Create metadata for Atomic Datasets**; Con las opciones parecidas al caso anterior, generará un registro por cada dataset que exista en nuestro servidor |TDS|. Cuenta con la opción **Harvest new or modified datasets only** que indica que cuando se repita el proceso de harvesting solo se incluyan aquellos datasets nuevos o que hayan sido modificados.
* **Create thumbnails for any datasets delivered by WMS**; crea iconos para los datasets que tengan activado el servicio WMS y permite elegir el icono.
* **Every**; indicaremos la frecuencia con que deseamos que se repita el proceso de harvest o si solo queremos que se repita una vez.

Una vez definidas estos parametros pulsaremos sobre ``Save`` y podremos observar como en la ventana anterior aparece nuestro proceso. Seleccionandole podremos acceder a las diferentes operaciones que se nos ofrece. Si pulsamos sobre ``Run`` ejecutaremos el harvest. Una vez finalizado, situando el puntero del ratón sobre el icono ``Status`` visualizaremos un resumen del proceso.

Creación de las plantillas de extracción de la información
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Para generar la información que necesitamos para el |DP|, debemos configurar el proceso de harvest de manera que este extraiga la información asociada a los datasets configurados en el servidor |TDS| siguiendo la NetCDF Attribute Convention for Dataset Discovery. Para ello a partir de la versión 2.7 de |GN| se implementa la posibilidad de utilizar fragmentos para la extracción y reutilización de esta información extraida en el proceso de harvest. Esta posibilidad solo está disponible para extracción de información de catalogos |TDS| y operaciones getFeature del protocolo WFS. Utilizando los fragmentos podremos extraer exclusivamente la información que requiere el |DP| para el proceso de busquedas implementado a través de |GN|. Podremos definir plantillas con los fragmentos que nos interesan que serán guardados en |GN| como **subplantillas** (subtemplates), a seleccionar en las opciones del proceso de harvest, y estos fragmentos que generarán estas subplantillas serán insertados en una plantilla que generará el registro (**plantilla base**) con el metadato en |GN|.

.. image:: img/web-harvesting-fragments.png
   :width: 400 px
   :alt: utilización de fragmentos en |GN|
   :align: center

Para tener disposición de las plantillas y subplantillas hemos de crear estas en la carpeta del esquema que vayamos a utilizar. Estas carpetas se encuentran en::

	$TOMCAT_HOME/webapps/geonetwork/xml/schemas/

Para el caso del |DP| utilizaremos el esquema ISO19139, por lo que será necesario crear la **plantilla base** en la carpeta ``templates`` del esquema ``iso19139``::

	$TOMCAT_HOME/webapps/geonetwork/xml/schemas/iso19139/templates

allí encontraremos la plantilla base que viene por defecto con la versión de |GN| que podremos utilizar para crear la nuestra propia. Dentro de la misma carpeta del esquema, encontraremos una carpeta ``convert`` en la que aparece la carpeta ``ThreddsTofragments``. En esta localización será donde incluiremos nuestras **subplantillas** que generarán los fragmentos::

	$TOMCAT_HOME/webapps/geonetwork/xml/schemas/iso19139/convert/ThreddsToFragments

Una vez que hayamos incluido nuestros archivos en las carpetas indicadas, deberemos cargar las plantillas del esquema en |GN|. Para ello, desde una sesión como administrador, nos dirigiremos a la ventana ``Administration`` y en la sección de ``Metadata & Template`` seleccionaremos el esquema ``iso19139`` y le indicaremos ``Add templates``. Realizado esto, podremos comprobar que en las opciones dentro de la ventana de ``Harvesting Management`` ``Stylesheet to create metadata fragments`` y ``Select template to combine with fragments`` podremos encontrar las plantillas que hemos creado. El nombre de estas plantillas serán el nombre del archivo para las **subplantillas** y el valor del tag que tenga asociado el id ``id="thredds.title"`` dentro de la **plantilla base**.

Creación de la plantilla base
"""""""""""""""""""""""""""""

Para la creación de la plantilla base tomaremos como plantilla de partida la que |GN| incluye por defecto en su versión 2.7. Esta, como hemos comentado se encuentra en::

	$TOMCAT_HOME/webapps/geonetwork/xml/schemas/iso19139/templates/thredds-harvester-unidata-data-discovery.xml

Esta es la plantilla base que se generará por cada registro que se incluya en |GN|. Se trata de una plantilla tipica de la ISO19139. La diferencia fundamental, es que asociado a determinados elementos de la ISO, aparece el atributo ``id=<identificador del fragmento>``. Esta es la manera en que se indica que durante el proceso de creación del metadato en |GN|, busque el identificador en la subplantilla que hemos seleccionado al crear el proceso de harvest. Por eso para crear la plantilla base, lo único que debemos hacer es sustituir los elementos que estemos interesados en crear mediante fragmentos, por una llamada a través del ``id`` al del fragmento que estamos interesados en incluir::

	<gmd:date id="thredds.resource.dates"/>
	<gmd:abstract id="thredds.abstract"/>
	<gmd:credit id="thredds.credit"/>
	<gmd:descriptiveKeywords id="thredds.keywords"/>
	<gmd:resourceConstraints id="thredds.use.constraints"/>
	<gmd:aggregationInfo id="thredds.project"/>

y en la subplantilla definiremos los fragmentos y les indicaremos el ``id`` al que la pantilla hace referencia.

Creación de la subplantilla (fragmentos)
""""""""""""""""""""""""""""""""""""""""

La subplantilla ha de definirse en la carpeta::

	$TOMCAT_HOME/webapps/geonetwork/xml/schemas/iso19139/convert/ThreddsToFragments
 
Una vez que hemos definido los ``id`` en la plantilla base, debemos crear estos en la subplantilla. Para ello podemos partir de alguna de los XSL que vienen suministrados en la versión de |GN|. Estas subplantillas, a diferencia de las plantillas base, se tratan de hojas XSL que serán ejecutadas durante la creación del metadato. 

Si abrimos una plantilla de las suministradas, por ejemplo::

	$TOMCAT_HOME/webapps/geonetwork/xml/schemas/iso19139/convert/ThreddsToFragments/netcdf-attributes.xsl

comprobaremos que se trata de un ejemplo normal de plantilla xsl, con su encabezado, definición de namespaces, y como diferencia se puede observar la aparición de unos elementos::

	<replacementGroup id="thredds.supplemental">
	<fragment uuid="{util:toString(util:randomUUID())}" title="{concat($name,'_contentinfo')}">
	...
	</fragment>
	</replacementGroup>

Esta es la manera de definir el fragmento. El atributo ``id`` que acompaña al elemento se trata del ``id`` al que se hace referencia en la plantilla base, y todos los elementos que se incluyan dentro del fragmento serán procesados en la creación del metadato e incluidos en la plantilla. 

|PG|
----

Instalación y configuración inicial
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Instalar |PG|::

    $ sudo apt-get install postgresql

Comprobar que está habilitado el servicio de conexión vía TCP/IP para localhost, y el puerto. En postgresql.conf::
    
    listen_addresses = 'localhost' 
    port = 5432 
   
Y en pg_hba.conf::

    host    all         all         127.0.0.1/32          md5

Si se ha modificado alguno de estos ficheros, reiniciar el servicio::

    $ sudo /etc/init.d/postgresql-8.4 restart

    
Creación esquema BDD para el |DP|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    
Obtener los scripts create_db.sql y create_schema.sql. Abrir el script create_db.sql y poner un password al usuario "icos". Luego, ejecutar el script::

    $ sudo -u postgres psql < create_db.sql
    
A continuación creamos el esquema::

    $ psql -U icos -d dataportal < create_schema.sql

    
|DP|
----
   
Fichero dataportal.properties
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Cambiar los valores para:

* URL del servicio de catálogo CSW donde realizar las búsquedas.
* Directorio temporal donde se almacenarán los datos descargables.
* Credenciales de acceso a la BDD de la aplicación.
* Datos sobre la cuenta de mail utilizada por el gestor de cuentas de usuario.


Referencias
------------

.. [1] http://www.keopx.net/blog/cambiar-las-preferencias-de-java-alternatives-en-debianubuntu
.. [2] http://www.guia-ubuntu.org/index.php?title=Java
.. [3] http://tomcat.apache.org/tomcat-6.0-doc/ssl-howto.html
.. [4] http://www.unidata.ucar.edu/projects/THREDDS/tech/tds4.2/tutorial/AddingServices.html
.. [5] http://www.unidata.ucar.edu/projects/THREDDS/tech/tds4.2/reference/ncISO.html
.. [6] http://www.unidata.ucar.edu/projects/THREDDS/tech/tds4.1/reference/RemoteManagement.html
.. [7] http://www.unidata.ucar.edu/projects/THREDDS/tech/tds4.2/tutorial/ConfigCatalogs.html
.. [8] http://www.unidata.ucar.edu/projects/THREDDS/tech/catalog/v1.0.2/InvCatalogSpec.html
.. [9] http://geonetwork-opensource.org/manuals/trunk/users/admin/harvesting/index.html#harvesting-fragments-of-metadata-to-support-re-use
.. [10] http://www.unidata.ucar.edu/software/netcdf-java/formats/DataDiscoveryAttConvention.html
﻿.. |Discovery| replace:: NetCDF Attribute Convention for Dataset Discovery
.. |Crosswalk| replace:: NOAA's NetCDF Attribute Convention for Dataset Discovery Conformance Test
.. |ODbL| replace:: Open Database License
.. |CF_vocab| replace:: CF standard names v.18
.. |UTM_vocab| replace:: vocabulario usado en la UTM
.. |cdm| replace:: Tipo de datos Thredds

.. _Discovery: http://www.unidata.ucar.edu/software/netcdf-java/formats/DataDiscoveryAttConvention.html
.. _Crosswalk: https://geo-ide.noaa.gov/wiki/index.php?title=NetCDF_Attribute_Convention_for_Dataset_Discovery_Conformance_Test
.. _ODbL: http://opendatacommons.org/licenses/odbl/
.. _ISO8601: http://es.wikipedia.org/wiki/ISO_8601
.. _CF_vocab: http://cf-pcmdi.llnl.gov/documents/cf-standard-names/standard-name-table/18/cf-standard-name-table.html
.. _UTM_vocab: http://ciclope.cmima.csic.es:8080/dataportal/xml/vocabulario.xml
.. _cdm: http://www.unidata.ucar.edu/software/netcdf-java/formats/DataDiscoveryAttConvention.html#cdm_data_type_Attribute


Preparación de los datos netCDF
===============================

El *Data Portal* puede realizar búsquedas por ámbito geográfico, período temporal, conjunto de variables, o por texto libre, dentro de un conjunto de ficheros netCDF. Para que los datos originales sean recuperables mediante estos criterios, es necesario que éstos estén convenientemente descritos.

A tal efecto, se han seguido las convenciones |Discovery|_. En concreto, es necesario que los ficheros netCDF contengan *al menos* los siguientes atributos globales:


Atributos Globales Mínimos
--------------------------

========================  =========================================================
Atributo                  Descripción
========================  =========================================================
Metadata_Conventions      Literal: "Unidata Dataset Discovery v1.0".
id                        Identificador de este dataset. Idealmente un DOI.
                          De momento un UUID.
naming_authority          Junto con *id*, debe formar un identificador
                          global único. Como UUID ya es global y único *per se*,
                          pondremos el literal "UUID", que indica su tipo.
title                     Descripción concisa del conjunto de datos.
summary                   Un párrafo describiendo los datos con mayor
                          detalle.
keywords                  Una lista de palabras clave separada por comas.
standard_name_vocabulary  Idealmente se usaría el estándar |CF_vocab|_.
                          Si esto no es posible, crearemos nuestro propio
                          vocabulario "ICOS-SPAIN", ampliando el |UTM_vocab|_.
                          Este atributo contendrá la URL donde pueda descargarse
                          el vocabulario.
license                   Licencia de uso de los datos. Se recomienda la |ODbL|_.
geospatial_lat_min        Límites geográficos en los que están contenidas
                          las medidas, coordenadas geográficas en grados
                          decimales, sistema de referencia WGS84 (EPSG:4326).
geospatial_lat_max        *idem*
geospatial_lon_min        *idem* 
geospatial_lon_max        *idem*
time_coverage_start       Instante del dato más remoto, en formato ISO8601_.
time_coverage_end         Instante del dato más reciente, en formato ISO8601_.
institution               Institución que publica los datos.
creator_url               Dirección web de la istitución.
cdm_data_type             |cdm|_. Uno de "Grid", "Image", "Station", "Radial"
                          o "Trajectory".
icos_domain               Atributo propio (no responde a ninguna convención),
                          que necesitamos a efectos estadísticos.
========================  =========================================================


Lista de valores de 'institution' y 'creator_url'
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

  * "Unidad de Tecnología Marina (UTM), CSIC" => http://www.utm.csic.es/
  * "Centro de Estudios Ambientales del Mediterráneo (CEAM)" => http://www.ceam.es/
  * "Centro de Investigación Atmosférica de Izaña, AEMET" => http://www.izana.org/
  * "Institut Català de Ciències del Clima (IC3)" => http://www.ic3.cat/
  * **... TODO: completar con lista de contribuidores en ICOS-SPAIN.**

  
Lista de valores de 'icos_domain'
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  * "environment" (terrestre/ecosistemas)
  * "atmosphere"
  * "oceans"
  

Atributos Globales Recomendados
-------------------------------

Se recomienda seguir el resto de las convenciones |Discovery|_, en especial se recomienda
incluir **alguna manera de contactar** con el creador o el publicador de los datos.

Ejemplo de un set de atributos globales según las |Discovery|_, expresados en *ncML*::

  <attribute name="Metadata_Conventions" value="Unidata Dataset Discovery v1.0" />
  <attribute name="id" value="icos-sample-1" />
  <attribute name="naming_authority" value="co.geomati" />
  <attribute name="title" value="Global Wind-Wave Forecast Model and Ocean Wave model" />
  <attribute name="summary" value="This is a sample global ocean file that comes with default Thredds installation. Its global attributes have been modified to conform with Dataset Discovery convention" />
  <attribute name="keywords" value="ocean, sample, metadata, icos, geomati.co" />
  <attribute name="license" value="Open Database License v.1.0" />
  <attribute name="standard_name_vocabulary" value="UTM.CSIC.ES" />
  <attribute name="geospatial_lat_min" value="40" />
  <attribute name="geospatial_lat_max" value="50" />
  <attribute name="geospatial_lon_min" value="-10" />
  <attribute name="geospatial_lon_max" value="10" />
  <attribute name="time_coverage_start" value="2011-07-10T12:00" />
  <attribute name="time_coverage_end" value="2011-07-15T12:00" />
  
  <attribute name="geospatial_vertical_min" value="-1" />
  <attribute name="geospatial_vertical_max" value="1" />
  <attribute name="geospatial_vertical_units" value="m" />
  <attribute name="geospatial_vertical_resolution" value="1" />
  <attribute name="geospatial_vertical_positive" value="up" />
  <attribute name="time_coverage_duration" value="P10D" />
  <attribute name="time_coverage_resolution" value="1" />

  <attribute name="Metadata_Link" value="http://ciclope.cmima.csic.es:8080/thredds/iso/wcsExample/ocean-metadata-sample.nc" />
  <attribute name="history" value="2011-08-16 - metadata changed to conform to data portal specification" />
  <attribute name="comment" value="Half of this metadata is fake" />

  <attribute name="creator_name" value="gribtocdl" />
  <attribute name="creator_url" value="http://www.unidata.ucar.edu/projects/THREDDS/" />
  <attribute name="creator_email" value="support@unidata.ucar.edu" />
  <attribute name="institution" value="unidata" />
  <attribute name="date_created" value="2003-04-02 12:12:50" />
  <attribute name="date_modified" value="2011-07-15 11:00:00" />
  <attribute name="date_issued" value="2011-07-10 12:00:00" />
  <attribute name="project" value="ICOS-SPAIN" />
  <attribute name="acknowledgement" value="UTM/CSIC" />
  <attribute name="contributor_name" value="Oscar Fonts" />
  <attribute name="contributor_role" value="Inventing Discovery Metadata Attributes" />
  <attribute name="publisher_name" value="UTM/CMIMA/CSIC" />
  <attribute name="publisher_url" value="http://www.utm.csic.es/" />
  <attribute name="publisher_email" value="esto@un.correo.es" />
  <attribute name="publisher_email" value="esto@un.correo.es" />

  <attribute name="processing_level" value="Who knows" />
  <attribute name="cdm_data_type" value="Grid" />
  <attribute name="record" value="reftime, valtime" />
  
  <attribute name="Conventions" value="NUWG" />
  <attribute name="GRIB_reference" value="Office Note 388 GRIB" />
  <attribute name="GRIB_URL" value="http://www.nco.ncep.noaa.gov/pmb/docs/on388/" />
  <attribute name="version" type="double" value="0.0" />

  
Tabla equivalencias metadatos
-----------------------------

A lo largo de la aplicación, estos **atributos netCDF** se transformarán en una **fichas ISO** en un proceso de harvesting. El servicio **search** podrá filtrar por alguno de estos conceptos vía **parámetros de búsqueda**, que se convertirán en un **request CSW**, y que dará lugar a unos **resultados de búsqueda**. Estos resultados, además, serán **ordenables** por alguno de los parámetros.

Puesto que en cada etapa estos metadatos siguen esquemas y toman nombres distintos, se detalla aquí una tabla de equivalencias (ISO basado en |Crosswalk|_):

.. list-table:: *Equivalencia entre los nombres de los metadatos en diferentes fases del proceso*
   :header-rows: 1
   
   * - netCDF global attribute
     - ISO 19115:2003/19139
     - Search request param
     - CSW Filter
     - Search order-by param
     - Search result field
   * - id
     - /gmd:MD_Metadata/gmd:fileIdentifier/gco:CharacterString
     - -- (no se busca por id, de momento)
     - Operación *getRecordById*.
     - id
     - id
   * - title
     - /gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString
     - text (texto libre)
     - any
     - title
     - title
   * - summary
     - /gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString
     - text (texto libre)
     - any
     - -- (no se ordena por resumen)
     - summary
   * - geospatial_lat_min, geospatial_lat_max, geospatial_lon_min, geospatial_lon_max
     - /gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal
       /gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal
       /gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:southBoundLongitude/gco:Decimal
       /gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:northBoundLongitude/gco:Decimal
     - bboxes (múltiples)
     - OGC BBOX filter
     - -- (no se ordena por bbox)
     - geo_extent (WKT)
   * - time_coverage_start
     - /gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition
     - start_date
     - TempExtent_begin
     - start_time
     - start_time
   * - time_coverage_end
     - /gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:endPosition
     - end_date
     - TempExtent_end
     - end_time
     - end_time
   * - variables (*no son atributos*)
     - /gmd:MD_Metadata/gmd:contentInfo/gmi:MI_CoverageDescription/gmd:dimension/gmd:MD_Band/gmd:sequenceIdentifier/gco:MemberName/gco:aName/gco:CharacterString
     - variables (multiselect)
     - ContentInfo
     - -- (no se ordena por variables)
     - variables
   * - institution
     - 	/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString
     - -- (no se busca por institucion)
     - -- (no se filtra por institucion)
     - -- (no se ordena por institucion)
     - institution
   * - creator_url
     - /gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL
     - -- (no se busca por URL de institución)
     - -- (no se filtra por URL de institución)
     - -- (no se ordena por URL de institución)
     - creator_url
   * - cdm_data_type
     - /gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode *May need some extensions to this codelist. Current values: vector, grid, textTable, tin, stereoModel, video.*
     - -- (no se busca por tipo)
     - -- (no se filtra por tipo)
     - -- (no se ordena por tipo)
     - data_type
   * - icos_domain
     - /gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:topicCategory/gmd:MD_TopicCategoryCode
     - -- (no se busca por área temática)
     - -- (no se filtra por área temática)
     - -- (no se ordena por área temática)
     - icos_domain
     
Convención datos
----------------

Observaciones norma seguida por NetCDF de la UTM presentes en Thredds
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Los ficheros NetCDF existentes en la instancia de Thredds de cíclope especifican un atributo "conventions=Unidata Observation Dataset v1.0".

Dicha norma está desaconsejada en favor de CF Conventions for Point Observations[1]:

* This Conventions is deprecated in favor of the CF Conventions for Point Observations 

y las CF Conventions for Point Observations forman parte del "draft incompleto" de la CF-1.6. 
Para este documento se ha trabajado con la versión 1.5 de CF, ignorando los trabajos en curso de la 1.6

En cuanto a los atributos globales, se sigue la norma NetCDF Attribute Convention for Dataset
Discovery, en la que se referencia en la cabecera un vocabulario[2], pero las variables no 
contienen un atributo *standard_name* que haga referencia a las variables definidas en dicho 
vocabulario, como se recomienda en dicha norma.

Las entradas del vocabulario no deberían tener unidades, ya que es posible tomar datos de la 
misma variable en medidas distintas. Por ejemplo dos instituciones distintas pueden producir 
información de profundidad, una en metros y la otra en kilómetros.

Descripción de la convención
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


Para cada variable se especificará el atributo "units". Por el momento se usará una cadena de carácter 
descriptiva de las unidad que vienen en los ficheros originales importados a NetCDF. En un futuro
se plantea la posibilidad de seguir CF, es decir, encontrando la unidad en el fichero udunits.dat del programa
Udunits de Unidata. 

Se especificará un atributo standard_name que referenciará la entrada en el vocabulario de la variable que se está midiendo. 

Para las variables coordenadas se seguirá CF y se especificarán los atributos *units*, *standard_name* y *axis*. Las unidades para
latitud y longitud serán siempre "degrees_north" y "degrees_east" respectivamente.

Para las coordenadas verticales se especificará en caso necesario un atributo *positive* con la dirección
creciente de la dimensión. Aunque estén desaconsejadas, en caso de que las coordenadas verticales no sean
dimensionales (nivel, capa, etc.) estas serán utilizadas. La alternativa es especificar mediante atributos
una fórmula para convertir el nivel a atmósferas, lo cual complica en exceso la carga de los datos de los
distintos proveedores.

Para la coordenada tiempo se seguirá también CF.

Para la obtención de las coordenadas de una variable se sigue la convención CF para trayectorias,
datos puntuales y mallas (ver resumen de CF más abajo), aunque en principio se intuye que sólo va a
haber datos puntuales y trayectorias. 

Las variables que sean calculadas como una media, incluirán un atributo 
*mean_desc* y *mean* que contendrán respectivamente una descripción de
la media y los nombres, separados por un espacio, de las dos variables
que contienen el número de elementos que se usaron para calcular la
media (*nd*) y la desviación típica (*sd*).

Estas variables tendrán la misma forma (*shape*) y por tanto, el mismo número de
valores, que la variable media. Esto es así porque cada valor de la variable media
se corresponde con el valor en la misma posición de cada una de las variables
auxiliares.

Además, con el fin de poder identificar las variables *nd* y *std* sin 
tener que buscar atributos *mean* en todas las variables, estas incorporarán un atributo
*mean_role* con valor "nd" o "std". Por ejemplo::

	dimensions:
	 station = 10 ; // measurement locations
	 time = UNLIMITED ;
	variables:
	 float co2(time,station) ;
	  co2:long_name = "carbon dioxide" ;
	  co2:coordinates = "lat lon" ;
	  co2:mean = "nd sd"
	  co2:mean_desc = "Hourly data means of 10 minutes means"
	 int nd(time,station) ;
	  nd:mean_role = "nd"
	 int sd(time,station) ;
	  sd:mean_role = "sd"
	 double time(time) ;
	  time:long_name = "time of measurement" ;
	  time:units = "days since 1970-01-01 00:00:00" ;
	 float lon(station) ;
	  lon:long_name = "station longitude";
	  lon:units = "degrees_east";
	 float lat(station) ;
	  lat:long_name = "station latitude" ;
	  lat:units = "degrees_north" ;

Se considera la utilización de un único sistema de referencia, por simplicidad. El sistema común 
será el WGS84 y no se incluirá información sobre el CRS dentro del fichero.

Cambios con respecto a la convención (implícita) de la fase 1
---------------------------------------------------------------

- Eliminación de las unidades en el vocabulario. 
- Se usaría un UUID como "id" (fácil de generar en java, a falta de DOIs).
- Especificación del atributo global naming_autority.
- Especificación del atributo global standard_name_vocabulary
- Especificación del atributo global "icos_domain" con los valores mencionados más arriba.
- Especificación del atributo "cdm_data_type" con uno de los |cdm|_.
- Codificación de las trayectorias, mallas, etc. como se especifica en CF (ver :ref:`coordsys`), incluyendo el atributo "axis" y un "standard_name" que indique una variable existente en el vocabulario.
- Especificación del atributo global "conventions = CF-1.5".
- Especificación del atributo global "Metadata_Conventions=Unidata Dataset Discovery v1.0".
- Especificación del atributo global "institution" y "creator_url".
- Especificación de los "atributos globales mínimos" (sobre todo bbox y time range) según: https://github.com/michogar/dataportal/blob/master/doc/data.rst
- Opcionalmente, especificación del resto de atributos globales recomendados en las discovery conventions: http://www.unidata.ucar.edu/software/netcdf-java/formats/DataDiscoveryAttConvention.html

Climate & Forecast
------------------

Es una convención que define ciertas normas y recomendaciones para los contenidos de los ficheros netcdf.

Las definiciones que más nos pueden interesar son las relativas a la organización de las variables que contienen las coordenadas y su relación con las variables que contienen los datos que han sido medidos, de manera que para una variable de interés concreta, sea posible saber qué variables contienen las coordenadas (lat, lon, vertical y tiempo) dónde y cuándo se midió cada valor, tanto si las mediciones representan una malla, datos puntuales, trayectorias, etc.

A continuación se describe su versión 1.5.

Descripción de los contenidos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Descripción de los contenidos del fichero. En particular "institution" permite describir la organización que produjo los datos

Descripción de los datos
^^^^^^^^^^^^^^^^^^^^^^^^^^

Se requiere el atributo "units" para todas las variables dimensionales (creo que se refiere a aquellas que tienen unidad, las que no son porcentajes, ratios, etc.)

Los valores válidos son los aceptados por un paquete informático de Unidata llamado Udunits, que incorpora un fichero udunits.dat con la lista de los nombres de unidad soportados.

long_name es el nombre de la variable que se presenta a los usuarios

standard_name define una manera de identificar unívocamente la magnitud que se está representando. Consta de una referencia a la tabla de standard names seguida opcionalmente de algunos modificadores.

Descripción de las coordenadas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Las variables que representan latitud y longitud deben llevar siempre el atributo "units". Se recomienda:

- Para latitud: degrees_north. Equivalente a degree_north, degree_N, degrees_N, degreeN y degreesN
- Para longitud: degrees_east. Equivalente a degree_east, degree_E, degrees_E, degreeE y degreesE

Opcionalmente, para indicar que una variable representa datos de latitud o longitud, es posible especificar 
un attributo (standard_name="latitude" | standard_name="longitude") o un atributo (axis="Y" | axis="X")

Descripción altura o profundidad
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Las variables que representan altura o profundidad deben llevar siempre el atributo "units".

Cuando las coordenadas son dimensionales, es posible indicar:

- Unidades de presión: bar, millibar, decibar, atmosphere (atm), pascal (Pa), hPa
- Unidades de longitud: meter, m, kilometer, km
- Otras

Si units no indica una unidad válida de presión, es necesario indicar el atributo "positive=(up|down)"

Opcionalmente, para indicar que una variable representa coordenadas verticales es posible especificar un attributo standard_name con un valor apropiado o un atributo (axis="Z")

En caso de coordenadas adimensionales, es posible, aunque desaconsejado, utilizar "level", "layer" o "sigma_level" como valor de "units". La forma recomendada por la convención CF es utilizar una serie de atributos que definen una fórmula que transforma un determinado valor de "level" a un valor dimensional. Estos atributos son "standard_name" para identificar la formula y "formula_terms" para especificar las entradas.

Descripción variables de tiempo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Las variables que representan tiempo deben llevar siempre el atributo "units". Se especifica::

	units=[unidad temporal] since [fecha_inicio]

Por ejemplo::

	units=seconds since 1992-10-8 15:15:42.5 -6:00

La unidad temporal puede ser: day (d), hour (hr, h), minute (min) y second (sec, s)

Una variable temporal puede ser identificada con las unidades sólo, pero también es posible utilizar "standard_name" con un valor apropiado o (axis='Z').

.. _coordsys:

Sistemas de coordenadas
^^^^^^^^^^^^^^^^^^^^^^^

Las dimensiones de una variable espacio temporal son utilizadas para localizar los valores de la variable en el espacio y en el tiempo. Existen varias maneras de localizar dichos valores.

Latitud, longitud, vertical y tiempo independiente
""""""""""""""""""""""""""""""""""""""""""""""""""

Cada una de las dimensiones es identificada por una "coordinate variable" según se explica en el NetCDF User Guide.

Series temporales de datos estacionarios
""""""""""""""""""""""""""""""""""""""""""""""""""

La variable tiene, en lugar de dimensiones latitud y longitud, una dimensión que identifica la posición de la medida. Variables coordenada auxiliares dan la latitud y longitud para cada posición. En el siguiente ejemplo se puede ver como una de las dimensiones de "humidity" es "station" y que las variables lat y lon tienen como única dimensión "station". Es decir, existe un valor de lat/lon para cada valor de station::

	dimensions:
	 station = 10 ; // measurement locations
	 pressure = 11 ; // pressure levels
	 time = UNLIMITED ;
	variables:
	 float humidity(time,pressure,station) ;
	  humidity:long_name = "specific humidity" ;
	  humidity:coordinates = "lat lon" ;
	 double time(time) ;
	  time:long_name = "time of measurement" ;
	  time:units = "days since 1970-01-01 00:00:00" ;
	 float lon(station) ;
	  lon:long_name = "station longitude";
	  lon:units = "degrees_east";
	 float lat(station) ;
	  lat:long_name = "station latitude" ;
	  lat:units = "degrees_north" ;
	 float pressure(pressure) ;
	  pressure:long_name = "pressure" ;
	  pressure:units = "hPa" ;

Trayectorias
""""""""""""""""""""""""""""""""""""""""""""""""""

El mismo caso que el anterior pero la variable tiene una dimensión temporal y existen variables coordenada auxiliares que dan la latitud, longitud y coordenada vertical para cada valor de tiempo.
En el siguiente ejemplo está la variable coordenada "time" que es la dimensión de todas las variables coordenada auxiliares: lat, lon y z::

	dimensions:
	 time = 1000 ;
	variables:
	 float O3(time) ;
	  O3:long_name = "ozone concentration" ;
	  O3:units = "1e-9" ;
	  O3:coordinates = "lon lat z" ;
	 double time(time) ;
	  time:long_name = "time" ;
	  time:units = "days since 1970-01-01 00:00:00" ;
	 float lon(time) ;
	  lon:long_name = "longitude" ;
	  lon:units = "degrees_east" ;
	 float lat(time) ;
	  lat:long_name = "latitude" ;
	  lat:units = "degrees_north" ;
	 float z(time) ;
	  z:long_name = "height above mean sea level" ;
	  z:units = "km" ;
	  z:positive = "up" ;

﻿.. _vocabulario.xml: http://ciclope.cmima.csic.es:8080/dataportal/xml/vocabulario.xml
.. _ISO8601: http://es.wikipedia.org/wiki/ISO_8601
.. _WKT: http://en.wikipedia.org/wiki/Well-known_text
.. _UTC: http://en.wikipedia.org/wiki/Coordinated_Universal_Time
.. _Luke: http://code.google.com/p/luke/downloads/list

.. |GN|  replace:: *GeoNetwork*
.. |DP|  replace:: *Data Portal*


Servicio "search" de búsqueda de datos
======================================

Este apartado define la interfaz del servicio de búsqueda *search*, tanto desde el punto de vista de la interfaz gráfica de usuario (su aspecto exterior), como los formatos de intercambio de información entre el cliente y el servidor.



Interfaz cliente-servidor
-------------------------

Las peticiones de búsqueda se harán mediante una peticion HTTP GET o POST a la siguiente url::

  [url_base]/search

Donde [url_base] es la URL donde está desplegada la aplicación. Por ejemplo::

  http://ciclope.cmima.csic.es:8080/dataportal/search


Tanto los parámetros de la petición como las respuestas se codificarán siempre en **UTF-8**.
  

Parámetros de la petición
^^^^^^^^^^^^^^^^^^^^^^^^^

Los parámetros que debe aceptar el servicio pueden dividirse en *parámetros de búsqueda*, *parámetros de paginación* y *parámetros de ordenación*.


Los *parametros de búsqueda* son:

  - **text**: Texto libre, a buscar entre cualquiera de los metadatos de tipo textual. Codificado en UTF-8.
  - **bboxes**: Lista de bounding boxes en EPSG:4326 expresada como un array, de formato::
  
      [[Xmin0,Ymin0,Xmax0,Ymax0],[Xmin1,Ymin1,Xmax1,Ymax1],...,[XminN,YminN,XmaxN,YmaxN]]
      
  - **start_date**: Formato "YYYY-MM-DD" (formato de fecha de calendario ISO8601_).
  - **end_date**: Formato "YYYY-MM-DD" (formato de fecha de calendario ISO8601_).
  - **variables**: Lista de variables separada por comas, de entre una lista controlada de valores. Los posibles valores son los distintos <nc_term> en `vocabulario.xml`_. Ejemplo::
  
      "sea_water_salinity,sea_water_temperature,sea_water_electrical_conductivity"
      
  - **response_format**: Formato MIME en que se solicita la respuesta. De momento sólo está definido el formato *text/xml*.
  
  
*Parámetros de paginación*:

  - **start**: Primer registro solicitado (offset, comenzando a contar por cero).
  - **limit**: Número máximo de resultados por página.
  
Por ejemplo, para solicitar la 3ª página a 20 resultados por página, los parámetros serían: *start=40* y *limit=20*.

  
*Parámetros de ordenación*:
  
  - **sort**: nombre del campo por el que se ordenan los elementos de la respuesta. Los posibles valores son:
    - "id",
    - "title",
    - "start_time", y
    - "end_time".
  - **dir**: "ASC" (orden ascendente) o "DESC" (orden descendente).

Por ejemplo, para obtener los registros más recientes primero, los parámetros serían: *sort=start_time* & *dir=DESC*.


Elementos de la respuesta
^^^^^^^^^^^^^^^^^^^^^^^^^

  - Flag **success**. Será *true* si todo ha ido bien, o *false* si ha habido algún error realizando la petición.
  
  - Atributo global **totalcount**. Se refiere al número total de resultados que cumplen los criterios de búsqueda, no contenidos en una respuesta específica. Por ejemplo, en una respuesta paginada donde se devuelvan 20 resultados por página, **totalcount** puede ser 1200 (así, toda la respuesta ocuparía 60 páginas de resultados).
  
  - Lista de resultados. Cada uno de ellos tendrá los siguientes elementos:

    - **id**: Identificador.
    - **title**: Título.
    - **summary**: Resumen.
    - **geo_extent**: Ámbito geográfico, expresado en WKT_. Se considerarán sólamente las primitivas geométricas 2D "POINT", "LINESTRING", "POLYGON" y "MULTIPOLYGON", expresadas en coordenadas geográficas WGS84 (EPSG:4326). Generalmente se tratará de un "POLYGON" de 4 vértices describiendo un BBOX.
    - **start_time** y **end_time**, en formato ISO8601_. Fracción horaria expresada en UTC_ (aka "Z").
    - **variables**: Lista de variables contenida en el dataset, separada por comas. Se espera que corresponda a una lista controlada de valores. Los posibles valores son los distintos <nc_term> de `vocabulario.xml`_.
    - **data_link**: Enlace a los datos.

    
En caso de error, el flag **success** será *false*, y la respuesta contendrá un error con los siguientes elementos:

  - **code**: Código del error. A criterio del desarrollador, debería servir para determinar la causa.
  - **message**: Mensaje amable para mostrar al usuario frustrado.

    
Respuesta codificada en "text/xml"
""""""""""""""""""""""""""""""""""

Ejemplo de respuesta XML válida::

    <?xml version="1.0" encoding="UTF-8"?>
    <response success="true" totalcount="330">
        <item>
            <id>5df54bf0-3a7d-44bf-9abf-84d772da8df1</id>
            <title>Global Wind-Wave Forecast Model and Ocean Wave model</title>
            <summary>This is a sample global ocean file that comes with default Thredds installation. Its global attributes have been modified to conform with Dataset Discovery convention</summary>
            <geo_extent>POLYGON ((-10 50, 10 50, 10 40, -10 40, -10 50))</geo_extent>
            <start_time>2011-07-10T12:00:00Z</start_time>
            <end_time>2011-07-15T12:00:00Z</end_time>
            <variables>sea_water_salinity,sea_water_temperature,sea_water_electrical_conductivity</variables>
            <data_link>http://ciclope.cmima.csic.es:8080/thredds/fileServer/cmimaTest/ocean-metadata-sample.nc</data_link>
        </item>
        <item>
            <id>5df54bf0-3a7d-44bf-9abf-84d772da8df1</id>
            <title>Global Wind-Wave Forecast Model and Ocean Wave model</title>
            <summary>This is a sample global ocean file that comes with default Thredds installation. Its global attributes have been modified to conform with Dataset Discovery convention</summary>
            <geo_extent>POLYGON ((-10 50, 10 50, 10 40, -10 40, -10 50))</geo_extent>
            <start_time>2011-07-10T12:00:00Z</start_time>
            <end_time>2011-07-15T12:00:00Z</end_time>
            <variables>sea_water_salinity,sea_water_temperature,sea_water_electrical_conductivity</variables>
            <data_link>http://ciclope.cmima.csic.es:8080/thredds/fileServer/cmimaTest/ocean-metadata-sample.nc</data_link>
        </item>
    </response>

    
Respuesta XML en caso de error::

    <?xml version="1.0" encoding="UTF-8"?>
    <response success="false">
        <error>
            <code>java.lang.NullPointerException</code>
            <message>Ooops, something went wrong here and there. Please do, or don't.</message>
        </error>
    </response>

Configuración de |GN| para búsqueda por variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
|GN| incluye el motor de búsqueda Apache Lucene para realizar búsquedas dentro del catálogo. Lucene está configurado para que estas búsquedas puedan ser realizadas por unos determinados campos. Para conseguir realizar búsquedas por un tipo de campos no incluidos, habrá que modificar |GN|. Los siguientes pasos indican como se ha de realizar esta modificación.

Indexación del campo en Lucene
""""""""""""""""""""""""""""""
En primer lugar indicaremos que nuevos campos han de ser indexados. Para ello en cada carpeta de esquema existe un archivo ``index-fields.xsl`` en el que se indica que campos han de ser indexados. La ruta para el esquema ISO19139 con el que estamos trabajando en el |DP| será::

	/var/lib/tomcat6/webapps/geonetwork/xml/schemas/iso19139/index-fields.xsl

Este archivo se trata de una plantilla XSLT que se encarga de extraer datos de nuestros metadatos en incluirlos en el índice de Lucene. Para realizar esta acción, debemos indicar que valores queremos que se incluyan en el índice, el nombre del campo en los que se incluirá y una serie de parametros que indican como han de incluirse estos:

* **store**: guarda el valor del campo en el índice
* **index**: indexa el campo, casi siempre será ``true``
* **token**: extrae el valor del campo en pequeños trozos (tokens)::
	
	P.ej.: 'es un valor de campo' --> 'es','un','valor','de','campo'

El fragmento de plantilla que debe quedar trás la ejecución de la plantilla será::

	<Field name="<nombre del campo>" string="{<valor del campo>}"
	store="true" index="true"
	token="true"/>

Así estamos indicando que cree un campo ``<nombre del campo>`` en el índice y que incluya el valor ``<valor del campo>`` en el mismo. Esta última será una expresión XPATH que recoja del metadato en el esquema que estamos trabajando, la información que nos interesa. En el caso del |DP| quedaría de la siguiente manera::

	<xsl:for-each select="//gmd:contentInfo/gmi:MI_CoverageDescription/gmd:dimension">
	<Field name="variable" token="false" store="true" index="true" string="{string(gmd:MD_Band/gmd:sequenceIdentifier/gco:MemberName/gco:aName/gco:CharacterString)}" />
	</xsl:for-each>

Así estamos indicando que para cada valor que aparezca de ``gmd:Dimension`` incluya este en un campo denominado ``variable`` en el índice. 
Una vez que hemos modificado el archivo ``index-fields.xsl`` debemos re-indexar todos los metadatos con la nueva disposición. Para ello iremos a la sección **Index settings** de la ventana de administración y en ``Rebuild Lucene index`` indicaremos ``Rebuild``. Esta operación tardará en función del número de metadatos que tengamos en el servidor.

Una vez que esta operación ha finalizado, debemos comprobar si las nuevas variables han sido indexadas. Para ello desargaremos la herramienta Luke_ - Lucene Index Toolbox, que nos permitirá explorar el indice y comprobar los cambios que hemos realizado. Una vez descargada, navegaremos hasta el directorio, modificaremos los permisos dandole de ejecución y ejecutaremos::

	$ java -jar lukeall-3.3.0.jar

Lo primero que nos indicará la aplicación es que seleccionemos la ruta donde se encuentra el índice, que en nuestro caso será::

	$TOMCAT_HOME/webapps/geonetwork/WEB-INF/lucene/nonspatial

.. image:: img/luke-lucene.png
		:width: 500 px
		:alt: Cáptura inicio Luke
		:align: center

Una vez abierto el índice, en la pestaña ``overview``, podremos comprobar que el campo se encuentra indexado, y visualizar los términos que ha guardado. También podremos ir a la pestaña ``search`` y realizar unas pruebas de búsqueda para el campo que acabamos de incluir.

Inclusión del campo en servicio CSW
"""""""""""""""""""""""""""""""""""
Una vez que hemos indexado el campo de búsqueda, debemos incluir este como campo soportado en las búsquedas a través del servicio CSW. Para ello modificaremos el archivo config-csw.xml que se encuentra en::

	$TOMCAT_HOME/webapps/geonetwork/WEB-INF/config-csw.xml

Debemos añadir dentro de los campos	``Additional queryable properties`` la linea que incluya nuestro campo como consultable. Para ello añadiremos en esa sección::

	<parameter name="<Nombre del campo dentro del esquema>" field="<nombre del campo incluido en el índice>" type="SupportedISOQueryables" />

Que para el caso del |DP| quedaría::

	<parameter name="ContentInfo" field="variable" type="SupportedISOQueryables" />

De esta manera, si consultamos del GetCapabilities del servidor observaremos si el campo ha sido incluido::

	<ows:Constraint name="SupportedISOQueryables">
	...
	<ows:Value>ContentInfo</ows:Value>
	...

Ya tendremos preparado nuestro servidor para realizar consultas por ``ContenInfo``.
    
Interfaz gráfica de usuario
---------------------------

TODO tras tarea 3.3.


Formulario de búsqueda
^^^^^^^^^^^^^^^^^^^^^^

TODO tras tarea 3.3.


Tabla de resultados
^^^^^^^^^^^^^^^^^^^

TODO tras tarea 3.3.
.. |dsc| replace:: *DatasetConversion*
.. |ds| replace:: *Dataset*
.. |s| replace:: *Station*
.. |t| replace:: *Trajectory*
.. |ts| replace:: *TimeSerie*
.. |dss| replace:: *Dataset*'s
.. |div| replace:: *DatasetIntVariable*
.. |ddv| replace:: *DatasetDoubleVariable*

Conversión a NetCDF
============================

Configuración del proyecto
----------------------------

Se ha creado un proyecto Java para generar NetCDFs que cumplan la convención utilizada en ICOS. Para hacer uso del proyecto
es necesario crear un proyecto Java y añadir la dependencia a *netcdf-converter*. Con maven, basta con añadir la siguiente
dependencia en el *pom.xml*:: 

	<dependency>
		<groupId>co.geomati</groupId>
		<artifactId>netcdf-converter</artifactId>
		<version>1.0-SNAPSHOT</version>
	</dependency>

Las dependencias están desplegadas en el repositorio maven de Fernando, por lo que habrá que añadir 
también la siguiente sección de repositorios::

	<repositories>
		<repository>
			<id>fergonco</id>
			<name>Repo en fergonco.es</name>
			<url>http://www.fergonco.es/maven-repo/</url>
		</repository>
	</repositories>

Interfaces a implementar
---------------------------

Una vez el proyecto depende del conversor es necesario implementar la interfaz |dsc|, a la que se le pedirán
los |dss| para la conversión.

Los |dss| devueltos por la implementación de |dsc| deberán implementar la interfaz |ds| y además, en función
de si contiene datos estacionarios o trayectorias, una (y sólo una) de las siguientes interfaces:

- |s| (o *GeoreferencedStation* ver javadoc).
- |t|.

En caso de implementar |s| puede implementar opcionalmente la interfaz |ts| indicando así que los datos
dependen de la dimensión tiempo.

En caso de |t|, esta extiende a |ts| por lo que no es necesario implementarla explícitamente.

Las implementaciones de |ds| deben devolver una o más variables principales que serán una implementación
de |div| o de |ddv|, dependiendo de si la variable en cuestión contiene valores enteros o decimales.

Conversión
------------

Una vez las interfaces hayan sido implementadas, ya sólo es necesario ejecutar un *main* con la siguiente línea::

	public static void main(String[] args) {
		Converter.convert(new UTMDatasetConversion());
	}

Limitaciones
------------

Coordenadas verticales no están soportadas.

Las variables no pueden tener más dimensión que tiempo y posición.Performance tests
==================

JMeter [1]_ can be used to test how the developed web services perform in different scenarios.

Before going on with this document, it is recommended to follow the web test plan
tutorial [2]_, which is very short and easy to read.

JMeter test plans are stored in .jmx files and there are several plans prepared to test the
dataportal services. At the moment of writing, they were on */dataportal/query-core/jmeter*
on the code base.

In order to launch a specific test, it is necessary to:

- Load it into jmeter.
- Set the number of users and the ramp-up period in the "Thread group" element.
- Possibly change the query parameters in the HTTP Request element to adapt to the desired test case.
- Execute Run > Start. 

Note that at any moment it is possible to right click an element in the test plan tree (at left)
and select the *Help* context menu to see a good explanation of the selected element.

Also be careful with the "Save responses to a file" element since it has a linux absolute path. In case a 
non-unix system is used it should be changed to specify the folder and prefix of the files containing
the different query responses. Relative paths are relative to the jmeter working directory.

Referencias
------------

.. [1] http://jmeter.apache.org/
.. [2] http://jmeter.apache.org/usermanual/build-web-test-plan.htmlRendimiento servicios
=======================

Todas las pruebas realizadas a continuación se han hecho atacando a 
los servicios de forma local y estos a geonetwork de forma
remota (en cíclope).

Las pruebas están hechas a fecha 11/1/2012. El hash del último commit
es "fa1e976". 

Servicio de búsqueda
-----------------------

Tests sin filtro
^^^^^^^^^^^^^^^^^

Los siguientes tests se han realizado con una petición que
devuelve la primera página de 25 resultados sin hacer ningún filtro.

Uso continuado
^^^^^^^^^^^^^^

Se lanzan 1000 peticiones sin filtros en 3000 segundos. Es
decir, una petición cada 3 segundos. Como cada petición tarda menos de
3 segundos no hay concurrencia. El objetivo de esta prueba es ver el
uso continuado del servidor sin estreses puntuales.

**Resultados**

Se observa en el *manager* de Tomcat que el número de sesiones
abiertas en geonetwork crece por cada petición. El valor más grande
observado es de 5759, sin que esto afecte al rendimiento
aparentemente. Se observa que el número decrece con el tiempo. Al
parecer se trata de un timeout elevado.

La siguiente figura muestra los resultados obtenidos.

.. figure:: img/jmeter_search_continuous.png
   
   Resultados búsqueda continua sin concurrencia.

Uso intenso "real"
^^^^^^^^^^^^^^^^^^

Se lanzan 200 peticiones sin filtros en 200 segundos. Es
decir, una petición cada segundo. El grado de concurrencia es bastante
alto. El objetivo es estresar GN para ver en qué punto se rompe.

**Resultados**

Todas las peticiones fueron servidas.

Se da concurrencia creciente, alcanzando más de 30 clientes
simultáneos. Los tiempos se incrementan proporcionalmente a la
concurrencia, como puede verse en la siguiente figura:

.. figure:: img/jmeter_search_real.png

Se puede apreciar que la productividad es casi el doble de lo que se podría obtener
encadenando peticiones una detrás de otra (0.5 peticiones/s).

Uso más intensivo
^^^^^^^^^^^^^^^^^^

Se lanzan 10 peticiones sin filtros en 2 segundos pero el
loop se pone a 100. Aparentemente, loop lo hace es enviar una nueva
petición cada vez que se completa una para mantener 10 peticiones
simultáneas hasta que se han consumido las 100*10 peticiones.
Conclusión, se crece de 0 a 10 peticiones en dos segundos y se
mantienen las 10 hasta el final del test.

**Resultados**

Se pueden ver en la siguiente figura3. Todas las peticiones se sirven. Ningún error.

.. figure:: img/jmeter_search_real_intense.png

DDOS
^^^^^^

Se lanzan 200 peticiones sin filtros en 2 segundos. Es
decir, 100 peticiones cada segundo. El grado de concurrencia va de 200
a 0. El objetivo es petar GN, pero no lo he conseguido.

**Resultados**

Los tiempos se van bastante. Hay unas pocas peticiones que petan al
principio (Raised exception while searching metadata :
java.sql.SQLException: Cannot get a connection, pool error: Timeout
waiting for idle object) pero el sistema se recupera y termina bien,
con más de un 90% de peticiones servidas correctamente.

Filtro BBox
^^^^^^^^^^^^^^^^^

Se ha realizado un test con un filtro bbox de la mitad del planeta
(-180, -90, 0, 90) y lanzando 100 peticiones en 100 segundos.

Se observa que el comportamiento es muy similar al de los tests sin filtro.

.. figure:: img/jmeter_search_bbox.png
    
Filtro temporal
^^^^^^^^^^^^^^^^^

Se ha realizado un test con un filtro tempora de "2010-1-1" a "2010-6-1"
y lanzando 100 peticiones en 100 segundos.

Se observa que el comportamiento es muy similar al de los tests sin filtro.

.. figure:: img/jmeter_search_date.png
   
Filtro por variable
^^^^^^^^^^^^^^^^^^^^^

Se ha realizado un test consultando los datasets que incluyen la variable
*depth* y lanzando 100 peticiones en 45 segundos. El tiempo es menor que en
los casos anteriores porque la productividad en este caso es mayor y se pretende
testear entornos con varios clientes simultáneos, cosa que no se conseguía realizando
una petición por segundo.

.. figure:: img/jmeter_search_var.png

Servicio de descarga
-----------------------

Los tests para el servicio de descarga se han realizado solicitando la descarga de
3 ficheros que suman 450Kb.

El tiempo de respuesta de una petición aislada está entre 1.5s y 2s.

Se han realizado 1000 peticiones en 1000 segundos. Es decir una petición por segundo,
lo que ha ocasionado 2 peticiones simultáneas constantemente. Se han obtenido tiempos
de respuesta iguales a los obtenidos por peticiones individuales.

Se han realizado test más agresivos (50 peticiones en 5 segundos) obteniendo tiempos
de respuesta más altos pero la misma productividad (por encima incluso que en el
caso anterior).

Esto se debe a que una gran parte del tiempo del servicio se emplea en la transmisión 
de los datos por la red y que no se ha alcanzado el límite de capacidad de la conexión.

También existe un pool de threads que permite maximizar el uso de dicha conexión. 

.. figure:: img/jmeter_download.png

Sitio web
============================

Tecnologías utilizadas
----------------------------

Para la creación del sitio web se ha utilizado rest2web [1]_, que permite la generación de HTML estático
a partir de ficheros escritos en reStructuredText y una plantilla HTML.

reStructuredText [2]_ es un formato tipo *wiki* que permite crear de forma sencilla tablas, incluir imágenes, etc.
Aquí [3]_ se puede consultar una guía rápida del formato.

La principal ventaja de dicha aproximación es que el resultado es HTML estático y por tanto los
requisitos del servidor son mínimos.

Instalación
-------------

En ubuntu basta con teclear:: 

    sudo apt-get install rest2web
    
en una línea de comandos.

Descripción del proyecto
-------------------------

Estructura
^^^^^^^^^^^

El directorio raíz de la web contiene un fichero *webicos.ini* con la configuración y los directorios *input* y *output*.

*Input* contiene la plantilla y los ficheros en reStructuredText, mientras que *output* contiene el sitio web generado.

Para generar hay que ejecutar r2w webicos.ini en el directorio raíz.

Contenidos
^^^^^^^^^^^

En *input*, cada fichero .txt consta de dos partes, una sección *restindex* y otra con los contenidos que se muestran
en la web. Por ejemlo::

    restindex
        crumb: partners
        format:rest
        page-title: Project Overview
        encoding: utf-8
        output-encoding: None
        target: index.html
    /restindex
    
    Objectives
    ==========
    
    To provide the long-term observations required to understand the present state and predict future behaviour of the global carbon 
    cycle and greenhouse gas emissions.

La sección *restindex* permite especificar parámetros para la generación del HTML, como por ejemplo el título de la
página (*page-title*) o el nombre de la página destino (*target*). 

index.txt
^^^^^^^^^^^

Especial atención requiere el fichero index.txt, que contiene sólo la sección *restindex* con atributos globales de todo el sitio::

    restindex
        crumb: home
        format:rest
        page-title: ICOS Spain
        encoding: utf-8
        output-encoding: utf-8
        section-pages: ,overview,organization,infrastructure,outreach,links,contacts
        file: style.css
        file: images/cabecera.jpg
        file: images/geomatico.png
        file: images/lsce.gif
        file: images/logo_UE_fp7.jpeg
        file: images/icos_bottom_banner.png
        file: images/logo_aemet.png
        file: images/logo_ceam.png
        file: images/logo_csic.png
        file: images/logo_ic3.png
        file: images/logo_uclm.png
        file: images/logo_ugr.png
        file: images/logo_u_las_palmas.png
    
        build: no
    /restindex

Los elementos más frecuentemente actualizados de esta página son el parámetro *section-pages* en caso de quere añadir
una nueva sección o los parámetros *file* en caso de querer incluir en el directorio *output* un nuevo fichero, ya
sea imagen, hoja css, etc.

Plantilla
^^^^^^^^^^^

Dentro de *input* es posible encontrar el fichero *template.txt* que contiene la plantilla HTML que se usará para
generar el HTML correspondiente a cada sección.

Dentro de dicho fichero es posible encontrar macros como  "<% title %>" que son susituidas en el momento de la
generación por contenido extraido de los ficheros correspondientes a las secciones.

También es posible ejecutar código Python existente para generar contenido dinámicamente. Estas llamadas se delimitan
por "<#" y "#>", por ejemplo::

    <#
        print_details(default_section, item_wrapper = '%s', page_title = '')
    #>

Para más información sobre las llamadas y macros disponibles, consultar [4]_ .

Referencias
------------

.. [1] http://www.voidspace.org.uk/python/rest2web/
.. [2] http://docutils.sourceforge.net/rst.html
.. [3] http://docutils.sourceforge.net/docs/user/rst/quickref.html
.. [4] http://www.voidspace.org.uk/python/rest2web/templating.html