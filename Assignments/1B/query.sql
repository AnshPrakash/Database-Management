

--PREAMBLE--
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
WITH
boo AS
(
  SELECT array_agg(bar.u1) AS arr,cardinality(array( (SELECT unnest(foo.arr)) INTERSECT (SELECT unnest(bar.arr)) )) AS count
  FROM
  (
    SELECT u1,array_agg(u2) AS arr FROM undirectedblock
    GROUP BY u1
  ) AS foo
  FULL OUTER JOIN 
  (
    SELECT u1,array_agg(u2) AS arr FROM components
    GROUP BY u1
  ) AS bar
  ON foo.u1 = bar.u1
  GROUP BY count
  ORDER BY count DESC
  LIMIT 1
)

SELECT hoo AS userid,boo.count FROM boo CROSS JOIN UNNEST(boo.arr) AS hoo 
ORDER BY userid
;

--4--
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
  WHERE u1 = 1558 AND u2 = 2826
  GROUP BY u1,u2
  ), -1)
AS COUNT;



--5--
SELECT COUNT(*) FROM
(
  (
    SELECT unnest(array_agg(DISTINCT u1)) AS component from components
    GROUP BY lowlink
    HAVING 704 = ANY (array_agg(DISTINCT u1))
  )
  EXCEPT
  (
    (
      SELECT u2 FROM connected
      WHERE u1 = 704
    )
      UNION
    (
      SELECT u2 FROM undirectedblock
      WHERE u1 = 704
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
SELECT CASE WHEN count = 0 THEN count - 1 ELSE count END FROM 
(
  SELECT COUNT(*) AS COUNT FROM
  (
    WITH RECURSIVE
      Allpath(u1,u2,paths) AS
      (
        SELECT connected.u1 AS u1,connected.u2 AS u2, array[connected.u1,connected.u2] AS paths 
        FROM connected WHERE connected.u1 = 3552 AND connected.u1 <> connected.u2
        UNION
        (
          SELECT Allpath.u1,connected.u2,Allpath.paths||connected.u2 AS paths  FROM Allpath,connected
          WHERE (
            Allpath.u2 = connected.u1
            AND
            connected.u2 <> ALL (Allpath.paths)
            AND 
            array_length(Allpath.paths,1) + 1 <= (SELECT COUNT(*) FROM friendlist))
        )

      )
    SELECT * FROM Allpath WHERE u2 = 321
  ) AS p1
  INNER JOIN
  (
    WITH RECURSIVE
      Allpath(u1,u2,paths) AS
      (
        SELECT connected.u1 AS u1,connected.u2 AS u2, array[connected.u1,connected.u2] AS paths 
        FROM connected WHERE connected.u1 = 321 AND connected.u1 <> connected.u2
        UNION
        (
          SELECT Allpath.u1,connected.u2,Allpath.paths||connected.u2 AS paths  FROM Allpath,connected
          WHERE (
            Allpath.u2 = connected.u1
            AND
            connected.u2 <> ALL (Allpath.paths)
            AND 
            array_length(Allpath.paths,1) + 1 <= (SELECT COUNT(*) FROM friendlist))
        )

      )
    SELECT * FROM Allpath WHERE u2 = 1436
  ) AS p2
  ON p1.u2 = p2.u1
  WHERE array_length(array((SELECT unnest(p1.paths)) INTERSECT (SELECT unnest(p2.paths)))  ,1) = 1
  ) AS foo
;


--9--
WITH RECURSIVE
  Allpath(u1,u2,paths) AS
  (
    SELECT connected.u1 AS u1,connected.u2 AS u2, array[connected.u1,connected.u2] AS paths 
    FROM connected,userdetails 
    WHERE connected.u1 = 3552 
          AND connected.u1 <> connected.u2
          AND (SELECT place FROM userdetails WHERE userid = connected.u1) <> (SELECT place FROM userdetails WHERE userid = connected.u2)
    UNION
    (
      SELECT Allpath.u1,connected.u2,Allpath.paths||connected.u2 AS paths  FROM Allpath,connected
      WHERE (
        Allpath.u2 = connected.u1
        AND connected.u2 <> ALL (Allpath.paths)
        AND (SELECT place FROM userdetails WHERE userid = connected.u1) <> (SELECT place FROM userdetails WHERE userid = connected.u2) 
        AND array_length(Allpath.paths,1) + 1 <= (SELECT COUNT(*) FROM friendlist))
    )

  )
SELECT CASE WHEN count = 0 THEN count - 1 ELSE count END FROM 
(SELECT COUNT(*) FROM Allpath WHERE u2 = 321) AS foo
;

--10--

WITH RECURSIVE
  userblocks AS
  (
    SELECT u1,array_agg(u2) AS arr FROM undirectedblock 
    GROUP BY u1
  ),
  Allpath(u1,u2,paths) AS
  (
    SELECT connected.u1 AS u1,connected.u2 AS u2, array[connected.u1,connected.u2] AS paths 
    FROM connected
    WHERE connected.u1 = 3552 
          AND connected.u1 <> connected.u2
          AND NOT (connected.u2 = ANY (array(SELECT userblocks.arr FROM userblocks WHERE u1 = connected.u1) ))
    UNION
    (
      SELECT Allpath.u1,connected.u2,Allpath.paths||connected.u2 AS paths  FROM Allpath,connected
      WHERE (
        Allpath.u2 = connected.u1
        AND connected.u2 <> ALL (Allpath.paths)
        AND NOT (connected.u2 = ANY (array(SELECT userblocks.arr FROM userblocks WHERE u1 = ANY(Allpath.paths) ) ))
        AND array_length(Allpath.paths,1) + 1 <= (SELECT COUNT(*) FROM friendlist))
    )
  )

SELECT CASE WHEN count = 0 THEN count - 1 ELSE count END FROM 
(SELECT COUNT(*) FROM Allpath WHERE u2 = 321) AS foo
;



--CLEANUP--
DROP VIEW components;
DROP VIEW connected;
DROP VIEW undirectedblock;


