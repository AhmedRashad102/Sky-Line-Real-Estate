---------- 1 / Published Listings With Property Details   ----------    
CREATE OR AlTER VIEW Active_Listings AS
SELECT 
	l.ID AS Listing_ID, 
	l.Status, 
	l.Date, 
	p.Type, 
	p.Price
FROM 
	Listing l
INNER JOIN 
	Property p ON l.Property_ID = p.ID
WHERE 
	l.Status = 'Published'
GO

---------- 2 / Appointment Details With Client And Property   ----------    
CREATE OR AlTER VIEW Appointment_Details AS
SELECT 
	a.ID, 
	a.Date AS Appointment_Date, 
	a.Status, 
	c.Name AS Client_Name, 
	p.Type AS Property_Type, 
	p.Price AS Property_Price
FROM 
	Appointment a
INNER JOIN 
	Client c ON a.Client_ID = c.ID
INNER JOIN 
	Property p ON a.Property_ID = p.ID
GO

---------- 3 / Appointments Per Month  ----------    
CREATE OR AlTER VIEW Appointment_Monthly AS
SELECT 
	FORMAT(Date, 'yyyy-MM') AS Month, 
	COUNT(*) AS Total_Appointments
FROM 
	Appointment
GROUP BY 
	FORMAT(Date, 'yyyy-MM')
GO

---------- 4 / Broker (Appointment + Listing)  ----------
CREATE OR ALTER VIEW Broker_Appointment_Listing AS
SELECT
    B.ID AS BrokerID,
    B.Name AS BrokerName,
    B.License_Number,
    B.Agency_Name,
    B.Email AS BrokerEmail,
    BP.Phone AS BrokerPhone,
    COUNT(DISTINCT L.ID) AS Number_Of_Listings,
    COUNT(DISTINCT AB.Appointment_ID) AS Number_Of_Appointments
FROM
    Broker B
LEFT JOIN
    Broker_Phone BP ON B.ID = BP.Broker_ID
LEFT JOIN
    Listing_Broker LB ON B.ID = LB.Broker_ID
LEFT JOIN
    Listing L ON LB.Listing_ID = L.ID
LEFT JOIN
    Appointment_Broker AB ON B.ID = AB.Broker_ID
GROUP BY
    B.ID, B.Name, B.License_Number, B.Agency_Name, B.Email, BP.Phone
GO

---------- 5 / Broker Commission  ----------
CREATE OR ALTER VIEW Broker_Commission AS
SELECT
    B.ID AS Broker_ID,
    B.Name AS Broker_Name,
    SUM(Py.Broker_Commission) AS Total_Commission_Earned
FROM
    Broker B
INNER JOIN
    Payment Py ON B.ID = Py.Broker_ID
GROUP BY
    B.ID, B.Name
GO

---------- 6 / Broker performance  ----------
CREATE OR AlTER VIEW Broker_Performance AS
SELECT 
	b.ID AS Broker_ID, 
	b.Name Broker_Name, 
	COUNT(p.ID) AS Number_Of_Deal, 
	SUM(pr.Price) AS Total_Revenue
FROM 
	Broker b
INNER JOIN 
	Payment p ON b.ID = p.Broker_ID
INNER JOIN 
	Property pr ON pr.ID = p.Property_ID
GROUP BY 
	b.ID, b.Name
GO

---------- 7 / Client Overview ----------
CREATE OR ALTER VIEW Client_Overview AS
SELECT
    C.ID AS Client_ID,
    C.Name AS Client_Name,
    C.Type AS Client_Type,
    CP.Phone AS Client_Phone
FROM
    Client C
LEFT JOIN
    Client_Phone CP ON C.ID = CP.Client_ID
GO

---------- 8 / Payment Per Client  ----------
CREATE OR AlTER VIEW Client_Payment AS
SELECT 
	c.ID AS Client_ID, 
	c.Name AS Client_Name, 
	COUNT(p.ID) AS Payment_Count,
	SUM(pr.Price) AS Total_Payment
FROM 
	Client c
INNER JOIN 
	Payment p ON c.ID = p.Client_ID
INNER JOIN 
	Property pr ON p.Property_ID = pr.ID
GROUP BY 
	c.ID, c.Name
GO

---------- 9 / Employee (Appointment + Listing)  ----------
CREATE OR ALTER VIEW Employee_Appointment_Listing AS
SELECT
    E.ID AS Employee_ID,
    E.Name AS Employee_Name,
    COUNT(DISTINCT a.ID) AS Number_Of_Appointments,
    COUNT(DISTINCT l.ID) AS Number_Of_Listings
FROM
    Employee E
LEFT JOIN
    Appointment A ON E.ID = A.Employee_ID
LEFT JOIN 
	Listing l ON e.ID = l.Employee_ID
GROUP BY
    E.ID, E.Name
GO


---------- 10 / Employee Commission  ----------
CREATE OR ALTER VIEW Employee_Commission AS
SELECT
    E.ID AS Employee_ID,
    E.Name AS Employee_Name,
    SUM(Py.Employee_Commission) AS Total_Commission_Earned
FROM
    Employee E
JOIN
    Payment Py ON E.ID = Py.Employee_ID
GROUP BY
    E.ID, E.Name
GO


---------- 11 / Listing Broker Details  ----------
CREATE OR ALTER VIEW Listing_Broker_Details AS
SELECT
    LB.Listing_ID,
    L.Date AS ListingDate,
    B.ID AS BrokerID,
    B.Name AS BrokerName,
    B.Agency_Name
FROM
    Listing_Broker LB
INNER JOIN
    Listing L ON LB.Listing_ID = L.ID
INNER JOIN
    Broker B ON LB.Broker_ID = B.ID
INNER JOIN
    Property P ON L.Property_ID = P.ID
GO


---------- 12 / Property Listing   ----------    
CREATE OR AlTER VIEW Listing_Status AS
SELECT
	Status, 
	COUNT(*) AS Total
FROM 
	Listing
GROUP BY 
	Status
GO

---------- 13 / Monthly Payment Report   ----------    
CREATE OR AlTER VIEW Monthly_Payment_Report AS
SELECT 
	FORMAT(p.Date, 'yyyy-MM') AS Payment_Month, 
	COUNT(*) AS Count_Of_Payment, 
	SUM(pr.Price) AS Total_Payment
FROM 
	Payment p
INNER JOIN 
	Property pr ON pr.ID = p.Property_ID
GROUP BY 
	FORMAT(p.Date, 'yyyy-MM')
GO

---------- 14 / Owner Earnings From Properties  ----------   
CREATE OR AlTER VIEW Owner_Earnings AS
SELECT 
	o.ID, 
	o.Name, 
	SUM(pr.Price) AS Total_Earned
FROM 
	Owner o
INNER JOIN 
	Property pr ON o.ID = pr.Owner_ID
INNER JOIN 
	Payment p ON pr.ID = p.Property_ID
GROUP BY 
	o.ID, o.Name
GO

---------- 15 / Owner Properties  ----------
CREATE OR ALTER VIEW Owner_Properties AS
SELECT
    O.ID AS Owner_ID,
    O.Name AS Owner_Name,
    O.Type AS Owner_Type,
    O.Address AS Owner_Address,
    O.Email AS Owner_Email,
    OP.Phone AS Owner_Phone,
    P.ID AS Property_ID,
    P.Type AS Property_Type,
    P.Price AS Property_Price,
    P.Status AS Property_Status
FROM
    Owner O
LEFT JOIN
    Owner_Phone OP ON O.ID = OP.Owner_ID
LEFT JOIN
    Property P ON O.ID = P.Owner_ID
GO

---------- 16 / Payment Transactions  ----------
CREATE OR ALTER VIEW Payment_Transactions AS
SELECT
    Py.ID AS PaymentID,
    Py.Date AS PaymentDate,
    Py.Type AS PaymentType,
    Py.Employee_Commission,
    Py.Broker_Commission,
    Py.Amount_To_Owner,
    C.Name AS ClientName,
    Br.Name AS BrokerName,
    Em.Name AS EmployeeName,
    O.Name AS OwnerName
FROM 
	Payment Py
LEFT JOIN 
	Client C ON Py.Client_ID = C.ID
LEFT JOIN 
	Broker Br ON Py.Broker_ID = Br.ID
LEFT JOIN 
	Employee Em ON Py.Employee_ID = Em.ID
LEFT JOIN 
	Property Pr ON Py.Property_ID = Pr.ID
LEFT JOIN 
	Owner O ON Py.Owner_ID = O.ID
GO

---------- 17 / Property By Type  ----------  
CREATE OR AlTER VIEW Property_By_Type AS
SELECT 
	Type AS Property_Type, 
	COUNT(*) AS Total_Property, 
	AVG(Price) AS Avg_Price
FROM 
	Property
GROUP BY 
	Type
GO


---------- 18 / Property Full Details  ----------
CREATE OR ALTER VIEW Property_Full_Details AS
SELECT
    P.ID AS Property_ID,
    P.Type AS Property_Type,
    P.Price AS Property_Price,
    P.Room,
    P.Bathroom,
    P.Status AS PropertyStatus,
    P.Fureniture,
    P.Year_Built,
    P.Payment_Method,
    O.Name AS Owner_Name,
    O.Email AS Owner_Email,
    L.City,
    L.Street,
    L.Building,
    L.Unit,
    L.Longitude,
    L.Latitude,
    L.Zipcode
FROM
    Property P
INNER JOIN
    Owner O ON P.Owner_ID = O.ID
INNER JOIN
    Location L ON P.ID = L.Property_ID
GO

