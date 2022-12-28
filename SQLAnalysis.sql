--Selecting columns in table
SELECT Location, date, total_cases,new_cases,total_deaths,population
FRom [projectp].[dbo].[CovidDeaths$]
order by 1,2

--Total cases vs total deaths in united kingdom
SELECT location,(total_deaths/ total_cases) * 100 AS DeathPercentage
FROM [projectp].[dbo].[CovidDeaths$]
WHERE location like '%Kingdom%'


--Total cases vs total deaths in India
SELECT location,(total_deaths/ total_cases) * 100 AS DeathPercentage
FROM [projectp].[dbo].[CovidDeaths$]
WHERE location like 'India'

--percentage of population who got covid 
select location,date,total_cases, (total_cases/population)*100 as DeathPercentage
FROM [projectp].[dbo].[CovidDeaths$]


--percentage of population who got covid in india on the most recent date
select location,date,total_cases, (total_cases/population)*100 as DeathPercentage
FROM [projectp].[dbo].[CovidDeaths$]
WHERE date = (SELECT MAX(date) FROM [projectp].[dbo].[CovidDeaths$]) 
AND location = 'India'

--Looking at countries with highest infection rate compared to population.
SELECT location,population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 AS percentagepopulationinfected
FROM [projectp].[dbo].[CovidDeaths$]
GROUP BY population,location
ORDER BY percentagepopulationinfected desc

--countries with highest death count per population
SELECT location, Max(CAST(total_deaths as int)) AS totaldeathcount
FROM [projectp].[dbo].[CovidDeaths$]
where continent is not null
GROUP by location
order by totaldeathcount desc

--let us see the same based on the continent

SELECT continent, max(cast(total_deaths as int)) as totaldeathcount
FROM [projectp].[dbo].[CovidDeaths$]
WHERE continent is not null
GROUP by continent
order by totaldeathcount desc

--- joining on location and date.
SELECT * FROM CovidDeaths$ AS CD
JOIN CovidVaccinations$ AS CV
ON CD.location = CV.location
and CD.date = CV.date 

-- Looking at total population vs vaccinations
SELECT cd.continent, cd.location, cd.date,cd.population, cv.new_vaccinations,
sum(convert(int,cv.new_vaccinations)) over (partition by cd.location_order by cd.location, cd.date)
FROM CovidDeaths$ AS cd
JOIN CovidVaccinations$ AS cv
ON cd.location = cv.location
and cd.date = cv.date
where cd.continent is not null
order by 2,3

