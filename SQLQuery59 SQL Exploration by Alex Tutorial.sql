----TOTAL CASES VS TOTAL DEATHS

--SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage
--FROM CovidDeaths
--WHERE location LIKE '%Nigeria%'
--ORDER BY 1,2

------TOTAL CASES VS POPULATION

--SELECT location,date,population,total_cases,(total_cases/population)*100 AS InfectedPercentage
--FROM CovidDeaths
--WHERE location LIKE '%Nigeria%'
--ORDER BY 1,2

------COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION

--SELECT location,population,MAX(total_cases) AS HighestInfectionCount,Max(total_cases/population)*100 AS MaxInfectedPercentage
--FROM CovidDeaths
--GROUP BY location,population
--ORDER BY MaxInfectedPercentage DESC

--SELECT location,MAX(CAST(total_deaths AS int)) AS HighestDeathCount
--FROM CovidDeaths
--WHERE continent IS NOT NULL
--GROUP BY location
--ORDER BY HighestDeathCount DESC

-------GLOBAL NUMBERS

--SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths as int)) AS total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
--FROM CovidDeaths
--WHERE continent is NOT NULL
--GROUP BY date
--ORDER BY 1,2

--

--SELECT CD.continent,CD.location,CD.date,CD.population,CV.new_vaccinations
--FROM CovidDeaths AS CD
--Inner Join CovidVaccinations AS CV
--ON CD.location=CV.location
--AND CD.date=CV.date
--WHERE CD.continent IS NOT NULL
--ORDER BY 2,3

-------TOTAL POPULATION VS VACCINATIONS

--SELECT CD.continent,CD.location,CD.date,CD.population,CV.new_vaccinations,SUM(CAST(CV.new_vaccinations AS bigint)) 
-- OVER (PARTITION BY CD.location ORDER BY CD.location,CD.date) AS RollingPeopleVaccinated
--FROM CovidDeaths AS CD
--Inner Join CovidVaccinations AS CV
--ON CD.location=CV.location
--AND CD.date=CV.date
--WHERE CD.continent IS NOT NULL
--ORDER BY 2,3

----USING CTE

--WITH PopVsVac(continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
--AS
--(
--SELECT CD.continent,CD.location,CD.date,CD.population,CV.new_vaccinations,SUM(CAST(CV.new_vaccinations AS bigint)) 
-- OVER (PARTITION BY CD.location ORDER BY CD.location,CD.date) AS RollingPeopleVaccinated
--FROM CovidDeaths AS CD
--Inner Join CovidVaccinations AS CV
--ON CD.location=CV.location
--AND CD.date=CV.date
--WHERE CD.continent IS NOT NULL
----ORDER BY 2,3
--)
--SELECT *,(RollingPeopleVaccinated/population)*100
--FROM PopVsVac

------USING TEMP TABLE

--DROP TABLE IF EXISTS #PercentPopulationVaccinated
--CREATE TABLE #PercentPopulationVaccinated
--(
--continent nvarchar (255),
--location nvarchar(255),
--data datetime,
--population numeric,
--new_vaccination numeric,
--RollingPeopleVaccinated numeric
--)
--INSERT INTO #PercentPopulationVaccinated
--SELECT CD.continent,CD.location,CD.date,CD.population,CV.new_vaccinations,SUM(CAST(CV.new_vaccinations AS bigint)) 
-- OVER (PARTITION BY CD.location ORDER BY CD.location,CD.date) AS RollingPeopleVaccinated
--FROM CovidDeaths AS CD
--Inner Join CovidVaccinations AS CV
--ON CD.location=CV.location
--AND CD.date=CV.date
--WHERE CD.continent IS NOT NULL
----ORDER BY 2,3
--SELECT *,(RollingPeopleVaccinated/population)*100
--FROM #PercentPopulationVaccinated

----CREATING VIEWS TO STORE DATA FOR LATER VISUALIZATIONS

CREATE VIEW PercentagePopulationVaccinated AS
SELECT CD.continent,CD.location,CD.date,CD.population,CV.new_vaccinations,SUM(CAST(CV.new_vaccinations AS bigint)) 
 OVER (PARTITION BY CD.location ORDER BY CD.location,CD.date) AS RollingPeopleVaccinated
FROM CovidDeaths AS CD
Inner Join CovidVaccinations AS CV
ON CD.location=CV.location
AND CD.date=CV.date
WHERE CD.continent IS NOT NULL
------ORDER BY 2,3