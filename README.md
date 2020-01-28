# Database-Management
Course work

man psql
Info
service postgresql
service postgres start
service postgresql status

-- Run SQL script
psql -U username -f filename.sql

#Start
sudo -u postgres psql
or 
su postgres # enter postgres password
psql
\\l #tell the databases in postgres server
\du #list users in postgres

#change password for user postgres
ALTER USER postgres WITH PASSWORD 'postgres';

create new User
CREATE USER user_name WITH PASSWORD 'password';
ALTER USER user_name WITH SUPERUSER; # add privlages
DROP USER user_name; # delete existing user

#Clear screen
Cltr+l

#timing on by 
\timing
more on timing:
https://dba.stackexchange.com/questions/3148/how-can-i-time-sql-queries-using-psql

#some links for changing user access
https://tableplus.com/blog/2018/04/postgresql-how-to-grant-access-to-users.html

#Good Link to start psql
https://www.ntu.edu.sg/home/ehchua/programming/sql/PostgreSQL_GetStarted.html


#Display Commands: You can append + to show more details.
\l: List all database (or \list).
\d: Display all tables, indexes, views, and sequences.
\dt: Display all tables.
\di: Display all indexes.
\dv: Display all views.
\ds: Display all sequences.
\dT: Display all types.
\dS: Display all system tables.
\du: Display all users.


\c dbname [username]: Connect to database, with an optional username (or \connect).

get User table
SELECT * FROM pg_user;

#Interesting!:
SELECT rolname FROM pg_roles;
