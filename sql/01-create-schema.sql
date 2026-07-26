USE numberone_pizza;

/*
    Numberone Pizza Database System
    Database schema

    This script creates the tables, primary keys,
    foreign keys and database constraints.
*/

-- Create a table to store customer information
CREATE TABLE Customer (
    CustomerId CHAR(3) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    Surname VARCHAR(50) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Address VARCHAR(255) NOT NULL
);


-- Create a table to store staff information
CREATE TABLE Staff (
    StaffId CHAR(2) PRIMARY KEY,
    TaxFileNo VARCHAR(15) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    Surname VARCHAR(50),
    Phone VARCHAR(15),
    Description VARCHAR(255),
    Address VARCHAR(255),
    Status VARCHAR(20),
    AcName VARCHAR(50),
    BSB VARCHAR(10),
    AcNo VARCHAR(15)
);

-- Create a table to store MenuItem information
CREATE TABLE MenuItem (
 ItemCode CHAR(5) PRIMARY KEY, -- Unique identifier for the item
 Name VARCHAR(255) NOT NULL, -- Name of the menu item (required)
 Size VARCHAR(50), -- Size of the item (optional)
 Price DECIMAL(10, 2) NOT NULL, -- Price of the item (required)
 Description TEXT -- Description of the item
);

-- Supplier table for recording supplier information
CREATE TABLE Supplier (
    SupplierID CHAR(5) PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Phone VARCHAR(20),
    Address VARCHAR(255),
    Email VARCHAR(255),
    ContactPerson VARCHAR(100)
);

-- Ingredient table for recording ingredient information
CREATE TABLE Ingredient (
    IngredientCode CHAR(5) PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    StockUnit VARCHAR(50),
    Description TEXT,
    StockLevelAtStockTake DECIMAL(10, 2),
    DateOfLastStockTake DATE,
    SuggestedStockLevel DECIMAL(10, 2),
    ReorderLevel DECIMAL(10, 2),
    Type VARCHAR(50)
);

-- In-store employee details
CREATE TABLE InStore (
    StaffId CHAR(2),
    HourlyRate DECIMAL(10, 2) DEFAULT 15.00,
    ShiftNo INT,
    PRIMARY KEY (StaffId),
    FOREIGN KEY (StaffId)
        REFERENCES Staff (StaffId)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Driver details
CREATE TABLE Driver (
    StaffId CHAR(2),
    DriverLicNo INT,
    RatePerDelivery DECIMAL(10, 2),
    ShiftNo INT,
    PRIMARY KEY (StaffId),
    FOREIGN KEY (StaffId)
        REFERENCES Staff (StaffId)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Employee shift details
CREATE TABLE Shift (
    ShiftNo INT PRIMARY KEY,
    StartDateTime DATETIME,
    HoursPaid DECIMAL(5, 2)
);
-- Customer orders
CREATE TABLE Orders (
    OrderId CHAR(5) PRIMARY KEY,
    OrderDateTime DATETIME,
    OrderType VARCHAR(50),
    TotalAmountDue DECIMAL(10, 2) DEFAULT 0.00,
    PaymentMethod VARCHAR(50),
    PaymentApprovalNo VARCHAR(50) DEFAULT NULL,
    Status VARCHAR(50),
    CustomerId CHAR(3),
    StaffId CHAR(2),

    FOREIGN KEY (CustomerId)
        REFERENCES Customer (CustomerId)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    FOREIGN KEY (StaffId)
        REFERENCES InStore (StaffId)
        ON UPDATE CASCADE
        ON DELETE CASCADE
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

-- Driver payment details
CREATE TABLE DriverPay (
    PaidDeliveryRate DECIMAL(10, 2),
    DeliveriesPaid INT,
    RecordId INT PRIMARY KEY,

    FOREIGN KEY (RecordId)
        REFERENCES StaffPayment (RecordId)
        ON UPDATE CASCADE
        ON DELETE CASCADE
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
-- In-store staff payment details
CREATE TABLE InStorePay (
    PaidHourlyRate DECIMAL(10, 2),
    HoursPaid DECIMAL(5, 2),
    RecordId INT PRIMARY KEY,

    FOREIGN KEY (RecordId)
        REFERENCES StaffPayment (RecordId)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- In-store staff shift details
CREATE TABLE InShopShift (
    NoOfHours DECIMAL(5, 2),
    ShiftNo INT,
    RecordId INT,
    StaffId CHAR(2),

    PRIMARY KEY (ShiftNo),

    FOREIGN KEY (ShiftNo)
        REFERENCES Shift (ShiftNo)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,

    FOREIGN KEY (RecordId)
        REFERENCES InStorePay (RecordId)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,

    FOREIGN KEY (StaffId)
        REFERENCES InStore (StaffId)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
-- Ingredient orders placed with suppliers
CREATE TABLE IngredientOrder (
    IngredientOrderNo CHAR(10) PRIMARY KEY,
    DateIssued DATE,
    DateSupplied DATE,
    Total DECIMAL(10, 2),
    Status VARCHAR(50),
    Description TEXT,
    SupplierID CHAR(5),

    FOREIGN KEY (SupplierID)
        REFERENCES Supplier (SupplierID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Menu items included in customer orders
CREATE TABLE QOrderMenuItem (
    ItemCode CHAR(5),
    OrderId CHAR(5),
    OrderDate DATE,
    QuantityOrdered INT,

    PRIMARY KEY (ItemCode, OrderId),

    FOREIGN KEY (ItemCode)
        REFERENCES MenuItem (ItemCode)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    FOREIGN KEY (OrderId)
        REFERENCES Orders (OrderId)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
-- Ingredients required for each menu item
CREATE TABLE QMenuItemIngredient (
    ItemCode CHAR(5),
    IngredientCode CHAR(5),
    QuantityUsed DECIMAL(10, 2),

    PRIMARY KEY (ItemCode, IngredientCode),

    FOREIGN KEY (ItemCode)
        REFERENCES MenuItem (ItemCode)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    FOREIGN KEY (IngredientCode)
        REFERENCES Ingredient (IngredientCode)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Ingredients included in supplier orders
CREATE TABLE QIngredientIngOrder (
    IngredientOrderNo CHAR(10),
    IngredientCode CHAR(5),
    QuantityOrdered DECIMAL(10, 2),

    PRIMARY KEY (IngredientOrderNo, IngredientCode),

    FOREIGN KEY (IngredientOrderNo)
        REFERENCES IngredientOrder (IngredientOrderNo)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    FOREIGN KEY (IngredientCode)
        REFERENCES Ingredient (IngredientCode)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
-- Suppliers and the ingredient orders they provide
CREATE TABLE QIngredientSupplier (
    IngredientOrderNo CHAR(10),
    SupplierID CHAR(5),
    PricePerUnit DECIMAL(10, 2),

    PRIMARY KEY (IngredientOrderNo, SupplierID),

    FOREIGN KEY (SupplierID)
        REFERENCES Supplier (SupplierID)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,

    FOREIGN KEY (IngredientOrderNo)
        REFERENCES IngredientOrder (IngredientOrderNo)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);



