.. sectnum::

.. |geomatico| replace:: geomati.co
.. _geomatico: http://geomati.co

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

   En este contexto, |geomatico|_ ha desarrollado un portal de búsqueda y descarga de datos que integre las mediciones realizadas en los ámbitos terrestre, marítimo y atmosférico, disciplinas que hasta ahora habían gestionado los datos de forma separada.

   El portal permite hacer búsquedas por múltiples ámbitos geográficos, por rango temporal, por texto libre o por un subconjunto de magnitudes, realizar vistas previas de los datos, y añadir los conjuntos de datos que se crean interesantes a un “*carrito*” de descargas.

   En el momento de realizar la descarga de una colección de datos, se le asignará un identificador universal que permitirá referenciarla en eventuales publicaciones, y repetir su descarga en el futuro (de modo que los experimentos publicados sean reproducibles).

   El portal se apoya en formatos abiertos de uso común en la comunidad científica, como el formato `NetCDF <http://www.unidata.ucar.edu/software/netcdf/>`_ para los datos, y en el `perfil ISO de CSW <http://www.opengeospatial.org/standards/cat>`_, estándar de catalogación y búsqueda propio del ámbito geoespacial. El portal se ha desarrollado partiendo de componentes de software libre existentes, como `Thredds Data Server <http://www.unidata.ucar.edu/projects/THREDDS/>`_, `GeoNetwork Open Source <http://geonetwork-opensource.org/>`_ y `GeoExt <http://geoext.org/>`_, y su código y documentación quedarán publicados bajo una licencia libre para hacer posible su reutilización en otros proyectos.

   **Palabras clave:** ICOS, Carbon, data portal, Thredds, Geonetwork.


Introducción
============

Objetivos
---------

Arquitectura
------------

El formato NetCDF
-----------------


Importador de datos NetCDF
==========================

Arquitectura
------------

Interfaz
........

Importadores desarrollados
--------------------------

Thredds
=======

Módulos (http, opendap, wms,...)
--------------------------------

Serialización JSON para OPeNDAP
-------------------------------


GeoNetwork
==========

Harvesting desde Thredds
------------------------

Indexación en Lucene
--------------------

Adaptación de CSW
-----------------

Dataportal: Servicios web (servidor)
====================================

Arquitectura
------------

Persistencia
------------

JPA, Datanucleus

Búsqueda
--------

Parámetros entrada
..................

Formato salida
..............

Descargas
---------

Parámetros entrada
..................

Formato salida
..............

Estadísticas
------------

Tipos
.....

Dataportal: Interfaz de Usuario (cliente web)
=============================================

Uso de ExtJS4 y GeoEXT
----------------------

Búsquedas
---------

Descargas
---------

Estadísticas
------------

Gráficas
--------

Metodología de desarrollo
=========================

Planificación (poker+excel)
---------------------------

Comunicación (skype+mikogo)
---------------------------

Documentación (rst+sphinx)
---------------------------

Control de versiones y tickets (github)
---------------------------------------

Gestión de dependencias y tareas (maven)
----------------------------------------

Testing (junit)
---------------

Rendimiento (jmeter)
--------------------

Conclusiones
============


Meta
====

Enlaces:

Un `enlace inline <http://geomati.co>`_,

Un `enlace externo`_.

.. _`enlace externo`: http://geomati.co

------------

Referencias:

  Notas a pie [#]_ autonuméricas [#]_.

.. [#] Primera nota a pie.
.. [#] Segunda nota a pie.

------------

Citar código::

  $ java -version

------------

Tablas:

TODO: Cambiar estilo headers

.. table:: Título de tabla

    =========== =============
    Name        Value
    =========== =============
    Dave        Cute
    Mona        Smart
    =========== =============

.. csv-table:: Tabla como CSV
   :header: "Treat", "Quantity", "Description"
   :widths: 15, 10, 30

   "Albatross", 2.99, "On a stick!"
   "Crunchy Frog", 1.49, "If we took the bones out, it wouldn't be
   crunchy, now would it?"
   "Gannet Ripple", 1.99, "On a stick!"

------------

Figuras:

(rst2odt no va a aceptar ni pdf ni svg, asi que todo bitmaps)

TODO: Aspect ratio fatal (even with python-image installed)

.. figure:: img/geomatico.png
   :align: center
   :width: 500px
   :alt: Título de la figura

------------

Sustituciones:

Esto es un |tlqsr|.

.. |tlqsr| replace:: texto largo que se repite

