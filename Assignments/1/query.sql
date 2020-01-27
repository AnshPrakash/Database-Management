

--1--
SELECT name,COUNT(*) AS number FROM badges GROUP BY name HAVING COUNT(*) >= 10000 ORDER BY COUNT(*) DESC,name ASC;
-- Time: 233.321 ms


--2--
SELECT foo.userid,users.displayname FROM 
( 
  SELECT Comments.userid,COUNT(*) AS comments_count  FROM Comments  
  WHERE Comments.userid IS NOT NULL 
  GROUP BY Comments.userid 
  ORDER BY COUNT(*) DESC 
  LIMIT 5  
) foo 
INNER JOIN users 
ON foo.userid = users.id ORDER BY foo.comments_count DESC,users.displayname ASC;
-- Time: 859.068 ms 


--3--
SELECT MAX(foo.userid) AS userid,foo.month FROM
( 
  SELECT userid,EXTRACT(MONTH FROM date) AS month 
  FROM badges 
  WHERE date BETWEEN '2010-01-01' AND '2010-12-31'
) AS foo
GROUP BY foo.month
ORDER BY foo.month ASC
;
-- Time: 768.698 ms


--4--
select id AS postid,LENGTH(title) AS charcount FROM posts WHERE LENGTH(title)>100 ORDER BY LENGTH(title) DESC, id ASC;
-- Time: 3723.597 ms (00:03.724)


--5--
SELECT column_name AS postcolumn
FROM information_schema.columns
WHERE table_name = 'posts' ORDER BY column_name ASC LIMIT 5 ;
-- Time: 106.917 ms


--6--

SELECT posts.title ,COUNT(*) AS count FROM postlinks 
INNER JOIN posts 
ON postlinks.postid = posts.id
GROUP BY posts.id,posts.title
ORDER BY count DESC,posts.title ASC
LIMIT 5
;

---------------------------
--------------------------


--7--
-- hmmm.... tough

SELECT OwneruserID from Posts 
GROUP BY OwneruserID,justify_hours(INTERVAL '24 hours');



--8--
SELECT users.displayname
FROM Votes 
INNER JOIN users 
ON users.id = Votes.userid 
WHERE Votes.BountyAmount IS NOT NULL
GROUP BY users.displayname
ORDER BY sum(Votes.BountyAmount) DESC,users.displayname ASC LIMIT 3;


--9--
--WRONG
SELECT LastEditorDisplayName AS displayname, COUNT(*) FROM badges 
INNER JOIN Posts
ON Posts.LastEditorUserId = badges.userid
WHERE LastEditorDisplayName IS NOT NULL
GROUP BY Posts.LastEditorUserId,Posts.LastEditorDisplayName
ORDER BY COUNT(*) DESC,Posts.LastEditorDisplayName ASC 
LIMIT 5
;



--10--
--WRONG
SELECT DISTINCT ON (EXTRACT(YEAR FROM CreationDate),EXTRACT(MONTH FROM CreationDate)) 
EXTRACT(YEAR FROM CreationDate),EXTRACT(MONTH FROM CreationDate),OwneruserID
FROM posts
GROUP BY OwnerUserId,EXTRACT(YEAR FROM CreationDate),EXTRACT(MONTH FROM CreationDate)
ORDER BY EXTRACT(YEAR FROM CreationDate) ASC,EXTRACT(MONTH FROM CreationDate) ASC,ABS(COUNT(case when PostTypeId=1 then 1 else null end ) - COUNT(case when PostTypeId=2 then 1 else null end)) DESC
;


--11--
-- interesting observation
SELECT  tags,avg(viewcount) As viewcount FROM Posts 
WHERE PostTypeId = 1
GROUP BY tags
ORDER BY tags ASC
;
-- Time: 3641.185 ms 

--12--

SELECT tags,COUNT(*) AS number FROM posts
WHERE PostTypeId = 1 AND AnswerCount = 0
GROUP BY tags
ORDER BY count(*) DESC, tags ASC
LIMIT 10
;
-- Time: 267.971 ms

--13--
-- learn how to deal with intervals

--14--
SELECT userid, COUNT(*) AS totalbadges FROM badges 
GROUP BY userid
ORDER BY COUNT(*) DESC
LIMIT 10
;
-- Time: 667.140 ms

--15--

--
-- I don't understand which date I should take?
SELECT to_char(CreationDate,'day') AS day FROM Posts
WHERE viewcount >= 9 AND PostTypeId = 1 AND AnswerCount = 0
GROUP BY to_char(CreationDate,'day')
ORDER BY COUNT(*) DESC
LIMIT 1
;

-- Time: 299.207 ms

--16--
--wrong
SELECT foo.postid AS postid,(1.0*foo.totvotes)/posts.viewcount AS ratio  FROM
(
  SELECT postid,count(*) AS totvotes FROM Votes 
  WHERE VoteTypeId = 2 or VoteTypeId = 3
  GROUP BY PostId
) AS foo
INNER JOIN posts ON posts.id = foo.postid
WHERE posts.viewcount >= 1
ORDER BY ((1.0*foo.totvotes)/posts.viewcount) DESC
LIMIT 10
;
-- Time: 7094.033 ms (00:07.094)

--17--

SELECT  users.displayname AS displayname FROM Comments 
INNER JOIN users ON users.id = Comments.userid
GROUP BY postid,UserId,users.displayname
ORDER BY sum(score) DESC, users.displayname ASC
LIMIT 3
;
-- Time: 5478.478 ms (00:05.478)

--18--


SELECT users.displayname,COUNT(*) as number FROM users INNER JOIN 
(
  SELECT p2.OwnerUserId FROM 
    Posts p1 INNER JOIN Posts p2 
  ON p1.AcceptedAnswerId = p2.id
) AS foo
ON foo.OwneruserID = users.id
WHERE (EXTRACT(YEAR FROM users.CreationDate) = 2008 
  AND EXTRACT(YEAR FROM users.LastAccessDate)<2010 
)
GROUP BY users.id,users.displayname
HAVING COUNT(*)>=10
ORDER BY number DESC,users.displayname ASC
;
-- Time: 531.993 ms

--19--

SELECT posts.id,count(case when Votes.VoteTypeId = 2 then 1 else null end) - count(case when Votes.VoteTypeId = 3 then 1 else null end) AS effectiveupvotes FROM Posts 
INNER JOIN Votes ON
posts.id = Votes.postid
WHERE posts.PostTypeId = 1 AND posts.AnswerCount = 0 
GROUP BY posts.id
ORDER BY effectiveupvotes DESC
LIMIT 1
;


-- --20--
-- SELECT  userid AS  FROM Posts 
-- INNER JOIN users
-- ON users.id = Posts.OwneruserID
-- WHERE Posts.PostTypeId = 1 OR Posts.PostTypeId = 2
-- GROUP BY users.id  


-- (
--   SELECT COUNT(*),userid AS badgeCount FROM badges 
--   INNER JOIN users 
--   ON users.id = badges.userid
--   GROUP BY users.id 
--   HAVING badgeCount >= 100
-- ) AS foo
-- ON foo.userid = Posts.OwneruserID
-- WHERE Posts.PostTypeId = 1 OR Posts.PostTypeId = 2
-- GROUP BY foo.userid =
















