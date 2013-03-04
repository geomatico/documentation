.. sectnum::

﻿.. |geomatico| replace:: **geomati.co**
.. |GS| replace:: **GeoServer**

.. _geomatico: http://geomati.co
.. _GS: http://geoserver.org


======================================
Geoserver, más allá de un servidor WMS
======================================

.. rubric::
   M. García, O. Fonts, V. González :sup:`(1)`

.. highlights::
   :sup:`(1)` |geomatico|_, red de desarrolladores SIG, info@geomati.co

.. epigraph:: **RESUMEN**

   |GS|_ es un servidor de mapas open source escrito en Java que permite a los usuarios compartir y editar información geoespacial usando estándares abiertos. En efecto, implementa varios estándares definidos por el Open Geospatial Consortium (OGC), como por ejemplo el archiconocido Web Map Service (WMS).

   Sin embargo, GeoServer ofrece muchas más funcionalidades que la implementación del estándar WMS. En el presente artículo se pretende dar un repaso a esas otras funcionalidades menos conocidas pero igualmente útiles y potentes que GeoServer incorpora.

   Para empezar se describirán brevemente los otros estándares más conocidos para servir datos: Web Feature Service (WFS) y Web Coverage Service (WCS).

   Algo menos conocido es la integración de Geowebcaché que permite cachear teselas de mapas para optimizar el servicio de las imágenes que componen los mapas, sirviéndolas mediante una interfaz estándar como WMTS.

   Web processing Service (WPS) ha sido incorporado en la versión 2.2.X como parte de la funcionalidad del nucleo de GeoServer. Ahora, GeoServer además de manejar el resto de estándares más comunes, WMS, WFS..., permite la creación de servicios de ejecución de tareas de análisis espacial. Se mostrará un ejemplo del uso de este estándar.

   GeoServer dispone también de una interfaz RESTful a través de la cual una aplicación cliente puede configurar una instancia del servidor simplemente usando llamadas HTTP. De esta manera se puede programar la configuración de los datos servidos por dicha instancia. Se mostrarán las operaciones más sencillas realizables a través de los servicios de esta API.

   Además de la cada vez mayor funcionalidad de la que dispone GeoServer, es posible, mediante el uso de las extensiones, incorporar mucha más de esta funcionalidad. Se hará un breve resumen de las extensiones más utilizadas mostrando algunos ejemplos de su uso.

   **Palabras clave:** GeoServer, RESTful, WPS, WFS, WMTS.


Introducción
============

|GS|_ es conocido como un servidor de mapas que cumple con los estándares OGC WMS, WFS y WCS principalmente. Una de sus características principales es una interfaz web de usuario que permite gestionar todos los contenidos del servidor (conexiones, capas, estilos, metadatos) de forma gráfica, lo cual facilita enormemente la gestión de los contenidos sin necesidad de tener conocimientos informáticos avanzados, puesto que no requiere editar ficheros de configuración o utilizar la línea de comandos.

Pero, además de la evidente interfaz gráfica, |GS| ofrece muchas más funcionalidades, no siempre conocidas, que lo hacen único respecto de otras alternativas, tanto de código libre como privativo. 

|GS| dispone de un muy buen manual en inglés, complementado por miles de *blog posts* y el histórico de sus listas de correo. Toda la información aquí expuesta se puede encontrar en la red. No es pues información inédita, y ni siquiera pretende ser exhaustiva. Simplemente pretendemos mostrar las características distintivas de |GS| que hemos considerado suficientemente relevantes, y esperamos que puedan resultar de utilidad para aquellas personas que se encuentren en la situación de tener que elegir un servidor de mapas para sus proyectos.

A pesar de su título, este documento comienza repasando los servicios estándar principales: WMS, WFS, SLD y WPS. Pero no describirá las funcionalidades básicas ya conocidas (qué es un documento de *capabilities*, o cómo realizar un *getMap*), sino que se centrará en las características que |GS| proporciona más allá de la funcionalidad evidente. Hablaremos también de algunas características relevantes al margen de OGC, como el sistema de seguridad y autenticación, el uso de las interfaces REST, y un repaso a algunas de sus extensiones, que se cuentan por docenas. Finalmente dedicaremos una breve nota a la interoperabilidad.

Este documento se ha elaborado en base a la última versión estable de |GS|, la 2.2.4.


WMS Avanzado
============

|GS| trata de llevar los estándares tan lejos como es posible. Por ejemplo, para WMS no sólo ofrece imágenes para la web, sino que a través de peticiones WMS podemos obtener visores completos, imágenes perfectamente georreferenciadas, documentos vectoriales o de alta resolución, listos para la imprenta, e incluso animaciones e información tridimensional.


Formatos distintivos
--------------------

Tal como se espera, WMS ofrece los formatos de imagen habituales: GIF, PNG y JPEG y TIFF. Pero veamos algunos formatos más interesantes [#]_:

.. [#] http://docs.geoserver.org/stable/en/user/services/wms/outputformats.html

* **image/png8**: Reduce el número de colores, escogidos de forma óptima, lo cual reduce el peso de la imagen PNG. Las últimas versiones utilizan una nueva técnica [#]_ que ofrece imágenes de calidad óptima, incluso con transparencia. La solución para generar cachés ligeras de capas vectoriales superpuestas.

.. [#] http://geo-solutions.blogspot.com.es/2012/05/developers-corner-geoserver-stunning.html


.. figure:: img/png_quantizers.png
   :align: center
   :width: 500
   :height: 250

   PNG8 generado en versiones anteriores (izquierda) y mejoras a partir de la versión 2.2 (derecha)

* **image/geotiff**, incluye cabeceras con el sistema de referencia de coordenadas. Unido al resto de capacidades del servicio (reproyección, simbolización, filtrado), permite usar WMS como un servicio flexible de descarga de geodatos que luego podremos incorporar en nuestros SIG de escritorio. También incluye la variante de 8 bits, **image/geotiff8**.

* **image/svg**, recupera una imagen en formato vectorial, editable con software de edición vectorial y calidad óptima para imprenta.

.. figure:: img/png_svg.png
   :align: center
   :width: 500
   :height: 250

   Detalle de una petición WMS de 2.2 metros/píxel, en formato PNG (izquierda) y SVG (derecha).

* **application/pdf**, que también se generará en formato vectorial cuando las capas sean vectoriales. Ideal para generar documentos para su impresión en alta calidad.

* **rss**, utilizable para monitorizar cambios en capas cuyo contenido cambie en el tiempo (eventos).

[[TODO montar capa dependiente del tiempo]]



* **kml** y **kmz**, permite ver el contenido en 3D en Google Earth. Dispone de varios parámetros específicos para controlar la manera como se obtienen los contenidos: incrementalmente utilizando networklinks, de forma rasterizada, de forma vectorial, etc. Combinado con las opciones de extrusión 3D y marcas temporales, permite animaciones y vistas tridimensionales, como veremos más adelante.

* **application/openlayers** genera un visor completo basado en OpenLayers a partir de una simple petición WMS. Es la opción que utiliza |GS| en su **layer preview**. Proporciona interactividad y la posibilidad de generar visores sencillos incrustables en páginas web sin tener que programar.



Parámetros específicos
----------------------

Además de los parámetros WMS estándar, |GS| proporciona una colección de parámetros específicos que extienden su funcionalidad:

* **angle**, permite orientar la imagen. 


Decoraciones
------------



Animaciones
-----------



3D
--


Filtrado de datos
=================

Introducción
------------

El estandar WFS o Web Feature Service implementado por la OGC es un servicio que permite el intercambio de geometrías, **features**, a través de la web. La diferencia principal con el WMS, o Web Map Service, es que este servicio WFS devuelve como respuesta un grupo de geometrías que permitirán al usuario realizar operaciones utilizando estas directamente, mientras que con el WMS solo tiene acceso a la representación espacial de estas geometrías. En ambos servicios el estandar define el parámetro **filter** mediante el uso del cual podremos realizar filtrado de los resultados a mostrar o descargar. 

OGC describe el estandar Filter Encoding[X], donde define la sintáxis que se puede utilizar para construir expresiones que permitan la consulta de estos y otros servicios. De la misma manera se describe el estandar CQL o Common Query Language[X]. Este se desarrolla como un lenguaje formal para desarrollar consultas con las que poder obtener información de sistemas como indices web, catálogos bibliográficos... La ventaja respecto del Filter Encoding es que se trata de un lenguaje más intuitivo, de lectura y definición más amigable, sin perder en ningún caso todo el potencial. Este estandar se creó para la especificación de Catálogo de la OGC[X].

|GS| implementa ambos estándares, tanto el Filter Encoding, como el CQL en una versión extendida denominada ECQL definida dentro del proyecto GeoTools[X].

Uso de filtrado en servicios WMS y WFS
--------------------------------------
El manejo de estos lenguajes de filtrado se realiza a través de las peticiones a los servicios. En el caso del uso del Filter Encoding, el parametro necesario es **filter** en ambos. Este parámetro está incluido dentro del estandar. La definición de las consultas se realiza mediante el uso de etiquetas de una manera similar a como manejaríamos un archivo XML. Por ejemplo, una consulta sencilla sería construida de esta manera::

	<PropertyIsEqualTo>
		<PropertyName>NOMBRE</PropertyName>
		<Literal>Valor</Literal>
	</PropertyIsEqualTo>
	   
En la anterior consulta se está indicando que se devuelva todas aquellas geometrías cuya propiedad NOMBRE = Valor. Para incluir esta consulta en la petición simplemente::

	http://localhost:8080/geoserver/namespace/wms?LAYERS=layer%3Aalayer&STYLES=&FORMAT=image%2Fpng&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&SRS=EPSG%3A4326&FILTER=<PropertyIsEqualTo><PropertyName>NOMBRE</PropertyName><Literal>Valor</Literal></PropertyIsEqualTo>&BBOX=-139.84870868359,18.549281576172,-51.852562316406,55.778420423828&WIDTH=780&HEIGHT=330
	
Al tratarse en este caso de una petición GET donde nos apoyamos en la URL para realizar la consulta, la expresión del filtro deberá codificarse de tal manera que pueda ser enviada dentro de esta URL.

Si se hecha un vistazo a la referencia del estandar Filter Encoding, podremos conocer las diferentes estructuras en las que nos permite apoyarnos para la construcción de los predicados. Por citar algunas tendremos:

	* Operadores de comparación.
		* Operadores binarios de comparación
		* Operador PropertyIsLike
		* ...
	* Operadores espaciales.
		* Intersects
		* Disjoint
		* Operador BBOX
	* Operadores lógicos
	* Expresiones
	
	.. note::
		En ningún caso es objetivo de este artículo mostrar la totalidad del estandar Filter Encoding por lo que se recomienda la revisión de este para un mejor entendimiento.

La construción de predicados apoyandose en este estandar puede convertirse en una operación compleja debido al manejo de las etiquetas de las diferentes operaciones. Por ejemplo, mediante esta operación estaríamos solicitando aquellas geometrías que cumpliesen diferentes predicados::

	<And>
		<Intersects xmlns:gml="http://www.opengis.net/gml">
			<PropertyName>the_geom</PropertyName>
			<gml:LineString><gml:coordinates>-125.68909683702887,50.174101053227751 -73.113095687349627,25.904513103468322 -73.113095687349627,25.904513103468322 -71.75127512103046,29.50361031445469</gml:coordinates></gml:LineString>
		</Intersects>
		<PropertyIsGreaterThan>
			<PropertyName>MALE</PropertyName>
			<PropertyName>FEMALE</PropertyName>
		</PropertyIsGreaterThan>
	</And>
	
CQL (Common Query Language) permite el manejo de consultas de una manera similar. En caso de querer representar la misma expresión básica del ejemplo anterior haremos::

	NOMBRE = Valor
	
como se puede observar la síntaxis es mucho más amigable, intentando equipararse a lenguajes de consulta más extendidos como el SQL.
Para ejecutar esta consulta en el servidor simplemente deberemos acompañar las peticiones con el parámetro **CQL_FILTER**::

	http://localhost:8080/geoserver/namespace/wms?LAYERS=layer%3alayer&STYLES=&FORMAT=image%2Fpng&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&SRS=EPSG%3A4326&CQL_FILTER=NOMBRE%20%3D%20'Valor'&BBOX=-139.84870868359,18.549281576172,-51.852562316406,55.778420423828&WIDTH=780&HEIGHT=330
	
|GS| implementa una extensión del lenguaje CQL denominada **ECQL**. Se puede ver una referencia del lenguaje en la documentación de GeoTools[X], proyecto bajo el que se ha desarrollado esta extensión. 

Si representasemos la expresión anterior mediante el lenguaje ECQL tendríamos::

	INTERSECTS(the_geom, LINESTRING(-125.68909683702887 50.174101053227751, -73.113095687349627 25.904513103468322, -73.113095687349627 25.904513103468322, -71.7512751210304629.50361031445469)) AND MALE > FEMALE	

Filtrado CQL
------------




Buscador
--------

Con CQL, paginación y GeoRSS (=> OpenSearch?)


SLD Avanzado
============

Estilos externos
----------------


Transformaciones
----------------


WPS Avanzado
============

Scripting...


Más allá de los estándares OGC
==============================

Seguridad
---------

Uno de los principales problemas que plantea el uso de datos geoespaciales en el entorno corporativo es la privacidad de los datos. Muchas veces los datos y/o servicios no son públicos, únicamente son accesibles para ciertas personas o bien sólo una persona puede publicarlos. Para solucionar este tipo de problemas, Geoserver proporciona un sofisticado sistema de seguridad que permite, entre otras muchas alternativas, la administración múltiple de datos y servicios [#]_.

.. [#] **MUELLER, C.**, 2012, *Flexible authentication for stateless web services* http://geoserver.org/display/GEOS/Flexible+Authentication+for+Stateless+Web+Services

El sistema de seguridad de Geoserver se basa en varios conceptos sencillos y muy comunes en la mayoría de los sistemas multiusuario: usuarios, grupos de usuarios y roles. Además, Geoserver incorpora el concepto de espacio de trabajo, que no es más que un contenedor que organiza datos y servicios. De esta manera, Geoserver proporciona un sistema de seguridad basado en roles, donde los permisos de lectura escritura y administración de los datos, servicios o espacios de trabajos se determinan mediante roles y estos roles son asignados a los usuarios o grupos de usuarios. 

Es precisamente gracias a los espacios de trabajo por lo que es posible la administración múltiple del servidor. Geoserver permite la posibilidad de dar permisos de administración sobre un espacio de trabajo a un determinado rol. De este modo, se puede permitir a un usuario añadir, eliminar, configurar y, en general, administrar datos y servicios sin que interfiera con otros espacios de trabajos que pueden estar completamente ocultos y administrados por otros usuarios con diferente rol. En cierto modo, puesto que cada espacio de trabajo crea sus propios endpoints WMS/WFS/WCS por separado, es posible considerar el conjunto de espacios de trabajo como varios servidores independientes ejecutándose sobre una sola instancia de GeoServer.


APIs REST
---------




Extensiones
===========

Breve resumen.



¿Interoperabilidad?
===================



Conclusiones
============


BORRAME: Directivas RST
=======================

Enlaces:

* Un `enlace inline <http://geomati.co>`_,
* Un `enlace externo`_.

.. _`enlace externo`: http://geomati.co


Notas a pie [#]_ autonuméricas [#]_.

.. [#] Primera nota a pie.
.. [#] Segunda nota a pie.


Esto es una figura. Poner width a 500, y height proporcional. Formato de imagen en png (no acepta vectoriales):

.. figure:: img/geomatico.png
   :align: center
   :width: 900
   :height: 160

   Pie de la figura: Logo de geomati.co.


Esto es una tabla:

.. table:: Descripción de la tabla 1.

  ========================  ==========================================
  Titulo 1                  Titulo 2
  ========================  ==========================================
  Fila 1                    Fila 1
  Fila 2                    Fila 2
  ========================  ==========================================


Esto es una tabla descrita como una lista:

.. list-table:: Descripción de la tabla 2.
   :header-rows: 1
   :widths: 15 22 15 15
   
   * - Titulo 1
     - Titulo 2
     - Titulo 3
     - Titulo 4
   * - Columna 1
     - Columna 2
     - Columna 3
     - Columna 4

Citar código::

  $ java -version


Sustituciones:

Esto es un |tlqsr|.

.. |tlqsr| replace:: texto largo que se repite
