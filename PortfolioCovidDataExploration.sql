select * from coviddeaths
order by 3, 4

-- select data that we are going to use 
 select location, date, total_cases, new_cases, total_deaths, population 
 from coviddeaths
 order by date

-- Looking to total_cases vs total_deaths 
-- shows likelihood of dying if you contract covid in your country 

select location, date, total_cases,  total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
 from coviddeaths
 where location like '%States%'
 order by 1,4
 
 -- Looking to total cases vs population 
 -- shows what percentage of population got covid 
 
select location, date,population, total_cases ,(total_cases/population)*100 as InfectedPercentage
 from coviddeaths
 where location like '%States%'
 order by 1,4
 
 -- Looking at the countries with the highest infection rate compared to population 
 
 select location,population, max(total_cases)as HighestInfectioncount,max((total_cases/population))*100 as
 PopulationInfectedPercentage
 from coviddeaths
 -- where location like '%States%'
 group by location, population
 order by PopulationInfectedPercentage desc
 
 -- Showing countries with Highest Death count per population 
 
 select location, max(cast (total_deaths as int )) as totaldeathscount
 from coviddeaths
 -- where location like '%States%'
 where continent is not null
 group by location
 order by totaldeathscount desc
 
 -- Break things down by continent
 
 
 select continent, max(cast (total_deaths as int )) as totaldeathscount
 from coviddeaths
 -- where location like '%States%'
 where continent is not null
 group by continent
 order by 2 desc
 
 -- GLOBAL NUMBERS 
 select sum (new_cases) as total_cases, sum (cast(new_deaths as int)) as total_deaths, 
 sum(cast(new_deaths as int))/sum(new_cases)*100 as Deathpercentage
 from coviddeaths
 where continent is not null 
 order by 1,2
 
 -- looking at total population vs vaccinations 
 
 select coviddeaths.continent, coviddeaths.location, coviddeaths.date,coviddeaths.population,
 covidvaccinations.new_vaccinations, 
 sum (covidvaccinations.new_vaccinations) OVER ( partition by coviddeaths.location order by coviddeaths.location,
											  coviddeaths.date ) as Rollingpeoplevaccinated
--, (Rollingpeoplevaccinated/population)*100
 from coviddeaths 
 inner join covidvaccinations
 on coviddeaths.location = covidvaccinations.location
 and coviddeaths.date = covidvaccinations.date 
 where coviddeaths.continent is not null 
 order by 1,2,
 
 -- USE CTE 
 with popvsVacc ( contient, location, date, population,Rollingpeoplevaccinated, new_vaccinations )
 as
 (
 select coviddeaths.continent, coviddeaths.location, coviddeaths.date,coviddeaths.population,
 covidvaccinations.new_vaccinations, 
 sum (covidvaccinations.new_vaccinations) OVER ( partition by coviddeaths.location order by coviddeaths.location,
											  coviddeaths.date ) as Rollingpeoplevaccinated
--, (Rollingpeoplevaccinated/population)*100
 from coviddeaths 
 inner join covidvaccinations
 on coviddeaths.location = covidvaccinations.location
 and coviddeaths.date = covidvaccinations.date 
 where coviddeaths.continent is not null 
 -- order by 1,2,5
 )
 
select *, (Rollingpeoplevaccinated/population)*100 from popvsVacc

-- Temp table 
Drop table if exists PercentPopulationVaccineted
Create table PercentPopulationVaccineted
(
Continent varchar(255),
location varchar (255),
date varchar (255),
population numeric,
new_vaccinations numeric,
Rollingpeoplevaccinated numeric
)
alter table PercentPopulationVaccineted column date into type varchar 
insert into PercentPopulationVaccineted
select coviddeaths.continent, coviddeaths.location, coviddeaths.date,coviddeaths.population,
 covidvaccinations.new_vaccinations, 
 sum (covidvaccinations.new_vaccinations) OVER ( partition by coviddeaths.location order by coviddeaths.location,
											  coviddeaths.date ) as Rollingpeoplevaccinated
--, (Rollingpeoplevaccinated/population)*100
 from coviddeaths 
 inner join covidvaccinations
 on coviddeaths.location = covidvaccinations.location
 and coviddeaths.date = covidvaccinations.date 
 where coviddeaths.continent is not null 
 -- order by 1,2,5
 select *, (Rollingpeoplevaccinated/population)*100 from PercentPopulationVaccineted
