In order to copy the sample values from PostGIS to Oracle, these steps have been followed.

1. Execute *pg_dump*::

     pg_dump -ab --exclude-table=spatial_ref_sys --inserts sos > dump.sql

2. Change dump.sql (made by hand)

  * Geometries. PostGIS (binary string) to Oracle (SDO)

    1. In PostGIS::
    
         SELECT ST_AsText(geom) FROM featureofinterest; 

    2. Copy <result>.

    3. In Oracle::

         SELECT MDSYS.SDO_GEOMETRY('<result>', null) FROM DUAL; 

    4. Replace PostGIS binary string for result of 3 in *dump.sql*.


  * Timestamps. Date string (PostGIS) to to_timestamp (Oracle). Example::

      '2012-11-19 13:00:00'

    to::

       to_timestamp('2012-11-19 13:00:00', 'YYYY-MM-DD HH24:MI:SS')
       
  * Comment missing tables when creating the Oracle DB with the 52N auto-generated script:
  
      * observationtype
      
      * observationconstellation
      
      * offeringallowedfeaturetype
      
      * offeringallowedobservationtype
      
      * resulttemplate
      
      * validproceduretime
      
  * Comment sequences (*SELECT pg_catalog.setval*)
