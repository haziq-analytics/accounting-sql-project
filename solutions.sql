-- Question 1
SELECT DISTINCT
      CustomerName,
      ContactEmail,
      Phone,
      Address
FROM Customers c
JOIN Invoices i
  ON c.CustomerID = i.CustomerID
WHERE Status = 'Unpaid' 
OR Status = 'Overdue';
-- Question 2 
SELECT 
      VendorName,
      DueDate,
      TotalAmountBSD AS TotalAmountOwed
FROM Vendors v
JOIN Bills b 
  ON v.VendorID = B.VendorID
WHERE Status = 'Unpaid';
-- Questions 3
SELECT 
      AccountName,
      BankName, CurrentBalanceBSD
FROM BankAccounts
ORDER BY CurrentBalanceBSD DESC;
-- Qustion 4
SELECT 
      DATETRUNC(MONTH, EntryDate) AS RevenueMonth,
      SUM(CreditAmountBSD) AS TotalRevenue
FROM JournalEntryLines jel
JOIN JournalEntries je
 ON jel.JournalEntryID = je.JournalEntryID
GROUP BY DATETRUNC(MONTH, EntryDate);
-- Question 5
SELECT 
      CustomerName,
      SUM(TotalAmountBSD) AS AmountInvoiced,
      COALESCE(SUM(AmountBSD), 0) AS AmountPaid
FROM Customers c
LEFT JOIN Invoices i
  ON c.CustomerID = i.CustomerID
LEFT JOIN Payments P
  ON i.InvoiceID = p.InvoiceID
GROUP BY CustomerName, c.CustomerID
