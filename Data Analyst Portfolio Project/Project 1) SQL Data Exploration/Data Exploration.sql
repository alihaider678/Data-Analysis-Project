SELECT * FROM portfolio_projects.coviddeaths
order by 3,4;
SELECT * FROM portfolio_projects.covidvaccinations
order by 3,4; 

-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From portfolio_projects.coviddeaths
Where continent is not null 
order by 1,2; 

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From portfolio_projects.coviddeaths 
where location like '%Pakistan%'
and continent is not null 
order by 1,2;

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, population, total_cases, (total_cases/population)*100 as DeathPercentage
From portfolio_projects.coviddeaths 
where location like '%Pakistan%'
and continent is not null 
order by 1,2;

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, population, MAX(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
From portfolio_projects.coviddeaths 
Group By location, population
order by PercentPopulationInfected DESC;

-- Showing countries with Highest Death Count Per Population

Select Location, MAX(CAST(total_deaths as DECIMAL)) as TotaldeathCount
From portfolio_projects.coviddeaths 
where continent is not null
Group By location
order by TotaldeathCount DESC;

-- BREAKING THINGS DOWN BY CONTINENT
-- Showing contintents with the highest death count per population
Select continent, MAX(CAST(total_deaths as DECIMAL)) as TotaldeathCount
From portfolio_projects.coviddeaths 
where continent is not null
Group By continent
order by TotaldeathCount DESC;


-- GLOBAL NUMBERS

Select  SUM(new_cases) as total_cases, SUM(cast(new_deaths as DECIMAL)) as total_deaths, SUM(cast(new_deaths as DECIMAL))/SUM(new_cases)*100 as DeathPercentage
From portfolio_projects.coviddeaths 
where continent is not null 
-- group by date
order by 1,2;



-- Looking at Total Population Vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population
from portfolio_projects.coviddeaths dea
join portfolio_projects.covidvaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
order by 2,3;