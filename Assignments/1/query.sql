
--PREAMBLE--

--1--
SELECT name,COUNT(*) AS number FROM badges GROUP BY name HAVING COUNT(*) >= 10000 ORDER BY COUNT(*) DESC,name ASC;


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



--3--
SELECT DISTINCT ON(EXTRACT(MONTH FROM badges.date)) EXTRACT(MONTH FROM badges.date) AS MONTH,users.id AS userid FROM badges
INNER JOIN users 
ON badges.userid = users.id
WHERE badges.date BETWEEN '2010-01-01' AND '2010-12-31'
GROUP BY EXTRACT(MONTH FROM badges.date),users.id,users.displayname
ORDER BY EXTRACT(MONTH FROM badges.date) ASC,COUNT(*) DESC,users.displayname ASC
;



--4--
select id AS postid,LENGTH(title) AS charcount FROM posts WHERE LENGTH(title)>100 ORDER BY LENGTH(title) DESC, id ASC;



--5--
SELECT column_name AS postcolumn
FROM information_schema.columns
WHERE table_name = 'posts' ORDER BY column_name ASC LIMIT 5 ;



--6--
SELECT posts.title ,COUNT(*) AS count FROM postlinks 
INNER JOIN posts 
ON postlinks.postid = posts.id
GROUP BY posts.id,posts.title
ORDER BY count DESC,posts.title ASC
LIMIT 5
;

--7--
SELECT users.displayname FROM users
INNER JOIN 
(
  SELECT DISTINCT p1.OwneruserID AS userid FROM Posts p1
  INNER JOIN Posts p2
  ON p1.OwneruserID = p2.OwneruserID
  WHERE  AGE(p1.CreationDate,p2.CreationDate) < INTERVAL '24 Hours' AND AGE(p1.CreationDate,p2.CreationDate) > INTERVAL '0 MINUTE'
) AS foo
ON foo.userid = users.id
ORDER BY users.displayname ASC
;

--8--
SELECT users.displayname
FROM Votes 
INNER JOIN users 
ON users.id = Votes.userid 
WHERE Votes.BountyAmount IS NOT NULL
GROUP BY users.displayname
ORDER BY sum(Votes.BountyAmount) DESC,users.displayname ASC LIMIT 3;


--9--
SELECT foo.displayname,COUNT(*) FROM Posts 
INNER JOIN 
( 
  SELECT users.id,users.displayname, COUNT(*) AS count FROM badges 
  INNER JOIN users
  ON users.id = badges.userid
  GROUP BY users.id,users.displayname
  HAVING COUNT(*) >= 10
) AS foo
ON foo.id = Posts.LastEditorUserId
GROUP BY foo.id,foo.displayname
ORDER BY COUNT(*) DESC,foo.displayname ASC
LIMIT 5
;




--10--
SELECT DISTINCT ON (foo.year,foo.month)
foo.year,foo.month,OwneruserID FROM users
INNER JOIN 
(
  SELECT EXTRACT(YEAR FROM CreationDate) AS YEAR,EXTRACT(MONTH FROM CreationDate) AS month,OwneruserID,ABS(COUNT(case when PostTypeId=1 then 1 else null end ) - COUNT(case when PostTypeId=2 then 1 else null end)) AS count 
  FROM posts
  GROUP BY OwnerUserId,EXTRACT(YEAR FROM CreationDate),EXTRACT(MONTH FROM CreationDate)
) AS foo
ON foo.OwneruserID = users.id
ORDER BY foo.year ASC,foo.MONTH ASC,foo.count DESC,users.displayname ASC
;


--11--
SELECT  tags,avg(viewcount) As viewcount FROM Posts 
WHERE PostTypeId = 1
GROUP BY tags
ORDER BY tags ASC
;


--12--
SELECT tags,COUNT(*) AS number FROM posts
WHERE PostTypeId = 1 AND AnswerCount = 0
GROUP BY tags
ORDER BY count(*) DESC, tags ASC
LIMIT 10
;


--13--
SELECT users.displayname FROM users
INNER JOIN
(
  WITH filteredPosts AS
  (
    SELECT Posts.id,Posts.OwneruserID,Posts.CreationDate,Posts.ParentId,Posts.PostTypeId FROM Posts 
    WHERE Posts.PostTypeId = 2
  ) 
  SELECT DISTINCT p1.OwneruserID AS userid FROM filteredPosts AS p1
  INNER JOIN filteredPosts AS p2
  ON  p1.OwneruserID = p2.OwneruserID
  WHERE (
    AGE(p2.CreationDate,p1.CreationDate) <= INTERVAL '24 Hours' 
    AND AGE(p2.CreationDate,p1.CreationDate) > INTERVAL '0 MINUTE'
    AND p1.ParentId = p2.ParentId
  )
  GROUP BY p1.OwneruserID
  HAVING COUNT(*)>=2
) AS foo
ON foo.userid = users.id
ORDER BY users.displayname ASC
;





--14--
SELECT userid, COUNT(*) AS totalbadges FROM badges 
GROUP BY userid
ORDER BY COUNT(*) DESC
LIMIT 10
;


--15--
SELECT to_char(CreationDate,'day') AS day FROM Posts
WHERE viewcount >= 9 AND PostTypeId = 1 AND AnswerCount = 0
GROUP BY to_char(CreationDate,'day')
ORDER BY COUNT(*) DESC
LIMIT 1
;


--16--
SELECT foo.postid AS postid,(1.0*foo.totvotes)/posts.viewcount AS ratio  FROM
(
  SELECT postid,count(*) AS totvotes FROM Votes 
  WHERE VoteTypeId = 2 or VoteTypeId = 3
  GROUP BY PostId
) AS foo
INNER JOIN posts ON posts.id = foo.postid
WHERE posts.viewcount >= 1
ORDER BY ((1.0*foo.totvotes)/posts.viewcount) DESC,foo.PostId ASC
LIMIT 10
;


--17--
SELECT  users.displayname AS displayname FROM Comments 
INNER JOIN users ON users.id = Comments.userid
GROUP BY postid,UserId,users.displayname
ORDER BY sum(score) DESC, users.displayname ASC
LIMIT 3
;

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

--19--
SELECT posts.id,count(case when Votes.VoteTypeId = 2 then 1 else null end) - count(case when Votes.VoteTypeId = 3 then 1 else null end) AS effectiveupvotes FROM Posts 
INNER JOIN Votes ON
posts.id = Votes.postid
WHERE posts.PostTypeId = 1 AND posts.AnswerCount = 0 
GROUP BY posts.id
ORDER BY effectiveupvotes DESC
LIMIT 1
;


--20--
SELECT users.id,(foo.postviews - users.Views) AS viewdiff FROM users
INNER JOIN 
(
  SELECT filteredUser.userid,(Posts.viewcount) As postviews FROM Posts
  INNER JOIN 
  (
    SELECT users.id AS userid,users.displayname FROM badges
    INNER JOIN users
    ON users.id = badges.userid
    GROUP BY users.id,users.displayname
    HAVING COUNT(*) >= 100
  ) AS filteredUser
  ON filteredUser.userid = Posts.OwneruserID
  WHERE (Posts.PostTypeId = 1 OR Posts.PostTypeId = 2)
) AS foo
ON foo.userid = users.id
WHERE (foo.postviews - users.Views) > 0 
ORDER BY (foo.postviews - users.Views) DESC, users.displayname ASC
;


--21--
SELECT 
  CASE WHEN users.Reputation>1000 THEN 'expert'
       WHEN users.Reputation<100 THEN 'new'
  END AS askertype,AVG(Posts.AnswerCount) AS replies FROM users
INNER JOIN Posts
ON Posts.OwneruserID = users.id
WHERE Posts.PostTypeId = 1 AND (users.Reputation>1000 OR users.Reputation<100)
GROUP BY askertype
;

--22--
WITH fileteredusers AS
(
  SELECT users.id AS userid FROM users
  WHERE AGE(users.LastAccessDate,users.CreationDate) >= INTERVAL '6 month' 
)


SELECT COUNT(*) FROM 
(
  SELECT (fileteredusers.userid) FROM fileteredusers
  EXCEPT
  (
    (
      SELECT Comments.userid FROM Comments
    )
    UNION
    (
      SELECT Posts.OwnerUserId FROM Posts
      WHERE Posts.PostTypeId =1 OR Posts.PostTypeId =2
    )
  )
) AS bar
;

--CLEANUP--




















