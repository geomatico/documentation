Annex: Installing Oracle 11g in Ubuntu 12.04
============================================

Download
--------

Download Oracle 11g from:

  http://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html

This is the full enterprise version. It's free (as in free beer) for developers.

Oracle officially supports the following Linux distributions: *Oracle Linux v.[4, 5, 6]*, *Red Hat Enterprise v.[4, 5, 6]* i *SUSE Linux Enterprise v.[10, 11]*.

Oracle SQL Developer is the graphic environment to browse Oracle databases (similar to pgAdmin):

  http://www.oracle.com/technetwork/developer-tools/sql-developer/downloads/index.html


Install
-------

Ubuntu is not officially supported by Oracle, and installation is a bit tricky, but this is a pretty good step by step guide for Ubuntu 12.04:

  http://www.makina-corpus.org/blog/howto-install-oracle-11g-ubuntu-linux-1204-precise-pangolin-64bits

It'll need a 32-bit old library that cannot be found in the standard packages. So, download and install from:

  http://packages.ubuntu.com/quantal/libstdc++5

The tutorial has been followed on Linux Mint 13 (Maya), and it works.


Setup environment
-----------------

To use commandline utilities (such as ``sqlplus``), it's useful to set the environment in ``~/.bashrc``::

	export ORACLE_BASE=/opt/oracle/Oracle11gee
	export ORACLE_HOME=$ORACLE_BASE/product/11.2.0/dbhome_1
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME/lib
	export PATH=$PATH:$ORACLE_HOME/bin
	export ORACLE_SID=orcl

This should be done for ``oracle`` user and any other that needs access to Oracle's CLI utilities.


Service startup script
----------------------

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

Make sure to check the values for ``ORA_HOME`` and ``ORA_OWNR``.
