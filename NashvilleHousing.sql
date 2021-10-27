/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortfolioProject].[dbo].[NashvilleHousing]



  --Cleaning Data In SQL
  SELECT*
  From PortfolioProject..NashvilleHousing

  --Standardizing Date Format
   SELECT SaleDate2, CONVERT(Date, SaleDate) 
  From PortfolioProject..NashvilleHousing

  Update PortfolioProject..NashvilleHousing
  SET SaleDate =  CONVERT(Date, SaleDate) 

  ALTER TABLE PortfolioProject..NashvilleHousing
  ADD SaleDate2 Date;

  UPDATE PortfolioProject..NashvilleHousing
  SET SaleDate2 =  CONVERT(Date, SaleDate) 

  --Populate Property Address Data
  SELECT *
  From PortfolioProject..NashvilleHousing
  Where PropertyAddress is Null  

  SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
  From PortfolioProject..NashvilleHousing a
  Join PortfolioProject..NashvilleHousing b
     on a.ParcelID = b.ParcelID
     AND a.[UniqueID ] <> b.[UniqueID ]
  Where a.PropertyAddress is null

  UPDATE a
  SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
   From PortfolioProject..NashvilleHousing a
  Join PortfolioProject..NashvilleHousing b
     on a.ParcelID = b.ParcelID
     AND a.[UniqueID ] <> b.[UniqueID ]
  Where a.PropertyAddress is null


  --Breaking out address into different columns

    SELECT PropertyAddress
  From PortfolioProject..NashvilleHousing
  --Where PropertyAddress is Null  
 -- order by ParcelID

 --Using Substring
 SELECT
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
 From PortfolioProject.dbo.NashvilleHousing

 
  ALTER TABLE PortfolioProject..NashvilleHousing
  ADD PropertyAddress1 nvarchar(255);

  UPDATE PortfolioProject..NashvilleHousing
  SET PropertyAddress1 =  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


  ALTER TABLE PortfolioProject..NashvilleHousing
  ADD PropertyAddress2 nvarchar(255);


  Update PortfolioProject..NashvilleHousing
  SET PropertyAddress2=  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

   SELECT *
  From PortfolioProject..NashvilleHousing

  --UsingParsename to split owner address

   SELECT OwnerAddress
  From PortfolioProject..NashvilleHousing


  select 
  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
    From PortfolioProject..NashvilleHousing



  ALTER TABLE PortfolioProject..NashvilleHousing
  ADD OwnerAddress1 nvarchar(255);

  UPDATE PortfolioProject..NashvilleHousing
  SET OwnerAddress1 =  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


  ALTER TABLE PortfolioProject..NashvilleHousing
  ADD OwnerAddress2 nvarchar(255);


  Update PortfolioProject..NashvilleHousing
  SET OwnerAddress2 =  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

  
  ALTER TABLE PortfolioProject..NashvilleHousing
  ADD OwnerAddress3 nvarchar(255);


  Update PortfolioProject..NashvilleHousing
  SET OwnerAddress3 =   PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


 --   SELECT *
  -- From PortfolioProject..NashvilleHousing

  --Change Y and N to Yes and No

Select Distinct(SoldAsVacant), Count(SoldAsVacant)   
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant  ,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END
From PortfolioProject..NashvilleHousing


  Update PortfolioProject..NashvilleHousing
  SET SoldAsVacant =   CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END


--Remove Duplicates
With RowNumCTE AS(
Select*,
   ROW_NUMBER() OVER (
   PARTITION BY ParcelID,
                PropertyAddress,
			    SalePrice,
			    SaleDate,
			    LegalReference 
			    ORDER BY
			      UniqueID
				  ) row_num
From PortfolioProject..NashvilleHousing

)
DELETE
--SELECT*
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress
 

 --Delete Unused Columns
 ALTER TABLE PortfolioProject..NashvilleHousing
 DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

  ALTER TABLE PortfolioProject..NashvilleHousing
 DROP COLUMN SaleDate

 SELECT *
 From PortfolioProject..NashvilleHousing