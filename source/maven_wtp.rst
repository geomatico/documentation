=====================================================
Creación de un nuevo proyecto WTP integrado con Maven
=====================================================

Herramientas
------------

Eclipse con soporte WTP
^^^^^^^^^^^^^^^^^^^^^^^
Instalar todos los paquetes de la categoría "Web, XML, Java EE Development 
and OSGi Enterprise Development" excepto "PHP Development" y "Rich Ajax 
Platform (RAP) Tooling”.

.. highlights::

   Puede que haga falta  añadir manualmente el repositorio.
   Para Eclipse 3.7 (Indigo):

   Menú Help > Install new Software > Add...

   * Indigo - http://download.eclipse.org/releases/indigo
   * Indigo updates - http://download.eclipse.org/eclipse/updates/3.7


Maven
^^^^^
Si no se van a gastar librerías externas que no pueden ser obtenidas mediante
Maven, se puede gastar cualquier versión de Maven.

.. highlights::

   Para instalar Maven3 manualmente:
   http://maven.apache.org/download.html#Installation


Sin embargo, si lo anterior es necesario, Maven 3.x permite la inclusión de 
jars externos como dependencias en el *pom.xml* de la siguiente manera::

	<dependency>
		<groupId>es.unex.sextante</groupId>
		<artifactId>sextante</artifactId>
		<version>1.0</version>
		<scope>system</scope>
		<systemPath>${local.lib.path}/sextante.jar</systemPath>
	</dependency>

donde *groupId*, *artifactId* y *version* tienen valores arbitrarios; para el
*scope*, *system* es similar a *provided*, sólo que hay que especificar la 
ubicación con *systemPath*. **IMPORTANTE**: esta ruta ha de ser **absoluta**.

De esta manera, si se compila el proyecto (*mvn eclipse:eclipse*), se 
incluirá el jar en el classpath automáticamente. Sin embargo, igual que con 
*provided*, si se empaqueta (*mvn package*), no se incluirá en el resultado. 
Para generar un *.war* que incluya estos jars, hay que especificarselo al 
war-plugin::

	<plugin>
		<groupId>org.apache.maven.plugins</groupId>
		<artifactId>maven-war-plugin</artifactId>
		<version>2.1.1</version>
		<configuration>
			<archive>
				<manifest>
					<addClasspath>false</addClasspath>
				</manifest>
			</archive>
			<webResources>
				<resource>
					<directory>${local.lib.path}</directory>
					<targetPath>WEB-INF/lib</targetPath>
					<includes>
						<include>**/*.jar</include>
					</includes>
				</resource>
			</webResources>
		</configuration>
	</plugin>

Tomcat
^^^^^^

Tomcat 7.x es la primera versión de Tomcat que soporta servlets 3.0 
(http://today.java.net/pub/a/today/2008/10/14/introduction-to-servlet-3.html),
que entre otras cosas, sustituye el descriptor *web.xml* por anotaciones en 
las clases Java. Para poder utilizar estas anotaciones, es necesario 
especificar la dependencia en el *pom.xml* (**IMPORTANTE**: el *scope* debe 
ser *provided*, ya que una vez se despliegue en Tomcat, la dependencia estará 
resuelta por el propio servidor)::

	<dependency>
		<groupId>org.apache.tomcat</groupId>
		<artifactId>tomcat-catalina</artifactId>
		<version>7.0.20</version>
		<scope>provided</scope>
	</dependency>

Si no se va a hacer uso de esta característica, se puede gastar cualquier versión de Tomcat. 


Creando el proyecto
-------------------

Vamos a crear un proyecto que tendrá un servlet para calcular el área de una 
determinada geometría, especificada en la propia URL de la petición (HTTP GET)
mediante WKT. Para esto, tendremos JTS 1.12 como dependencia para el ćalculo 
del área y la lectura del WKT. En primer lugar, creamos el proyecto::

	$ mvn archetype:generate -DarchetypeArtifactId=maven-archetype-webapp
	...
	Confirm properties configuration:
	groupId: org.examples
	artifactId: area-example
	version: 1.0-SNAPSHOT
	package: org.examples

	$ cd area-example
	$ mkdir src/main/java

Hay que fijarse en crear el directorio *src/main/java*, ya que Maven no lo 
crea por defecto. Lo mismo ocurre para *src/test/\**. Sin embargo, en este 
ejemplo tan sencillo no necesitaremos este directorio. También tenemos que 
modificar el *pom.xml* para incluir la dependencia a JTS. Además, para poder
implementar los servlets, necesitaremos también la dependencia a *servlet-api*;
es importante que el *scope* de esta dependencia sea *provided*, ya que una 
vez se despliegue la aplicación web en el servidor, éste será el que la
proporcione. El resultado será algo como esto::

	<project xmlns="http://maven.apache.org/POM/4.0.0" 
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
			http://maven.apache.org/maven-v4_0_0.xsd">
		<modelVersion>4.0.0</modelVersion>

		<groupId>org.examples</groupId>
		<artifactId>area-example</artifactId>
		<packaging>war</packaging>
		<version>1.0-SNAPSHOT</version>
		<name>area-example Maven Webapp</name>
		<url>http://maven.apache.org</url>

		<dependencies>
			<dependency>
				<groupId>com.vividsolutions</groupId>
				<artifactId>jts</artifactId>
				<version>1.12</version>
			</dependency>
			<dependency>
				<groupId>javax.servlet</groupId>
				<artifactId>servlet-api</artifactId>
				<version>2.5</version>
				<scope>provided</scope>
			</dependency>
		</dependencies>
	
		<build>
			<finalName>area-example</finalName>
			<plugins>
				<plugin>
					<groupId>org.apache.maven.plugins</groupId>
					<artifactId>maven-compiler-plugin</artifactId>
					<configuration>
						<source>1.6</source>
						<target>1.6</target>
					</configuration>
				</plugin>
			</plugins>
		</build>
	</project>

Ahora preparamos el proyecto para ser importado en Eclipse y lo importamos en el workspace::

	$ mvn eclipse:eclipse -Dwtpversion=2.0

Ahora simplemente tenemos que crear nuestro nuevo servlet::

	package org.examples;
	
	import java.io.IOException;
	import java.io.PrintWriter;

	import javax.servlet.ServletException;
	import javax.servlet.http.HttpServlet;
	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;
	
	import com.vividsolutions.jts.geom.Geometry;
	import com.vividsolutions.jts.io.ParseException;
	import com.vividsolutions.jts.io.WKTReader;

	public class AreaServlet extends HttpServlet {

		@Override
		protected void doGet(HttpServletRequest request,
				HttpServletResponse response) throws ServletException, IOException {
			PrintWriter writer = response.getWriter();
			try {
				Geometry geometry = new WKTReader().read(request
						.getParameter("GEOM"));
				response.setContentType("text/html");
				writer.write("Area is: " + geometry.getArea());
			} catch (ParseException e) {
				writer.write("Invalid WKT geometry");
			} finally {
				writer.close();
			}
		}
	}

Ejecutando nuestro servlet
--------------------------

En función de si utilizamos servlets 3.0 o no, deberemos especificar nuestro 
servlet en el fichero *web.xml* o no. Si no vamos a utilizarlos, nuestro
*web.xml* deberá ser así::

	<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xmlns="http://java.sun.com/xml/ns/javaee"
		xmlns:web="http://java.sun.com/xml/ns/j2ee/web-app_2_4.xsd"
		xsi:schemaLocation="http://java.sun.com/xml/ns/j2ee 
			http://java.sun.com/xml/ns/j2ee/web-app_2_4.xsd"
		version="2.4">

		<welcome-file-list>
			<welcome-file>Area</welcome-file>
		</welcome-file-list>

		<servlet>
			<servlet-name>AreaServlet</servlet-name>
			<servlet-class>org.examples.AreaServlet</servlet-class>
			<load-on-startup>1</load-on-startup>
		</servlet>
		<servlet-mapping>
			<servlet-name>AreaServlet</servlet-name>
			<url-pattern>/Area</url-pattern>
		</servlet-mapping>
	</web-app>

Si vamos a utilizar servlets 3.0, nuestro *web.xml* (que también debe de 
existir), será así::

	<web-app xmlns="http://java.sun.com/xml/ns/javaee" 
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xsi:schemaLocation="http://java.sun.com/xml/ns/javaee 
			http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd"
		version="3.0">
	</web-app>

Es importante notar que la versión especificada debe ser la 3.0 y que 
tendremos que añadir la anotación **@WebServlet** a nuestro servlet::

	@WebServlet("/Area")
	public class AreaServlet extends HttpServlet {
	...

Ahora, intentamos ejecutar el proyecto: botón derecho en el proyecto y *Run on
server*. En este punto simplemente configuramos nuestro Tomcat y le damos a 
finalizar. Veremos como en la consola aparece una *NullPointerException* 
debido a que no hemos especificado la geometría en la petición y nuestro 
servlet no maneja nada bien este tipo de situaciones. Si realizamos esta 
petición::

	http://localhost:8080/area-example/Area?GEOM=POLYGON((0 0, 5 0, 5 5, 0 5, 0 0))

el resultado mostrado en la web debería ser::

	Area is: 25.0

Empaquetando nuestra aplicación web
-----------------------------------

El empaquetado una vez se ha generado el proyecto correctamente es realmente
simple::

	$ mvn package

y en el directorio *target* tendremos una fichero *.war* con nuestra 
aplicación empaquetada y lista para ser desplegada en nuestro servidor.
