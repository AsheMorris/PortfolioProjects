SELECT *
FROM CovidDeaths
Order By 3,4

SELECT *
FROM CovidVaccinations
Order By 3,4

--Select *
--From PortfolioProjects..CovidDeaths
--Order By 3,4

--Select data that I am going to be using

Select location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1,2

--Looking at the total cases vs total deaths
--Shows per country, the likelihood of dying from Covid if contracted

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM CovidDeaths
ORDER BY 1,2

--Shows the likelihood of dying from Covid if contracted (US only)
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM CovidDeaths
WHERE location like '%states%'

-- Looking at total cases vs population
Select location, date, total_cases, population, (total_cases/population)*100 as case_percentage
FROM CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2

--Looking at countries with the highest infection rates compared to population

Select location, population, Max(total_cases) as highest_infection_count, Max((total_cases/ population))*100 as infection_rate_percent
FROM CovidDeaths
--WHERE location like '%states%'
GROUP BY location, population
ORDER BY infection_rate_percent DESC 


--Countries with highest death count per population

Select location, Max(cast(total_deaths as int)) as total_death_count
FROM CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY location
ORDER BY total_death_count DESC

-- Highest deaths by population by continent

Select continent, Max(cast(total_deaths as int)) as total_death_count
FROM CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY continent
ORDER BY total_death_count DESC

-- A global look at the total number & percentage of deaths vs. total cases

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/ SUM(new_cases) * 100 as death_percentage
FROM CovidDeaths
WHERE continent is not null
ORDER BY 1,2

--Look at a join of deaths and population tables
SELECT *
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is not null
Order by 1,2,3


--Looking at Total Population vs, Vaccination

-- Use CTE

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPplVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int, vac.new_vaccinations)) OVER (Partition BY dea.location order by dea.location, dea.date) as RollingPplVaccinated
--, (RollingPplVaccinated/population) *100
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is not null
--Order by 2,3

Select *, (RollingPplVaccinated/population) * 100 as RollingPercentageVac
From PopvsVac

--Temp Table

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
    continent nvarchar (255),
    location nvarchar (255),
    date datetime,
    population numeric,
    new_vacciations numeric,
    RollingPplVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int, vac.new_vaccinations)) OVER (Partition BY dea.location order by dea.location, dea.date) as RollingPplVaccinated
--, (RollingPplVaccinated/population) *100
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is not null
--Order by 2,3

Select *, (RollingPplVaccinated/population) * 100 as RollingPercentageVac
From #PercentPopulationVaccinated


-- Creating View to store data for later visualization

Create View PercentageTotalVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int, vac.new_vaccinations)) OVER (Partition BY dea.location order by dea.location, dea.date) as RollingPplVaccinated
--, (RollingPplVaccinated/population) *100
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is not null
--Order by 2,3