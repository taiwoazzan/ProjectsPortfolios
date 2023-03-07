Covid 19 Data Exploration 


--Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

SELECT * 
FROM PortfolioProject..CovidDeaths$
WHERE continent is not NULL
ORDER BY 3,4

SELECT * 
FROM PortfolioProject..CovidVaccinations$
WHERE continent is not NULL
ORDER BY 3,4


--Select Data used for starting point of analysis

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths$
WHERE continent is NOT NULL
ORDER BY 1,2 


--	Total Cases vs Total Deaths
--	Shows likelihood of dying if you contract covid in your country (specific for Nigeria)

SELECT location, date, total_cases, new_cases, total_cases, population, (total_cases/total_deaths) * 100 AS  PercentageDeathRate
FROM PortfolioProject..CovidDeaths$
WHERE location = 'Nigeria' AND continent is NOT NULL
ORDER BY 1,2

SELECT location, MAX(total_cases) AS maxTotalcases --to determine the maximum number of total cases detected over the cause the pandemic
FROM PortfolioProject..CovidDeaths$
WHERE location = 'Nigeria' AND continent is not null
GROUP BY location
ORDER BY 1,2

--	Total Cases vs Population
--	Shows what percentage of population infected with Covid

SELECT location, date, total_cases, new_cases, total_cases, population, (total_cases/population) * 100 AS PercentagePopulationInfected  
FROM PortfolioProject..CovidDeaths$
WHERE location = 'Nigeria' AND continent is not null
ORDER BY 1,2

 --Countries with Highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) AS TotalcasesInfected, MAX(total_cases/population) * 100 AS PercentagePopulationInfected  
FROM PortfolioProject..CovidDeaths$
WHERE continent is not NULL
GROUP BY location,population
ORDER BY TotalcasesInfected desc

--Countries with Highest Death Count per Population

Select Location, MAX(CONVERT(INT,Total_deaths)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
Where continent is not null 
Group by Location
order by TotalDeathCount desc

--	 BREAKING THINGS DOWN BY CONTINENT

--	 Showing contintents with the highest death count per population
SELECT continent, MAX(CAST(Total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null 
GROUP BY continent
ORDER BY TotalDeathCount desc

--	 Showing contintents with the highest Cases count per population
SELECT continent, MAX(total_cases) AS TotalCasesCount
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null 
GROUP BY continent
ORDER BY TotalCasesCount desc

-- GLOBAL NUMBERS

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null 
ORDER BY 1,2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.Location Order by dea.location, dea.Date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null 
ORDER BY 2,3


-- Using CTE to perform Calculation on Partition By in previous query
WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.Location Order by dea.location, dea.Date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null 
)
SELECT *, (RollingPeopleVaccinated/Population)*100 AS  PercentagePopulationVaccinated
FROM PopvsVac


-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date

SELECT *, (RollingPeopleVaccinated/Population)*100 AS PercentagePopulationVaccinated
FROM #PercentPopulationVaccinated




-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 AS PercentagePopulationVaccinated
From PopvsVac


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 


