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
     name  LIKE '%u%' AND name NOT LIKE '% %'
