This tutorial shows how to install the 52N SOS in a Tomcat server from scratch. We assume that Oracle is already
installed in the system, and that there is an existing user with the following configuration:

* Connect permission
* Create table permission
* Create sequence permission
* Unlimited tablespace
* Quota unlimited on users

To create a user with that configuration::

    > create user sos identified by *password*;
    > alter user sos identified by *password* quota unlimited on users;
    > grant connect, create table, create sequence to sos;
    > grant unlimited tablespace to sos;

Once the Oracle database is configured, we proceed to setup Tomcat. Download it from its website and unpack it:

    http://tomcat.apache.org
   
For this tutorial we used the 7.0.40 version.

First, you need to create a file named *org.hibernate.spatial.dialect.oracle.OracleSpatial10gDialect.properties*
in *apache-tomcat-7.0.40/lib* with the following contents::

    CONNECTION-FINDER = org.n52.sos.ds.datasource.OracleC3P0ConnectionFinder
    
Then, copy your *52n-sos-webapp.war* file into *apache-tomcat-7.0.40/webapps* and start the Tomcat server. 

Now you have 52N SOS running in your Tomcat server. To access it, open this URL in your browser:

    http://localhost:8080/52n-sos-webapp
    
You will find the 52N SOS home page with the following message::

    You first have to complete the installation process! Click here to start it.
    
Click *there*, press Start and select Oracle Spatial from the drop-down list. A database configuration form will 
appear below. Fill it with your database settings. For example, for the "sos" user created above, these will be the
configuration values:

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

**IMPORTANT**: It is possible to insert test data in the database (by using the *Create test data* checkbox in the 
installation), but once it is created, it won't be possible to remove it using the 52N SOS webapp. Trying to do so from
the *Admin -> Datasource maintenance* menu will result in an internal server error. It is always possible to remove it 
using your preferred SQL client.
