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





--Queries within Queries

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





--Aggregate Functions

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
