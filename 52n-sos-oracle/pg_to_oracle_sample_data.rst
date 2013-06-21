Instructions
------------

In order to copy the sample values from PostGIS to Oracle, these steps have been followed.

1. Execute *pg_dump*::

     $ pg_dump -ab --exclude-table=spatial_ref_sys --inserts sos > dump.sql
     
2. Create a file *dump.sed* with the following contents::

     # dump.sed
     s/INSERT INTO featureofinterest VALUES ([0-9\s]*,/INSERT INTO featureofinterest VALUES (featureofinterestid_seq.nextval,/g
     s/INSERT INTO featureofinteresttype VALUES ([0-9\s]*,/INSERT INTO featureofinteresttype VALUES (featureofinteresttypeid_seq.nextval,/g
     s/INSERT INTO observableproperty VALUES ([0-9\s]*,/INSERT INTO observableproperty VALUES (observablepropertyid_seq.nextval,/g
     s/INSERT INTO observationconstellation VALUES ([0-9\s]*,/INSERT INTO observationconstellation VALUES (observationconstellationid_seq.nextval,/g
     s/INSERT INTO observation VALUES ([0-9\s]*,/INSERT INTO observation VALUES (observationid_seq.nextval,/g
     s/INSERT INTO observationtype VALUES ([0-9\s]*,/INSERT INTO observationtype VALUES (observationtypeid_seq.nextval,/g
     s/INSERT INTO offering VALUES ([0-9\s]*,/INSERT INTO offering VALUES (offeringid_seq.nextval,/g
     s/INSERT INTO procedure VALUES ([0-9\s]*,/INSERT INTO procedure VALUES (procedureid_seq.nextval,/g
     s/INSERT INTO proceduredescriptionformat VALUES ([0-9\s]*,/INSERT INTO proceduredescriptionformat VALUES (procdescformatid_seq.nextval,/g
     s/INSERT INTO resulttemplate VALUES ([0-9\s]*,/INSERT INTO resulttemplate VALUES (resulttemplateid_seq.nextval,/g
     s/INSERT INTO unit VALUES ([0-9\s]*,/INSERT INTO unit VALUES (unitid_seq.nextval,/g
     s/INSERT INTO validproceduretime VALUES ([0-9\s]*,/INSERT INTO validproceduretime VALUES (validproceduretimeid_seq.nextval,/g
     s/\('[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}'\)/to_timestamp(\1, 'YYYY-MM-DD HH24:MI:SS')/g
     s/\(INSERT INTO featureofinterest VALUES ([^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,\)\([^,]*\)/\1SDO_GEOMETRY(2001, 4326, SDO_POINT_TYPE(__INSERT__X__HERE__, __INSERT__Y__HERE___, NULL), NULL, NULL)/g
     s/SELECT pg_catalog.setval.*;//g
     /^--/d
     /^SET/d
     /^$/d

3. Execute the following command::

    $ sed -f dump.sed dump.sql > insert_into_oracle.sql
    
4. Put the coordinates for the feature points in the *insert_into_oracle.sql* file (by hand). To do so, search for this text::

    SDO_POINT_TYPE(__INSERT__X__HERE__, __INSERT__Y__HERE___, NULL)
    
inside an *INSERT INTO featureofinterest* instruction and substitute the first two parameters with the point coordinates.
The point coordinates can be obtained from the PostGIS database with the following query::

    SELECT ST_AsText(geom) FROM featureofinterest;
    
**NOTE**: This step may also be automatized, but it's harder and it is not available yet.

Notes
-----

* The sed script is database-dependent and it was updated on 21st June 2013.

* All dates must be in the following format: YYYY-MM-DD HH24:MI:SS

* This only works with geometries of type point in the *featureofinterest* table. If any other geometry type is present, or there are geometries in any other table, this won't work properly.

* Geometries are **always** inserted in the *featureofinterest* table with EPSG:4326. This can always be updated in Oracle with::

    UPDATE featureofinterest f SET f.geom.sdo_srid = 23031 <where>;
    
Result
------

As a result of performing the steps above, these are the contents of *insert_into_oracle.sql*::

    INSERT INTO featureofinteresttype VALUES (featureofinteresttypeid_seq.nextval, 'http://www.opengis.net/def/samplingFeatureType/OGC-OM/2.0/SF_SamplingCurve');
    INSERT INTO featureofinteresttype VALUES (featureofinteresttypeid_seq.nextval, 'http://www.opengis.net/def/samplingFeatureType/OGC-OM/2.0/SF_SamplingSurface');
    INSERT INTO featureofinteresttype VALUES (featureofinteresttypeid_seq.nextval, 'http://www.opengis.net/def/samplingFeatureType/OGC-OM/2.0/SF_SamplingPoint');
    INSERT INTO featureofinteresttype VALUES (featureofinteresttypeid_seq.nextval, 'http://www.opengis.net/def/nil/OGC/0/unknown');
    INSERT INTO featureofinterest VALUES (featureofinterestid_seq.nextval, 'T', 3, 'http://www.52north.org/test/featureOfInterest/1', NULL, 'con terra',SDO_GEOMETRY(2001, 4326, SDO_POINT_TYPE(7.727958, 51.883906, NULL), NULL, NULL), '<sams:SFSpatialSamplingFeature 
         xmlns:xlink="http://www.w3.org/1999/xlink"
    	xmlns:sams="http://www.opengis.net/samplingSpatial/2.0" 
    	xmlns:sf="http://www.opengis.net/sampling/2.0" 
    	xmlns:gml="http://www.opengis.net/gml/3.2" gml:id="ssf_http://www.52north.org/test/featureOfInterest/1">
    	<gml:identifier codeSpace="">http://www.52north.org/test/featureOfInterest/1</gml:identifier>
    	<gml:name>con terra</gml:name>
    	<sf:type xlink:href="http://www.opengis.net/def/samplingFeatureType/OGC-OM/2.0/SF_SamplingPoint"/>
    	<sf:sampledFeature xlink:href="http://www.opengis.net/def/nil/OGC/0/unknown"/>
    	<sams:shape>
    		<gml:Point gml:id="pSsf_http://www.52north.org/test/featureOfInterest/1">
    			<gml:pos srsName="http://www.opengis.net/def/crs/EPSG/0/4326">51.883906 7.727958</gml:pos>
    		</gml:Point>
    	</sams:shape>
    </sams:SFSpatialSamplingFeature>', NULL);
    INSERT INTO featureofinterest VALUES (featureofinterestid_seq.nextval, 'T', 3, 'http://www.52north.org/test/featureOfInterest/2', NULL, 'ESRI',SDO_GEOMETRY(2001, 4326, SDO_POINT_TYPE(-117.19571, 34.056517, NULL), NULL, NULL), '<sams:SFSpatialSamplingFeature 
    	xmlns:xlink="http://www.w3.org/1999/xlink"
    	xmlns:sams="http://www.opengis.net/samplingSpatial/2.0" 
    	xmlns:sf="http://www.opengis.net/sampling/2.0" 
    	xmlns:gml="http://www.opengis.net/gml/3.2" gml:id="ssf_http://www.52north.org/test/featureOfInterest/2">
    	<gml:identifier codeSpace="">http://www.52north.org/test/featureOfInterest/2</gml:identifier>
    	<gml:name>ESRI</gml:name>
    	<sf:type xlink:href="http://www.opengis.net/def/samplingFeatureType/OGC-OM/2.0/SF_SamplingPoint"/>
    	<sf:sampledFeature xlink:href="http://www.opengis.net/def/nil/OGC/0/unknown"/>
    	<sams:shape>
    		<gml:Point gml:id="pSsf_http://www.52north.org/test/featureOfInterest/2">
    			<gml:pos srsName="http://www.opengis.net/def/crs/EPSG/0/4326">34.056517 -117.1957110000000</gml:pos>
    		</gml:Point>
    	</sams:shape>
    </sams:SFSpatialSamplingFeature>', NULL);
    INSERT INTO featureofinterest VALUES (featureofinterestid_seq.nextval, 'T', 3, 'http://www.52north.org/test/featureOfInterest/3', NULL, 'Kisters',SDO_GEOMETRY(2001, 4326, SDO_POINT_TYPE(6.13201440420609, 50.7857066129618, NULL), NULL, NULL), '<sams:SFSpatialSamplingFeature 
    	xmlns:xlink="http://www.w3.org/1999/xlink"
    	xmlns:sams="http://www.opengis.net/samplingSpatial/2.0" 
    	xmlns:sf="http://www.opengis.net/sampling/2.0" 
    	xmlns:gml="http://www.opengis.net/gml/3.2" gml:id="ssf_http://www.52north.org/test/featureOfInterest/3">
    	<gml:identifier codeSpace="">http://www.52north.org/test/featureOfInterest/3</gml:identifier>
    	<gml:name>Kisters</gml:name>
    	<sf:type xlink:href="http://www.opengis.net/def/samplingFeatureType/OGC-OM/2.0/SF_SamplingPoint"/>
    	<sf:sampledFeature xlink:href="http://www.opengis.net/def/nil/OGC/0/unknown"/>
    	<sams:shape>
    		<gml:Point gml:id="pSsf_http://www.52north.org/test/featureOfInterest/3">
    			<gml:pos srsName="http://www.opengis.net/def/crs/EPSG/0/4326">50.78570661296184 6.1320144042060925</gml:pos>
    		</gml:Point>
    	</sams:shape>
    </sams:SFSpatialSamplingFeature>', NULL);
    INSERT INTO featureofinterest VALUES (featureofinterestid_seq.nextval, 'T', 3, 'http://www.52north.org/test/featureOfInterest/4', NULL, 'IfGI',SDO_GEOMETRY(2001, 4326, SDO_POINT_TYPE(7.59365560000003, 51.9681661, NULL), NULL, NULL), '<sams:SFSpatialSamplingFeature 
    	xmlns:xlink="http://www.w3.org/1999/xlink"
    	xmlns:sams="http://www.opengis.net/samplingSpatial/2.0" 
    	xmlns:sf="http://www.opengis.net/sampling/2.0" 
    	xmlns:gml="http://www.opengis.net/gml/3.2" gml:id="ssf_http://www.52north.org/test/featureOfInterest/4">
    	<gml:identifier codeSpace="">http://www.52north.org/test/featureOfInterest/4</gml:identifier>
    	<gml:name>IfGI</gml:name>
    	<sf:type xlink:href="http://www.opengis.net/def/samplingFeatureType/OGC-OM/2.0/SF_SamplingPoint"/>
    	<sf:sampledFeature xlink:href="http://www.opengis.net/def/nil/OGC/0/unknown"/>
    	<sams:shape>
    		<gml:Point gml:id="pSsf_http://www.52north.org/test/featureOfInterest/4">
    			<gml:pos srsName="http://www.opengis.net/def/crs/EPSG/0/4326">51.9681661 7.593655600000034</gml:pos>
    		</gml:Point>
    	</sams:shape>
    </sams:SFSpatialSamplingFeature>', NULL);
    INSERT INTO featureofinterest VALUES (featureofinterestid_seq.nextval, 'T', 3, 'http://www.52north.org/test/featureOfInterest/5', NULL, 'TU-Dresden',SDO_GEOMETRY(2001, 4326, SDO_POINT_TYPE(13.72376, 51.02881, NULL), NULL, NULL), '<sams:SFSpatialSamplingFeature 
    	xmlns:xlink="http://www.w3.org/1999/xlink"
    	xmlns:sams="http://www.opengis.net/samplingSpatial/2.0" 
    	xmlns:sf="http://www.opengis.net/sampling/2.0" 
    	xmlns:gml="http://www.opengis.net/gml/3.2" gml:id="ssf_http://www.52north.org/test/featureOfInterest/5">
    	<gml:identifier codeSpace="">http://www.52north.org/test/featureOfInterest/5</gml:identifier>
    	<gml:name>TU-Dresden</gml:name>
    	<sf:type xlink:href="http://www.opengis.net/def/samplingFeatureType/OGC-OM/2.0/SF_SamplingPoint"/>
    	<sf:sampledFeature xlink:href="http://www.opengis.net/def/nil/OGC/0/unknown"/>
    	<sams:shape>
    		<gml:Point gml:id="pSsf_http://www.52north.org/test/featureOfInterest/5">
    			<gml:pos srsName="http://www.opengis.net/def/crs/EPSG/0/4326">51.02881 13.72375999999997</gml:pos>
    		</gml:Point>
    	</sams:shape>
    </sams:SFSpatialSamplingFeature>', NULL);
    INSERT INTO featureofinterest VALUES (featureofinterestid_seq.nextval, 'T', 3, 'http://www.52north.org/test/featureOfInterest/6', NULL, 'Hochschule Bochum',SDO_GEOMETRY(2001, 4326, SDO_POINT_TYPE(7.270806, 51.447722, NULL), NULL, NULL), '<sams:SFSpatialSamplingFeature 
    	xmlns:xlink="http://www.w3.org/1999/xlink"
    	xmlns:sams="http://www.opengis.net/samplingSpatial/2.0" 
    	xmlns:sf="http://www.opengis.net/sampling/2.0" 
    	xmlns:gml="http://www.opengis.net/gml/3.2" gml:id="ssf_http://www.52north.org/test/featureOfInterest/6">
    	<gml:identifier codeSpace="">http://www.52north.org/test/featureOfInterest/6</gml:identifier>
    	<gml:name>Hochschule Bochum</gml:name>
    	<sf:type xlink:href="http://www.opengis.net/def/samplingFeatureType/OGC-OM/2.0/SF_SamplingPoint"/>
    	<sf:sampledFeature xlink:href="http://www.opengis.net/def/nil/OGC/0/unknown"/>
    	<sams:shape>
    		<gml:Point gml:id="pSsf_http://www.52north.org/test/featureOfInterest/6">
    			<gml:pos srsName="http://www.opengis.net/def/crs/EPSG/0/4326">51.447722 7.270806</gml:pos>
    		</gml:Point>
    	</sams:shape>
    </sams:SFSpatialSamplingFeature>', NULL);
    INSERT INTO featureofinterest VALUES (featureofinterestid_seq.nextval, 'T', 3, 'http://www.52north.org/test/featureOfInterest/7', NULL, 'ITC',SDO_GEOMETRY(2001, 4326, SDO_POINT_TYPE(4.2833935999999, 52.0464393, NULL), NULL, NULL), '<sams:SFSpatialSamplingFeature 
    	xmlns:xlink="http://www.w3.org/1999/xlink"
    	xmlns:sams="http://www.opengis.net/samplingSpatial/2.0" 
    	xmlns:sf="http://www.opengis.net/sampling/2.0" 
    	xmlns:gml="http://www.opengis.net/gml/3.2" gml:id="ssf_http://www.52north.org/test/featureOfInterest/7">
    	<gml:identifier codeSpace="">http://www.52north.org/test/featureOfInterest/7</gml:identifier>
    	<gml:name>ITC</gml:name>
    	<sf:type xlink:href="http://www.opengis.net/def/samplingFeatureType/OGC-OM/2.0/SF_SamplingPoint"/>
    	<sf:sampledFeature xlink:href="http://www.opengis.net/def/nil/OGC/0/unknown"/>
    	<sams:shape>
    		<gml:Point gml:id="pSsf_http://www.52north.org/test/featureOfInterest/7">
    			<gml:pos srsName="http://www.opengis.net/def/crs/EPSG/0/4326">52.0464393 4.283393599999954</gml:pos>
    		</gml:Point>
    	</sams:shape>
    </sams:SFSpatialSamplingFeature>', NULL);
    INSERT INTO featureofinterest VALUES (featureofinterestid_seq.nextval, 'T', 3, 'http://www.52north.org/test/featureOfInterest/8', NULL, 'DLZ-IT',SDO_GEOMETRY(2001, 4326, SDO_POINT_TYPE(10.9430600000001, 50.68606, NULL), NULL, NULL), '<sams:SFSpatialSamplingFeature 
    	xmlns:xlink="http://www.w3.org/1999/xlink"
    	xmlns:sams="http://www.opengis.net/samplingSpatial/2.0" 
    	xmlns:sf="http://www.opengis.net/sampling/2.0" 
    	xmlns:gml="http://www.opengis.net/gml/3.2" gml:id="ssf_http://www.52north.org/test/featureOfInterest/8">
    	<gml:identifier codeSpace="">http://www.52north.org/test/featureOfInterest/8</gml:identifier>
    	<gml:name>DLZ-IT</gml:name>
    	<sf:type xlink:href="http://www.opengis.net/def/samplingFeatureType/OGC-OM/2.0/SF_SamplingPoint"/>
    	<sf:sampledFeature xlink:href="http://www.opengis.net/def/nil/OGC/0/unknown"/>
    	<sams:shape>
    		<gml:Point gml:id="pSsf_http://www.52north.org/test/featureOfInterest/8">
    			<gml:pos srsName="http://www.opengis.net/def/crs/EPSG/0/4326">50.68606 10.94306000000006</gml:pos>
    		</gml:Point>
    	</sams:shape>
    </sams:SFSpatialSamplingFeature>', NULL);
    INSERT INTO observableproperty VALUES (observablepropertyid_seq.nextval, 'T', 'http://www.52north.org/test/observableProperty/1', 'http://www.52north.org/test/observableProperty/1');
    INSERT INTO observableproperty VALUES (observablepropertyid_seq.nextval, 'T', 'http://www.52north.org/test/observableProperty/2', 'http://www.52north.org/test/observableProperty/2');
    INSERT INTO observableproperty VALUES (observablepropertyid_seq.nextval, 'T', 'http://www.52north.org/test/observableProperty/3', 'http://www.52north.org/test/observableProperty/3');
    INSERT INTO observableproperty VALUES (observablepropertyid_seq.nextval, 'T', 'http://www.52north.org/test/observableProperty/4', 'http://www.52north.org/test/observableProperty/4');
    INSERT INTO observableproperty VALUES (observablepropertyid_seq.nextval, 'T', 'http://www.52north.org/test/observableProperty/5', 'http://www.52north.org/test/observableProperty/5');
    INSERT INTO observableproperty VALUES (observablepropertyid_seq.nextval, 'T', 'http://www.52north.org/test/observableProperty/6', 'http://www.52north.org/test/observableProperty/6');
    INSERT INTO observableproperty VALUES (observablepropertyid_seq.nextval, 'T', 'http://www.52north.org/test/observableProperty/7', 'http://www.52north.org/test/observableProperty/7');
    INSERT INTO observableproperty VALUES (observablepropertyid_seq.nextval, 'T', 'http://www.52north.org/test/observableProperty/8', 'http://www.52north.org/test/observableProperty/8');
    INSERT INTO proceduredescriptionformat VALUES (procdescformatid_seq.nextval, 'http://www.opengis.net/sensorML/1.0.1');
    INSERT INTO procedure VALUES (procedureid_seq.nextval, 'T', 1, 'http://www.52north.org/test/procedure/1', 'F', NULL);
    INSERT INTO procedure VALUES (procedureid_seq.nextval, 'T', 1, 'http://www.52north.org/test/procedure/2', 'F', NULL);
    INSERT INTO procedure VALUES (procedureid_seq.nextval, 'T', 1, 'http://www.52north.org/test/procedure/3', 'F', NULL);
    INSERT INTO procedure VALUES (procedureid_seq.nextval, 'T', 1, 'http://www.52north.org/test/procedure/4', 'F', NULL);
    INSERT INTO procedure VALUES (procedureid_seq.nextval, 'T', 1, 'http://www.52north.org/test/procedure/5', 'F', NULL);
    INSERT INTO procedure VALUES (procedureid_seq.nextval, 'T', 1, 'http://www.52north.org/test/procedure/6', 'F', NULL);
    INSERT INTO procedure VALUES (procedureid_seq.nextval, 'T', 1, 'http://www.52north.org/test/procedure/7', 'F', NULL);
    INSERT INTO procedure VALUES (procedureid_seq.nextval, 'T', 1, 'http://www.52north.org/test/procedure/8', 'F', NULL);
    INSERT INTO unit VALUES (unitid_seq.nextval, 'test_unit_1');
    INSERT INTO unit VALUES (unitid_seq.nextval, 'test_unit_2');
    INSERT INTO unit VALUES (unitid_seq.nextval, 'test_unit_3');
    INSERT INTO unit VALUES (unitid_seq.nextval, 'test_unit_4');
    INSERT INTO unit VALUES (unitid_seq.nextval, 'test_unit_5');
    INSERT INTO unit VALUES (unitid_seq.nextval, 'test_unit_6');
    INSERT INTO unit VALUES (unitid_seq.nextval, 'test_unit_7');
    INSERT INTO unit VALUES (unitid_seq.nextval, 'test_unit_8');
    INSERT INTO observation VALUES (observationid_seq.nextval, 1, 1, 1, to_timestamp('2012-11-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 1);
    INSERT INTO observation VALUES (observationid_seq.nextval, 1, 1, 1, to_timestamp('2012-11-19 14:01:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:01:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:01:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 1);
    INSERT INTO observation VALUES (observationid_seq.nextval, 1, 1, 1, to_timestamp('2012-11-19 14:02:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:02:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:02:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 1);
    INSERT INTO observation VALUES (observationid_seq.nextval, 1, 1, 1, to_timestamp('2012-11-19 14:03:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:03:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:03:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 1);
    INSERT INTO observation VALUES (observationid_seq.nextval, 1, 1, 1, to_timestamp('2012-11-19 14:04:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:04:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:04:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 1);
    INSERT INTO observation VALUES (observationid_seq.nextval, 1, 1, 1, to_timestamp('2012-11-19 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 1);
    INSERT INTO observation VALUES (observationid_seq.nextval, 1, 1, 1, to_timestamp('2012-11-19 14:06:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:06:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:06:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 1);
    INSERT INTO observation VALUES (observationid_seq.nextval, 1, 1, 1, to_timestamp('2012-11-19 14:07:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:07:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:07:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 1);
    INSERT INTO observation VALUES (observationid_seq.nextval, 1, 1, 1, to_timestamp('2012-11-19 14:08:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:08:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:08:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 1);
    INSERT INTO observation VALUES (observationid_seq.nextval, 1, 1, 1, to_timestamp('2012-11-19 14:09:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:09:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:09:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 1);
    INSERT INTO observation VALUES (observationid_seq.nextval, 2, 2, 2, to_timestamp('2012-11-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 2);
    INSERT INTO observation VALUES (observationid_seq.nextval, 2, 2, 2, to_timestamp('2012-11-19 14:01:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:01:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:01:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 2);
    INSERT INTO observation VALUES (observationid_seq.nextval, 2, 2, 2, to_timestamp('2012-11-19 14:02:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:02:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:02:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 2);
    INSERT INTO observation VALUES (observationid_seq.nextval, 2, 2, 2, to_timestamp('2012-11-19 14:03:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:03:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:03:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 2);
    INSERT INTO observation VALUES (observationid_seq.nextval, 2, 2, 2, to_timestamp('2012-11-19 14:04:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:04:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:04:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 2);
    INSERT INTO observation VALUES (observationid_seq.nextval, 2, 2, 2, to_timestamp('2012-11-19 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 2);
    INSERT INTO observation VALUES (observationid_seq.nextval, 2, 2, 2, to_timestamp('2012-11-19 14:06:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:06:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:06:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 2);
    INSERT INTO observation VALUES (observationid_seq.nextval, 2, 2, 2, to_timestamp('2012-11-19 14:07:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:07:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:07:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 2);
    INSERT INTO observation VALUES (observationid_seq.nextval, 2, 2, 2, to_timestamp('2012-11-19 14:08:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:08:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:08:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 2);
    INSERT INTO observation VALUES (observationid_seq.nextval, 2, 2, 2, to_timestamp('2012-11-19 14:09:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:09:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:09:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 2);
    INSERT INTO observation VALUES (observationid_seq.nextval, 3, 3, 3, to_timestamp('2012-11-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 3);
    INSERT INTO observation VALUES (observationid_seq.nextval, 3, 3, 3, to_timestamp('2012-11-19 14:01:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:01:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:01:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 3);
    INSERT INTO observation VALUES (observationid_seq.nextval, 3, 3, 3, to_timestamp('2012-11-19 14:02:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:02:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:02:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 3);
    INSERT INTO observation VALUES (observationid_seq.nextval, 3, 3, 3, to_timestamp('2012-11-19 14:03:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:03:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:03:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 3);
    INSERT INTO observation VALUES (observationid_seq.nextval, 3, 3, 3, to_timestamp('2012-11-19 14:04:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:04:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:04:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 3);
    INSERT INTO observation VALUES (observationid_seq.nextval, 3, 3, 3, to_timestamp('2012-11-19 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 3);
    INSERT INTO observation VALUES (observationid_seq.nextval, 3, 3, 3, to_timestamp('2012-11-19 14:06:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:06:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:06:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 3);
    INSERT INTO observation VALUES (observationid_seq.nextval, 3, 3, 3, to_timestamp('2012-11-19 14:07:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:07:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:07:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 3);
    INSERT INTO observation VALUES (observationid_seq.nextval, 3, 3, 3, to_timestamp('2012-11-19 14:08:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:08:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:08:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 3);
    INSERT INTO observation VALUES (observationid_seq.nextval, 3, 3, 3, to_timestamp('2012-11-19 14:09:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:09:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:09:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 3);
    INSERT INTO observation VALUES (observationid_seq.nextval, 4, 4, 4, to_timestamp('2012-11-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 4);
    INSERT INTO observation VALUES (observationid_seq.nextval, 4, 4, 4, to_timestamp('2012-11-19 14:01:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:01:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:01:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 4);
    INSERT INTO observation VALUES (observationid_seq.nextval, 4, 4, 4, to_timestamp('2012-11-19 14:02:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:02:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:02:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 4);
    INSERT INTO observation VALUES (observationid_seq.nextval, 4, 4, 4, to_timestamp('2012-11-19 14:03:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:03:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:03:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 4);
    INSERT INTO observation VALUES (observationid_seq.nextval, 4, 4, 4, to_timestamp('2012-11-19 14:04:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:04:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:04:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 4);
    INSERT INTO observation VALUES (observationid_seq.nextval, 4, 4, 4, to_timestamp('2012-11-19 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 4);
    INSERT INTO observation VALUES (observationid_seq.nextval, 4, 4, 4, to_timestamp('2012-11-19 14:06:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:06:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:06:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 4);
    INSERT INTO observation VALUES (observationid_seq.nextval, 4, 4, 4, to_timestamp('2012-11-19 14:07:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:07:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:07:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 4);
    INSERT INTO observation VALUES (observationid_seq.nextval, 4, 4, 4, to_timestamp('2012-11-19 14:08:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:08:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:08:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 4);
    INSERT INTO observation VALUES (observationid_seq.nextval, 4, 4, 4, to_timestamp('2012-11-19 14:09:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:09:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:09:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 4);
    INSERT INTO observation VALUES (observationid_seq.nextval, 5, 5, 5, to_timestamp('2012-11-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 5);
    INSERT INTO observation VALUES (observationid_seq.nextval, 5, 5, 5, to_timestamp('2012-11-19 14:01:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:01:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:01:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 5);
    INSERT INTO observation VALUES (observationid_seq.nextval, 5, 5, 5, to_timestamp('2012-11-19 14:02:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:02:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:02:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 5);
    INSERT INTO observation VALUES (observationid_seq.nextval, 5, 5, 5, to_timestamp('2012-11-19 14:03:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:03:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:03:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 5);
    INSERT INTO observation VALUES (observationid_seq.nextval, 5, 5, 5, to_timestamp('2012-11-19 14:04:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:04:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:04:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 5);
    INSERT INTO observation VALUES (observationid_seq.nextval, 5, 5, 5, to_timestamp('2012-11-19 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 5);
    INSERT INTO observation VALUES (observationid_seq.nextval, 5, 5, 5, to_timestamp('2012-11-19 14:06:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:06:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:06:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 5);
    INSERT INTO observation VALUES (observationid_seq.nextval, 5, 5, 5, to_timestamp('2012-11-19 14:07:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:07:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:07:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 5);
    INSERT INTO observation VALUES (observationid_seq.nextval, 5, 5, 5, to_timestamp('2012-11-19 14:08:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:08:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:08:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 5);
    INSERT INTO observation VALUES (observationid_seq.nextval, 5, 5, 5, to_timestamp('2012-11-19 14:09:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:09:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:09:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 5);
    INSERT INTO observation VALUES (observationid_seq.nextval, 6, 6, 6, to_timestamp('2012-11-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 6);
    INSERT INTO observation VALUES (observationid_seq.nextval, 6, 6, 6, to_timestamp('2012-11-19 14:01:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:01:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:01:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 6);
    INSERT INTO observation VALUES (observationid_seq.nextval, 6, 6, 6, to_timestamp('2012-11-19 14:02:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:02:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:02:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 6);
    INSERT INTO observation VALUES (observationid_seq.nextval, 6, 6, 6, to_timestamp('2012-11-19 14:03:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:03:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:03:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 6);
    INSERT INTO observation VALUES (observationid_seq.nextval, 6, 6, 6, to_timestamp('2012-11-19 14:04:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:04:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:04:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 6);
    INSERT INTO observation VALUES (observationid_seq.nextval, 6, 6, 6, to_timestamp('2012-11-19 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 6);
    INSERT INTO observation VALUES (observationid_seq.nextval, 6, 6, 6, to_timestamp('2012-11-19 14:06:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:06:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:06:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 6);
    INSERT INTO observation VALUES (observationid_seq.nextval, 6, 6, 6, to_timestamp('2012-11-19 14:07:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:07:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:07:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 6);
    INSERT INTO observation VALUES (observationid_seq.nextval, 6, 6, 6, to_timestamp('2012-11-19 14:08:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:08:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:08:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 6);
    INSERT INTO observation VALUES (observationid_seq.nextval, 6, 6, 6, to_timestamp('2012-11-19 14:09:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:09:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:09:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 6);
    INSERT INTO observation VALUES (observationid_seq.nextval, 1, 1, 1, to_timestamp('2012-11-19 13:10:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 13:15:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 13:16:00', 'YYYY-MM-DD HH24:MI:SS'), 'http://www.52north.org/test/observation/1', NULL, 'F', NULL, NULL, 1);
    INSERT INTO observation VALUES (observationid_seq.nextval, 1, 1, 1, to_timestamp('2012-11-19 13:15:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 13:20:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 13:21:00', 'YYYY-MM-DD HH24:MI:SS'), 'http://www.52north.org/test/observation/2', NULL, 'F', NULL, NULL, 1);
    INSERT INTO observation VALUES (observationid_seq.nextval, 7, 7, 7, to_timestamp('2012-11-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 7);
    INSERT INTO observation VALUES (observationid_seq.nextval, 7, 7, 7, to_timestamp('2012-11-19 14:01:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:01:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:01:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 7);
    INSERT INTO observation VALUES (observationid_seq.nextval, 7, 7, 7, to_timestamp('2012-11-19 14:02:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:02:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:02:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 7);
    INSERT INTO observation VALUES (observationid_seq.nextval, 7, 7, 7, to_timestamp('2012-11-19 14:03:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:03:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:03:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 7);
    INSERT INTO observation VALUES (observationid_seq.nextval, 7, 7, 7, to_timestamp('2012-11-19 14:04:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:04:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:04:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 7);
    INSERT INTO observation VALUES (observationid_seq.nextval, 7, 7, 7, to_timestamp('2012-11-19 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 7);
    INSERT INTO observation VALUES (observationid_seq.nextval, 7, 7, 7, to_timestamp('2012-11-19 14:06:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:06:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:06:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 7);
    INSERT INTO observation VALUES (observationid_seq.nextval, 7, 7, 7, to_timestamp('2012-11-19 14:07:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:07:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:07:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 7);
    INSERT INTO observation VALUES (observationid_seq.nextval, 7, 7, 7, to_timestamp('2012-11-19 14:08:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:08:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:08:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 7);
    INSERT INTO observation VALUES (observationid_seq.nextval, 7, 7, 7, to_timestamp('2012-11-19 14:09:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:09:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:09:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 7);
    INSERT INTO observation VALUES (observationid_seq.nextval, 8, 8, 8, to_timestamp('2012-11-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 8);
    INSERT INTO observation VALUES (observationid_seq.nextval, 8, 8, 8, to_timestamp('2012-11-19 14:01:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:01:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:01:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 8);
    INSERT INTO observation VALUES (observationid_seq.nextval, 8, 8, 8, to_timestamp('2012-11-19 14:02:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:02:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:02:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 8);
    INSERT INTO observation VALUES (observationid_seq.nextval, 8, 8, 8, to_timestamp('2012-11-19 14:03:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:03:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:03:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 8);
    INSERT INTO observation VALUES (observationid_seq.nextval, 8, 8, 8, to_timestamp('2012-11-19 14:04:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:04:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:04:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 8);
    INSERT INTO observation VALUES (observationid_seq.nextval, 8, 8, 8, to_timestamp('2012-11-19 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 8);
    INSERT INTO observation VALUES (observationid_seq.nextval, 8, 8, 8, to_timestamp('2012-11-19 14:06:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:06:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:06:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 8);
    INSERT INTO observation VALUES (observationid_seq.nextval, 8, 8, 8, to_timestamp('2012-11-19 14:07:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:07:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:07:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 8);
    INSERT INTO observation VALUES (observationid_seq.nextval, 8, 8, 8, to_timestamp('2012-11-19 14:08:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:08:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:08:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 8);
    INSERT INTO observation VALUES (observationid_seq.nextval, 8, 8, 8, to_timestamp('2012-11-19 14:09:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:09:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2012-11-19 14:09:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'F', NULL, NULL, 8);
    INSERT INTO booleanvalue VALUES (21, 'T');
    INSERT INTO booleanvalue VALUES (22, 'F');
    INSERT INTO booleanvalue VALUES (23, 'F');
    INSERT INTO booleanvalue VALUES (24, 'T');
    INSERT INTO booleanvalue VALUES (25, 'F');
    INSERT INTO booleanvalue VALUES (26, 'T');
    INSERT INTO booleanvalue VALUES (27, 'T');
    INSERT INTO booleanvalue VALUES (28, 'F');
    INSERT INTO booleanvalue VALUES (29, 'F');
    INSERT INTO booleanvalue VALUES (30, 'T');
    INSERT INTO categoryvalue VALUES (31, 'test_category_1');
    INSERT INTO categoryvalue VALUES (32, 'test_category_2');
    INSERT INTO categoryvalue VALUES (33, 'test_category_1');
    INSERT INTO categoryvalue VALUES (34, 'test_category_5');
    INSERT INTO categoryvalue VALUES (35, 'test_category_4');
    INSERT INTO categoryvalue VALUES (36, 'test_category_3');
    INSERT INTO categoryvalue VALUES (37, 'test_category_1');
    INSERT INTO categoryvalue VALUES (38, 'test_category_2');
    INSERT INTO categoryvalue VALUES (39, 'test_category_1');
    INSERT INTO categoryvalue VALUES (40, 'test_category_6');
    INSERT INTO countvalue VALUES (11, 1);
    INSERT INTO countvalue VALUES (12, 2);
    INSERT INTO countvalue VALUES (13, 3);
    INSERT INTO countvalue VALUES (14, 4);
    INSERT INTO countvalue VALUES (15, 5);
    INSERT INTO countvalue VALUES (16, 6);
    INSERT INTO countvalue VALUES (17, 7);
    INSERT INTO countvalue VALUES (18, 8);
    INSERT INTO countvalue VALUES (19, 9);
    INSERT INTO countvalue VALUES (20, 10);
    INSERT INTO numericvalue VALUES (1, 1.20);
    INSERT INTO numericvalue VALUES (2, 1.30);
    INSERT INTO numericvalue VALUES (3, 1.40);
    INSERT INTO numericvalue VALUES (4, 1.50);
    INSERT INTO numericvalue VALUES (5, 1.60);
    INSERT INTO numericvalue VALUES (6, 1.70);
    INSERT INTO numericvalue VALUES (7, 1.80);
    INSERT INTO numericvalue VALUES (8, 1.90);
    INSERT INTO numericvalue VALUES (9, 2.00);
    INSERT INTO numericvalue VALUES (10, 2.10);
    INSERT INTO numericvalue VALUES (51, 1.20);
    INSERT INTO numericvalue VALUES (52, 1.30);
    INSERT INTO numericvalue VALUES (53, 1.40);
    INSERT INTO numericvalue VALUES (54, 1.50);
    INSERT INTO numericvalue VALUES (55, 1.60);
    INSERT INTO numericvalue VALUES (56, 1.70);
    INSERT INTO numericvalue VALUES (57, 1.80);
    INSERT INTO numericvalue VALUES (58, 1.90);
    INSERT INTO numericvalue VALUES (59, 2.00);
    INSERT INTO numericvalue VALUES (60, 2.10);
    INSERT INTO numericvalue VALUES (61, 3.50);
    INSERT INTO numericvalue VALUES (62, 4.20);
    INSERT INTO numericvalue VALUES (63, 1.20);
    INSERT INTO numericvalue VALUES (64, 1.30);
    INSERT INTO numericvalue VALUES (65, 1.40);
    INSERT INTO numericvalue VALUES (66, 1.50);
    INSERT INTO numericvalue VALUES (67, 1.60);
    INSERT INTO numericvalue VALUES (68, 1.70);
    INSERT INTO numericvalue VALUES (69, 1.80);
    INSERT INTO numericvalue VALUES (70, 1.90);
    INSERT INTO numericvalue VALUES (71, 2.00);
    INSERT INTO numericvalue VALUES (72, 2.10);
    INSERT INTO numericvalue VALUES (73, 1.20);
    INSERT INTO numericvalue VALUES (74, 1.30);
    INSERT INTO numericvalue VALUES (75, 1.40);
    INSERT INTO numericvalue VALUES (76, 1.50);
    INSERT INTO numericvalue VALUES (77, 1.60);
    INSERT INTO numericvalue VALUES (78, 1.70);
    INSERT INTO numericvalue VALUES (79, 1.80);
    INSERT INTO numericvalue VALUES (80, 1.90);
    INSERT INTO numericvalue VALUES (81, 2.00);
    INSERT INTO numericvalue VALUES (82, 2.10);
    INSERT INTO observationtype VALUES (observationtypeid_seq.nextval, 'http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_CountObservation');
    INSERT INTO observationtype VALUES (observationtypeid_seq.nextval, 'http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement');
    INSERT INTO observationtype VALUES (observationtypeid_seq.nextval, 'http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_SWEArrayObservation');
    INSERT INTO observationtype VALUES (observationtypeid_seq.nextval, 'http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_TruthObservation');
    INSERT INTO observationtype VALUES (observationtypeid_seq.nextval, 'http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_CategoryObservation');
    INSERT INTO observationtype VALUES (observationtypeid_seq.nextval, 'http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_TextObservation');
    INSERT INTO offering VALUES (offeringid_seq.nextval, 'T', 'http://www.52north.org/test/offering/1', 'http://www.52north.org/test/offering/1 name');
    INSERT INTO offering VALUES (offeringid_seq.nextval, 'T', 'http://www.52north.org/test/offering/2', 'http://www.52north.org/test/offering/2 name');
    INSERT INTO offering VALUES (offeringid_seq.nextval, 'T', 'http://www.52north.org/test/offering/3', 'http://www.52north.org/test/offering/3 name');
    INSERT INTO offering VALUES (offeringid_seq.nextval, 'T', 'http://www.52north.org/test/offering/4', 'http://www.52north.org/test/offering/4 name');
    INSERT INTO offering VALUES (offeringid_seq.nextval, 'T', 'http://www.52north.org/test/offering/5', 'http://www.52north.org/test/offering/5 name');
    INSERT INTO offering VALUES (offeringid_seq.nextval, 'T', 'http://www.52north.org/test/offering/6', 'http://www.52north.org/test/offering/6 name');
    INSERT INTO offering VALUES (offeringid_seq.nextval, 'T', 'http://www.52north.org/test/offering/7', 'http://www.52north.org/test/offering/7 name');
    INSERT INTO offering VALUES (offeringid_seq.nextval, 'T', 'http://www.52north.org/test/offering/8', 'http://www.52north.org/test/offering/8 name');
    INSERT INTO observationconstellation VALUES (observationconstellationid_seq.nextval, 1, 1, 2, 1, 'F', 'F');
    INSERT INTO observationconstellation VALUES (observationconstellationid_seq.nextval, 2, 2, 1, 2, 'F', 'F');
    INSERT INTO observationconstellation VALUES (observationconstellationid_seq.nextval, 3, 3, 4, 3, 'F', 'F');
    INSERT INTO observationconstellation VALUES (observationconstellationid_seq.nextval, 4, 4, 5, 4, 'F', 'F');
    INSERT INTO observationconstellation VALUES (observationconstellationid_seq.nextval, 5, 5, 6, 5, 'F', 'F');
    INSERT INTO observationconstellation VALUES (observationconstellationid_seq.nextval, 6, 6, 3, 6, 'F', 'F');
    INSERT INTO observationconstellation VALUES (observationconstellationid_seq.nextval, 7, 7, 2, 7, 'F', 'F');
    INSERT INTO observationconstellation VALUES (observationconstellationid_seq.nextval, 8, 8, 2, 8, 'F', 'F');
    INSERT INTO observationhasoffering VALUES (1, 1);
    INSERT INTO observationhasoffering VALUES (2, 1);
    INSERT INTO observationhasoffering VALUES (3, 1);
    INSERT INTO observationhasoffering VALUES (4, 1);
    INSERT INTO observationhasoffering VALUES (5, 1);
    INSERT INTO observationhasoffering VALUES (6, 1);
    INSERT INTO observationhasoffering VALUES (7, 1);
    INSERT INTO observationhasoffering VALUES (8, 1);
    INSERT INTO observationhasoffering VALUES (9, 1);
    INSERT INTO observationhasoffering VALUES (10, 1);
    INSERT INTO observationhasoffering VALUES (11, 2);
    INSERT INTO observationhasoffering VALUES (12, 2);
    INSERT INTO observationhasoffering VALUES (13, 2);
    INSERT INTO observationhasoffering VALUES (14, 2);
    INSERT INTO observationhasoffering VALUES (15, 2);
    INSERT INTO observationhasoffering VALUES (16, 2);
    INSERT INTO observationhasoffering VALUES (17, 2);
    INSERT INTO observationhasoffering VALUES (18, 2);
    INSERT INTO observationhasoffering VALUES (19, 2);
    INSERT INTO observationhasoffering VALUES (20, 2);
    INSERT INTO observationhasoffering VALUES (21, 3);
    INSERT INTO observationhasoffering VALUES (22, 3);
    INSERT INTO observationhasoffering VALUES (23, 3);
    INSERT INTO observationhasoffering VALUES (24, 3);
    INSERT INTO observationhasoffering VALUES (25, 3);
    INSERT INTO observationhasoffering VALUES (26, 3);
    INSERT INTO observationhasoffering VALUES (27, 3);
    INSERT INTO observationhasoffering VALUES (28, 3);
    INSERT INTO observationhasoffering VALUES (29, 3);
    INSERT INTO observationhasoffering VALUES (30, 3);
    INSERT INTO observationhasoffering VALUES (31, 4);
    INSERT INTO observationhasoffering VALUES (32, 4);
    INSERT INTO observationhasoffering VALUES (33, 4);
    INSERT INTO observationhasoffering VALUES (34, 4);
    INSERT INTO observationhasoffering VALUES (35, 4);
    INSERT INTO observationhasoffering VALUES (36, 4);
    INSERT INTO observationhasoffering VALUES (37, 4);
    INSERT INTO observationhasoffering VALUES (38, 4);
    INSERT INTO observationhasoffering VALUES (39, 4);
    INSERT INTO observationhasoffering VALUES (40, 4);
    INSERT INTO observationhasoffering VALUES (41, 5);
    INSERT INTO observationhasoffering VALUES (42, 5);
    INSERT INTO observationhasoffering VALUES (43, 5);
    INSERT INTO observationhasoffering VALUES (44, 5);
    INSERT INTO observationhasoffering VALUES (45, 5);
    INSERT INTO observationhasoffering VALUES (46, 5);
    INSERT INTO observationhasoffering VALUES (47, 5);
    INSERT INTO observationhasoffering VALUES (48, 5);
    INSERT INTO observationhasoffering VALUES (49, 5);
    INSERT INTO observationhasoffering VALUES (50, 5);
    INSERT INTO observationhasoffering VALUES (51, 6);
    INSERT INTO observationhasoffering VALUES (52, 6);
    INSERT INTO observationhasoffering VALUES (53, 6);
    INSERT INTO observationhasoffering VALUES (54, 6);
    INSERT INTO observationhasoffering VALUES (55, 6);
    INSERT INTO observationhasoffering VALUES (56, 6);
    INSERT INTO observationhasoffering VALUES (57, 6);
    INSERT INTO observationhasoffering VALUES (58, 6);
    INSERT INTO observationhasoffering VALUES (59, 6);
    INSERT INTO observationhasoffering VALUES (60, 6);
    INSERT INTO observationhasoffering VALUES (61, 1);
    INSERT INTO observationhasoffering VALUES (62, 1);
    INSERT INTO observationhasoffering VALUES (63, 7);
    INSERT INTO observationhasoffering VALUES (64, 7);
    INSERT INTO observationhasoffering VALUES (65, 7);
    INSERT INTO observationhasoffering VALUES (66, 7);
    INSERT INTO observationhasoffering VALUES (67, 7);
    INSERT INTO observationhasoffering VALUES (68, 7);
    INSERT INTO observationhasoffering VALUES (69, 7);
    INSERT INTO observationhasoffering VALUES (70, 7);
    INSERT INTO observationhasoffering VALUES (71, 7);
    INSERT INTO observationhasoffering VALUES (72, 7);
    INSERT INTO observationhasoffering VALUES (73, 8);
    INSERT INTO observationhasoffering VALUES (74, 8);
    INSERT INTO observationhasoffering VALUES (75, 8);
    INSERT INTO observationhasoffering VALUES (76, 8);
    INSERT INTO observationhasoffering VALUES (77, 8);
    INSERT INTO observationhasoffering VALUES (78, 8);
    INSERT INTO observationhasoffering VALUES (79, 8);
    INSERT INTO observationhasoffering VALUES (80, 8);
    INSERT INTO observationhasoffering VALUES (81, 8);
    INSERT INTO observationhasoffering VALUES (82, 8);
    INSERT INTO offeringallowedfeaturetype VALUES (1, 3);
    INSERT INTO offeringallowedfeaturetype VALUES (2, 3);
    INSERT INTO offeringallowedfeaturetype VALUES (3, 3);
    INSERT INTO offeringallowedfeaturetype VALUES (4, 3);
    INSERT INTO offeringallowedfeaturetype VALUES (5, 3);
    INSERT INTO offeringallowedfeaturetype VALUES (6, 3);
    INSERT INTO offeringallowedfeaturetype VALUES (7, 3);
    INSERT INTO offeringallowedfeaturetype VALUES (8, 3);
    INSERT INTO offeringallowedobservationtype VALUES (1, 2);
    INSERT INTO offeringallowedobservationtype VALUES (2, 1);
    INSERT INTO offeringallowedobservationtype VALUES (3, 4);
    INSERT INTO offeringallowedobservationtype VALUES (4, 5);
    INSERT INTO offeringallowedobservationtype VALUES (5, 6);
    INSERT INTO offeringallowedobservationtype VALUES (6, 3);
    INSERT INTO offeringallowedobservationtype VALUES (7, 2);
    INSERT INTO offeringallowedobservationtype VALUES (8, 2);
    INSERT INTO resulttemplate VALUES (resulttemplateid_seq.nextval, 6, 6, 6, 6, 'http://www.52north.org/test/procedure/6/template/1', '<swe:DataRecord xmlns:swe="http://www.opengis.net/swe/2.0" xmlns:xlink="http://www.w3.org/1999/xlink">
    			<swe:field name="phenomenonTime">
    				<swe:Time definition="http://www.opengis.net/def/property/OGC/0/PhenomenonTime">
    					<swe:uom xlink:href="http://www.opengis.net/def/uom/ISO-8601/0/Gregorian"/>
    				</swe:Time>
    			</swe:field>
    			<swe:field name="http://www.52north.org/test/observableProperty/6">
    				<swe:Quantity definition="http://www.52north.org/test/observableProperty/6">
    					<swe:uom code="test_unit_6"/>
    				</swe:Quantity>
    			</swe:field>
    		</swe:DataRecord>', '<swe:TextEncoding xmlns:swe="http://www.opengis.net/swe/2.0" tokenSeparator="#" blockSeparator="@"/>');
    INSERT INTO textvalue VALUES (41, 'test_text_0');
    INSERT INTO textvalue VALUES (42, 'test_text_1');
    INSERT INTO textvalue VALUES (43, 'test_text_3');
    INSERT INTO textvalue VALUES (44, 'test_text_4');
    INSERT INTO textvalue VALUES (45, 'test_text_5');
    INSERT INTO textvalue VALUES (46, 'test_text_6');
    INSERT INTO textvalue VALUES (47, 'test_text_7');
    INSERT INTO textvalue VALUES (48, 'test_text_7');
    INSERT INTO textvalue VALUES (49, 'test_text_8');
    INSERT INTO textvalue VALUES (50, 'test_text_10');
    INSERT INTO validproceduretime VALUES (validproceduretimeid_seq.nextval, 1, to_timestamp('2012-11-19 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, '<sml:SensorML version="1.0.1"
      xmlns:sml="http://www.opengis.net/sensorML/1.0.1"
      xmlns:gml="http://www.opengis.net/gml"
      xmlns:swe="http://www.opengis.net/swe/1.0.1"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <sml:member>
        <sml:System >
          <sml:identification>
            <sml:IdentifierList>
              <sml:identifier name="uniqueID">
                <sml:Term definition="urn:ogc:def:identifier:OGC:1.0:uniqueID">
                  <sml:value>http://www.52north.org/test/procedure/1</sml:value>
                </sml:Term>
              </sml:identifier>
              <sml:identifier name="longName">
                <sml:Term definition="urn:ogc:def:identifier:OGC:1.0:longName">
                  <sml:value>con terra GmbH (www.conterra.de)</sml:value>
                </sml:Term>
              </sml:identifier>
              <sml:identifier name="shortName">
                <sml:Term definition="urn:ogc:def:identifier:OGC:1.0:shortName">
                  <sml:value>con terra</sml:value>
                </sml:Term>
              </sml:identifier>
            </sml:IdentifierList>
          </sml:identification>
          <sml:position name="sensorPosition">
            <swe:Position referenceFrame="urn:ogc:def:crs:EPSG::4326">
              <swe:location>
                <swe:Vector gml:id="STATION_LOCATION">
                  <swe:coordinate name="easting">
                    <swe:Quantity axisID="x">
                      <swe:uom code="degree"/>
                      <swe:value>7.727958</swe:value>
                    </swe:Quantity>
                  </swe:coordinate>
                  <swe:coordinate name="northing">
                    <swe:Quantity axisID="y">
                      <swe:uom code="degree"/>
                      <swe:value>51.883906</swe:value>
                    </swe:Quantity>
                  </swe:coordinate>
                  <swe:coordinate name="altitude">
                    <swe:Quantity axisID="z">
                      <swe:uom code="m"/>
                      <swe:value>0.0</swe:value>
                    </swe:Quantity>
                  </swe:coordinate>
                </swe:Vector>
              </swe:location>
            </swe:Position>
          </sml:position>
          <sml:inputs>
            <sml:InputList>
              <sml:input name="">
                <swe:ObservableProperty definition="http://www.52north.org/test/observableProperty/1"/>
              </sml:input>
            </sml:InputList>
          </sml:inputs>
          <sml:outputs>
            <sml:OutputList>
              <sml:output name="">
                <swe:Quantity  definition="http://www.52north.org/test/observableProperty/1">
                  <swe:uom code="NOTDEFINED"/>
                </swe:Quantity>
              </sml:output>
            </sml:OutputList>
          </sml:outputs>
        </sml:System>
      </sml:member>
    </sml:SensorML>');
    INSERT INTO validproceduretime VALUES (validproceduretimeid_seq.nextval, 2, to_timestamp('2012-11-19 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, '<sml:SensorML version="1.0.1"
      xmlns:sml="http://www.opengis.net/sensorML/1.0.1"
      xmlns:gml="http://www.opengis.net/gml"
      xmlns:swe="http://www.opengis.net/swe/1.0.1"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <sml:member>
        <sml:System >
          <sml:identification>
            <sml:IdentifierList>
              <sml:identifier name="uniqueID">
                <sml:Term definition="urn:ogc:def:identifier:OGC:1.0:uniqueID">
                  <sml:value>http://www.52north.org/test/procedure/2</sml:value>
                </sml:Term>
              </sml:identifier>
              <sml:identifier name="longName">
                <sml:Term definition="urn:ogc:def:identifier:OGC:1.0:longName">
                  <sml:value>ESRI (www.esri.com)</sml:value>
                </sml:Term>
              </sml:identifier>
              <sml:identifier name="shortName">
                <sml:Term definition="urn:ogc:def:identifier:OGC:1.0:shortName">
                  <sml:value>ESRI</sml:value>
                </sml:Term>
              </sml:identifier>
            </sml:IdentifierList>
          </sml:identification>
          <sml:position name="sensorPosition">
            <swe:Position referenceFrame="urn:ogc:def:crs:EPSG::4326">
              <swe:location>
                <swe:Vector gml:id="STATION_LOCATION">
                  <swe:coordinate name="easting">
                    <swe:Quantity axisID="x">
                      <swe:uom code="degree"/>
                      <swe:value>-117.1957110000000</swe:value>
                    </swe:Quantity>
                  </swe:coordinate>
                  <swe:coordinate name="northing">
                    <swe:Quantity axisID="y">
                      <swe:uom code="degree"/>
                      <swe:value>34.056517</swe:value>
                    </swe:Quantity>
                  </swe:coordinate>
                  <swe:coordinate name="altitude">
                    <swe:Quantity axisID="z">
                      <swe:uom code="m"/>
                      <swe:value>0.0</swe:value>
                    </swe:Quantity>
                  </swe:coordinate>
                </swe:Vector>
              </swe:location>
            </swe:Position>
          </sml:position>
          <sml:inputs>
            <sml:InputList>
              <sml:input name="">
                <swe:ObservableProperty definition="http://www.52north.org/test/observableProperty/2"/>
              </sml:input>
            </sml:InputList>
          </sml:inputs>
          <sml:outputs>
            <sml:OutputList>
              <sml:output name="">
                <swe:Quantity  definition="http://www.52north.org/test/observableProperty/2">
                  <swe:uom code="NOTDEFINED"/>
                </swe:Quantity>
              </sml:output>
            </sml:OutputList>
          </sml:outputs>
        </sml:System>
      </sml:member>
    </sml:SensorML>');
    INSERT INTO validproceduretime VALUES (validproceduretimeid_seq.nextval, 3, to_timestamp('2012-11-19 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, '<sml:SensorML version="1.0.1"
      xmlns:sml="http://www.opengis.net/sensorML/1.0.1"
      xmlns:gml="http://www.opengis.net/gml"
      xmlns:swe="http://www.opengis.net/swe/1.0.1"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <sml:member>
        <sml:System >
          <sml:identification>
            <sml:IdentifierList>
              <sml:identifier name="uniqueID">
                <sml:Term definition="urn:ogc:def:identifier:OGC:1.0:uniqueID">
                  <sml:value>http://www.52north.org/test/procedure/3</sml:value>
                </sml:Term>
              </sml:identifier>
              <sml:identifier name="longName">
                <sml:Term definition="urn:ogc:def:identifier:OGC:1.0:longName">
                  <sml:value>Kisters AG (www.kisters.de)</sml:value>
                </sml:Term>
              </sml:identifier>
              <sml:identifier name="shortName">
                <sml:Term definition="urn:ogc:def:identifier:OGC:1.0:shortName">
                  <sml:value>Kisters</sml:value>
                </sml:Term>
              </sml:identifier>
            </sml:IdentifierList>
          </sml:identification>
          <sml:position name="sensorPosition">
            <swe:Position referenceFrame="urn:ogc:def:crs:EPSG::4326">
              <swe:location>
                <swe:Vector gml:id="STATION_LOCATION">
                  <swe:coordinate name="easting">
                    <swe:Quantity axisID="x">
                      <swe:uom code="degree"/>
                      <swe:value>6.1320144042060925</swe:value>
                    </swe:Quantity>
                  </swe:coordinate>
                  <swe:coordinate name="northing">
                    <swe:Quantity axisID="y">
                      <swe:uom code="degree"/>
                      <swe:value>50.78570661296184</swe:value>
                    </swe:Quantity>
                  </swe:coordinate>
                  <swe:coordinate name="altitude">
                    <swe:Quantity axisID="z">
                      <swe:uom code="m"/>
                      <swe:value>0.0</swe:value>
                    </swe:Quantity>
                  </swe:coordinate>
                </swe:Vector>
              </swe:location>
            </swe:Position>
          </sml:position>
          <sml:inputs>
            <sml:InputList>
              <sml:input name="">
                <swe:ObservableProperty definition="http://www.52north.org/test/observableProperty/3"/>
              </sml:input>
            </sml:InputList>
          </sml:inputs>
          <sml:outputs>
            <sml:OutputList>
              <sml:output name="">
                <swe:Quantity  definition="http://www.52north.org/test/observableProperty/3">
                  <swe:uom code="NOTDEFINED"/>
                </swe:Quantity>
              </sml:output>
            </sml:OutputList>
          </sml:outputs>
        </sml:System>
      </sml:member>
    </sml:SensorML>');
    INSERT INTO validproceduretime VALUES (validproceduretimeid_seq.nextval, 4, to_timestamp('2012-11-19 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, '<sml:SensorML version="1.0.1"
      xmlns:sml="http://www.opengis.net/sensorML/1.0.1"
      xmlns:gml="http://www.opengis.net/gml"
      xmlns:swe="http://www.opengis.net/swe/1.0.1"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <sml:member>
        <sml:System >
          <sml:identification>
            <sml:IdentifierList>
              <sml:identifier name="uniqueID">
                <sml:Term definition="urn:ogc:def:identifier:OGC:1.0:uniqueID">
                  <sml:value>http://www.52north.org/test/procedure/4</sml:value>
                </sml:Term>
              </sml:identifier>
              <sml:identifier name="longName">
                <sml:Term definition="urn:ogc:def:identifier:OGC:1.0:longName">
                  <sml:value>Institute for Geoinformatics (http://ifgi.uni-muenster.de/en)</sml:value>
                </sml:Term>
              </sml:identifier>
              <sml:identifier name="shortName">
                <sml:Term definition="urn:ogc:def:identifier:OGC:1.0:shortName">
                  <sml:value>IfGI</sml:value>
                </sml:Term>
              </sml:identifier>
            </sml:IdentifierList>
          </sml:identification>
          <sml:position name="sensorPosition">
            <swe:Position referenceFrame="urn:ogc:def:crs:EPSG::4326">
              <swe:location>
                <swe:Vector gml:id="STATION_LOCATION">
                  <swe:coordinate name="easting">
                    <swe:Quantity axisID="x">
                      <swe:uom code="degree"/>
                      <swe:value>7.593655600000034</swe:value>
                    </swe:Quantity>
                  </swe:coordinate>
                  <swe:coordinate name="northing">
                    <swe:Quantity axisID="y">
                      <swe:uom code="degree"/>
                      <swe:value>51.9681661</swe:value>
                    </swe:Quantity>
                  </swe:coordinate>
                  <swe:coordinate name="altitude">
                    <swe:Quantity axisID="z">
                      <swe:uom code="m"/>
                      <swe:value>0.0</swe:value>
                    </swe:Quantity>
                  </swe:coordinate>
                </swe:Vector>
              </swe:location>
            </swe:Position>
          </sml:position>
          <sml:inputs>
            <sml:InputList>
              <sml:input name="">
                <swe:ObservableProperty definition="http://www.52north.org/test/observableProperty/4"/>
              </sml:input>
            </sml:InputList>
          </sml:inputs>
          <sml:outputs>
            <sml:OutputList>
              <sml:output name="">
                <swe:Quantity  definition="http://www.52north.org/test/observableProperty/4">
                  <swe:uom code="NOTDEFINED"/>
                </swe:Quantity>
              </sml:output>
            </sml:OutputList>
          </sml:outputs>
        </sml:System>
      </sml:member>
    </sml:SensorML>');
    INSERT INTO validproceduretime VALUES (validproceduretimeid_seq.nextval, 5, to_timestamp('2012-11-19 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, '<sml:SensorML version="1.0.1"
      xmlns:sml="http://www.opengis.net/sensorML/1.0.1"
      xmlns:gml="http://www.opengis.net/gml"
      xmlns:swe="http://www.opengis.net/swe/1.0.1"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <sml:member>
        <sml:System >
          <sml:identification>
            <sml:IdentifierList>
              <sml:identifier name="uniqueID">
                <sml:Term definition="urn:ogc:def:identifier:OGC:1.0:uniqueID">
                  <sml:value>http://www.52north.org/test/procedure/5</sml:value>
                </sml:Term>
              </sml:identifier>
              <sml:identifier name="longName">
                <sml:Term definition="urn:ogc:def:identifier:OGC:1.0:longName">
                  <sml:value>Technical University Dresden (http://tu-dresden.de/en)</sml:value>
                </sml:Term>
              </sml:identifier>
              <sml:identifier name="shortName">
                <sml:Term definition="urn:ogc:def:identifier:OGC:1.0:shortName">
                  <sml:value>TU-Dresden</sml:value>
                </sml:Term>
              </sml:identifier>
            </sml:IdentifierList>
          </sml:identification>
          <sml:position name="sensorPosition">
            <swe:Position referenceFrame="urn:ogc:def:crs:EPSG::4326">
              <swe:location>
                <swe:Vector gml:id="STATION_LOCATION">
                  <swe:coordinate name="easting">
                    <swe:Quantity axisID="x">
                      <swe:uom code="degree"/>
                      <swe:value>13.72375999999997</swe:value>
                    </swe:Quantity>
                  </swe:coordinate>
                  <swe:coordinate name="northing">
                    <swe:Quantity axisID="y">
                      <swe:uom code="degree"/>
                      <swe:value>51.02881</swe:value>
                    </swe:Quantity>
                  </swe:coordinate>
                  <swe:coordinate name="altitude">
                    <swe:Quantity axisID="z">
                      <swe:uom code="m"/>
                      <swe:value>0.0</swe:value>
                    </swe:Quantity>
                  </swe:coordinate>
                </swe:Vector>
              </swe:location>
            </swe:Position>
          </sml:position>
          <sml:inputs>
            <sml:InputList>
              <sml:input name="">
                <swe:ObservableProperty definition="http://www.52north.org/test/observableProperty/5"/>
              </sml:input>
            </sml:InputList>
          </sml:inputs>
          <sml:outputs>
            <sml:OutputList>
              <sml:output name="">
                <swe:Quantity  definition="http://www.52north.org/test/observableProperty/5">
                  <swe:uom code="NOTDEFINED"/>
                </swe:Quantity>
              </sml:output>
            </sml:OutputList>
          </sml:outputs>
        </sml:System>
      </sml:member>
    </sml:SensorML>');
    INSERT INTO validproceduretime VALUES (validproceduretimeid_seq.nextval, 6, to_timestamp('2012-11-19 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, '<sml:SensorML version="1.0.1"
      xmlns:sml="http://www.opengis.net/sensorML/1.0.1"
      xmlns:gml="http://www.opengis.net/gml"
      xmlns:swe="http://www.opengis.net/swe/1.0.1"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <sml:member>
        <sml:System >
          <sml:identification>
            <sml:IdentifierList>
              <sml:identifier name="uniqueID">
                <sml:Term definition="urn:ogc:def:identifier:OGC:1.0:uniqueID">
                  <sml:value>http://www.52north.org/test/procedure/6</sml:value>
                </sml:Term>
              </sml:identifier>
              <sml:identifier name="longName">
                <sml:Term definition="urn:ogc:def:identifier:OGC:1.0:longName">
                  <sml:value>Hochschule Bochum - Bochum University of Applied Sciences (http://www.hochschule-bochum.de/en/)</sml:value>
                </sml:Term>
              </sml:identifier>
              <sml:identifier name="shortName">
                <sml:Term definition="urn:ogc:def:identifier:OGC:1.0:shortName">
                  <sml:value>Hochschule Bochum</sml:value>
                </sml:Term>
              </sml:identifier>
            </sml:IdentifierList>
          </sml:identification>
          <sml:position name="sensorPosition">
            <swe:Position referenceFrame="urn:ogc:def:crs:EPSG::4326">
              <swe:location>
                <swe:Vector gml:id="STATION_LOCATION">
                  <swe:coordinate name="easting">
                    <swe:Quantity axisID="x">
                      <swe:uom code="degree"/>
                      <swe:value>7.270806</swe:value>
                    </swe:Quantity>
                  </swe:coordinate>
                  <swe:coordinate name="northing">
                    <swe:Quantity axisID="y">
                      <swe:uom code="degree"/>
                      <swe:value>51.447722</swe:value>
                    </swe:Quantity>
                  </swe:coordinate>
                  <swe:coordinate name="altitude">
                    <swe:Quantity axisID="z">
                      <swe:uom code="m"/>
                      <swe:value>0.0</swe:value>
                    </swe:Quantity>
                  </swe:coordinate>
                </swe:Vector>
              </swe:location>
            </swe:Position>
          </sml:position>
          <sml:inputs>
            <sml:InputList>
              <sml:input name="">
                <swe:ObservableProperty definition="http://www.52north.org/test/observableProperty/6"/>
              </sml:input>
            </sml:InputList>
          </sml:inputs>
          <sml:outputs>
            <sml:OutputList>
              <sml:output name="">
                <swe:Quantity  definition="http://www.52north.org/test/observableProperty/6">
                  <swe:uom code="NOTDEFINED"/>
                </swe:Quantity>
              </sml:output>
            </sml:OutputList>
          </sml:outputs>
        </sml:System>
      </sml:member>
    </sml:SensorML>');
    INSERT INTO validproceduretime VALUES (validproceduretimeid_seq.nextval, 7, to_timestamp('2012-11-19 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, '<sml:SensorML version="1.0.1"
      xmlns:sml="http://www.opengis.net/sensorML/1.0.1"
      xmlns:gml="http://www.opengis.net/gml"
      xmlns:swe="http://www.opengis.net/swe/1.0.1"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <sml:member>
        <sml:System >
          <sml:identification>
            <sml:IdentifierList>
              <sml:identifier name="uniqueID">
                <sml:Term definition="urn:ogc:def:identifier:OGC:1.0:uniqueID">
                  <sml:value>http://www.52north.org/test/procedure/7</sml:value>
                </sml:Term>
              </sml:identifier>
              <sml:identifier name="longName">
                <sml:Term definition="urn:ogc:def:identifier:OGC:1.0:longName">
                  <sml:value>ITC - University of Twente (http://www.itc.nl/)</sml:value>
                </sml:Term>
              </sml:identifier>
              <sml:identifier name="shortName">
                <sml:Term definition="urn:ogc:def:identifier:OGC:1.0:shortName">
                  <sml:value>ITC</sml:value>
                </sml:Term>
              </sml:identifier>
            </sml:IdentifierList>
          </sml:identification>
          <sml:position name="sensorPosition">
            <swe:Position referenceFrame="urn:ogc:def:crs:EPSG::4326">
              <swe:location>
                <swe:Vector gml:id="STATION_LOCATION">
                  <swe:coordinate name="easting">
                    <swe:Quantity axisID="x">
                      <swe:uom code="degree"/>
                      <swe:value>4.283393599999954</swe:value>
                    </swe:Quantity>
                  </swe:coordinate>
                  <swe:coordinate name="northing">
                    <swe:Quantity axisID="y">
                      <swe:uom code="degree"/>
                      <swe:value>52.0464393</swe:value>
                    </swe:Quantity>
                  </swe:coordinate>
                  <swe:coordinate name="altitude">
                    <swe:Quantity axisID="z">
                      <swe:uom code="m"/>
                      <swe:value>0.0</swe:value>
                    </swe:Quantity>
                  </swe:coordinate>
                </swe:Vector>
              </swe:location>
            </swe:Position>
          </sml:position>
          <sml:inputs>
            <sml:InputList>
              <sml:input name="">
                <swe:ObservableProperty definition="http://www.52north.org/test/observableProperty/7"/>
              </sml:input>
            </sml:InputList>
          </sml:inputs>
          <sml:outputs>
            <sml:OutputList>
              <sml:output name="">
                <swe:Quantity  definition="http://www.52north.org/test/observableProperty/7">
                  <swe:uom code="NOTDEFINED"/>
                </swe:Quantity>
              </sml:output>
            </sml:OutputList>
          </sml:outputs>
        </sml:System>
      </sml:member>
    </sml:SensorML>');
    INSERT INTO validproceduretime VALUES (validproceduretimeid_seq.nextval, 8, to_timestamp('2012-11-19 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, '<sml:SensorML version="1.0.1"
      xmlns:sml="http://www.opengis.net/sensorML/1.0.1"
      xmlns:gml="http://www.opengis.net/gml"
      xmlns:swe="http://www.opengis.net/swe/1.0.1"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <sml:member>
        <sml:System >
          <sml:identification>
            <sml:IdentifierList>
              <sml:identifier name="uniqueID">
                <sml:Term definition="urn:ogc:def:identifier:OGC:1.0:uniqueID">
                  <sml:value>http://www.52north.org/test/procedure/8</sml:value>
                </sml:Term>
              </sml:identifier>
              <sml:identifier name="longName">
                <sml:Term definition="urn:ogc:def:identifier:OGC:1.0:longName">
                  <sml:value>Bundesanstalt für IT-Dienstleistungen im Geschäftsbereich des BMVBS (http://www.dlz-it.de)</sml:value>
                </sml:Term>
              </sml:identifier>
              <sml:identifier name="shortName">
                <sml:Term definition="urn:ogc:def:identifier:OGC:1.0:shortName">
                  <sml:value>DLZ-IT</sml:value>
                </sml:Term>
              </sml:identifier>
            </sml:IdentifierList>
          </sml:identification>
          <sml:position name="sensorPosition">
            <swe:Position referenceFrame="urn:ogc:def:crs:EPSG::4326">
              <swe:location>
                <swe:Vector gml:id="STATION_LOCATION">
                  <swe:coordinate name="easting">
                    <swe:Quantity axisID="x">
                      <swe:uom code="degree"/>
                      <swe:value>10.94306000000006</swe:value>
                    </swe:Quantity>
                  </swe:coordinate>
                  <swe:coordinate name="northing">
                    <swe:Quantity axisID="y">
                      <swe:uom code="degree"/>
                      <swe:value>50.68606</swe:value>
                    </swe:Quantity>
                  </swe:coordinate>
                  <swe:coordinate name="altitude">
                    <swe:Quantity axisID="z">
                      <swe:uom code="m"/>
                      <swe:value>0.0</swe:value>
                    </swe:Quantity>
                  </swe:coordinate>
                </swe:Vector>
              </swe:location>
            </swe:Position>
          </sml:position>
          <sml:inputs>
            <sml:InputList>
              <sml:input name="">
                <swe:ObservableProperty definition="http://www.52north.org/test/observableProperty/8"/>
              </sml:input>
            </sml:InputList>
          </sml:inputs>
          <sml:outputs>
            <sml:OutputList>
              <sml:output name="">
                <swe:Quantity  definition="http://www.52north.org/test/observableProperty/8">
                  <swe:uom code="NOTDEFINED"/>
                </swe:Quantity>
              </sml:output>
            </sml:OutputList>
          </sml:outputs>
        </sml:System>
      </sml:member>
    </sml:SensorML>');
