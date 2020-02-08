CREATE DATABASE socialgraph;

CREATE TABLE userdetails(
  userid int PRIMARY KEY,
  username text,
  place text
); 

CREATE TABLE friendlist(
  userid1 int,
  userid2 int,
  PRIMARY KEY (userid1,userid2)
); 

CREATE TABLE block(
  userid1 int,
  userid2 int,
  PRIMARY KEY (userid1,userid2)
); 

-- \copy userdetails from './Randomdata/userdetails.csv' DELIMITER '|' CSV HEADER;
-- \copy friendlist from './Randomdata/friendlist.csv' DELIMITER '|' CSV HEADER;
-- \copy block from './Randomdata/block.csv' DELIMITER '|' CSV HEADER;

\copy userdetails from './GivenData/userdetails.csv' DELIMITER ',' CSV HEADER;
\copy friendlist from './GivenData/friendlist.csv' DELIMITER ',' CSV HEADER;
\copy block from './GivenData/block.csv' DELIMITER ',' CSV HEADER;


DROP TABLE userdetails;
DROP TABLE friendlist;
DROP TABLE block;