-- Preview data

Select *
From PortfolioProjects..nashville_housing

-- Standardize date format
Select sale_date_converted, CONVERT(date, [Sale Date])
From PortfolioProjects..nashville_housing

Update PortfolioProjects..nashville_housing
SET [Sale Date] = CONVERT(date, [Sale Date])

Alter Table nashville_housing
add sale_date_converted date;

update PortfolioProjects..nashville_housing
set sale_date_converted = CONVERT(date, [Sale Date])

-- Populate property address data

Select *
From PortfolioProjects..nashville_housing
--Where [Property Address] is null
Order By [Parcel ID]

Select a.[Parcel ID], a.[Property Address], b.[Parcel ID], b.[Property Address], isnull(a.[property address], b.[Property Address])
From PortfolioProjects..nashville_housing a
JOIN PortfolioProjects..nashville_housing b
on a.[Parcel ID] = b.[Parcel ID]
and a.[Unnamed: 0] <> b.[Unnamed: 0]
Where a.[Property Address] is null


Update a
Set [Property Address] = isnull(a.[property address], b.[Property Address])
From PortfolioProjects..nashville_housing a
JOIN PortfolioProjects..nashville_housing b
on a.[Parcel ID] = b.[Parcel ID]
and a.[Unnamed: 0] <> b.[Unnamed: 0]
Where a.[Property Address] is null


-- Change Yes and No to Y and N in Sold As Vacant Column

Select Distinct ([Sold As Vacant]), COUNT([Sold As Vacant])
From PortfolioProjects..nashville_housing
Group by [Sold As Vacant]
order by 2

Select [Sold As Vacant]
, Case When [Sold As Vacant] = 'Yes' then 'Y'
	   When [Sold As Vacant] = 'No' then 'N'
	   Else[Sold As Vacant]
	   End 
From PortfolioProjects..nashville_housing	

-- Remove duplicates

With row_num_cte AS(
Select *,
ROW_NUMBER() Over (
Partition by [Parcel ID], 
			 [Property Address],
			 [Sale Price],
			 [Sale Date],
			 [Legal Reference]
			 Order by 
				[Unnamed: 0]
				) row_num
From PortfolioProjects..nashville_housing
--Order By [Parcel ID]
)
Select *
From row_num_cte
Where row_num > 1
--Order by [Property Address]

-- Delete unused columns

Select *
From PortfolioProjects..nashville_housing

Alter Table PortfolioProjects..nashville_housing
Drop Column [Owner Address], [Tax District]