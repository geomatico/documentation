Running in production
=====================

This tutorial shows how to install the 52N SOS in a Tomcat server from scratch. We assume that an Oracle 11g instance is already running and accessible through the network.


Create an Oracle user
---------------------

We need to create an Oracle user with the following configuration:

* Connect permission
* Create table permission
* Create sequence permission
* Unlimited tablespace
* Quota unlimited on users

To create a `sos` user with this configuration, you can use the following `sqlplus` commands::

    > create user sos identified by *password*;
    > alter user sos identified by *password* quota unlimited on users;
    > grant connect, create table, create sequence to sos;
    > grant unlimited tablespace to sos;


Get the Oracle Instant Client
-----------------------------

52n SOS supports either *thin* (pure java) or *OCI* (more performant, platform specific) Oracle 11g drivers.

The *OCI* driver is recommended for production.

Get the platform specific Oracle Instant Client (*OCI*) from Oracle's website:

    http://www.oracle.com/technetwork/database/features/instant-client/index-097480.html

.. note::

   If the full Oracle 11g has been installed in the same machine, the Instant Client is already there.


Install and configure tomcat
----------------------------

We'll need tomcat 6 or above. Download it from tomcat's website, or use the package manager from your Operating System.

1. Make sure that Tomcat will have access to the OCI driver files.

	* `LD_LIBRARY_PATH` (unix) or `PATH` (windows) environment variable should point to the location where Oracle Instant Client is installed.
	* The `ojdbc6.jar` file in this same location should be included in tomcat's classpath. For instance, make a symbolic link to it in `<TOMCAT_BASE>/lib`.

2. Create a file named *org.hibernate.spatial.dialect.oracle.OracleSpatial10gDialect.properties* in tomcat's `<TOMCAT_BASE>/lib` directory. This file's contents will be:

    CONNECTION-FINDER = org.n52.sos.ds.datasource.OracleC3P0ConnectionFinder

3. Copy your *52n-sos-webapp.war* file into `<TOMCAT_BASE>/webapps` and start the Tomcat server. For instance:

	sudo service tomcat6 start


First run: Setup SOS server
---------------------------

Now you have 52N SOS running in your Tomcat server. To access it, open this URL in your browser:

    http://localhost:8080/52n-sos-webapp
    
You will find the 52N SOS home page with the following message::

    You first have to complete the installation process! Click here to start it.
    
Click *here*, press Start and select Oracle Spatial from the drop-down list. A database configuration form will appear below. Fill it with your database settings. For example, for the "sos" user created above, these will be the configuration values:

* **User Name**: sos
* **Password**: sos
* **Database**: sos
* **Host**: localhost
* **Database port**: 1521
* **Schema**: sos
* **Transactional profile**: *Checked*
* **Create tables**: *Checked*
* **Delete existing tables**: *Checked*
* **Create test data**: *Checked*

Click Next and fill the Settings. For testing purposes it is possible to simply skip this process by clicking Next again.

Finally, set a user name and a password for the 52N SOS administrator and click Install.

.. warning::

   It is possible to insert test data in the database (by using the *Create test data* checkbox in the installation), but once it is created, it won't be possible to remove it using the 52N SOS webapp, as this functionality is not yet implemented (july 2013). Trying to do so from the *Admin -> Datasource maintenance* menu will show an error. It is always possible to remove it manually using your preferred SQL client.
