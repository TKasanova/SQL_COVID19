SELECT *
FROM dbo.Housing;

------------------------------------------------------------------------------------------------------
-- Standardize Date Format

SELECT saleDateConverted, CONVERT(Date, SaleDate)
FROM dbo.Housing;

UPDATE Housing
SET SaleDate = Convert (Date, SaleDate);

-- If it doesn't Update properly

ALTER TABLE Housing 
ALTER COLUMN SaleDate Date;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data
SELECT *
FROM dbo.Housing 
WHERE PropertyAddress is null
ORDER BY SalePrice DESC, ParcelID ;

SELECT a.ParcelID,a.PropertyAddress, b.ParcelID, b.PropertyAddress,ISNULL (a.PropertyAddress,b.PropertyAddress)
FROM dbo.Housing a
JOIN dbo.Housing b
   on a.ParcelID = b.ParcelID
   AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null;

UPDATE a
SET PropertyAddress= ISNULL (a.PropertyAddress,b.PropertyAddress)
FROM dbo.Housing a
JOIN dbo.Housing b
   on a.ParcelID = b.ParcelID
   AND a.[UniqueID] <>b.[UniqueID]
WHERE a.PropertyAddress is null;

--------------------------------------------------------------------------------------------------------------------------------------------
-- Breaking out Address into Individual Columns (Address, City, State)

SELECT  PropertyAddress
FROM dbo.Housing
WHERE PropertyAddress is null;

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Street,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as City

From dbo.Housing;

ALTER TABLE Housing
ADD PropertyStreetAddress Nvarchar(255);

Update dbo.Housing
SET PropertyStreetAddress = SUBSTRING(PropertyAddress, 1 , CHARINDEX(',', PropertyAddress) -1 ); 

ALTER TABLE dbo.Housing
Add PropertyCityAddress Nvarchar(255);

Update dbo.Housing
SET PropertyCityAddress = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


SELECT *
FROM dbo.Housing;

ALTER TABLE Housing
DROP COLUMN PropertyAddress;

SELECT CONCAT(PropertyStreetAddress, ',', PropertyCityAddress) as PropertyAddress
From dbo.Housing;

ALTER TABLE dbo.Housing
ADD PropertyAddress Nvarchar(255);

UPDATE dbo.Housing
SET PropertyAddress = CONCAT(PropertyStreetAddress, ',', PropertyCityAddress); 


SELECT OwnerAddress
from Housing;


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3) AS Street
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2) AS City
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1) AS State
From Housing;


ALTER TABLE Housing
Add OwnerStreetAddress Nvarchar(255);


ALTER TABLE Housing
Add OwnerCityAddress Nvarchar(255);

ALTER TABLE Housing
Add OwnerStateAddress Nvarchar(255);

Update Housing
SET OwnerStreetAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3);


Update Housing
SET OwnerCityAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3);


Update Housing
SET OwnerStateAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3);
 
 SELECT * 
 FROM Housing;
 -------------------------------------------------------------------------------------
 
-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant) AS SoldCount
From Housing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END  as COUNT
From Housing


Update Housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	                    When SoldAsVacant = 'N' THEN 'No'
	                    ELSE SoldAsVacant
	                    END;
 SELECT *
 FROM Housing;