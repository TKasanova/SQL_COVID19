SELECT *
FROM dbo.Housing;

------------------------------------------------------------------------------------------------------

-- Standardize Date Format

SELECT saleDateConverted, CONVERT(Date, SaleDate)
FROM dbo.Housing;

UPDATE Housing
SET SaleDate = Convert (Date, SaleDate);
