--SELECT * FROM CovidVaccinations ORDER BY 3,4
SELECT * FROM CovidDeaths WHERE continent IS NOT NULL ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1,2


--Looking at the total cases vs total deaths
--This shows the likelihood of dying from covid in any country e.g Nigeria
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
FROM CovidDeaths
WHERE location LIKE '%Nigeria%'
ORDER BY 1,2

--Looking at the total cases vs population
--This shows the number that contracted the covid-19 virus in any country e.g Nigeria
SELECT location, date, total_cases, population, (total_cases/population)*100 AS Infection_Percentage
FROM CovidDeaths
WHERE location LIKE '%Nigeria%'
ORDER BY 1,2

--Looking at Countries with the highest infection rate compared with the Population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount,  MAX((total_cases/population)*100) AS Infection_Percentage
FROM CovidDeaths
GROUP BY location, population
ORDER BY Infection_Percentage DESC

--Showing countries with the highest death count per population
SELECT location, population, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL --This removes the continents themselves
GROUP BY location, population
ORDER BY TotalDeathCount DESC

--LETS'S BREAK THIS DOWN BY CONTINENT
SELECT continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null 
GROUP BY continent
ORDER BY TotalDeathCount desc

--Global Numbers
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



