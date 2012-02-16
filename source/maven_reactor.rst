=====================================================
Creación de un proyecto Maven multimódulo
=====================================================

Un proyecto maven multimódulo es un directorio con un *parent pom.xml* y una serie
de proyectos maven al mismo nivel que dicho *pom*.

Para la creación hace falta crear el *parent pom* a mano. La diferencia entre un *pom* normal
y un *parent pom* es básicamente el *packaging* y la sección *modules*::

	<?xml version="1.0" encoding="UTF-8"?>
	<project xmlns="http://maven.apache.org/POM/4.0.0
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
		xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
	  <modelVersion>4.0.0</modelVersion>
	
	  <groupId>GROUP</groupId>
	  <artifactId>ARTIFACT</artifactId>
	  <version>1.0-SNAPSHOT</version>
	  <packaging>pom</packaging>
	
	  <name>layerlistener</name>
	  <url>http://maven.apache.org</url>
	  <modules>
	  </modules>
	
	  <properties>
	    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
	  </properties>
	
	</project>
	
A continuación, en el directorio que contiene el parent pom se crean proyectos de la
forma habitual::

	mvn archetype:generate
	
Se actualizará la sección de *modules* del *parent pom*::

	<?xml version="1.0" encoding="UTF-8"?>
	<project xmlns="http://maven.apache.org/POM/4.0.0" 
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
		xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
	  <modelVersion>4.0.0</modelVersion>
	
	  <groupId>GROUP</groupId>
	  <artifactId>ARTIFACT</artifactId>
	  <version>1.0-SNAPSHOT</version>
	  <packaging>pom</packaging>
	
	  <name>layerlistener</name>
	  <url>http://maven.apache.org</url>
	  <modules>
			<module>Modulo1</module>
			<module>Modulo2</module>
	  </modules>
	
	  <properties>
	    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
	  </properties>
	
	</project>

y se incluirá una referencia al padre en los modulos hijo::

	<?xml version="1.0"?>
	<project
		xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd"
		xmlns="http://maven.apache.org/POM/4.0.0" 
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
		<modelVersion>4.0.0</modelVersion>
		<parent>
			<artifactId>PARENT_ARTIFACT</artifactId>
			<groupId>PARENT_GROUP</groupId>
			<version>1.0-SNAPSHOT</version>
		</parent>
		<groupId>GROUP</groupId>
		<artifactId>ARTIFACT</artifactId>
		<version>1.0-SNAPSHOT</version>
		<name>NAME</name>
		<url>http://maven.apache.org</url>
		<properties>
			<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
		</properties>
		<dependencies>
			...
		</dependencies>
	</project>

