Select *
From oscars

-- Change winner_nominee column from not null to null value

Alter Table PortfolioProjects..oscars
Alter Column [winner_nominee] nvarchar(255) null;

-- Change ceremony, year_film, and year_ceremony from "float, null" to null value
Alter Table PortfolioProjects..oscars
Alter Column [ceremony] number(255) null;

Alter Table PortfolioProjects..oscars
Alter Column [year_film] datetime null;

Alter Table PortfolioProjects..oscars
Alter Column [year_ceremony] datetime null;


-- In winner_nominee column, change '1' to winner and '0' to nominee
 
Select [winner_nominee],
	Case When [winner_nominee] = '1' Then 'winner'
	     When [winner_nominee] = '0' Then 'nominee'
	Else [winner_nominee] 
	End AS nominee_winner
 From PortfolioProjects..oscars

 -- First Oscars ceremony was on 1928.  Filter to see when the first minority received a nomination. 
 --(first minority nominee was in 1936)

Select *
From PortfolioProjects..oscars
where race != 'White'
Order by year_ceremony

-- Filter to see the year of first minority winner (1940)

Select *
From PortfolioProjects..oscars
where race != 'White' and winner_nominee = 1
Order by year_ceremony

-- Total number of winners (2,357 total winners)

Select 
	Count(*) 
From PortfolioProjects..oscars
where winner_nominee = '1'

-- Count the number of winners who were not white (113) 

Select 
	Count(*)  
From PortfolioProjects..oscars
Where winner_nominee = '1' and race != 'White' 
  and winner_nominee = '0' and race != 'White'  
	 

-- Verify by running the count for the number of winners who were  white (2,244)

Select 
	Count(*)  
From PortfolioProjects..oscars
Where winner_nominee = '1' and race = 'White'

-- Number of nominees who were not white

Select 
	Count(*)  
From PortfolioProjects..oscars
Where winner_nominee = '0' and race != 'White' 


-- Number of winners by race

Select 
	Count(case when race = 'Asian' and winner_nominee = '1' then 1 else null end) winners_asian,
	Count(case when race = 'Black' and winner_nominee = '1' then 1 else null end) winners_black,
	Count(case when race = 'Hispanic' and winner_nominee = '1' then 1 else null end) winners_hispanic,
	Count(case when race = 'White' and winner_nominee = '1' then 1 else null end) winners_white
From PortfolioProjects..oscars

-- Number of winners by race from the year 2000 and after

Select 
	Count(case when race = 'Asian' and winner_nominee = '1' then 1 else null end) winners_asian,
	Count(case when race = 'Black' and winner_nominee = '1' then 1 else null end) winners_black,
	Count(case when race = 'Hispanic' and winner_nominee = '1' then 1 else null end) winners_hispanic,
	Count(case when race = 'White' and winner_nominee = '1' then 1 else null end) winners_white
From PortfolioProjects..oscars
WHERE year_ceremony >= '2000'



