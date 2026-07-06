CREATE DATABASE SinarFinanceDB;
GO
USE SinarFinanceDB;
GO

-- Chart of Accounts (self-referencing hierarchy: e.g. "Current Assets" under "Assets")
CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY IDENTITY(1,1),
    AccountCode NVARCHAR(20) UNIQUE NOT NULL,
    AccountName NVARCHAR(100) NOT NULL,
    AccountType NVARCHAR(20) NOT NULL, -- 'Asset','Liability','Equity','Revenue','Expense'
    ParentAccountID INT NULL FOREIGN KEY REFERENCES Accounts(AccountID),
    IsActive BIT DEFAULT 1
);

-- Fiscal periods for reporting/closing
CREATE TABLE FiscalPeriods (
    PeriodID INT PRIMARY KEY IDENTITY(1,1),
    PeriodName NVARCHAR(20) NOT NULL, -- e.g. 'Jan 2026'
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    IsClosed BIT DEFAULT 0
);

-- Customers (Accounts Receivable side)
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName NVARCHAR(100) NOT NULL,
    ContactEmail NVARCHAR(100),
    Phone NVARCHAR(20),
    Address NVARCHAR(200),
    CreditLimitBSD DECIMAL(12,2) DEFAULT 0,
    IsActive BIT DEFAULT 1
);

-- Vendors (Accounts Payable side)
CREATE TABLE Vendors (
    VendorID INT PRIMARY KEY IDENTITY(1,1),
    VendorName NVARCHAR(100) NOT NULL,
    ContactEmail NVARCHAR(100),
    Phone NVARCHAR(20),
    Address NVARCHAR(200),
    IsActive BIT DEFAULT 1
);

-- Bank accounts belonging to the company
CREATE TABLE BankAccounts (
    BankAccountID INT PRIMARY KEY IDENTITY(1,1),
    AccountName NVARCHAR(100) NOT NULL,
    BankName NVARCHAR(100) NOT NULL, -- e.g. 'Baiduri Bank', 'BIBD'
    AccountNumber NVARCHAR(50) UNIQUE NOT NULL,
    CurrentBalanceBSD DECIMAL(14,2) DEFAULT 0
);

-- Journal Entries (header for a double-entry transaction)
CREATE TABLE JournalEntries (
    JournalEntryID INT PRIMARY KEY IDENTITY(1,1),
    EntryDate DATE NOT NULL,
    Description NVARCHAR(200),
    PeriodID INT FOREIGN KEY REFERENCES FiscalPeriods(PeriodID),
    IsPosted BIT DEFAULT 0
);

-- Journal Entry Lines (the actual debit/credit rows — must balance per entry)
CREATE TABLE JournalEntryLines (
    LineID INT PRIMARY KEY IDENTITY(1,1),
    JournalEntryID INT FOREIGN KEY REFERENCES JournalEntries(JournalEntryID),
    AccountID INT FOREIGN KEY REFERENCES Accounts(AccountID),
    DebitAmountBSD DECIMAL(14,2) DEFAULT 0,
    CreditAmountBSD DECIMAL(14,2) DEFAULT 0,
    Description NVARCHAR(200)
);

-- Customer Invoices (AR)
CREATE TABLE Invoices (
    InvoiceID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    InvoiceDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    Status NVARCHAR(20) DEFAULT 'Unpaid', -- 'Unpaid','Partially Paid','Paid','Overdue'
    TotalAmountBSD DECIMAL(12,2) NOT NULL
);

CREATE TABLE InvoiceLines (
    InvoiceLineID INT PRIMARY KEY IDENTITY(1,1),
    InvoiceID INT FOREIGN KEY REFERENCES Invoices(InvoiceID),
    Description NVARCHAR(200),
    Quantity INT NOT NULL,
    UnitPriceBSD DECIMAL(10,2) NOT NULL,
    LineTotalBSD DECIMAL(12,2) NOT NULL,
    AccountID INT FOREIGN KEY REFERENCES Accounts(AccountID) -- revenue account
);

-- Vendor Bills (AP)
CREATE TABLE Bills (
    BillID INT PRIMARY KEY IDENTITY(1,1),
    VendorID INT FOREIGN KEY REFERENCES Vendors(VendorID),
    BillDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    Status NVARCHAR(20) DEFAULT 'Unpaid',
    TotalAmountBSD DECIMAL(12,2) NOT NULL
);

CREATE TABLE BillLines (
    BillLineID INT PRIMARY KEY IDENTITY(1,1),
    BillID INT FOREIGN KEY REFERENCES Bills(BillID),
    Description NVARCHAR(200),
    Quantity INT NOT NULL,
    UnitPriceBSD DECIMAL(10,2) NOT NULL,
    LineTotalBSD DECIMAL(12,2) NOT NULL,
    AccountID INT FOREIGN KEY REFERENCES Accounts(AccountID) -- expense account
);

-- Payments (covers both money received from customers and paid to vendors)
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    PaymentDate DATE NOT NULL,
    PaymentType NVARCHAR(10) NOT NULL, -- 'Received' or 'Paid'
    InvoiceID INT NULL FOREIGN KEY REFERENCES Invoices(InvoiceID),
    BillID INT NULL FOREIGN KEY REFERENCES Bills(BillID),
    AmountBSD DECIMAL(12,2) NOT NULL,
    PaymentMethod NVARCHAR(20), -- 'Cash','Bank Transfer','Cheque','Online'
    BankAccountID INT FOREIGN KEY REFERENCES BankAccounts(BankAccountID)
);
