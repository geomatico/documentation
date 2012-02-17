===============================================================================
Creación de un plugin y ejecución contra distribución binaria existente
===============================================================================

Estructura del proyecto
------------------------

Creamos un proyecto java normal, con separación de fuentes y binarios en directorios *src* y *bin*.

Creamos un directorio *config* con un fichero *config.xml* con el siguiente contenido::

	<?xml version="1.0" encoding="UTF-8"?>
	<plugin-config>
		<depends plugin-name="com.iver.cit.gvsig" />
		<libraries library-dir="." />
		<extensions>
			<extension class-name="org.gvsigce.layerListener.HelloWorldExtension"
				description="Test extension. Remove"
				active="true"/>
		</extensions>
	</plugin-config>
	
Entre otras cosas, ahí se especifican las extensiones, que son invocadas al arrancar, y los menús y herramientas
que se instalarán para que el usuario pueda invocarlas manualmente. 

Classpath (Objetivo: compilar)
------------------------------

El objetivo es compilar, el entorno de ejecución es totalmente distinto y lo veremos posteriormente.

Dependencias de plugins
^^^^^^^^^^^^^^^^^^^^^^^^

Para depender de un plugin, sólo es necesario incluir el jar principal del plugin. Si hay errores de 
compilación se van resolviendo incluyendo el jar necesario, pero no es necesario meter
todas las dependencias transitivas a priori. Tampoco pasa nada por meterlas, no molestan y es
posible que sea más rápido, aunque haya más "ruido". De nuevo, el objetivo es "compilar".

Por ejemplo si se depende del plugin principal de gvSIG (*com.iver.cit.gvsig*) sólo es necesario incluir
dicho jar. En tiempo de ejecución, la dependencia se especifica en el *config.xml* (ver *depends* en 
ejemplo anterior).

Al utilizar un binario como base del desarrollo, es conveniente definir una variable GVSIG_HOME que
apunte al directorio donde gvSIG está instalado. Luego se pueden añadir los jars de los plugins
relativos a la variable.

Inicialmente se requiere el jar del plugin principal y andami::

	<?xml version="1.0" encoding="UTF-8"?>
	<classpath>
		<classpathentry kind="src" path="src"/>
		<classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER"/>
		<classpathentry kind="var" path="GVSIG_HOME/bin/gvSIG/extensiones/com.iver.cit.gvsig/lib/com.iver.cit.gvsig.jar"/>
		<classpathentry kind="var" path="GVSIG_HOME/bin/andami.jar"/>
		<classpathentry kind="output" path="bin"/>
	</classpath>

Dependencias de librerías normales
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

De la misma manera que en el caso anterior, el objetivo es compilar. Se meten todos los jars necesarios
para compilar en el classpath.

Generación del plugin
-----------------------

El plugin gvSIG es un directorio con el fichero *config.xml* en la raíz. Dicho fichero determina
el classpath en ejecución de dos maneras.

Dependencias de plugins
^^^^^^^^^^^^^^^^^^^^^^^^

Como se ha comentado antes, el fichero puede especificar con elementos *depends* 
los nombres de los plugins de los que depende.

En tiempo de ejecución, un plugin puede acceder a todas las classes que hay en los plugins 
de los que depende.

Dependencias de librerías normales
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

En la sección *libraries* del fichero se especifica el directorio donde se encuentran los jars en
tiempo de ejecución. En este directorio sí que es necesario poner todos y cada uno de los jars que
sean necesarios.

Generación con ant
^^^^^^^^^^^^^^^^^^^^

Típicamente se utiliza Ant para la generación del plugin. El objetivo es crear el directorio
del plugin con el *config.xml* en la raíz y con las librerías no-plugin necesarias::

	<project name="Generate extension in Andami" default="generate-without-source" basedir=".">
		<description>
	        Instala el plugin en Andami
	    </description>
		<!-- set global properties for this build -->
		<property name="build" location="bin" />
		<property name="dist" location="dist" />
		<property name="plugin" value="org.gvsigce.layerListener" />
		<property name="lib-dir" location="dist" />
		<property name="andami" location="/home/fergonco/applications/gvSIG_1.11.0_final/bin" />
		<property name="extensionsDir" location="${andami}/gvSIG/extensiones" />
	
		<target name="init">
			<!-- Create the time stamp -->
			<tstamp />
			<!-- Create the build directory structure used by compile -->
			<mkdir dir="${dist}" />
		</target>
	
	
		<target name="generate-without-source" description="generate the distribution without the source file">
			<!-- Create the distribution directory -->
			<delete dir="${dist}" />
			<mkdir dir="${dist}" />
			
			<jar jarfile="${dist}/${plugin}.jar" basedir="${build}" />
			<copy file="config/config.xml" todir="${dist}" />
			<copy todir="${dist}">
				<fileset dir="config" includes="text*.properties" />
			</copy>
			<copy todir="${lib-dir}">
				<fileset dir="./lib" includes="*.jar,*.zip" />
			</copy>
			<move todir="${extensionsDir}/${plugin}/">
				<fileset dir="${dist}" includes="**/**" />
			</move>
	
			<delete dir="${dist}" />
		</target>
	
	</project>

Ejecución
----------

Para ejecutar es necesario:

1- En la pestaña "main" dejar en blanco el proyecto y poner *com.iver.andami.Launcher* como clase a
ejecutar

2- En *arguments* se indica "gvSIG gvSIG/extensiones" sin las comillas y en "Working directory" el
directorio *bin* dentro de la instalación de gvSIG que queramos ejecutar.
