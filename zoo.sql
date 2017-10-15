--0 Simple Queries

1. SELECT population FROM world WHERE name = 'Germany';

2. SELECT name, population FROM world WHERE name IN ('Sweden', 'Norway', 'Denmark');

3. SELECT name, area FROM world WHERE area BETWEEN 200000 AND 250000;





--1 Pattern Matching Queries

--Show the name for countries that have a population of at least 200 million
1. SELECT name FROM world
    WHERE population >= 200000000;

--Give the name and GDP for countries with a population of at least 200 million
2. SELECT name, gdp FROM world
    WHERE population >= 200000000;

--Show the name and population in millions for countries of 'South America'
3. SELECT name, population / 1000000 FROM world
    WHERE continent = 'South America';

--Show the name and population for France, Germany, Italy
4. SELECT name, population FROM world
    WHERE name IN ('France', 'Germany', 'Italy');

--Show the countries which have a name that includes the word 'United'
5. SELECT name FROM world
    WHERE name LIKE 'United%';

/*Show the countries that are big by area or big by population.
Show name, population and area. BIG = area > 3M sqkm or pop > 250M*/
6. SELECT name, population, area FROM world
    WHERE area > 3000000 OR population > 250000000;

/*Show the countries that are big by area or big by population but not both.
Show name, population and area.*/
7. SELECT name, population, area FROM world
    WHERE area > 3000000 AND population < 250000000
      OR area < 3000000 AND population > 250000000;

--For South America show population in M and GDP in B both to 2 decimal places.
8. SELECT name, ROUND(population/1000000, 2), ROUND(gdp/1000000000, 2)
    FROM world WHERE continent = 'South America';

--Show per-capita GDP for the trillion dollar countries to the nearest $1000
9. SELECT name, ROUND(gdp/population,-3) FROM world
    WHERE gdp > 1000000000000;

--Show the name and capital where the name and the capital have the same number of characters.
10. SELECT name, capital FROM world
     WHERE LENGTH(name) = LENGTH(capital);

/*Show the name and the capital where the first letters of each match.
Don't include countries where the name and the capital are the same word.*/
11. SELECT name, capital FROM world
     WHERE LEFT(name,1) = LEFT(capital,1) AND name <> capital;

--Find the country that has all the vowels and no spaces in its name.
12. SELECT name FROM TABLE_NAME WHERE name LIKE '%a%' AND
     name  LIKE '%e%' AND name  LIKE '%i%' AND name  LIKE '%o%' AND
     name  LIKE '%u%' AND name NOT LIKE '% %';





--2 Queries within Queries

--List each country name where the population is larger than that of 'Russia'.
1. SELECT name FROM world WHERE population >
     (SELECT population FROM world WHERE name = 'Russia');

--Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.
2. SELECT name FROM world WHERE continent = 'Europe' AND gdp/population >
    (SELECT gdp/population FROM world WHERE name = 'United Kingdom');

/*List the name and continent of countries in the continents containing either
Argentina or Australia. Order by name of the country.*/
3. SELECT name, continent FROM world WHERE continent IN
    (SELECT continent FROM world WHERE name IN ('Argentina', 'Australia'))
    ORDER BY name;

/*Which country has a population that is more than Canada but less than Poland?
Show the name and the population.*/
4. SELECT name, population FROM world WHERE population
    > (SELECT population FROM world WHERE name = 'Canada') AND population
    < (SELECT population FROM world WHERE name = 'Poland');

/*Show the name and the population of each country in Europe.
Show the population as a percentage of the population of Germany.*/
5. SELECT name, CONCAT(ROUND(100*population/(SELECT population FROM world WHERE name='Germany')),'%')
    FROM world WHERE continent='Europe';

--Which countries have a GDP greater than every country in Europe?
6. SELECT name FROM world WHERE gdp >= all(SELECT gdp FROM world
    WHERE continent = 'Europe' AND gdp > 0) AND contient != 'Europe';

--Find the largest country area in each continent, show continent, name and area
7. SELECT continent, name, area FROM world x
    WHERE area >= ALL (SELECT area FROM world y
    WHERE y.continent=x.continent AND area>0)

--List each continent and the name of country that comes first alphabetically
8. SELECT continent, name FROM world x WHERE x.name <= ALL (
    SELECT name FROM world y WHERE x.continent=y.continent);





--3 Aggregate Functions

--Show the total population of the world
1.  SELECT SUM(population) FROM world;

--List all continents, once each
2. SELECT DISTINCT(continent) FROM world;

--Give the total GDP of Africa
3. SELECT SUM(GDP) FROM world WHERE continent = 'Africa';

--Show how many countries have area of at least 1000000
4. SELECT COUNT(name) FROM world WHERE area >= 1000000;

--What is the total population of ('Estonia', 'Latvia', 'Lithuania')
5. SELECT SUM(population) FROM world WHERE name IN ('Estonia', 'Latvia', 'Lithuania');

--For each continent show the continent and number of countries.
6. SELECT continent, COUNT(name) FROM world
    WHERE population >= 10000000 GROUP BY continent;

--List the continents that have a total population of at least 100 million.
7. SELECT continent FROM world GROUP BY continent
    HAVING SUM(population) >= 10000000;





--4 Joining Tables

--Show matchid and player name for all goals scored by Germany
1. SELECT matchid, player FROM goal
    WHERE teamid = 'GER'

--Show id, stadium, team1, team2 for game 1012
2. SELECT id,stadium,team1,team2
    FROM game WHERE game.id = 1012

--Show player, teamed, stadium and made for every German goal.
3. SELECT player,teamid, stadium, mdate FROM game
    JOIN goal ON (game.id=goal.matchid) WHERE teamid='GER'

--Show team1, team2, player for every goal from a player named Mario.
4. SELECT team1, team2, player FROM game JOIN goal
    ON game.id=goal.matchid WHERE player LIKE 'Mario%'

--Show player, teamid, coach, gtime for all goals scored in first 10 minutes.
5. SELECT player, teamid, coach, gtime FROM eteam
    JOIN goal ON teamid=eteam.id WHERE gtime <= 10

--List dates and name of team in which ‘Fernando Santos’ was the team1 coach.
6. SELECT mdate, teamname FROM game JOIN eteam
    ON game.team1 = eteam.id WHERE coach = 'Fernando Santos'

--List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
7. SELECT player FROM goal JOIN game
    ON goal.matchid = game.id WHERE stadium = 'National Stadium, Warsaw'

--Show the name of all players who scored goal against Germany.
8. SELECT DISTINCT player FROM game JOIN goal ON goal.matchid = game.id
        WHERE (team1='GER' or team2='GER') AND goal.teamid <> 'GER'

--Show teamname and total number of goals scored.
9. SELECT teamname, COUNT(player) goals_scored
    FROM eteam JOIN goal ON eteam.id = goal.teamid GROUP BY teamname

--Show stadium name and total number of goals scored.
10. Select stadium, COUNT(player) goals_scored FROM game
     JOIN goal ON game.id = goal.matchid GROUP BY stadium





--5 Null Statements

--List the teachers who have NULL for their department
1. SELECT name FROM teacher WHERE dept IS NULL

--Use inner join to miss teachers with no department and vice versa.
2. SELECT teacher.name, dept.name FROM teacher
    INNER JOIN dept ON (teacher.dept=dept.id)

--Use a different JOIN so that all teachers are listed
3. SELECT teacher.name, dept.name FROM teacher
    LEFT JOIN dept ON teacher.dept = dept.id;

--Use a different join so that all departments are listed.
4. SELECT teacher.name, dept.name FROM teacher
    RIGHT JOIN dept ON teacher.dept = dept.id;

--Show teacher name and mobile phone number or COALESCE
5. SELECT name, COALESCE(mobile, '07986 444 2266') FROM teacher

--Use coalesce for the LEFT JOIN from 3
6. SELECT teacher.name AS teacher, COALESCE(dept.name,'None') AS department
    FROM teacher LEFT JOIN dept ON (teacher.dept=dept.id)

--Use COUNT to show the number of teachers and the number of mobile phones
7. SELECT COUNT(name), COUNT(mobile) FROM teacher

--Use COUNT and GROUP BY dept.name to show each department and the number of staff.
8. SELECT dept.name, COUNT(teacher.name) FROM teacher RIGHT JOIN dept
    ON teacher.dept = dept.id GROUP BY dept.name

/*Use CASE to show the name of each teacher followed by 'Sci' if the teacher
is in dept 1 or 2 and 'Art' otherwise*/
9. SELECT teacher.name CASE
    WHEN dept.id=1 THEN ‘Sci’ WHEN dept.id=2 THEN ’Sci’ ELSE ‘ART’ END
    FROM teacher LEFT JOIN dept ON (teacher.dept = dept.id)

/*Use CASE to show the name of each teacher followed by ‘Sci’ if the the teacher
is in dept 1 or 2 show ‘Art’ if the dept is 3 and ‘None’ otherwise*/
10. SELECT teacher.name, CASE
    WHEN dept.id=1 THEN 'Sci' WHEN dept.id=2 THEN 'Sci' WHEN dept.id=3 THEN 'Art'
    ELSE 'None' END FROM teacher LEFT JOIN dept ON (teacher.dept=dept.id)





--6 Self Joins

--How many stops are in the data base
1. SELECT COUNT(stops.id) FROM stops

--Find the ID value for the stop ‘Craiglockhart’
2. SELECT id FROM stops WHERE name = ‘Craiglockhart’

--Give the ID and the name for the stops on the ‘4’ ‘LRT’ service
3. SELECT id, name FROM stops JOIN route ON id=stop 
    WHERE num = '4' AND company = 'LRT'  
