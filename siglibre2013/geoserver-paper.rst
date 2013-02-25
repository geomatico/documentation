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

   |GS|_ es un servidor de mapas open source escrito en Java que permite a los usuarios compartir y editar información geoespacial usando estándares abiertos. En efecto, implementa varios estándares definidos por el Open Geospatial Consortium (OGC), como por ejemplo el archiconocido Web Map Service(WMS).

   Sin embargo, GeoServer ofrece muchas más funcionalidades que la implementación del estándar WMS. En el presente artículo se pretende dar un repaso a esas otras funcionalidades menos conocidas pero igualmente útiles y potentes que GeoServer incorpora.

   Para empezar se describirán brevemente los otros estándares más conocidos para servir datos: Web Feature Service (WFS) y Web Coverage Service (WCS).

   Algo menos conocido es la integración de Geowebcaché que permite cachear teselas de mapas para optimizar el servicio de las imágenes que componen los mapas, sirviéndolas mediante una interfaz estándar como WMTS.

   Web processing Service (WPS) ha sido incorporado en la versión 2.2.X como parte de la funcionalidad del nucleo de GeoServer. Ahora, GeoServer además de manejar el resto de estándares más comunes, WMS, WFS..., permite la creación de servicios de ejecución de tareas de análisis espacial. Se mostrará un ejemplo del uso de este estándar.

   GeoServer dispone también de una interfaz RESTful a través de la cual una aplicación cliente puede configurar una instancia del servidor simplemente usando llamadas HTTP. De esta manera se puede programar la configuración de los datos servidos por dicha instancia. Se mostrarán las operaciones más sencillas realizables a través de los servicios de esta API.

   Además de la cada vez mayor funcionalidad de la que dispone GeoServer, es posible, mediante el uso de las extensiones, incorporar mucha más de esta funcionalidad. Se hará un breve resumen de las extensiones más utilizadas mostrando algunos ejemplos de su uso.

   **Palabras clave:** GeoServer, RESTful, WPS, WFS, WMTS.


Introducción
============



WMS Avanzado
============



Formatos georreferenciados
--------------------------



Formatos Vectoriales
--------------------



Calidad de Imprenta
-------------------



Decoraciones
------------



Animaciones
-----------



3D
--


WFS Avanzado
============

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


Transformaciones de coordenadas
-------------------------------



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