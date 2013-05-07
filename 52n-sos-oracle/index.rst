=======================================
Oracle Spatial driver for 52n SOS 4.0.0
=======================================

Installing Oracle 11g
=====================

Download Oracle 11g from:

  http://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html

It's the full enterprise version, it's free (as in free beer) for developers.

Oracle officially supports the following Linux distributions: *Oracle Linux v.[4, 5, 6]*, *Red Hat Enterprise v.[4, 5, 6]* i *SUSE Linux Enterprise v.[10, 11]*.

Oracle SQL Developer is the graphic environment to browse Oracle databases (similar to pgAdmin):

  http://www.oracle.com/technetwork/developer-tools/sql-developer/downloads/index.html


Installing Oracle on Ubuntu 12.04
---------------------------------

Ubuntu is not officially supported by Oracle, and installation is a bit tricky, but this is a pretty good step by step guide for Ubuntu 12.04:

  http://www.makina-corpus.org/blog/howto-install-oracle-11g-ubuntu-linux-1204-precise-pangolin-64bits

It'll need a 32-bit old library that cannot be found in the standard packages. So, download and install from:

The tutorial has been followed on Linux Mint 13 (Maya), and it works.

  http://packages.ubuntu.com/quantal/libstdc++5

Once installed, create an init script in ``/etc/init.d/oracle`` to start or stop Oracle as a service::

	#!/bin/bash
	#
	# Run-level Startup script for the Oracle Instance and Listener
	#
	### BEGIN INIT INFO
	# Provides:          Oracle
	# Required-Start:    $remote_fs $syslog
	# Required-Stop:     $remote_fs $syslog
	# Default-Start:     2 3 4 5
	# Default-Stop:      0 1 6
	# Short-Description: Startup/Shutdown Oracle listener and instance
	### END INIT INFO

	ORA_HOME="/opt/oracle/Oracle11gee/product/11.2.0/dbhome_1"
	ORA_OWNR="oracle"

	# if the executables do not exist -- display error

	if [ ! -f $ORA_HOME/bin/dbstart -o ! -d $ORA_HOME ]
	then
	        echo "Oracle startup: cannot start"
	        exit 1
	fi

	# depending on parameter -- startup, shutdown, restart
	# of the instance and listener or usage display

	case "$1" in
	        start)
	                # Oracle listener and instance startup
	                echo -n "Starting Oracle: "
	                su - $ORA_OWNR -c "$ORA_HOME/bin/dbstart $ORA_HOME"
	                su - $ORA_OWNR -c "$ORA_HOME/bin/lsnrctl start"

	                #Optional : for Enterprise Manager software only
	                su - $ORA_OWNR -c "$ORA_HOME/bin/emctl start dbconsole"

	                touch /var/lock/oracle
	                echo "OK"
	                ;;
	        stop)
	                # Oracle listener and instance shutdown
	                echo -n "Shutdown Oracle: "

	                #Optional : for Enterprise Manager software only
	                su - $ORA_OWNR -c "$ORA_HOME/bin/emctl stop dbconsole"

	                su - $ORA_OWNR -c "$ORA_HOME/bin/lsnrctl stop"
	                su - $ORA_OWNR -c "$ORA_HOME/bin/dbshut $ORA_HOME"
	                rm -f /var/lock/oracle
	                echo "OK"
	                ;;
	        reload|restart)
	                $0 stop
	                $0 start
	                ;;
	        *)
	                echo "Usage: $0 start|stop|restart|reload"
	                exit 1
	esac
	exit 0

Make sure to check values in ``ORA_HOME`` and ``ORA_OWNR``.

To use commandline utilities (such as ``sqlplus``), it's useful to set the environment in ``~/.bashrc``::

	export ORACLE_BASE=/opt/oracle/Oracle11gee
	export ORACLE_HOME=$ORACLE_BASE/product/11.2.0/dbhome_1
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME/lib
	export PATH=$PATH:$ORACLE_HOME/bin
	export ORACLE_SID=orcl

This should be done for ``oracle`` user and any other that needs access to Oracle's CLI utilities.


52n SOS v.4.0.0 Code
====================

Recommended execution environment:

 * Java 1.6
 * Tomcat 6
 * PostgreSQL 9
 * PostGIS 2
 * pgAdmin (optional, but useful)
 
Requirements for code development:

 * svn
 * git
 * git-svn
 * maven (52n recommends maven 3, but maven 2 also works)
 * eclipse (or any other IDE at your choice)

Source code is in 52n's SVN repo, Development branch is:

  https://svn.52north.org/svn/swe/main/SOS/Service/branches/52n-sos-400-refactored/

To develop without interfering, we've created a *mirror* in Github, keeping all the history from SVN branch:

  https://github.com/oscarfonts/52n-sos-4.0

The mirror has been created with *git-svn*, following these steps::

  # Get the SVN revision where the branch starts (result: 12853)
  svn log --stop-on-copy https://svn.52north.org/svn/swe/main/SOS/Service/branches/52n-sos-400-refactored/

  # Create git repo keeping the branch's history (thus ``-r12853``)
  git svn clone -r12853:HEAD https://svn.52north.org/svn/swe/main/SOS/Service/branches/52n-sos-400-refactored/ 52n-sos-4

The "master" git branch will be a mirror of the SVN one. DON'T commit any change to this branch, only rebase from original SVN to incorporate latest changes::

  git checkout master    # get master branch
  git svn rebase         # update from svn
  git push origin master # share on github

To keep up with SVN changes, first bring them to the "master" branch as expained, then propagate them to the "oracle" branch::

  git checkout oracle    # a oracle hi ha les nostres coses
  git pull master        # incorporem els canvis dels mestres de 52n
  git push origin oracle # cap al github

To build the war file (see the project's ``README.txt`` for more details)::

  mvn package # compila, executa els tests, i prepara el .war

WAR will be located at ``webapp/target/52n-sos-webapp-4.0.0-SNAPSHOT.war``.

Deploy the war file on Tomcat webapps and open:

  http://localhost:8080/sos/

This will open the first-run installation wizard.

.. note::

   **TODO:** Create Jetty starter to enable debugging within Eclipse.


Oracle JDBC driver
==================

**Work In Progress, need to find the best way to deal with these proprietary drivers**

There are two drivers, "thin" and "OCI". The thin client is pure java, the OCI driver is platform-specific, but provides more functionality. The use of OCI driver is recommended, to avoid fetch size limitations on BLOB fields and increase performance.


Using thin driver with maven
----------------------------

For licensing reasons, it has to be installed manually to the local Maven repo.

1. Download thin driver from: http://www.oracle.com/technetwork/database/enterprise-edition/jdbc-112010-090769.html
2. Install to Maven local repo:
   mvn install:install-file -DgroupId=com.oracle -DartifactId=ojdbc14 -Dversion=10.2.0.3.0 -Dpackaging=jar -Dfile=ojdbc6.jar -DgeneratePom=true
3. Add dependency to ``pom.xml``:

.. code-block: xml

  <dependency>
    <groupId>com.oracle</groupId>
    <artifactId>ojdbc14</artifactId>
    <version>10.2.0.3.0</version>
  </dependency>

.. warning::

   This manual installation will be a nuisance for non-oracle-wise developers. We whould avoid interfering with, or blocking, other developer's work that may not want to use Oracle at all.


Installing thin driver in the system
------------------------------------

As the jar file cannot be packaged and distributed with the war project, it'd rather be placed as a shared library in the system (accessible to all webapps). For instance, in a standard Ubuntu setup::

  sudo cp ojdbc6.jar /usr/share/java  # system wide java shared libraries
  sudo ln -s ../../java/ojdbc6.jar /usr/share/tomcat6/lib/ojdbc6.jar  # tomcat java shared libraries


Using the OCI driver
--------------------

Download the Oracle Instant Client:

  http://www.oracle.com/technetwork/database/features/instant-client/index-097480.html

Instructions from Ubuntu:

  https://help.ubuntu.com/community/Oracle%20Instant%20Client

.. note::

   In a system where the full Oracle 11g has been installed, the Instant Client is already there.


Changes needed in 52n SOS 4.0.0
===============================

53n SOS version 4.0.0 uses Hibernate to abstract the SGBD specificities. But, if we try to connect to Oracle without changing the 52n SOS code, we see this is not quite true.

Using the following connection parameters in the installation wizard:

 * Database Host: localhost
 * Database Port: 1521
 * Schema: sos
 * Database Driver: oracle.jdbc.driver.OracleDriver
 * Connection Pool: --
 * Database Dialect: --
 * Connection String: jdbc:oracle:oci:sos/sos@192.168.1.1:1521/orcl

We get::

  java.lang.NullPointerException
	org.n52.sos.web.JdbcUrl.parse(JdbcUrl.java:94)
	org.n52.sos.web.install.InstallDatabaseController.checkJdbcUrl(InstallDatabaseController.java:139)
	org.n52.sos.web.install.InstallDatabaseController.process(InstallDatabaseController.java:61)
	org.n52.sos.web.install.AbstractProcessingInstallationController.post(AbstractProcessingInstallationController.java:54)

So, the first class to change/extend is ``org.n52.sos.web.JdbcUrl`` parser, as Oracle connection string syntax differs very much from the Postgresql one.

The wizard page itself will need an "Oracle" vs. "PostGIS" selector, so it can trigger different behaviours (in JDBC connection string parsing, for instance, and also on database creation).

Users can tell the installation wizard to create a test database, and load some test data on it. This is controlled by ``InstallFinishController`` class, which will run the following methods and their associated SQL scripts::

  * ``setSchema``.
  * ``dropTables``: Runs DROP_DATAMODEL_SQL_FILE = ``/sql/script_20_drop.sql``
  * ``createTables``: Runs CREATE_DATAMODEL_SQL_FILE = ``/sql/script_20_create.sql``
  * ``insertTestData``: Runs INSERT_TEST_DATA_SQL_FILE = ``/sql/insert_test_data.sql``
  * ``insertSettings``: this has ben recently changed to use an internal sqlite database, so hopefully won't affect.

These scripts may contain PostgreSQL/PostGIS specific syntax (well, they do, actually). Here we suggest some alternative solutions:

 * One approach would be to duplicate the scripts, adapting them to Oracle (Spatial) specific syntax. This will add a manteinance burden if the SOS schema changes (which is likely to happen sooner or later).
 * The elegant solution would be to use Hibernate, so schema creation and initial data loading is abstracted from SGBD specific syntax. This can be a lot of work, we have to study carefully if we can afford it.
 * An intermediate solution would be to split the scripts, expressing as much as possible in a neutral "standard SQL" language, and keeping the irreductible "SGBD specific" bits (spatial?) separate.

Once the initialisation wizard is working, the server is supposed to use Hibernate for its normal operation (TODO further analysis is needed to confirm there's no other hardcoded SQL around).

To operate with PostGIS specificities, a custom dialect has been created, based on *hibernate spatial* (see ``hibernate-dialect`` module), which bridges geospatial PostGIS data with JTS classes. Oracle Spatial will need its own dialect, analogous to the existing one, providing implementations for ``org.hibernate.spatial.SpatialDialect`` and ``org.hibernate.type.descriptor.sql.SqlTypeDescriptor`` interfaces, and an extension to ``org.hibernate.spatial.dialect.AbstractJTSGeometryValueExtractor``.


Coding style
------------

The goal is to contribute the Oracle capabilities to the original 52n project. Take into account that a contributor agreement license is needed, as well as good coordination and approval from the 52n core developers. Use the 52n SOS mailing list.

New code will be documented in Javadoc. JUnit testing with a reasonable coverage will be provided. Error handling should take special care on logging meaningful messages from Oracle's error causes.

Any Oracle setup that cannot be automated by the SOS server should be clearly documented for future users and developers (v. gr. how to create a schema/user, how to grant permissions, or how to install the propietary JDBC/OCI drivers).

Note that this is a first quick analysis, and further code modifications could be needed. Consider sharing progresses in the SOS public mailing list and asking for beta testers out there.
