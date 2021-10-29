# NashvilleHousing-DataCleaning

The aim of this exercise is to perform various SQL queries for data cleaning and standardization on Nashville Housing datset. The data is processed for further analysis by removing or modifying data that is incorrect, incomplete, irrelevant, duplicated, or improperly formatted.

Here are the queries used:


1. Filling of incomplete data


```
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
```
