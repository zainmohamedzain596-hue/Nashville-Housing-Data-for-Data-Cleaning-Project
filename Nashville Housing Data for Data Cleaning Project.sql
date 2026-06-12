

__ Cleaning Data in SQL Queries



Select *
From [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)]

Select *
From [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)]
--where PropertyAddress is null
order by ParcelID

Select A.ParcelID,A.PropertyAddress,B.ParcelID,B.PropertyAddress,ISNULL (A.PropertyAddress,B.PropertyAddress)
From [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)] AS A
JOIN [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)]as B	
ON A.ParcelID = b.ParcelID
AND A.UNIQUEID <> B.UniqueID
Where a.PropertyAddress is null

UPDATE A
SET PropertyAddress=ISNULL (A.PropertyAddress,B.PropertyAddress)
From [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)] AS A
JOIN [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)]as B	
ON A.ParcelID = b.ParcelID
AND A.UNIQUEID <> B.UniqueID
Where a.PropertyAddress is null


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select *
From [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)]


Select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)as  Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1)as City
From [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)]


alter table  [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)]
 Add PropertySplitAddress Nvarchar(255);

 update [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)]
set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table  [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)]
 Add PropertyCityAddress Nvarchar(255);

 update [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)]
set PropertyCityAddress = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1)


Select OwnerAddress
From [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)]

Select PARSENAME(REPLACE(OwnerAddress ,',','.'),3) 
, PARSENAME(REPLACE(OwnerAddress ,',','.'),2)
, PARSENAME(REPLACE(OwnerAddress ,',','.'),1)
From [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)]

alter table [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)]
add OwnerSplitAddress  Nvarchar(255),
OwnerSplitCity  Nvarchar(255),
OwnerSplitState  Nvarchar(255);

update [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)]
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress ,',','.'),3),
    OwnerSplitCity  = PARSENAME(REPLACE(OwnerAddress ,',','.'),2),
    OwnerSplitState = PARSENAME(REPLACE(OwnerAddress ,',','.'),1);

Select *
From [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)]

---------------------------------------------------------------------------------------



-- Change Y and N to Yes and No in "Sold as Vacant" field


Select *
From [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)]

Select distinct (SoldAsVacant),COUNT(SoldAsVacant)
From [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)]
Group by SoldAsVacant

SELECT SoldAsVacant,
       CASE WHEN SoldAsVacant = 1 THEN 'Yes' ELSE 'No' END AS SoldAsVacant_Text
FROM [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)]

ALTER TABLE [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)]
ADD SoldAsVacant_Text Nvarchar(10)

UPDATE [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)]
SET  SoldAsVacant_Text =CASE WHEN SoldAsVacant = 1 THEN 'Yes' ELSE 'No' END 




-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates


Select *
From [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)]

WITH RownumCTE AS(
Select *, ROW_NUMBER ()
       OVER(PARTITION BY ParcelID ,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID) AS ROW_NUM
From [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)]
)
DELETE	
FROM RownumCTE
WHERE  ROW_NUM > 1
---ORDER BY UniqueID



-- Delete Unused Columns

Select *
From [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)]

alter table  [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)]
drop column PropertyAddress,SaleDate,TaxDistrict

alter table  [Portfolio 1].dbo.[Nashville Housing Data for Data Cleaning (1)]
drop column OwnerAddress