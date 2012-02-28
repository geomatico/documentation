.. |AC| replace:: *Apache Continuum*
.. |GIT| replace:: *Git*
.. |MVN| replace:: *Maven2*
.. |GH| replace:: *Github*
.. |SH| replace:: *SSH*
.. |SCM| replace:: *SCM*

===================================================
Configuración de Apache Continuum con |GIT| y |MVN|
===================================================

Introducción
============

|AC| se trata de un servidor de integración continua con capacidad para realizar builds automáticos, gestión de releases, gestión de usuarios y se puede integrar con la mayoría de las herramientas conocidas de desarrollo y gestores de versiones.
En nuestro caso vamos a realizar la instalación y configuración de |AC| con el resto de herramientas de nuestro entorno, |GIT| y |MVN|. |AC| también nos permite el envio de alertas sobre el estado de las diferentes operaciones que realiza, tanto al correo como a diferentes herramientas 

Requerimientos
==============
+---------+-----------------------+
| JDK     |    1.5 o superior     |
+---------+-----------------------+
|Memoria  |   Sin minimo requerido|
+---------+-----------------------+
|Disco    |   Al menos 30MB       |
+---------+-----------------------+
| OS      |  Sin requerimiento    |
+---------+-----------------------+

Instalación
===========
En nuestro caso hemos realizado la instalación sobre una máquina con Ubuntu Server 11.10

Instalación y configuración de |GIT|
------------------------------------
Instalación de |GIT|
^^^^^^^^^^^^^^^^^^^^
Para máquinas con repositorio de paquetes basados en apt::
	
	$ sudo apt-get install git
	
Esto instalará |GIT| en la máquina. Podemos comprobar que la se ha instalado correctamente en la máquina ejecutando::

	$ git --version
	
que nos debría mostrar un mensaje similar a este::
	
	git version [número de versión]

Configuración de |GIT| para conectar con |GH|
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Antes de seguir con el proceso de instalación de el resto de herramientas es necesario realizar una configuración de |GIT| en la máquina. Lo primero que |AC| realiza es utilizar |GIT| para hacer un ``clone`` del proyecto desde nuestro repositorio, en este caso desde |GH|. |GIT| utiliza un sistema de claves basado en |SH| para autenticar al usuario en |GH|. Así lo primero que debemos hacer es crear nuestro almacén de claves |SH|. Antes de seguir con el proceso comprobaremos si ya existe el almacén de claves. Para ello nos loguearemos como ``sudo``. Esto es debido a que la instalación de |AC| posteriormente la vamos a realizar como servicio en nuestro equipo así que se ejecutará como usuario ``root`` por lo que las claves que debemos crear seran para este usuario::

	$ sudo su
	$ cd ~/.ssh
	
en caso de que exista podemos hacer un backup del contenido y después, siempre como ``root``::

	$ ssh-keygen -t dsa -C "tu_email@tuemail.com"
	
respondemos a las cuestiones que nos plantea por defecto. Para la ``passphrase`` se recomienda incluir una y después configurar un ssh-agent que almacene esa ``passphrase`` y la gestione. En nuestro caso no incluiremos esta información. Así que dejaremos la ``passphrase`` sin incluir.
Una vez que hayamos terminado con la creación de la clave veremos que en el directorio ha creado dos archivos ``id_dsa`` y ``id_dsa.pub`` donde almacena la información de las claves recién creadas.

El siguiente paso es incluir la información de nuestra clave en el repositorio |GH| para que este nos reconozca. Para ello vamos a nuestra cuenta en |GH| y en *"Account Settings"* > *"SSH public keys"* > *"Add another public key"* introduciremos el texto que aparece en el archivo recién creado ``id_dsa.pub``, no hace falta incluir un título. Una vez realizado esto comprobaremos que |GH| reconoce nuestro equipo ejecutando::

	$ ssh -T git@github.com
	
Indicamos *"yes"* cuando nos pregunte si queremos seguir conectando y si todo ha ido de manera correcta nos debería indicar::

	Hi *username*! Yoou've suddesfully authenticated, but GitHub does not provide shell acces
	
En caso de aparecer problemas recomendamos revisar los posibles errores en [1]_

Una vez comprobado que conectamos correctamente con nuestro servidor, configuraremos una serie de información dentro de |GIT|. |GIT| dispone de una herramienta ``config`` que permiten obtener y establecer variables de configuración que controlan el funcionamiento de |GIT|. Estas se almacenan en tres sitios distintos:

* Archivo ``/etc/.gitconfig``: que contiene los valores para todos los usuarios del sistema y sus repositorios. Con la opción ``--system`` la herramienta ``config`` lee y escribe estas variables.
* Archivo ``~/.gitconfig``: específico para cada usuario. Se accede a su información con la opción ``--global``.
* Archivo ``config`` en el directorio del repositorio, ``.git/congif``. Con información específica para ese repositorio. 

Cada nivel sobrescribe al nivel anterior.

Empezaremos configurando nuestra identidad::

	$ git config --global user.name "Nombre Apellido"
	$ git config --global user.email "tu_email@tuemail.com"
	
Incluiremos el token de la API de |GH|. Para ello introduciremos::

	$ git config --global github.user Nombre usuario github
	$ git config --global github.token 0123456789yourf0123456789token
	
Llegados a este punto deberíamos ser capaces de realizar un ``clone`` de un repositorio de |GH|. Podemos comprobar que esto es así realizando::

	$ git init
	$ git clone git@github.com:username/name_repository.git
	
+------------------------------------------------+
|       ¡ATENCION!                               |
|                                                |
|  Es importante tener en cuenta el usuario      |
|  con el que se ejecuta git y ssh para que      |
|  coincidan y después este tenga acceso a las   |
|  claves                                        |
+------------------------------------------------+

Para el caso en el que la información de la cuenta de |GH| sea diferente a la de la cuenta de la máquina, se debe configurar el archivo ``config`` del |SH|. Para ello modificamos o creamos el archivo ``.ssh/config`` e incluimos la siguiente información::

	Host github.com
		User git
		Hostname github.com
		PreferredAuthentications publickey
		IdentityFile [path a la ruta del archivo id_dsa]
		
+-----------------------------+
|   ¡ATENCION!                |
|                             |
|Este paso es necesario para  |
|el manejo de |GIT| con |AC|  |
+-----------------------------+


**Referencias**

* Set Up Git [2]_
* Configurando Git por primera vez [3]_
* Force SSH client to use given private key (identity file) [4]_

Instalación y configuración de |MVN|
------------------------------------
Instalación de |MVN|
^^^^^^^^^^^^^^^^^^^^
Como en el caso anterior se utilizará el gestor de paquetes de Ubuntu::

	$ sudo apt-get install maven2
	
Una vez realizada la instalación comprobaremos que esta se ha realizado de manera correcta mediante::

	$ mvn --version
	
que nos mostrará::
	
	Apache Maven 2.2.1 (rdebian-4)
	Java version: [número de versión]
	Java home: [path a la JRE]
	Default locale: es_ES, platform encoding: UTF-8
	OS name: "linux" version: [versión núcleo] arch: "i386" Family: "unix"

Configuración de |MVN|
^^^^^^^^^^^^^^^^^^^^^^
La única configuración necesaria serán la inclusión de las variables de entorno en nuestro sistema. Podemos hacer esto para todo el sistema o a nivel de ususario. Como en el caso anterior, recordar que el usuario con el que vamos a ejecutar |AC| es el usuario ``root`` que será el encargado de lanzar el servicio en el que instalamos |AC|. Añadiremos al archivo que deseemos lo siguiente::

	export M2_HOME=/usr/share/maven2
	export MAVEN_HOME=/usr/share/maven2
	export M2=/usr/share/maven2/bin
	export PATH=/usr/share/maven2/bin:PATH
	
Instalación de |AC|
-----------------------------------
La instalación de |AC| puede realizarse de dos maneras:

* Standalone
* Tomcat

en el primer caso, nos descargaremos un instalador con todo lo necesario para el uso de la herramienta, mientras que en la versión ``Tomcat``, será necesario realizar la instalación y configuración de estas de manera individual. En nuestro caso realizaremos la instalación ``Standalone``.
Para la instalación ´´Standalone´´ debemos descargar la versión que nos interese de la página de descargas de |AC| [5]_::

	wget http://apache.rediris.es//continuum/binaries/apache-continuum-1.3.8-bin.tar.gz

en este caso la versión descargada es la 1.3.8. Seguidamente descomprimimos e instalamos en el directorio que nos interese::

	$ tar -xzvf apache-continuum-1.3.8-bin.tar.gz
	$ sudo mv apache-continuum-1.3.8 /usr/local/apache-continuum

Instalación de |AC| como servicio
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Para instalar |AC| como servicio en Linux crearemos un enlace simbólico al script de inicio de |AC|::

	$ ln -s /usr/local/continuum-[VERSION]/bin/continuum /etc/init.d/continuum
	
y le indicamos que arranque este al inicio mediante::

	$ update-rc.d continuum defaults 80
	
obteniendo como mensaje::

	Adding system startup for /etc/init.d/continuum ...
		/etc/rc0.d/K80continuum -> ../init.d/continuum
		/etc/rc1.d/K80continuum -> ../init.d/continuum
		/etc/rc6.d/K80continuum -> ../init.d/continuum
		/etc/rc2.d/S80continuum -> ../init.d/continuum
		/etc/rc3.d/S80continuum -> ../init.d/continuum
		/etc/rc4.d/S80continuum -> ../init.d/continuum
		/etc/rc5.d/S80continuum -> ../init.d/continuum

Recordar que cuando se inicie la máquina nuestro servidor |AC| se iniciará con el usuario ``root``. Podemos comprobar esto mediante::

	$ ps -ef | grep continuum
	
Crearemos la variable de entorno para |AC| para todos los usuarios editando el archivo ``/etc/environment``::

	$ sudo echo 'export CONTINUUM_HOME=/usr/local/apache-continuum' > /etc/environment

Ejecución de |AC| en linea de comandos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Si se desea arrancar y parar |AC| de forma manual, es posible hacerlo ejecutando el script 
llamado *continuum* en el directorio *bin* de nuestra instalación.

Configuración de |AC|
=====================
Creación del usuario admin
--------------------------
Lo primero que necesitaremos para manejar nuestra instalación será generar un usuario ``admin`` con el que acceder al entorno de configuración de |AC|. Para ello según instalamos el servidor, accederemos a nuestra instalación mediante un navegador accediendo a::

	http://[dirección del servidor]:8080/continuum
	
esto mostrará una pantalla donde incluiremos nuestros datos, email, password,... El usuario que creamos es el usuario ``admin`` que es el que necesitaremos para acceder posteriormente. [6]_ Una vez que hayamos creado el usuario el sistema nos pedirá crear nuestros directorios de trabajo. Le indicaremos los directorios::

	* Working Directory: directorio desde donde nuestro sevidor realizará las operaciones necesarias ``clone``, ``init``...
	* Build Output|Releas|Deploy Directory: donde depositará los resultados del build, release y deploy respectivamente
	
Asegurarse de que nuestro usuario tiene permisos de escritura/lectura en dichos directorios
Una vez realizado esto, podremos añadir proyectos o seguir configurando algunas opciones más.

Configurando seguridad en |AC|
------------------------------
Las propiedades para seguridad en |AC| vienen definidas en un archivo ``security.properties`` que por defecto puede encontrarse en:

	* ~/.m2/security.properties
	* $CONTINUUM_HOME/conf/security.properties
	
En el caso de una instalación ``Standalone``, como es nuestro caso, |AC| se autoconfigura, y las propiedades de seguridad pueden encontrarse en: ``$CONTINUUM_HOME/apps/continuum/webapp/WEB-INF/classes/META-INF/plexus/application.xml``

Configurando Buiders y JDK en |AC|
----------------------------------
Será necesario incluir Builders en nuestra instalación. |AC| ya tiene incluidos por defecto pero podremos definir las herramientas que nos serán necesarias. En nuestro caso incluiremos las herramientas ``Maven`` y la ``JDK``. Para ello seleccionamos ``Type Installation`` > ``Add`` y le indicamos:

+------------------+-----------------------+---------------------+----------------------+-----------------------------+
|                  |  *Installation type*  |   *Name*            |         *Type*       |    *Value/Path*             |
+------------------+-----------------------+---------------------+----------------------+-----------------------------+
|    Maven2        |   Tool                |    Maven2           |      Maven2          | /usr/share/maven2           |
+------------------+-----------------------+---------------------+----------------------+-----------------------------+
|    JDK           |   Tool                |    Java6            |      JDK             | /usr/lib/jvm/java-6-openjdk |
+------------------+-----------------------+---------------------+----------------------+-----------------------------+

**Referencias**

	* Managing Building Tool [7]_
	* Managing JDKs [8]_
	
Configurando entorno para el Build
----------------------------------

Configuraremos un entorno para realizar el build de nuestro proyecto. Para ello iremos a la pestaña ``Build Environments`` de nuestro servidor |AC| y añadiremos uno ``Add`` asignandole un nombre y añadiendole las instalaciones que hemos creado en el paso anterior. Así indicaremos que realice las operaciones de compile/test contra nuestras instalaciones

**Referencias**
	
	* Build Environment [9]_
	
Configurando programaciones
---------------------------
Podemos indicar a |AC| los periodos de tiempo en los que queremos que realice las operaciones indicadas. Para ello crearemos unas programaciones. Iremos a la pestaña ``Schedules`` de nuestro servidor y le indicaremos ``Add``. A tener en cuenta en esta pestaña serán las expresiones ``cron`` con la que le indicaremos la periodicidad que nos interesa. Para una explicación de las expresiones ``cron`` visitar [10]_ La programación la debemos relacionar con la cola de trabajo en la que estemos interesados. De esta manera cuando se realice la operación determinada |AC| utilizará dicha cola para el desarrollo de las operaciones.
Hemos de marcar la casilla ``Enabled`` para activar nuestra programación.

**Referencias**
	
	* Managing Schedules [11]_

Configurando repositorios locales
---------------------------------
Por defecto |AC| utiliza el repositorio ``$USER_HOME/.m2/repository`` para la construcción de los artefactos, pero mediante esta opción le podemos indicar que utilice un directorio que nos sea interesante.

Configurando colas de Build
---------------------------
Por defecto existe la ``DEFAULT_BUILD_QUEUE`` que no puede ser eliminada. Pero podremos añadir más colas para el Build desde esta pestaña. De esta manera podemos realizar Build en paralelo si tenemos configurado el sistema para ello desde la página de Configuración.

**Referencias**

	* Managing Build Queues [12]_
	
Configurando plantillas para el Build
-------------------------------------
Estas plantillas serán donde indicaremos que operaciones queremos realizar sobre nuestro proyecto. Desde la página de administración de |AC| iremos a la pestaña ``Build Definition Templates`` > ``Add``. Por defecto en nuestra instalación aparecen varias plantillas para diferentes herramientas. En nuestro caso crearemos una para que utilice nuestra instalación de Maven2. Debido a la construcción del directorio de nuestro proyecto, será necesario indicar un parametro que le indique la posición del archivo pom.xml que debe utilizar para las operaciones. Así habrá que indicar los siguientes valores:

	* POM filename*: el nombre del archivo que utilizará para las operaciones, en nuestro caso pom.xml
	* Goals: las operaciones (``goals`` en Maven) que queremos que realice en cada build.
	* Arguments: argumentos opcionales que le podemos pasar para la ejecución de la operación, en nuestro caso debido a que el pom.xml no se encuentra en la carpeta raiz del proyecto le indicaremos la ruta relativa a esta carpeta donde se encuentra dicho archivo mediante el parámetro -f [ruta_relativa]/pom.xml
	* Build fresh: indica que realice siempre un checkout limpio en vez de realizar un update desde el gestor de versiones
	* Always Build
	* Schedule: la programción que queremos que utilice
	* Build environment: el entorno de construcción que debe utilizar
	* Type: el tipo de definición que es (Maven2 en nuestro caso)
	* Description: una pequeña descripción de la plantilla
	
Podremos modificar las plantillas que aparecen por defecto para que se adapten a las necesidades de nuestro proyecto.

**Referencias**
	
	Build Definition Template [13]_
	
Creación de proyectos en |AC|
=============================
Añadiendo un proyecto |MVN|
----------------------------
Lo primero que debemos entender es el flujo de trabajo de |AC|. Para crear un proyecto |MVN| debemos tener acceso a un archivo pom.xml que defina nuestro proyecto. Podremos indicarle que lo descargue desde una URL o podemos hacer que lo obtenga de un directorio local. 

Los proyectos maven2 multimódulo no pueden ser añadidos como fichero por lo que la opción más sencilla es especificar una URL con protocolo *file://*. En este último caso, debemos activar esta opción, ya que por razones de seguridad viene desactivada por defecto en |AC|. Esto se puede hacer editando el fichero $CONTINUUM_HOME/apps/continuum/WEB-INF/classes/META-INF/plexus/application.xml

El pom.xml que le vamos a indicar, desde el que |AC| construirá nuestro proyecto, debe incorporar las direcciones a nuestro repositorio de desarrollo, en este caso |GH|. Para ello debemos comprobar que aparecen las etiquetas ``scm`` en nuestro pom.xml::

	<scm></scm>
	
Mediante |SCM| podemos indicar las rutas a nuestro repositorio y así automatizar los procesos que maneja acciones contra este mediante |MVN|. Podemos encontrar una lista de los |SCM| implementados en este plugin en [15]_ Para el caso de Git se encuentra parcialmente imlementado, pero nos ofrece suficiente funcionalidad para las operaciones que necesitamos. Hemos de tener en cuenta el tipo de dirección que le vamos a indicar en las etiquetas ``scm``. Desde aquí le indicaremos el protocolo con el que nuestro servidor se comunicará con el repositorio. Este paso es importante, ya que tenemos que utilizar la seguridad que hemos configurado anteriormente al instalar la herramienta |GIT|. Existen varios protocolos con los que comunicarnos con nuestro repositorio |GIT|, http, https, ssh... en unos casos utilizaremos la seguridad implementada en |SH| mientras que en otro debemos indicarles manualmente los datos de acceso al repositorio. Esta última opción no nos es válida ya que las operaciones contra el repositorio se realizarán de manera automática por el |AC|. Así que lo que le indicaremos en el pom.xml será::

	<scm>
		<connection>scm:git:ssh://github.com/[username]/[repository].git</connection>
		<developerConnection>scm:git:ssh://github.com/[username]/[repository].git</developerConnection>
	</scm>
	
La diferencia entre ``developerconnection`` y ``connection`` es que en el caso de esta última, se trata de un acceso de solo lectura. Será la que use nuestro servidor |AC| para la descarga de nuestro código. 
Una vez que hayamos incluido esto en nuestro pom.xml podemos indicarle a |AC| la ruta de este y empezar a crear nuestro proyecto. Si para acceder a este archivo necesitamos identificarnos, podemos rellenar los campos ``Username`` y ``Password``, |AC| montará una peticion http indicandole en ella los datos suministrados de la manera::
	
	http://username:password//[urel del pom.xml]
	
podemos comprobar antes si el archivo es accesible de esta manera.

Otras opciones a definir serán:

	* Project Group, donde le indicamos si se trata de un grupo de proyectos, quien define el grupo
	* Marcaremos ``For multi-module project, load only root as recursive build``, si viene definido el grupo de proyectos mediante ``modules`` dentro del ``pom.xml``
	* Build Definition template, donde le podemos indicar la plantilla que queremos que utilice para el build, definida anteriormente.
	
Una vez que le indicamos ``Add``, |AC| automáticamente realizará un ``clone`` de nuestro proyecto en un directorio creado dentro del working-directory. Si todo está correcto, veremos en al pantalla ´´Project Group Summary´´ que en la opción ``Scm Root URL`` nos aparece marcado como ``Build in Sucess`` (tenemos una leyenda de símbolos en la parte inferior izquierda de la pantalla de |AC|). En cualquier otro caso, es interesante revisar el ``log`` que genera |AC|. Para ello podemos ejecutar un::

	$ tail -f $CONTINUUM_HOME/logs/continuum.log
	
que nos mostrará la información de los procesos que va realizando |AC|.

Hay que tener en cuenta que el proceso que realiza |AC| es por este orden:

	* Crea una carpeta en el directorio working-directory
	* Inicializa |GIT| en dicho directorio
	* Realiza un ``clone`` desde el mismo
	
Podemos realizar una comprobación manual de cualquiera de los pasos para comprobar que la instalación es correcta.
	
**Referencias**
	
	* Maven SCM [14]_
	* SCM Implementation: |GIT| [16]_
	* |Git| Remotes [17]_
	* Maven Tips and tricks: Using Github [18]_

Referencias
===========
.. [1] http://help.github.com/ssh-issues/
.. [2] http://help.github.com/linux-set-up-git/
.. [3] http://progit.org/book/es/ch1-5.html
.. [4] http://www.cyberciti.biz/faq/force-ssh-client-to-use-given-private-key-identity-file/
.. [5] http://continuum.apache.org/download.html
.. [6] http://continuum.apache.org/docs/1.3.8/getting-started.html
.. [7] http://continuum.apache.org/docs/1.3.8/administrator_guides/builder.html
.. [8] http://continuum.apache.org/docs/1.3.8/administrator_guides/jdk.html
.. [9] http://continuum.apache.org/docs/1.3.8/administrator_guides/buildEnvironment.html
.. [10] http://en.wikipedia.org/wiki/Cron
.. [11] http://continuum.apache.org/docs/1.3.8/administrator_guides/schedules.html
.. [12] http://continuum.apache.org/docs/1.3.8/administrator_guides/buildQueue.html
.. [13] http://continuum.apache.org/docs/1.3.8/administrator_guides/builddefTemplate.html
.. [14] http://maven.apache.org/scm/
.. [15] http://maven.apache.org/scm/scms-overview.html
.. [17] http://help.github.com/remotes/
.. [18] http://www.sonatype.com/people/2009/09/maven-tips-and-tricks-using-github/
