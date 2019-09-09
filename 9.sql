-- Self join Tutorial

/* Use these tables:
stops(id, name)
route(num, company, pos, stop)
*/

--1) How many stops are in the database?
SELECT COUNT(name)
	FROM stops;

--2) Find the id value for the stop 'Craiglockhart'
SELECT id 
	FROM stops
	WHERE name = 'Craiglockhart';

--3) Give the id and the name for the stops on the '4' 'LRT' service.
SELECT stops.id, stops.name
	FROM stops
	INNER JOIN route
	ON stops.id = route.stop
	WHERE route.num = 4
	AND route.company = 'LRT';

/*4) The query shown gives the number of routes that visit either London Road (149) or 
Craiglockhart (53). Run the query and notice the two services that link these stops 
have a count of 2. 
Add a HAVING clause to restrict the output to these two routes. */

SELECT company, num, COUNT(*)
	FROM route 
	WHERE stop = 149
	OR stop =53
	GROUP BY company, num
	HAVING COUNT(*) >=2;

/*5) Execute the self join shown and observe that b.stop gives all the places you can get 
to from Craiglockhart, without changing routes. 
Change the query so that it shows the services from Craiglockhart to London Road. */
SELECT a.company, a.num, a.stop, b.stop
	FROM route a JOIN route b
	ON (a.company = b.company AND a.num = b.num)
	WHERE a.stop = 53 AND b.stop = 149;

/*6) The query shown is similar to the previous one, however by joining two copies of 
the stops table we can refer to stops by name rather than by number. 
Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. 
If you are tired of these places try 'Fairmilehead' against 'Tollcross' */
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
	WHERE stopa.name='Craiglockhart' AND stopb.name = 'London Road'

--7) Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')
SELECT a.company, a.num
	FROM route a JOIN route b 
	ON(a.company = b.company AND a.num = b.num)
	WHERE a.stop = 115 AND b.stop = 137
	GROUP BY a.company, a.num;

--8) Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'
SELECT a.company, a.num
	FROM route a JOIN route b ON
	(a.company = b.company AND a.num = b.num)
	JOIN stops stopa ON (a.stop = stopa.id)
	JOIN stops stopb ON (b.stop = stopb.id)
	WHERE stopa.name = 'Craiglockhart' AND stopb.name = 'Tollcross';

--9 )Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services.

select stops.name, route.company, route.num
from route
join stops on route.stop=stops.id
where route.company='LRT' and route.num in (10, 27, 4, 45, 47)
group by stops.name, route.company, route.num
order by num

--10)Find the routes involving two buses that can go from Craiglockhart to Lochend.
SELECT from_c.num, from_c.company, from_c.name, to_l.num, to_l.company FROM (SELECT DISTINCT stopd.name, c.company, c.num FROM route c
  JOIN route d ON (c.company=d.company AND c.num=d.num)
  JOIN stops stopc ON (c.stop=stopc.id)
  JOIN stops stopd ON (d.stop=stopd.id)
  WHERE stopc.name='Craiglockhart') AS from_c
JOIN (SELECT * FROM (SELECT DISTINCT stopb.name, a.company, a.num FROM route a
  JOIN route b ON (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
  WHERE stopa.name='Lochend') AS from_ca) to_l ON (from_c.name=to_l.name);