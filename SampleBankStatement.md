# Sample Commercial Bank Transaction Text

Copy and paste the transactions below into the Import screen to test the import feature.

## Sample Transaction History (December 2025)

```
01/12/2025 SALARY CT0036 ABC COMPANY PRIVATE LIMITED 150,000.00
02/12/2025 PMT LOAN 4873937 3508386 MONTHLY INSTALLMENT 102,533.00
03/12/2025 PURCHASE OPENAI *CHATGPT SUBSCRIPTION MONTHLY 6,409.77
05/12/2025 PMT LOAN 9876543 LOAN DISBURSEMENT CREDIT 500,000.00
07/12/2025 PURCHASE KEELLS SUPER COLOMBO 03 BRANCH 8,500.00
08/12/2025 FAST CASH KADAWATH-CRM1 BR ATM WITHDRAWAL 10,000.00
10/12/2025 PURCHASE KFC COLOMBO CITY CENTER 3,200.00
11/12/2025 BILL PMT CEB ELECTRICITY BOARD PAYMENT 5,500.00
12/12/2025 PURCHASE KEELLS SUPER NUGEGODA BRANCH 7,200.00
14/12/2025 BILL PMT HUTCHISON TELECOM MOBILE 1,500.00
15/12/2025 PURCHASE PIZZA HUT NUGEGODA OUTLET 4,500.00
16/12/2025 WITHDRAWAL KADAWATHA-1 BR ATM CASH 10,000.00
18/12/2025 PURCHASE CARGILLS FOOD CITY MAHARAGAMA 9,300.00
20/12/2025 PURCHASE RESTAURANT GRAND COLOMBO 5,800.00
23/12/2025 FAST CASH COLOMBO-2 BR ATM WITHDRAWAL 10,000.00
25/12/2025 IB CEFT CHGS ONLINE TRANSFER FEE 25.00
28/12/2025 PURCHASE ARPICO SUPERCENTRE COLOMBO 4,750.00
29/12/2025 WITHDRAWAL NUGEGODA BR COUNTER CASH 5,000.00
```

## Expected Results

After importing and confirming, you should have:

**Income (2)**:
- Salary: Rs. 150,000.00 (included in earnings)
- Loan Credit: Rs. 500,000.00 (excluded from earnings)

**Expenses (15)**:
- Loan EMI: Rs. 102,533.00
- Subscriptions: Rs. 6,409.77
- Groceries: Rs. 29,750.00 (4 transactions)
- Cash Withdrawal: Rs. 35,000.00 (4 transactions)
- Dining Out: Rs. 13,500.00 (3 transactions)
- Utilities: Rs. 5,500.00
- Telecom: Rs. 1,500.00
- Bank Charges: Rs. 25.00

**Total Expenses**: Rs. 194,217.77
**Real Income**: Rs. 150,000.00
**Savings**: Rs. -44,217.77 (deficit)

## Testing Different Transaction Types

### Test 1: Basic Expense
```
15/01/2025 PURCHASE TEST STORE COLOMBO 1,500.00
```

### Test 2: Income
```
15/01/2025 SALARY CT0036 MY COMPANY NAME 100,000.00
```

### Test 3: Grocery
```
15/01/2025 PURCHASE KEELLS SUPER WELLAWATTE 5,200.00
```

### Test 4: Dining Out
```
15/01/2025 PURCHASE KFC KANDY CITY CENTER 2,800.00
```

### Test 5: Cash Withdrawal
```
15/01/2025 FAST CASH KANDY-ATM1 BR 5,000.00
```

### Test 6: Utility Bill
```
15/01/2025 BILL PMT CEB ELECTRICITY 3,500.00
```

### Test 7: Bank Charges
```
15/01/2025 IB CEFT CHGS TRANSFER FEE 50.00
```

### Test 8: Multiple Transactions
```
10/01/2025 PURCHASE CARGILLS FOOD CITY 6,500.00
11/01/2025 WITHDRAWAL COLOMBO-3 BR 8,000.00
12/01/2025 PURCHASE PIZZA HUT NEGOMBO 3,500.00
```

## Notes

- All dates are in dd/MM/yyyy format
- Amounts use comma separators for thousands
- The parser automatically detects transaction types
- You can edit categories before saving
- Loan credits are automatically marked as "exclude from earnings"
