Building from source
====================

You will need subversion (svn) and maven (mvn).


Get the source code
-------------------

Get the source code from SVN repo::

  svn checkout \
  https://svn.52north.org/svn/swe/main/SOS/Service/branches/52n-sos-400-refactored/ \
  52n-sos-400


Get the Oracle thin driver
--------------------------

52n SOS supports either *thin* (pure java) or *OCI* (more performant, platform specific) Oracle 11g drivers. The *thin* driver is easier to use for building the project.

These drivers are not freely distributable, so they have to be downloaded from Oracle's website and installed manually.

Download the latest 11.2 thin driver (*ojdbc6.jar*) from:

   http://www.oracle.com/technetwork/database/enterprise-edition/jdbc-112010-090769.html

And install the jar in your local repository::

    mvn install:install-file -Dfile=ojdbc6.jar -DgroupId=com.oracle \
    -DartifactId=ojdbc6 -Dversion=11.2.0 -Dpackaging=jar


Build with Maven
----------------

Then, you can build it using the Oracle profile::

    mvn package -P oracle

If the Oracle driver is not installed in Maven, the build will fail.
    
After the last command, a *52n-sos-webapp.war* file will appear in *webapp/target*, ready to use.


Enable unit tests
-----------------

The Oracle datasource project (hibernate/datasource/oracle) is ready for some unit testing related to database connectivity. Since it requires an existing Oracle database, tests are executed **only if** the environment variable **SOS_TEST_CONF** is defined. The value of this variable must be a valid path to a Java properties file. This file must contain the following keys:

* oracle_host: Oracle DB host
* oracle_port: Oracle DB port
* oracle_user: Oracle DB user. This user must have permissions to create tables and sequence and, in general, be ready
  to use it for the 52N SOS server successfully.
* oracle_pass: Oracle DB pass for the previously explained user.
* oracle_user_no_rights: Oracle DB user. This user must **NOT** have permissions to create tables or sequences.
* oracle_user_no_rights: Oracle DB pass for the previously explained user.

This is a sample file::

    oracle_host=localhost
    oracle_port=1521
    oracle_user=oracle
    oracle_pass=oracle
    oracle_user_no_rights=sos_test_no_rights
    oracle_pass_no_rights=sos
