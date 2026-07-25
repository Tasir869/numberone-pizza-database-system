--Queries
 --Query 1: Find an employee's hourly payment rate
SELECT FirstName, Surname, HourlyRate
FROM Staff
JOIN InStore ON InStore.StaffId = Staff.StaffId
WHERE Staff.StaffId = '11';
--Query 2: Find a Driver’s Shifts Within a Date Range
SELECT Shift.ShiftNo, Shift.StartDateTime, Shift.HoursPaid
FROM Staff
JOIN DriverShift ON Staff.StaffId = DriverShift.StaffId
JOIN Shift ON DriverShift.ShiftNo = Shift.ShiftNo
WHERE Staff.FirstName = 'James'
 AND Staff.Surname = 'Wilson'
 AND Shift.StartDateTime BETWEEN '2023-10-26 14:00:00' AND '2029-10-26 14:00:00';
--Query 3: Find a Customer’s In-Store Orders Within a Date Range
SELECT O.OrderId, O.OrderDateTime, O.OrderType, O.TotalAmountDue, O.PaymentMethod,
O.PaymentApprovalNo, O.Status, C.FirstName, C.Surname
FROM Orders O
JOIN Customer C ON O.CustomerId = C.CustomerId
JOIN WalkInOrder WIO ON O.OrderId = WIO.OrderId
WHERE C.FirstName = 'John'
 AND C.Surname = 'Doe'
 AND O.OrderDateTime BETWEEN '2023-10-26 10:45:00' AND '2023-11-02 08:30:00'
 AND O.OrderType = 'In-Store';
--Query 4: Find Menu Items Ordered in a Particular Year
SELECT DISTINCT M.Name
FROM MenuItem M
JOIN QOrderMenuItem Q ON M.ItemCode = Q.ItemCode
WHERE YEAR(Q.OrderDate) = YEAR('2023');