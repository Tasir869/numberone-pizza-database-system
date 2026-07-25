USE numberone_pizza;

-- Query 1: Find an employee's hourly payment rate
SELECT
    S.StaffId,
    S.FirstName,
    S.Surname,
    I.HourlyRate
FROM Staff AS S
JOIN InStore AS I
    ON S.StaffId = I.StaffId
WHERE S.StaffId = '11';


-- Query 2: Find a driver's shifts within a date range
SELECT
    S.StaffId,
    S.FirstName,
    S.Surname,
    SH.ShiftNo,
    SH.StartDateTime,
    SH.HoursPaid
FROM Staff AS S
JOIN DriverShift AS DS
    ON S.StaffId = DS.StaffId
JOIN Shift AS SH
    ON DS.ShiftNo = SH.ShiftNo
WHERE S.FirstName = 'James'
  AND S.Surname = 'Wilson'
  AND SH.StartDateTime BETWEEN
      '2023-10-25 00:00:00'
      AND '2023-10-26 23:59:59';


-- Query 3: Find a customer's in-store orders within a date range
SELECT
    O.OrderId,
    O.OrderDateTime,
    O.OrderType,
    O.TotalAmountDue,
    O.PaymentMethod,
    O.PaymentApprovalNo,
    O.Status,
    C.FirstName,
    C.Surname
FROM Orders AS O
JOIN Customer AS C
    ON O.CustomerId = C.CustomerId
JOIN WalkInOrder AS W
    ON O.OrderId = W.OrderId
WHERE C.FirstName = 'Jane'
  AND C.Surname = 'Smith'
  AND O.OrderDateTime BETWEEN
      '2023-10-26 00:00:00'
      AND '2023-10-27 23:59:59'
  AND O.OrderType = 'In-Store';


-- Query 4: Find menu items ordered in 2023
SELECT DISTINCT
    M.ItemCode,
    M.Name
FROM MenuItem AS M
JOIN QOrderMenuItem AS Q
    ON M.ItemCode = Q.ItemCode
WHERE YEAR(Q.OrderDate) = 2023
ORDER BY M.Name;