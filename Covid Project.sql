--Select *
--From CovidDeath
--Order by 3,4

--Select *
--From PortfolioProject..CovidVaccination
----Order by select *

--Select location, date, total_cases, new_cases, total_deaths, population
--From CovidDeath
--where continent is not null 
--Order by 1, 2

--Select location, date,total_cases, population, 
--(cast(total_deaths as int) / total_cases)  As DeathPercentage ,
--total_cases / population As GotCovid
--From CovidDeath
--where continent is not null
--where location like '%den%' 
--Order by 1, 2

--Select location, population, Max(total_cases) As HighestInfectionCount, 
--(Max(total_cases) / population) As PercentPopulationInfected
--From CovidDeath
--where continent is not null
--group by location, population
--Order by PercentPopulationInfected Desc

--Select location, population, Max(cast(total_deaths as int)) As HighestDeathCount, 
--(Max(cast(total_deaths as int)) / population) As PercentPopulationDeath
--From CovidDeath	
--where continent is not null
--group by location, population
--Order by PercentPopulationDeath Desc

--Select continent, population, Max(cast(total_deaths as int)) As HighestDeathCount, 
--(Max(cast(total_deaths as int)) / population) As PercentPopulationDeath
--From CovidDeath	
--where continent is not null
--group by continent, population
--Order by PercentPopulationDeath Desc

--Select continent, Max(cast(total_deaths as int)) As HighestDeathCount
--From CovidDeath	
--where continent is not null
--group by continent
--Order by HighestDeathCount Desc

--Select  date, Sum(new_cases) As TotalNewCases, Sum(cast(new_deaths as int)) As TotallNewDeathes, Sum(cast(new_deaths as int)) / Sum(new_cases)
--From CovidDeath
--where continent is not null
--group by date
--having Sum(new_cases) > 0
--Order by 1, 2 Desc

--with PopvsVac (continent, Location, Date, Population, New_Vaccination, RollingPeopleVaccinated)
--as
--(
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM(convert(bigint, vac.new_vaccinations )) over (partition by dea.location order by dea.location, dea.date) As RollingPeopleVaccinated
--From CovidDeath dea
--Join CovidVaccination vac
--	On dea.location = vac.location and 
--	   dea.date = vac.date
--where dea.continent is not null
--)
--Select *, (RollingPeopleVaccinated/Population) 
--From PopvsVac

--drop table if exists #PercentPopulationVaccinated
--Create Table #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--location nvarchar(255),
--Date datetime, 
--Population numeric,
--New_vaccinations numeric, 
--RollingPeopleVaccinated numeric
--)
--Insert into #PercentPopulationVaccinated   
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM(convert(bigint, vac.new_vaccinations )) over (partition by dea.location order by dea.location, dea.date) As RollingPeopleVaccinated
--From CovidDeath dea
--Join CovidVaccination vac
--	On dea.location = vac.location and 
--	   dea.date = vac.date
--where dea.continent is not null

--Select *, (RollingPeopleVaccinated/Population) 
--From #PercentPopulationVaccinated 

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(bigint, vac.new_vaccinations )) over (partition by dea.location order by dea.location, dea.date) As RollingPeopleVaccinated
From CovidDeath dea
Join CovidVaccination vac
	On dea.location = vac.location and 
	   dea.date = vac.date
where dea.continent is not null

select *
from PercentPopulationVaccinated