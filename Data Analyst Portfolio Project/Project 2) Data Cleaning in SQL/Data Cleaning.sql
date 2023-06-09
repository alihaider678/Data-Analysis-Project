-- Cleaning Data in SQL Queries
select * from portfolio_projects.nashvillehousing;

-- Populate Property Address data
select * from portfolio_projects.nashvillehousing
where PropertyAddress is not null;


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
From portfolio_projects.nashvillehousing a
JOIN portfolio_projects.nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
where a.PropertyAddress is null;
    

-- Breaking out Address into Individual Columns (Address, City, State)
select PropertyAddress from 
portfolio_projects.nashvillehousing;

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
from portfolio_projects.nashvillehousing;

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 );


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress));

select * from portfolio_projects.nashvillehousing;

select OwnerAddress from portfolio_projects.nashvillehousing;

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.NashvilleHousing;



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3);


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update nashvillehousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2);



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1);



Select *
From PortfolioProject.NashvilleHousing;


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.NashvilleHousing
Group by SoldAsVacant
order by 2;




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.NashvilleHousing;


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END;

-- Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.NashvilleHousing
-- order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress;

Select *
From PortfolioProject.NashvilleHousing;

-- Delete Unused Columns
Select *
From PortfolioProject.NashvilleHousing;
ALTER TABLE PortfolioProject.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;


