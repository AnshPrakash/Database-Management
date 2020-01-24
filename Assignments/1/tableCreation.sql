CREATE DATABASE stackExchange;

CREATE TABLE Badges(
  Id int,
  Name text,
  UserId int,
  Date timestamp
); 
\copy Badges from 'badges.csv' DELIMITER '|' CSV HEADER;
-- COPY 1102019
-- Time 3018.370 ms (0003.018)

CREATE TABLE Comments(
  Id int,
  CreationDate timestamp,
  PostId int,
  Score int,
  UserId int
); 
\copy Comments from 'comments.csv' DELIMITER '|' CSV HEADER;
-- COPY 3875183
-- Time 16530.487 ms (0016.530)

CREATE TABLE PostLinks(
  Id int,
  CreationDate timestamp,
  PostId int,
  RelatedPostId int,
  LinkTypeId int
);

\copy PostLinks from 'postLinks.csv' DELIMITER '|' CSV HEADER;
-- COPY 161519
-- Time 485.184 ms

CREATE TABLE Posts(
  Id  integer,
  AcceptedAnswerId  integer,
  AnswerCount  integer,
  ClosedDate  timestamp,
  CommentCount  integer,
  CommunityOwnedDate  timestamp,
  CreationDate  timestamp,
  FavoriteCount  integer,
  LastActivityDate  timestamp,
  LastEditDate  timestamp,
  LastEditorDisplayName  text,
  LastEditorUserId  integer,
  OwnerUserId  integer,
  ParentId  integer,
  PostTypeId  integer,
  Score  integer,
  Tags  text,
  Title  text,
  ViewCount  integer
);

\copy Posts from 'posts.csv' DELIMITER '|' CSV HEADER;
-- COPY 1882505 !?
-- Time 40245.131 ms (0040.245)

CREATE TABLE Users(
  Id  integer,
  Age  integer,
  CreationDate  timestamp,
  DisplayName  text,
  DownVotes  integer,
  EmailHash  text,
  LastAccessDate  timestamp,
  Location  text,
  Reputation  integer,
  UpVotes  integer,
  Views  integer,
  WebsiteUrl  text,
  AccountId  integer
);

\copy Users from 'users.csv' DELIMITER '|' CSV HEADER;
-- COPY 299396
-- Time 1660.199 ms (0001.660)


CREATE TABLE Votes(
  Id  integer,
  PostId  integer,
  UserId  integer,
  BountyAmount  integer, 
  VoteTypeId  integer,
  CreationDate  timestamp
);

\copy Votes from 'votes.csv' DELIMITER '|' CSV HEADER;
-- COPY 10143364
-- Time: 26446.584 ms (00:26.447)


