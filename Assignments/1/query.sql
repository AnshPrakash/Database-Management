

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

