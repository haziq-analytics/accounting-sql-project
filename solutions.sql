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
GROUP BY CustomerName, c.CustomerID;

-- Question 6
SELECT TOP 3
      CustomerName,
      Phone,
      SUM(TotalAmountBSD) as TotalInvoiced
FROM Customers c
JOIN Invoices i
  ON c.CustomerID = i.CustomerID
GROUP BY CustomerName, Phone
ORDER BY TotalInvoiced DESC;

-- Question 7
SELECT 
      SUM(DebitAmountBSD) AS TotalDebit,
      SUM(CreditAmountBSD) AS TotalCredit
FROM JournalEntryLines
GROUP BY JournalEntryID
HAVING SUM(DebitAmountBSD) <> SUM(CreditAmountBSD)

      -- Question 8
;WITH AgingReport AS (
SELECT
      CustomerName,
      DATEDIFF(DAY, DueDate, GETDATE()) AS DaysBetween,
      Status,
      TotalAmountBSD
FROM Invoices i
JOIN Customers c
  ON i.CustomerID = c.CustomerID
WHERE Status = 'Unpaid'
OR Status = 'Overdue'
)
SELECT 
      CustomerName,
      TotalAmountBSD AS TotalInvoiced,
      CASE 
          WHEN DaysBetween > 60 THEN '60+'
          WHEN DaysBetween > 30 THEN '31-60'
          ELSE '0-30'
      END AS DaysOverdue
FROM AgingReport;

-- Queston 9
With AccountBalance AS (
SELECT 
     a.AccountID,
      a.ParentAccountID,
      SUM(CASE
          WHEN a.AccountType IN ('Asset', 'Expense') THEN DebitAmountBSD - CreditAmountBSD
          ELSE CreditAmountBSD - DebitAmountBSD 
      END ) AS Amount
FROM Accounts a
JOIN JournalEntryLines jel
  ON a.AccountID = jel.AccountID
GROUP BY a.AccountID, a.ParentAccountID
)
SELECT 
      p.AccountName AS ParentCategory,
      SUM(c.Amount) AS TotalBalance
FROM AccountBalance c
JOIN Accounts p
  ON c.ParentAccountID = p.AccountID
GROUP BY p.AccountName;

-- Question 10
DROP VIEW IF EXISTS monthly_finance_dashboard_view
GO
CREATE VIEW monthly_finance_dashboard_view AS
WITH MonthlyReport AS (
SELECT 
      DATETRUNC(MONTH, EntryDate) AS ReportingMonth,
      SUM(CASE WHEN a.AccountType = 'Expense' THEN jel.DebitAmountBSD ELSE 0 END)  AS TotalExpenses,
      SUM(CASE WHEN a.AccountType = 'Revenue' THEN jel.CreditAmountBSD ELSE 0 END) AS TotalRevenue,
      SUM(CASE WHEN a.AccountType = 'Revenue' THEN jel.CreditAmountBSD ELSE 0 END) -
      SUM(CASE WHEN a.AccountType = 'Expense' THEN jel.DebitAmountBSD ELSE 0 END) AS NetIncome
FROM JournalEntryLines jel
JOIN JournalEntries je
 ON jel.JournalEntryID = je.JournalEntryID
JOIN Accounts a
  ON jel.AccountID = a.AccountID
WHERE AccountType = 'Revenue'
OR AccountType = 'Expense'
GROUP BY DATETRUNC(MONTH, EntryDate)
),
RunningCumulative AS (
SELECT 
      ReportingMonth,
      TotalExpenses,
      TotalRevenue,
      NetIncome,
      SUM(NetIncome) OVER(ORDER BY ReportingMonth) AS RunningTotal
FROM MonthlyReport
)
SELECT *
FROM RunningCumulative

SELECT *
FROM monthly_finance_dashboard_view



