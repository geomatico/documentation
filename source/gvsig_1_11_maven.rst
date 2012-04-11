===============================================
gvSIG 1.11 plugin development using Maven 3
===============================================

Project creation
------------------

As any normal maven project::

	mvn archetype:generate
	cd whatever
	mvn eclipse:eclipse

The pom.xml
-------------

1) Include these properties, that are used to reference the jars in the gvSIG installation::

	<gvsig.home>/path/to/gvsig</gvsig.home>
	<gvsig.plugin.home>${gvsig.home}/bin/gvSIG/extensiones/com.iver.cit.gvsig</gvsig.plugin.home>

2) Add your gvSIG dependencies using the *system* scope. Which dependencies? the necessary libraries
   for your plugin to compile. At runtime, the gvSIG classloader will provide these classes so at this
   point anything that makes the code compile is fine. Start with this minimum set::

	<dependency>
		<groupId>org.gvsig</groupId>
		<artifactId>com.iver.cit.gvsig</artifactId>
		<version>1.0</version>
		<scope>system</scope>
		<systemPath>${gvsig.plugin.home}/lib/com.iver.cit.gvsig.jar</systemPath>
	</dependency>
	<dependency>
		<groupId>org.gvsig</groupId>
		<artifactId>andami</artifactId>
		<version>1.0</version>
		<scope>system</scope>
		<systemPath>${gvsig.home}/bin/andami.jar</systemPath>
	</dependency>

3) Assemble your plugin::

	<build>
		<plugins>
			<plugin>
				<artifactId>maven-assembly-plugin</artifactId>
				<version>2.3</version>
				<executions>
					<execution>
						<id>release</id>
						<phase>package</phase>
						<goals>
							<goal>single</goal>
						</goals>
					</execution>
				</executions>
				<configuration>
					<descriptors>
						<descriptor>src/main/assembly/assembly.xml</descriptor>
					</descriptors>
					<finalName>${project.groupId}</finalName>
					<appendAssemblyId>false</appendAssemblyId>
					<attach>false</attach>
				</configuration>
			</plugin>
		</plugins>
	</build>

   The contents of the src/main/assembly/assembly.xml file are::

	<assembly>
		<id>gvsig-plugin</id>
		<baseDirectory>.</baseDirectory>
		<formats>
			<format>dir</format>
		</formats>
	
		<fileSets>
			<fileSet>
				<directory>${basedir}/src/main/config</directory>
				<outputDirectory>/</outputDirectory>
				<includes>
					<include>config.xml</include>
				</includes>
			</fileSet>
		</fileSets>
	
		<dependencySets>
			<dependencySet>
				<unpack>false</unpack>
				<scope>runtime</scope>
				<outputDirectory>/</outputDirectory>
			</dependencySet>
		</dependencySets>
	</assembly>

The config.xml file
---------------------

Start with this basic one::

	<?xml version="1.0" encoding="UTF-8"?>
	<plugin-config>
		<depends plugin-name="com.iver.cit.gvsig" />
		<libraries library-dir="." />
		<extensions>
			<extension class-name="org.example.TestExtension"
				description="Test extension"
				active="true"/>
		</extensions>
	</plugin-config>
	
The extension
----------------

Just create a new extension that says hello world when initialized::

	package org.example;
	
	import javax.swing.JOptionPane;
	
	import com.iver.andami.plugins.Extension;

	public class TestExtension extends Extension {
	
		@Override
		public void execute(String arg0) {
		}
	
		@Override
		public void initialize() {
			JOptionPane.showMessageDialog(null, "Qué pasa neeeeeen!");
		}
	
		@Override
		public boolean isEnabled() {
			return true;
		}
	
		@Override
		public boolean isVisible() {
			return true;
		}
	}

Deploying the plugin
---------------------

Just::

	mvn package
	
will create the folder in target. Move it to the gvSIG extension folder and run gvSIG.

Debugging gvSIG with eclipse
------------------------------------

1) In *main* tab leave empty the project text box and choose *com.iver.andami.Launcher* as main class.

2) put "gvSIG gvSIG/extensiones" in *arguments* and the *bin* folder in the gvSIG installation
   we are executing in "Working directory".
