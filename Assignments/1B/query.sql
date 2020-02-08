

CREATE VIEW connected AS 
(
  SELECT userid1 AS u1, userid2 AS u2,least(userid2,userid1) AS lowlink FROM friendlist
  UNION
  SELECT userid2 AS u2, userid1 AS u1,least(userid2,userid1) AS lowlink FROM friendlist
  UNION
  SELECT userid AS u1,userid AS u2 ,userid AS lowlink from userdetails
)
;

--PREAMBLE--

SELECT count(*) FROM
(
  SELECT lowlink from
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
  AS components
  GROUP BY lowlink
)
AS allcomponenets
;


--2--
SELECT array_length(array_agg(DISTINCT u1),1) AS COUNT from
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
AS components
GROUP BY lowlink
ORDER BY array_length(array_agg(DISTINCT u1),1) ASC
;


--CLEANUP--
DROP VIEW connected;