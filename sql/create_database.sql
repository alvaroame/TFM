CREATE USER licpub WITH
	LOGIN
	NOSUPERUSER
	CREATEDB
	NOCREATEROLE
	INHERIT
	NOREPLICATION
	CONNECTION LIMIT -1
	PASSWORD 'licpub123';

CREATE TABLESPACE ts_licpub_data
  OWNER licpub
  LOCATION 'c:\\db\\licpub\\data';

ALTER TABLESPACE ts_licpub_data
  OWNER TO licpub;

CREATE TABLESPACE ts_licpub_idx
  OWNER licpub
  LOCATION 'c:\\db\\licpub\\idx';

ALTER TABLESPACE ts_licpub_idx
  OWNER TO licpub;

CREATE DATABASE licpub
    WITH
    OWNER = licpub
    ENCODING = 'UTF8'
    TABLESPACE = ts_licpub_data
    CONNECTION LIMIT = -1;

\connect licpub;

CREATE SCHEMA licpub
    AUTHORIZATION licpub;