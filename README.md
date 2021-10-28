# NashvilleHousing-DataCleaning

The data set had repeation of same address twice with same ParcelID and different uniqueId. Some have NULL as their propertyAddress and the repeated ParcelId . To replace Null with address we used the JOIN clause to combine the dataset with itself on ParcelId to find the missing adresses.
The table is then updated with the adresss 
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
