Install Oracle driver jar
-------------------------

After cloning the git repository, you have to include the Oracle driver jar in the local Maven repository. 
To do so, download it from the Oracle website:

   http://www.oracle.com/technetwork/database/enterprise-edition/jdbc-112010-090769.html

And install it in the local repository::

    $ mvn install:install-file -Dfile=ojdbc6.jar -DgroupId=com.oracle -DartifactId=ojdbc6 -Dversion=11.2.0 -Dpackaging=jar
    
Then, you can work as expected::

    $ mvn eclipse:eclipse
    $ mvn package
    
After the last command, a *52n-sos-webapp.war* file will appear in *webapp/target*, ready to use.


Testing
-------

The Oracle datasource project (hibernate/datasource/oracle) is ready for some unit testing related to database
connectivity. Since it requires an existing Oracle database, tests are executed **only if** the environment variable
**SOS_TEST_CONF** is defined. The value of this variable must be a valid path to a Java properties file. This file
must contain the following keys:

* oracle_host: Oracle DB host
* oracle_port: Oracle DB port
* oracle_user: Oracle DB user. This user must have permissions to create tables and sequence and, in general, be ready
  to use it for the 52N SOS server successfully.
* oracle_pass: Oracle DB pass for the previously explained user.
* oracle_user_no_rights: Oracle DB user. This user must **NOT** have permissions to create tables or sequences.
* oracle_user_no_rights: Oracle DB pass for the previously explained user.

Here is a sample file::

    oracle_host=localhost
    oracle_port=1521
    oracle_user=oracle
    oracle_pass=oracle
    oracle_user_no_rights=sos_test_no_rights
    oracle_pass_no_rights=sos
