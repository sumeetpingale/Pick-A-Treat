--- Procedure and trigger --
-- registered users, prod price -- 
--- notify price changes to the customers -- only if they have purchase earlier

use PICK_A_TREAT_SUMEET_PINGALE;

--- drop trigger trgNotifyPriceChange
CREATE TRIGGER trgNotifyPriceChange
ON PRODUCT_INVENTORY AFTER UPDATE AS
BEGIN
	
	DECLARE @prodname varchar(100);
	DECLARE @prodtype varchar(100);
	DECLARE @prodprice money;

	SELECT @prodname = Prod_Name from inserted;
	SELECT @prodtype = Prod_Type from inserted;
	SELECT @prodprice = Prod_Price from inserted;

	SELECT cust.Cust_Id, cust.First_Name, prd.Prod_Name, @prodprice as New_Price
	from Product_Inventory prd INNER JOIN Order_Item ord
	ON ord.Prod_Id = prd.Prod_Id
	INNER JOIN Cart ct
	ON ct.Cart_Id = ord.Cart_Id
	INNER JOIN Customer cust
	ON cust.Cust_Id = ct.Cust_Id 
	WHERE prd.Prod_Name=@prodname

	PRINT 'Trigger is generated on price change for customers who had bought that item'

END
GO


CREATE OR ALTER PROCEDURE dbo.spPriceUpdateAndInformCustomer
@Prod_Price money,
@Prod_Name varchar(100),
@Prod_Type varchar(100)
AS
BEGIN

	UPDATE dbo.Product_Inventory
	SET Prod_Price = @Prod_Price
	WHERE Prod_Name = @Prod_Name
	and Prod_Type = @Prod_Type;
		
END
GO


EXEC dbo.spPriceUpdateAndInformCustomer 3.5,'Parle-G','Cookies';






