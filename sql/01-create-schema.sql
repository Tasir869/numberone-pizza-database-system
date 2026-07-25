/*
    Numberone Pizza Database System
    Database schema

    This script creates the tables, primary keys,
    foreign keys and database constraints.
*/

-- Create a table to store customer information
CREATE TABLE Customer (
 CustomerId CHAR(3) PRIMARY KEY, -- Unique identifier for each customer (Eg:
xxx)
 FirstName VARCHAR(50) NOT NULL, -- First name of the customer (must not be
null)
 Surname VARCHAR(50) NOT NULL, -- Last name of the customer (must not be
null)
 Phone VARCHAR(15) NOT NULL, -- Customer's contact phone number (must not
be null)
 Address VARCHAR(255) NOT NULL -- Customer's physical address (must not be
null)
);


-- Create a table to store staff information
CREATE TABLE Staff (
 StaffId CHAR(2) PRIMARY KEY, -- Unique identifier for each staff member
(Eg: xx)
 TaxFileNo VARCHAR(15) NOT NULL, -- Tax file number of the staff member
(must not be null)
 FirstName VARCHAR(50) NOT NULL, -- First name of the staff member (must
not be null)
 Surname VARCHAR(50), -- Last name of the staff member
 Phone VARCHAR(15), -- Staff member's contact phone number
 Description VARCHAR(255), -- Staff be Manager, Crew Member, or Cashier
 Address VARCHAR(255), -- Staff member's physical address
 Status VARCHAR(20), -- Staff member's employment status (e.g.,
active, inactive)
 AcName VARCHAR(50), -- Bank account name for payroll purposes
 BSB VARCHAR(10), -- Bank State Branch code for direct deposits
 AcNo VARCHAR(15) -- Bank account number for direct deposits
);

-- Create a table to store MenuItem information
CREATE TABLE MenuItem (
 ItemCode CHAR(5) PRIMARY KEY, -- Unique identifier for the item
 Name VARCHAR(255) NOT NULL, -- Name of the menu item (required)
 Size VARCHAR(50), -- Size of the item (optional)
 Price DECIMAL(10, 2) NOT NULL, -- Price of the item (required)
 Description TEXT -- Description of the item
);
--Supplier table for recording supplier information
CREATE TABLE Supplier (
 SupplierID CHAR(5) PRIMARY KEY, -- Unique identifier for the supplier
 Name VARCHAR(255) NOT NULL, -- Name of the supplier (required)
 Phone VARCHAR(20), -- Phone number of the supplier
 Address VARCHAR(255), -- Address of the supplier
 eMail VARCHAR(255), -- Email address of the supplier
 ContactPerson VARCHAR(100) -- Name of the contact person at the supplier
);
--Ingredient table for recording ingredient information
CREATE TABLE Ingredient (
 IngredientCode CHAR(5) PRIMARY KEY, -- Unique identifier for the
ingredient
 Name VARCHAR(255) NOT NULL, -- Name of the ingredient
(required)
 StockUnit VARCHAR(50), -- Unit of measurement for stock
 Description TEXT, -- Description of the ingredient
 StockLevelAtStockTake DECIMAL(10, 2), -- Stock level at the last stock
take
 DateOfLastStockTake DATE, -- Date of the last stock take
 SuggestedStockLevel DECIMAL(10, 2), -- Suggested stock level for the
ingredient
 ReorderLevel DECIMAL(10, 2), -- Reorder level for the ingredient
 Type VARCHAR(50) -- Type or category of the
ingredient
);
-- InStore table
CREATE TABLE InStore (
 StaffId CHAR(2),
 HourlyRate DECIMAL(10, 2) DEFAULT 15.00, --Default value of 15.00
 ShiftNo INT,
 PRIMARY KEY (StaffId),
 FOREIGN KEY (StaffId) REFERENCES Staff (StaffId) ON UPDATE CASCADE ON DELETE
CASCADE
);
-- Driver table
CREATE TABLE Driver (
 StaffId CHAR(2),
 DriverLicNo INT,
 RatePerDelivery DECIMAL(10, 2),
 ShiftNo INT,
PRIMARY KEY ( StaffId ),
 FOREIGN KEY (StaffId) REFERENCES Staff (StaffId) ON UPDATE CASCADE ON DELETE
CASCADE
);
--Create the Shift table
CREATE TABLE Shift (
 ShiftNo INT PRIMARY KEY, -- Unique identifier for each shift
 StartDateTime DATETIME, -- Date and time when the shift starts
 HoursPaid DECIMAL(5, 2) -- Number of hours paid for the shift
);
--Create the Orders table
CREATE TABLE Orders (
 OrderId CHAR(5) PRIMARY KEY,
 OrderDateTime DATETIME,
 OrderType VARCHAR(50),
 TotalAmountDue DECIMAL(10, 2) DEFAULT 0.00, -- Default value 0.00
 PaymentMethod VARCHAR(50),
 PaymentApprovalNo VARCHAR(50) DEFAULT NULL, -- Default value NULL
 Status VARCHAR(50),
 CustomerId CHAR(3),
 StaffId CHAR(2),
 FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId) ON UPDATE CASCADE ON
DELETE CASCADE,
 FOREIGN KEY (StaffId) REFERENCES Instore(StaffId) ON UPDATE CASCADE ON DELETE
CASCADE
);
-- Create the WalkInOrder table
CREATE TABLE WalkInOrder (
 OrderId CHAR(5) PRIMARY KEY,
 WalkInTime DATETIME,
 FOREIGN KEY (OrderId) REFERENCES Orders(OrderId) ON UPDATE CASCADE ON DELETE
CASCADE
);
-- Create the PhoneOrder table
CREATE TABLE PhoneOrder (
 OrderId CHAR(5) PRIMARY KEY,
 TimeCallAnswered DATETIME,
 TimeCallTerminated DATETIME,
 FOREIGN KEY (OrderId) REFERENCES Orders(OrderId) ON UPDATE CASCADE ON DELETE
CASCADE
);
-- Create the StaffPayment table
CREATE TABLE StaffPayment (
 RecordId INT PRIMARY KEY,
 GrossPay DECIMAL(10, 2) DEFAULT 0.00, -- Default value 0.00
 TaxWithHeld DECIMAL(10, 2) DEFAULT 0.00, -- Default value 0.00
 TotalAmountPaid DECIMAL(10, 2),
 PaymentDate DATE,
 PayPeriodStartDate DATE,
 PayPeriodEndDate DATE,
 StaffId CHAR(2),
 FOREIGN KEY (StaffId) REFERENCES Staff(StaffId) ON UPDATE CASCADE ON DELETE
CASCADE
);
--DriverPay table for staff payments related to delivery work
CREATE TABLE DriverPay (
 PaidDeliveryRate DECIMAL(10, 2), -- The rate paid to the staff for deliveries
 DeliveriesPaid INT, -- The number of deliveries for which the
staff is paid
 RecordId INT PRIMARY KEY, -- Unique identifier for the payment
 FOREIGN KEY (RecordId) REFERENCES StaffPayment (RecordId) ON UPDATE CASCADE ON
DELETE CASCADE
);
-- Create the DriverShift table
CREATE TABLE DriverShift (
 NoOfDeliveries INT,
 ShiftNo INT,
 RecordId INT,
 StaffId CHAR(2),
 PRIMARY KEY (ShiftNo),
 FOREIGN KEY (ShiftNo) REFERENCES Shift(ShiftNo) ON DELETE NO ACTION ON UPDATE
NO ACTION,
 FOREIGN KEY (RecordId) REFERENCES DriverPay(RecordId) ON DELETE NO ACTION ON
UPDATE NO ACTION,
 FOREIGN KEY (StaffId) REFERENCES Driver(StaffId) ON DELETE NO ACTION ON UPDATE
NO ACTION
);
-- Create the DeliveryOrder table
CREATE TABLE DeliveryOrder (
 OrderId CHAR(5) PRIMARY KEY,
 DeliveryAddress VARCHAR(255),
 DeliveryTime DATETIME,
 ShiftNo INT,
 FOREIGN KEY (OrderId) REFERENCES PhoneOrder(OrderId) ON UPDATE CASCADE ON
DELETE CASCADE,
 FOREIGN KEY (ShiftNo) REFERENCES DriverShift(ShiftNo) ON UPDATE CASCADE ON
DELETE CASCADE
);
-- Create the PickupOrder table
CREATE TABLE PickupOrder (
 OrderId CHAR(5) PRIMARY KEY, -- Unique identifier for the pickup order
 DeliveryAddress VARCHAR(255), -- Address for the pickup order
 DeliveryTime DATETIME, -- Time for the pickup order
 FOREIGN KEY (OrderId) REFERENCES PhoneOrder (OrderId) ON UPDATE CASCADE ON
DELETE CASCADE
);
--InStorePay table for staff payments related to in-store work
CREATE TABLE InStorePay (
 PaidHourlyRate DECIMAL(10, 2), -- The hourly rate paid to the staff
 HoursPaid DECIMAL(5, 2), -- The number of hours for which the staff is
paid
 RecordId INT PRIMARY KEY, -- Unique identifier for the payment record
 FOREIGN KEY (RecordId) REFERENCES StaffPayment (RecordId) ON UPDATE CASCADE ON
DELETE CASCADE
);
--InShopShift table for recording in-store staff shifts
CREATE TABLE InShopShift (
 NoOfHours DECIMAL(5, 2), -- The number of hours worked in the shift
 ShiftNo INT, -- Unique identifier for the shift
 RecordId INT, -- Identifier for the related in-store payment
record
 StaffId CHAR(2), -- Staff identifier
 PRIMARY KEY (ShiftNo),
 FOREIGN KEY (ShiftNo) REFERENCES Shift (ShiftNo) ON DELETE NO ACTION ON UPDATE
NO ACTION,
 FOREIGN KEY (RecordId) REFERENCES InStorePay (RecordId) ON DELETE NO ACTION ON
UPDATE NO ACTION,
 FOREIGN KEY (StaffId) REFERENCES InStore (StaffId) ON DELETE NO ACTION ON
UPDATE NO ACTION
);
--IngredientOrder table for recording ingredient orders
CREATE TABLE IngredientOrder (
 IngredientOrderNo CHAR(10) PRIMARY KEY, -- Unique identifier for the ingredient
order
 DateIssued DATE, -- Date when the order was issued
 DateSupplied DATE, -- Date when the ingredients were
supplied
 Total DECIMAL(10, 2), -- Total cost of the order
 Status VARCHAR(50), -- Status of the order
 Description TEXT, -- Description of the order
 SupplierID CHAR(5), -- Identifier for the supplier providing
the ingredients
 FOREIGN KEY (SupplierID) REFERENCES Supplier (SupplierID) ON UPDATE CASCADE ON
DELETE CASCADE
);
--QuantityOrderMenuItem table for recording quantity ordered for menu items
CREATE TABLE QOrderMenuItem (
 ItemCode CHAR(5) PRIMARY KEY, -- Identifier for the menu item and primary key
 OrderDate DATE, -- Date of the order
 QuantityOrdered INT, -- Quantity of the menu item ordered
 OrderId CHAR(5), -- Identifier for the overall order
 FOREIGN KEY (ItemCode) REFERENCES MenuItem (ItemCode) ON UPDATE CASCADE ON
DELETE CASCADE,
 FOREIGN KEY (OrderId) REFERENCES Orders (OrderId) ON UPDATE CASCADE ON DELETE
CASCADE
);
-- Define the QuantityMenuItemIngredient table for recording quantities of
ingredients used in menu items
CREATE TABLE QMenuItemIngredient (
 ItemCode CHAR(5) PRIMARY KEY, -- Identifier for the menu item and primary
key
 IngredientCode CHAR(5), -- Identifier for the ingredient
 QuantityUsed DECIMAL(10, 2), -- Quantity of the ingredient used
 FOREIGN KEY (ItemCode) REFERENCES MenuItem (ItemCode) ON UPDATE CASCADE ON
DELETE CASCADE,
 FOREIGN KEY (IngredientCode) REFERENCES Ingredient (IngredientCode) ON UPDATE
CASCADE ON DELETE CASCADE
);
--QuantityIngredientIngOrder table for recording quantities of ingredients ordered
in ingredient orders
CREATE TABLE QIngredientIngOrder (
 IngredientOrderNo CHAR(10) PRIMARY KEY, -- Identifier for the ingredient order
and primary key
 IngredientCode CHAR(5), -- Identifier for the ingredient
 QuantityOrdered DECIMAL(10, 2), -- Quantity of the ingredient ordered
 FOREIGN KEY (IngredientOrderNo) REFERENCES IngredientOrder (IngredientOrderNo)
ON UPDATE CASCADE ON DELETE CASCADE,
 FOREIGN KEY (IngredientCode) REFERENCES Ingredient (IngredientCode) ON UPDATE
CASCADE ON DELETE CASCADE
);
--QuantityIngredientSupplier table for recording quantities of ingredients supplied
by suppliers
CREATE TABLE QIngredientSupplier (
 IngredientOrderNo CHAR(10) PRIMARY KEY, -- Identifier for the ingredient order
and primary key
 SupplierID CHAR(5), -- Identifier for the supplier
 PricePerUnit DECIMAL(10, 2), -- Price per unit of the ingredient
 FOREIGN KEY (SupplierID) REFERENCES Supplier (SupplierID) ON DELETE NO ACTION
ON UPDATE NO ACTION,
 FOREIGN KEY (IngredientOrderNo) REFERENCES IngredientOrder (IngredientOrderNo)
ON DELETE NO ACTION ON UPDATE NO ACTION
);



