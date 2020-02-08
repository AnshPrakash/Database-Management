

CREATE VIEW connected AS 
(
  SELECT userid1 AS u1, userid2 AS u2,least(userid2,userid1) AS lowlink, 1 AS length FROM friendlist
  UNION
  SELECT userid2 AS u1, userid1 AS u2,least(userid2,userid1) AS lowlink, 1 AS length FROM friendlist
  UNION
  SELECT userid AS u1,userid AS u2 ,userid AS lowlink, 0 AS length from userdetails
)
;

CREATE VIEW undirectedblock AS
(
  SELECT userid1 AS u1,userid2 AS u2 from block 
  UNION
  SELECT userid2 AS u1,userid1 AS u2 from block 
);

CREATE VIEW components AS
  (
    WITH RECURSIVE
    friendzone(u1,u2,lowlink) AS
      (  
        SELECT connected.u1,connected.u2,connected.lowlink FROM connected
        UNION
        (
          SELECT friendzone.u1,connected.u2,least(friendzone.lowlink,connected.lowlink) FROM friendzone,connected
          WHERE friendzone.u2 = connected.u1
        )
      )
    SELECT u1,u2,min(lowlink) AS lowlink
    FROM  friendzone
    GROUP BY u1,u2
  )
;


--PREAMBLE--

--1--
SELECT count(*) FROM
(
  SELECT lowlink from components
  GROUP BY lowlink
)
AS allcomponenets
;


--2--
SELECT array_length(array_agg(DISTINCT u1),1) AS COUNT from components
GROUP BY lowlink
ORDER BY array_length(array_agg(DISTINCT u1),1) ASC
;

--3--



--4--
--change u1 and u2
SELECT COALESCE( (WITH RECURSIVE
  friendzone(u1,u2,length) AS
    (  
      SELECT connected.u1,connected.u2,connected.length FROM connected
      UNION
      (
        SELECT friendzone.u1,connected.u2,friendzone.length +1 FROM friendzone,connected
        WHERE friendzone.u2 = connected.u1 AND friendzone.length +1 <= (SELECT COUNT(*) FROM friendlist)
      )
    )
  SELECT min(length) FROM  friendzone
  WHERE u1 = 2 AND u2 = 5
  GROUP BY u1,u2
  ), -1)
AS COUNT;



--5--
SELECT COUNT(*) FROM
(
  (
    SELECT unnest(array_agg(DISTINCT u1)) AS component from components
    GROUP BY lowlink
    HAVING 8 = ANY (array_agg(DISTINCT u1))
  )
  EXCEPT
  (
    (
      SELECT u2 FROM connected
      WHERE u1 = 8
    )
      UNION
    (
      SELECT u2 FROM undirectedblock
      WHERE u1 = 8
    )
  )
) AS sendrequest
;

--6--
WITH
foo AS
(
  SELECT u1,array_agg(u2) AS arr FROM components
  GROUP BY u1
) ,
bar AS
( 
  SELECT u1, array_agg(u2) AS arr FROM undirectedblock
  GROUP BY u1
),
avail AS
(
  SELECT ud1.userid AS u1,array_agg(ud2.userid) AS arr,ud1.place FROM userdetails AS ud1
  INNER JOIN userdetails AS ud2
  ON ud1.place = ud2.place
  GROUP BY u1,ud1.place
)
SELECT avail.u1 AS userid 
FROM avail FULL OUTER JOIN
(
  SELECT foo.u1,array( (SELECT unnest(foo.arr)) UNION (SELECT unnest(bar.arr)) ) AS arr 
  from foo FULL OUTER JOIN bar ON foo.u1= bar.u1
) AS boo
ON boo.u1 = avail.u1
ORDER BY  cardinality(array( (SELECT unnest(avail.arr)) EXCEPT (SELECT unnest(boo.arr)) )) DESC, avail.u1 ASC
LIMIT 10
;

--7--

SELECT u1 AS userid from 
(
  WITH RECURSIVE
    friendzone(u1,u2,length) AS
      (  
        SELECT connected.u1,connected.u2,connected.length FROM connected
        UNION
        (
          SELECT friendzone.u1,connected.u2,friendzone.length +1 FROM friendzone,connected
          WHERE friendzone.u2 = connected.u1 AND friendzone.length +1 <= (SELECT COUNT(*) FROM friendlist) 
        )
      )
    SELECT u1,u2,min(length) As length FROM  friendzone
    group by u1,u2
    HAVING min(length) = 3
) AS foo
GROUP BY foo.u1
ORDER BY COUNT(*) DESC,foo.u1 ASC
;

--8--


--9--

--10--





--CLEANUP--
DROP VIEW connected;
DROP VIEW components

