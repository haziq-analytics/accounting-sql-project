USE SinarFinanceDB;
GO

-- ACCOUNTS (Chart of Accounts, hierarchy: parent accounts first)
INSERT INTO Accounts (AccountCode, AccountName, AccountType, ParentAccountID) VALUES
('1000', 'Assets', 'Asset', NULL),
('2000', 'Liabilities', 'Liability', NULL),
('3000', 'Equity', 'Equity', NULL),
('4000', 'Revenue', 'Revenue', NULL),
('5000', 'Expenses', 'Expense', NULL);

INSERT INTO Accounts (AccountCode, AccountName, AccountType, ParentAccountID) VALUES
('1100', 'Cash and Bank', 'Asset', 1),
('1200', 'Accounts Receivable', 'Asset', 1),
('1300', 'Inventory', 'Asset', 1),
('2100', 'Accounts Payable', 'Liability', 2),
('2200', 'Loans Payable', 'Liability', 2),
('3100', 'Owner''s Capital', 'Equity', 3),
('3200', 'Retained Earnings', 'Equity', 3),
('4100', 'Sales Revenue', 'Revenue', 4),
('4200', 'Service Revenue', 'Revenue', 4),
('5100', 'Salaries Expense', 'Expense', 5),
('5200', 'Rent Expense', 'Expense', 5),
('5300', 'Utilities Expense', 'Expense', 5),
('5400', 'Office Supplies Expense', 'Expense', 5);

-- FISCAL PERIODS
INSERT INTO FiscalPeriods (PeriodName, StartDate, EndDate, IsClosed) VALUES
('Jan 2026', '2026-01-01', '2026-01-31', 1),
('Feb 2026', '2026-02-01', '2026-02-28', 1),
('Mar 2026', '2026-03-01', '2026-03-31', 1),
('Apr 2026', '2026-04-01', '2026-04-30', 1),
('May 2026', '2026-05-01', '2026-05-31', 1),
('Jun 2026', '2026-06-01', '2026-06-30', 0);

-- CUSTOMERS
INSERT INTO Customers (CustomerName, ContactEmail, Phone, Address, CreditLimitBSD, IsActive) VALUES
('Hengyi Trading Sdn Bhd', 'accounts@hengyi.bn', '2451234', 'Kg Beribi, BSB', 15000, 1),
('QAF Brunei Sdn Bhd', 'finance@qaf.bn', '2452345', 'Jalan Gadong, BSB', 20000, 1),
('Dillenia Ventures', 'admin@dillenia.bn', '2453456', 'Kiulap, BSB', 10000, 1),
('Baiduri Properties', 'ap@baiduriprop.bn', '2454567', 'Kg Kiarong, BSB', 25000, 1),
('Serusop Enterprises', 'contact@serusop.bn', '2455678', 'Tutong Town', 8000, 1),
('Muara Port Services', 'billing@muaraport.bn', '2456789', 'Muara', 12000, 1),
('Sengkurong Auto Parts', 'sales@sengkurong.bn', '2457890', 'Sengkurong', 6000, 1),
('Kuala Belait Traders', 'info@kbtraders.bn', '3221234', 'Kuala Belait', 9000, 1);

-- VENDORS
INSERT INTO Vendors (VendorName, ContactEmail, Phone, Address, IsActive) VALUES
('DST Communications', 'billing@dst.bn', '2331111', 'Gadong, BSB', 1),
('Progresif Cellular', 'ar@progresif.bn', '2332222', 'Kiarong, BSB', 1),
('Berakas Power Supply', 'accounts@bpc.bn', '2333333', 'Berakas, BSB', 1),
('Hua Ho Wholesale', 'wholesale@huaho.bn', '2334444', 'Beribi, BSB', 1),
('Sunlite Stationery', 'sales@sunlite.bn', '2335555', 'Kiulap, BSB', 1),
('Excellent Facility Mgmt', 'admin@excellentfm.bn', '2336666', 'Gadong, BSB', 1),
('Brunei Shell Petroleum', 'invoicing@bsp.com.bn', '2337777', 'Panaga', 1);

-- BANK ACCOUNTS
INSERT INTO BankAccounts (AccountName, BankName, AccountNumber, CurrentBalanceBSD) VALUES
('Sinar Operating Account', 'Baiduri Bank', 'BB-00123456', 85000.00),
('Sinar Payroll Account', 'BIBD', 'BIBD-00987654', 32000.00),
('Sinar Savings Account', 'Baiduri Bank', 'BB-00654321', 150000.00);

-- JOURNAL ENTRIES (headers)
INSERT INTO JournalEntries (EntryDate, Description, PeriodID, IsPosted) VALUES
('2026-01-05', 'Sale to Hengyi Trading', 1, 1),
('2026-01-10', 'Paid rent for January', 1, 1),
('2026-01-15', 'Purchased office supplies', 1, 1),
('2026-02-03', 'Sale to QAF Brunei', 2, 1),
('2026-02-08', 'Paid salaries February', 2, 1),
('2026-02-20', 'Utilities bill payment', 2, 1),
('2026-03-05', 'Sale to Dillenia Ventures', 3, 1),
('2026-03-12', 'Paid DST phone bill', 3, 1),
('2026-04-02', 'Sale to Baiduri Properties', 4, 1),
('2026-04-18', 'Loan repayment installment', 4, 1),
('2026-05-06', 'Sale to Serusop Enterprises', 5, 1),
('2026-05-15', 'Paid rent for May', 5, 1),
('2026-06-04', 'Sale to Muara Port Services', 6, 0),
('2026-06-10', 'Purchased fuel from BSP', 6, 0);

-- JOURNAL ENTRY LINES (each entry must balance: total debit = total credit)
INSERT INTO JournalEntryLines (JournalEntryID, AccountID, DebitAmountBSD, CreditAmountBSD, Description) VALUES
-- Entry 1: Sale to Hengyi (AR debit, Revenue credit)
(1, 7, 5200.00, 0, 'Invoice to Hengyi Trading'),
(1, 13, 0, 5200.00, 'Sales revenue recognized'),
-- Entry 2: Paid rent
(2, 16, 1800.00, 0, 'January rent'),
(2, 6, 0, 1800.00, 'Paid from bank'),
-- Entry 3: Office supplies
(3, 18, 350.00, 0, 'Supplies purchase'),
(3, 6, 0, 350.00, 'Paid from bank'),
-- Entry 4: Sale to QAF
(4, 7, 8100.00, 0, 'Invoice to QAF Brunei'),
(4, 13, 0, 8100.00, 'Sales revenue recognized'),
-- Entry 5: Salaries
(5, 15, 12000.00, 0, 'February salaries'),
(5, 6, 0, 12000.00, 'Paid from payroll account'),
-- Entry 6: Utilities
(6, 17, 620.00, 0, 'Electricity and water'),
(6, 6, 0, 620.00, 'Paid from bank'),
-- Entry 7: Sale to Dillenia
(7, 7, 3400.00, 0, 'Invoice to Dillenia Ventures'),
(7, 13, 0, 3400.00, 'Sales revenue recognized'),
-- Entry 8: DST bill
(8, 17, 210.00, 0, 'Phone and internet'),
(8, 6, 0, 210.00, 'Paid from bank'),
-- Entry 9: Sale to Baiduri Properties
(9, 7, 9600.00, 0, 'Invoice to Baiduri Properties'),
(9, 13, 0, 9600.00, 'Sales revenue recognized'),
-- Entry 10: Loan repayment
(10, 9, 2500.00, 0, 'Loan principal + interest'),
(10, 6, 0, 2500.00, 'Paid from bank'),
-- Entry 11: Sale to Serusop
(11, 7, 4750.00, 0, 'Invoice to Serusop Enterprises'),
(11, 13, 0, 4750.00, 'Sales revenue recognized'),
-- Entry 12: Rent May
(12, 16, 1800.00, 0, 'May rent'),
(12, 6, 0, 1800.00, 'Paid from bank'),
-- Entry 13: Sale to Muara Port (unposted)
(13, 7, 6300.00, 0, 'Invoice to Muara Port Services'),
(13, 13, 0, 6300.00, 'Sales revenue recognized'),
-- Entry 14: Fuel purchase (unposted)
(14, 17, 480.00, 0, 'Fuel for company vehicles'),
(14, 8, 0, 480.00, 'On credit from BSP');

-- INVOICES (AR)
INSERT INTO Invoices (CustomerID, InvoiceDate, DueDate, Status, TotalAmountBSD) VALUES
(1, '2026-01-05', '2026-02-04', 'Paid', 5200.00),
(2, '2026-02-03', '2026-03-05', 'Paid', 8100.00),
(3, '2026-03-05', '2026-04-04', 'Paid', 3400.00),
(4, '2026-04-02', '2026-05-02', 'Partially Paid', 9600.00),
(5, '2026-05-06', '2026-06-05', 'Unpaid', 4750.00),
(6, '2026-06-04', '2026-07-04', 'Unpaid', 6300.00),
(7, '2026-05-20', '2026-06-19', 'Overdue', 2100.00),
(8, '2026-06-15', '2026-07-15', 'Unpaid', 3850.00);

-- INVOICE LINES
INSERT INTO InvoiceLines (InvoiceID, Description, Quantity, UnitPriceBSD, LineTotalBSD, AccountID) VALUES
(1, 'Consulting services', 1, 5200.00, 5200.00, 13),
(2, 'Bulk product supply', 1, 8100.00, 8100.00, 13),
(3, 'Advisory services', 1, 3400.00, 3400.00, 13),
(4, 'Property management fee', 1, 9600.00, 9600.00, 13),
(5, 'Logistics support', 1, 4750.00, 4750.00, 13),
(6, 'Port handling services', 1, 6300.00, 6300.00, 13),
(7, 'Auto parts supply', 1, 2100.00, 2100.00, 13),
(8, 'Trading commission', 1, 3850.00, 3850.00, 13);

-- BILLS (AP)
INSERT INTO Bills (VendorID, BillDate, DueDate, Status, TotalAmountBSD) VALUES
(1, '2026-01-08', '2026-02-07', 'Paid', 210.00),
(3, '2026-02-15', '2026-03-17', 'Paid', 620.00),
(5, '2026-01-12', '2026-02-11', 'Paid', 350.00),
(2, '2026-03-10', '2026-04-09', 'Unpaid', 245.00),
(7, '2026-06-10', '2026-07-10', 'Unpaid', 480.00),
(6, '2026-04-25', '2026-05-25', 'Overdue', 900.00),
(4, '2026-05-05', '2026-06-04', 'Paid', 1500.00);

-- BILL LINES
INSERT INTO BillLines (BillID, Description, Quantity, UnitPriceBSD, LineTotalBSD, AccountID) VALUES
(1, 'Phone and internet plan', 1, 210.00, 210.00, 17),
(2, 'Electricity and water', 1, 620.00, 620.00, 17),
(3, 'Office stationery bulk order', 1, 350.00, 350.00, 18),
(4, 'Mobile data plan', 1, 245.00, 245.00, 17),
(5, 'Fuel for vehicles', 1, 480.00, 480.00, 17),
(6, 'Facility maintenance', 1, 900.00, 900.00, 17),
(7, 'Wholesale goods restock', 1, 1500.00, 1500.00, 18);

-- PAYMENTS
INSERT INTO Payments (PaymentDate, PaymentType, InvoiceID, BillID, AmountBSD, PaymentMethod, BankAccountID) VALUES
('2026-02-01', 'Received', 1, NULL, 5200.00, 'Bank Transfer', 1),
('2026-03-01', 'Received', 2, NULL, 8100.00, 'Bank Transfer', 1),
('2026-04-01', 'Received', 3, NULL, 3400.00, 'Cheque', 1),
('2026-04-20', 'Received', 4, NULL, 5000.00, 'Bank Transfer', 1), -- partial payment
('2026-01-20', 'Paid', NULL, 1, 210.00, 'Online', 1),
('2026-02-25', 'Paid', NULL, 2, 620.00, 'Online', 1),
('2026-01-25', 'Paid', NULL, 3, 350.00, 'Cash', 1),
('2026-05-10', 'Paid', NULL, 7, 1500.00, 'Bank Transfer', 1);
