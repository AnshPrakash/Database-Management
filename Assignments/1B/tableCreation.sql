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