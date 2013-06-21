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

Then, copy your *52n-sos-webapp.war* file into *apache-tomcat-7.0.40/webapps* and execute *startup.bat* (Windows)
or *startup.sh* (Linux), depending on your operating system.

Now you have 52N SOS running in your Tomcat server. To access it, open this URL in your browser:

    http://localhost:8080/52n-sos-webapp
    
You will find the 52N SOS home page with the following message::

    You first have to complete the installation process! Click here to start it.
    
Click *there*, press Start and select Oracle Spatial from the drop-down list. A database configuration form will 
appear below. Fill it with your database settings. For example, for the "sos" user created above, these will be the
configuration values:

* **User Name**: 
* **User Name**: 
* **User Name**: 
* **User Name**: 
