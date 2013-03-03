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
   :width: 400
   :height: 200

   PNG8 generado en versiones anteriores (izquierda) y mejoras a partir de la versión 2.2 (derecha)

* **image/geotiff**, incluye cabeceras con el sistema de referencia de coordenadas. Unido al resto de capacidades del servicio (reproyección, simbolización, filtrado), permite usar WMS como un servicio flexible de descarga de geodatos que luego podremos incorporar en nuestros SIG de escritorio. También incluye la variante de 8 bits, **image/geotiff8**.

* **image/svg**, recupera una imagen en formato vectorial, editable con software de edición vectorial y calidad óptima para imprenta.

.. figure:: img/png_svg.png
   :align: center
   :width: 500
   :height: 250

   Detalle de una petición WMS de 2.2 metros/píxel, en formato PNG (izquierda) y SVG (derecha).

* **application/pdf**, que también se generará en formato vectorial cuando las capas sean vectoriales. Ideal para generar documentos para su impresión en alta calidad.

* **application/rss** y **application/atom**, útil para suscribirse a capas cuyos datos cambien con el tiempo. Las geometrías se codifican en formato GeoRSS, de modo que un visor adecuado (como OpenLayers [#]_) se pueden mostrar los resultados sobre un mapa.

.. [#] http://openlayers.org/dev/examples/georss.html

* **kml** y **kmz**, permite ver el contenido en 3D en Google Earth. Dispone de varios parámetros específicos para controlar la manera como se obtienen los contenidos: incrementalmente utilizando networklinks, de forma rasterizada (descarga completa o mediante teselado *superoverlay*), de forma vectorial, etc. Combinado con las opciones de extrusión 3D de y marcas temporales, permite animaciones y vistas tridimensionales, como veremos más adelante.

* **application/openlayers** genera un visor completo basado en OpenLayers a partir de una simple petición WMS. Es la opción que utiliza |GS| en su **layer preview**. Proporciona un método muy sencillo de incrustar visores en otras páginas web, enviarlos como enlace en un correo electrónico, etc.


Parámetros específicos
----------------------

Además de los parámetros WMS estándar, |GS| proporciona una colección de parámetros específicos que extienden su funcionalidad. Generalmente estos parámetros se utilizan ligados a algún caso de uso concreto. Es decir, la mayoría de ellos no tiene sentido usarlos en cualquier petición. Veamos algunos de los más interesantes:

* **angle**, permite orientar la imagen.

.. figure:: img/angle.png
   :align: center
   :width: 400
   :height: 200

   Petición WMS orientada al norte (izquierda) y con un ángulo de 45 grados (derecha).

* **cql_filter**, permite seleccionar qué geometrías quieren mostrarse, mediante unas sintaxis de filtrado (CQL y ECQL) muy compactas pero potentes. Por ejemplo, para obtener los elementos en un radio de 250 metros respecto a un punto dado::

  cql_filter=DWITHIN(the_geom, POINT (431198 4581563), 250, meters)

.. figure:: img/cql_filter.png
   :align: center
   :width: 400
   :height: 200

   Capa original (izquierda) y con el filtro de ejemplo aplicado (derecha).

Dedicaremos un apartado más adelante a ver sus posibilidades, entre las que se incluyen filtrados geométricos y temporales.

* **env**, permite especificar un conjunto de valores que se utilizarán para la simbolización personalizada. Los valores dependerán de cómo se contruya el SLD de visualización. Por ejemplo, podemos escoger qué símbolo se utilizará para un tipo de elemento, su tamaño y color. Veremos ejemplos en el apartado dedicado a simbolización.


Decoraciones
------------

En una imagen generada mediande WMS, además del propio contenido del mapa, nos puede interesar añadir alguna información contextual como la escala gráfica o numérica, la leyenda, e incluso textos e imágenes personalizadas.

Para ello, |GS| proporciona una manera de definir composiciones o *layouts* [#]_. 

.. [#] http://docs.geoserver.org/latest/en/user/advanced/wmsdecoration.html

Por ejemplo, el siguiente *layout* define tres decoraciones (leyenda, escala gráfica e imagen personalizada):

.. code-block:: xml

  <layout>
    <decoration type="legend" affinity="top,right" offset="12,12" size="auto"/>

    <decoration type="scaleline" affinity="bottom,right" offset="12,12" size="auto"/>

    <decoration type="image" affinity="bottom,center" offset="12,12" size="360,64">
      <option name="url" value="layouts/geomatico.png"/>
    </decoration>
  </layout>

Los ficheros de *layout* deben guardarse en ``GEOSERVER_DATA_DIR/layouts/nombre.xml`` , e invocarse mediante ``&FORMAT_OPTIONS=layout:nombre`` en la petición WMS.

.. figure:: img/decorations.png
   :align: center
   :width: 400
   :height: 200

   Resultado obtenido de aplicar el *layout* anterior a una petición WMS.


Animaciones
-----------

Aunque se base en el protocolo WMS, este servicio es completamente específico de GeoServer, y se utiliza para generar GIFs animados. utiliza dos parámetros:

* **aparam**: El parámetro que se desea animar. Puede ser cualquiera de los parámetros WMS, pero también cualquiera de los parámetros específicos de |GS|. Esto permite animar la posición, proyección, tamaño, tiempo, estilo, parámetros de estilo (env), ángulo, decoraciones, etc.

* **avalues**: una lista de valores que debe tomar el parámetro para cada uno de los *frames* del gif animado::

  http://localhost:8080/geoserver/wms/animate
  ?layers=<capa>
  &aparam=<parameto>
  &avalues=<valores> 

Como se observa, la dirección de base ya no es ``/geoserver/wms``, sino ``geoserver/wms/animate``.

Se pueden especificar las siguentes opciones de formato (**format_options**):

* **gif_loop_continuosly**: Para repetir la animación indefinidamente, o ejecutarla una sola vez.
* **gif_frames_delay*: El tiempo (en milisegundos) entre dos frames. Controla la velocidad de la animación.

Estas animaciones sólo se pueden generar en formato GIF.


Altura y tiempo
---------------

Por motivos históricos, en este momento existen dos maneras de gestionar las dimensiones de altura y tiempo en |GS|.

Protocolo WMS
.............



Formato KML
...........



WFS Avanzado
============

Filtrado CQL
------------


Buscador
--------

Con CQL, paginación y GeoRSS (=> OpenSearch?)


Procesos
========

Scripting...


SLD Avanzado
============

Estilos externos
----------------


Transformaciones
----------------



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


Transformaciones de coordenadas
===============================


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