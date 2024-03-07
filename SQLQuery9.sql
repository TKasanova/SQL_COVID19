

SELECT
       *
FROM  dbo.CovidVaccinations
WHERE 
      location ='Azerbaijan';

SELECT 
      SUM(TRY_CAST(total_vaccinations AS INT)) AS totalVaccinations
FROM  
      dbo.CovidVaccinations
WHERE
       location = 'Africa';


Select *
From dbo.CovidDeaths
Where continent is not null  OR total_deaths is not null 
order by 3,4;


GO
SELECT *
FROM dbo.CovidDeaths
WHERE location = 'Azerbaijan';
GO
-- Select Data that we are going to be starting with

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM dbo.CovidDeaths
Where continent is not null 
ORDER BY 4 DESC,6
;

-- Looking at Total Cases vs Total Deaths
SELECT 
       location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM 
       dbo.CovidDeaths
WHERE location LIKE '%ALGERIA%'
               AND continent IS NOT NULL
ORDER BY 5 ,2
;


SELECT 
       location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage, MAX((total_deaths/total_cases) * 100 ) OVER() AS MAXdeathpercentage
FROM 
       dbo.CovidDeaths
WHERE 
     location = 'ALGERIA'
ORDER BY 1 ,2
;

WITH MaxCte AS (SELECT 
location, date, total_cases,total_deaths,(total_deaths/total_cases) * 100 as MAXDeathPercentage,
MAX((total_deaths/total_cases) * 100) OVER() AS Max_Ratio
FROM
	dbo.CovidDeaths
WHERE location = 'ALGERIA')
SELECT *
FROM
	MaxCte
WHERE
	MAXDeathPercentage = Max_Ratio;



-- Total Cases vs Population
-- Shows what percentage of population infected with Covid
SELECT 
       location, date, population ,total_cases, (total_cases/population) * 100  AS PercentPopulationInfected
FROM 
       dbo.CovidDeaths
-- WHERE location LIKE ' '
ORDER BY 5 DESC ,1
;
-- Countries with Highest Infection Rate compared to Population
SELECT 
       location, population ,MAX(total_cases) AS Highest_Infection , MAX(total_cases/population)*100 AS Percent_Infection_Populations 
FROM 
       dbo.CovidDeaths
GROUP BY Location, Population
-- WHERE location ...
ORDER BY Percent_Infection_Populations  desc;

-- Countries with Highest Death Count per Population
SELECT 
       location, population, MAX(cast(Total_deaths as int)) AS Highest_DeathCount
FROM 
       dbo.CovidDeaths
Where continent is not null 
GROUP BY Location, population
ORDER BY Highest_DeathCount desc;

-- Showing contitents with the highest death count per population
SELECT 
       continent, population, MAX(cast(Total_deaths as int)) AS Highest_DeathCount, 
FROM 
       dbo.CovidDeaths
-- WHERE location ...
Where continent is not null 
GROUP BY continent, population
ORDER BY Highest_DeathCount desc;


SELECT continent, SUM(CAST(Total_Death_Count AS int)) AS total_deaths_for_continent
FROM (
    SELECT continent, MAX(Total_deaths) as Total_Death_Count
    FROM dbo.CovidDeaths
    WHERE continent IS not NULL
    GROUP BY continent

    UNION

    SELECT location AS continent, MAX(Total_deaths) as Total_Death_Count
    FROM dbo.CovidDeaths
    WHERE continent IS null
    GROUP BY location
) AS subquery
GROUP BY continent
ORDER BY total_deaths_for_continent DESC;

--Second Method 
WITH AggregatedDeaths AS (
    SELECT continent, MAX(Total_deaths) as Total_Death_Count
    FROM dbo.CovidDeaths
    WHERE continent IS NOT NULL
    GROUP BY continent

    UNION

    SELECT location AS continent, MAX(Total_deaths) as Total_Death_Count
    FROM dbo.CovidDeaths
    WHERE continent IS NULL
    GROUP BY location)
SELECT continent, SUM(CAST(Total_Death_Count AS int)) AS total_deaths_for_continent
FROM AggregatedDeaths
GROUP BY continent
ORDER BY total_deaths_for_continent DESC;

--3 METHOD

WITH combined_results AS (
  SELECT location ,continent ,MAX(Total_deaths) as Total_Death_Count
  FROM dbo.CovidDeaths
  WHERE continent IS  NULL
  GROUP BY location, continent)
SELECT c.location,r.continent ,SUM(COALESCE(r.Total_Death_Count, 0)) AS total_death_for_continent
FROM combined_results c
LEFT JOIN combined_results r ON c.location = r.continent
GROUP BY c.location , r.continent
ORDER BY total_death_for_continent DESC;

-- GLOBAL NUMBERS
SELECT SUM(new_cases) as Total_CASES, SUM(CAST(new_deaths as int)) AS TOTAL_DEATH, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM dbo.CovidDeaths
WHERE  continent is not null
ORDER BY 1,2;
  -- husyin 306 alex85