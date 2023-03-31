select *
from Projects.dbo.CovidDeaths$ 
where continent is not null
order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from Projects.dbo.CovidDeaths$ 
where continent is not null
order by 1,2

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from Projects.dbo.CovidDeaths$ 
where location like '%India%'
and continent is not null
order by 1,2

--Shows what percentage of population got covid
select location,date,population,total_cases,(total_cases/population)*100 as populationInfectedpercent
from Projects.dbo.CovidDeaths$ 
--where location like '%India%'
order by 1,2

--looking at countries with highest infection rates compared to the population
select location,population,MAX(total_cases) as HighestInfectioncount,MAX((total_cases/population))*100 as populationInfectedpercent
from Projects.dbo.CovidDeaths$ 
group by location,population
--where location like '%India%'
order by populationInfectedpercent desc

--showing countries with highest death count per population
select location,MAX(cast(total_deaths as int)) as TotalDeathCount 
from Projects.dbo.CovidDeaths$ 
--where location like '%India%'
where continent is not null
group by location
order by TotalDeathCount  desc

--let's break down things by continent

select continent,MAX(cast(total_deaths as int)) as TotalDeathCount 
from Projects.dbo.CovidDeaths$ 
--where location like '%India%'
where continent is  not null
group by continent
order by TotalDeathCount  desc

--Showing continent with highest death counts per population
select continent,MAX(cast(total_deaths as int)) as TotalDeathCount 
from Projects.dbo.CovidDeaths$ 
--where location like '%India%'
where continent is  not null
group by continent
order by TotalDeathCount  desc



--GLOBAL NUMBERS
select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as deathpercentage
from Projects.dbo.CovidDeaths$ 
--where location like '%India%'
where continent is not null
--group by date
order by 1,2


--Looking at total population vs vaccination
select CovidDeaths$.continent,CovidDeaths$.location,CovidDeaths$.date,CovidDeaths$.population,CovidVaccinations$.new_vaccinations,
     SUM(convert(int,CovidVaccinations$.new_vaccinations)) over (partition by CovidDeaths$.location  order by CovidDeaths$.location,CovidDeaths$.date) as RollingPeopleCount--(RollingPeopleCount/CovidDeaths$.population)
from Projects.dbo.CovidDeaths$ 
join Projects.dbo.CovidVaccinations$ 
on CovidDeaths$ .location=CovidVaccinations$.location
and CovidDeaths$.date=CovidVaccinations$.date
where CovidDeaths$.continent is not null
order by 2,3



--Use CTE

with popvsvac(continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
select CovidDeaths$.continent,CovidDeaths$.location,CovidDeaths$.date,CovidDeaths$.population,CovidVaccinations$.new_vaccinations,
     SUM(convert(int,CovidVaccinations$.new_vaccinations)) over (partition by CovidDeaths$.location  order by CovidDeaths$.location,CovidDeaths$.date) as RollingPeopleVaccinated
	 --(RollingPeopleVaccinated/CovidDeaths$.population)*100
from Projects.dbo.CovidDeaths$ 
join Projects.dbo.CovidVaccinations$ 
on CovidDeaths$ .location=CovidVaccinations$.location
and CovidDeaths$.date=CovidVaccinations$.date
where CovidDeaths$.continent is not null
--order by 2,3
)
select * ,(RollingPeopleVaccinated/population)*100
from popvsvac

--Temp table


Drop table if exists #percentpopulationvaccinated
Create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric)

Insert into #percentpopulationvaccinated
select CovidDeaths$.continent,CovidDeaths$.location,CovidDeaths$.date,CovidDeaths$.population,CovidVaccinations$.new_vaccinations,
     SUM(convert(int,CovidVaccinations$.new_vaccinations)) over (partition by CovidDeaths$.location  order by CovidDeaths$.location,CovidDeaths$.date) as RollingPeopleVaccinated
	 --(RollingPeopleVaccinated/CovidDeaths$.population)*100
from Projects.dbo.CovidDeaths$ 
join Projects.dbo.CovidVaccinations$ 
on CovidDeaths$ .location=CovidVaccinations$.location
and CovidDeaths$.date=CovidVaccinations$.date
--where CovidDeaths$.continent is not null
--order by 2,3

select * ,(RollingPeopleVaccinated/population)*100
from #percentpopulationvaccinated



--Creating view to store data for visualization

Create View percentpopulationvaccinated as
select CovidDeaths$.continent,CovidDeaths$.location,CovidDeaths$.date,CovidDeaths$.population,CovidVaccinations$.new_vaccinations,
     SUM(convert(int,CovidVaccinations$.new_vaccinations)) over (partition by CovidDeaths$.location  order by CovidDeaths$.location,CovidDeaths$.date) as RollingPeopleVaccinated
	 --(RollingPeopleVaccinated/CovidDeaths$.population)*100
from Projects.dbo.CovidDeaths$ 
join Projects.dbo.CovidVaccinations$ 
on CovidDeaths$ .location=CovidVaccinations$.location
and CovidDeaths$.date=CovidVaccinations$.date
where CovidDeaths$.continent is not null
--order by 2,3

select * from select *
from Projects.dbo.CovidDeaths$ 
where continent is not null
order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from Projects.dbo.CovidDeaths$ 
where continent is not null
order by 1,2

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from Projects.dbo.CovidDeaths$ 
where location like '%India%'
and continent is not null
order by 1,2

--Shows what percentage of population got covid
select location,date,population,total_cases,(total_cases/population)*100 as populationInfectedpercent
from Projects.dbo.CovidDeaths$ 
--where location like '%India%'
order by 1,2

--looking at countries with highest infection rates compared to the population
select location,population,MAX(total_cases) as HighestInfectioncount,MAX((total_cases/population))*100 as populationInfectedpercent
from Projects.dbo.CovidDeaths$ 
group by location,population
--where location like '%India%'
order by populationInfectedpercent desc

--showing countries with highest death count per population
select location,MAX(cast(total_deaths as int)) as TotalDeathCount 
from Projects.dbo.CovidDeaths$ 
--where location like '%India%'
where continent is not null
group by location
order by TotalDeathCount  desc

--let's break down things by continent

select continent,MAX(cast(total_deaths as int)) as TotalDeathCount 
from Projects.dbo.CovidDeaths$ 
--where location like '%India%'
where continent is  not null
group by continent
order by TotalDeathCount  desc

--Showing continent with highest death counts per population
select continent,MAX(cast(total_deaths as int)) as TotalDeathCount 
from Projects.dbo.CovidDeaths$ 
--where location like '%India%'
where continent is  not null
group by continent
order by TotalDeathCount  desc



--GLOBAL NUMBERS
select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as deathpercentage
from Projects.dbo.CovidDeaths$ 
--where location like '%India%'
where continent is not null
--group by date
order by 1,2


--Looking at total population vs vaccination
select CovidDeaths$.continent,CovidDeaths$.location,CovidDeaths$.date,CovidDeaths$.population,CovidVaccinations$.new_vaccinations,
     SUM(convert(int,CovidVaccinations$.new_vaccinations)) over (partition by CovidDeaths$.location  order by CovidDeaths$.location,CovidDeaths$.date) as RollingPeopleCount,
	 --(RollingPeopleCount/CovidDeaths$.population
from Projects.dbo.CovidDeaths$ 
join Projects.dbo.CovidVaccinations$ 
on CovidDeaths$ .location=CovidVaccinations$.location
and CovidDeaths$.date=CovidVaccinations$.date
where CovidDeaths$.continent is not null
order by 2,3



--Use CTE

with popvsvac(continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
select CovidDeaths$.continent,CovidDeaths$.location,CovidDeaths$.date,CovidDeaths$.population,CovidVaccinations$.new_vaccinations,
     SUM(convert(int,CovidVaccinations$.new_vaccinations)) over (partition by CovidDeaths$.location  order by CovidDeaths$.location,CovidDeaths$.date) as RollingPeopleVaccinated
	 --(RollingPeopleVaccinated/CovidDeaths$.population)*100
from Projects.dbo.CovidDeaths$ 
join Projects.dbo.CovidVaccinations$ 
on CovidDeaths$ .location=CovidVaccinations$.location
and CovidDeaths$.date=CovidVaccinations$.date
where CovidDeaths$.continent is not null
--order by 2,3
)
select * ,(RollingPeopleVaccinated/population)*100
from popvsvac

--Temp table


Drop table if exists #percentpopulationvaccinated
Create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric)

Insert into #percentpopulationvaccinated
select CovidDeaths$.continent,CovidDeaths$.location,CovidDeaths$.date,CovidDeaths$.population,CovidVaccinations$.new_vaccinations,
     SUM(convert(int,CovidVaccinations$.new_vaccinations)) over (partition by CovidDeaths$.location  order by CovidDeaths$.location,CovidDeaths$.date) as RollingPeopleVaccinated
	 --(RollingPeopleVaccinated/CovidDeaths$.population)*100
from Projects.dbo.CovidDeaths$ 
join Projects.dbo.CovidVaccinations$ 
on CovidDeaths$ .location=CovidVaccinations$.location
and CovidDeaths$.date=CovidVaccinations$.date
--where CovidDeaths$.continent is not null
--order by 2,3

select * ,(RollingPeopleVaccinated/population)*100
from #percentpopulationvaccinated



--Creating view to store data for visualization

Create View populationpercentvaccinated as
select CovidDeaths$.continent,CovidDeaths$.location,CovidDeaths$.date,CovidDeaths$.population,CovidVaccinations$.new_vaccinations,
     SUM(convert(int,CovidVaccinations$.new_vaccinations)) over (partition by CovidDeaths$.location  order by CovidDeaths$.location,CovidDeaths$.date) as RollingPeopleVaccinated
	 --(RollingPeopleVaccinated/CovidDeaths$.population)*100
from Projects.dbo.CovidDeaths$ 
join Projects.dbo.CovidVaccinations$ 
on CovidDeaths$ .location=CovidVaccinations$.location
and CovidDeaths$.date=CovidVaccinations$.date
where CovidDeaths$.continent is not null
--order by 2,3

select * from  percentpopulationvaccinated