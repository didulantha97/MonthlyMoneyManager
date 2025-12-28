# Monthly Money Manager (LKR)

A comprehensive iOS app for tracking monthly income and expenses in Sri Lankan Rupees (LKR), with powerful features for importing Commercial Bank transactions, budget management, and actionable financial insights.

## Features

### 📊 Dashboard
- **Real Income Tracking**: Excludes loan credits from earnings calculation
- **Savings Analysis**: Real-time savings rate calculation
- **Fixed vs Variable Costs**: Breakdown of spending patterns
- **Smart Alerts**: Budget overruns, high cash withdrawals, and loan credit notifications

### 💳 Transaction Management
- **Manual Entry**: Add transactions with date, amount, description, and category
- **Bank Statement Import**: Parse and import Commercial Bank transaction text
- **Filtering**: Filter by month, type (income/expense), and category
- **Swipe Actions**: Quick delete on transaction rows
- **Pull-to-Refresh**: Keep data up to date

### 📥 Import from Bank Statements
- **Copy & Paste**: Simply paste transaction history from Commercial Bank PDF/statements
- **Auto-Classification**: Intelligent keyword-based categorization
- **Review & Edit**: Confirm and adjust categories before saving
- **Supported Formats**: Handles dd/MM/yyyy date format and comma-separated amounts

### 💰 Budget Management
- **Monthly Budgets**: Set spending limits for each category
- **Visual Progress**: Color-coded progress bars (green/yellow/red)
- **Copy Previous Month**: Quickly replicate last month's budgets
- **Budget Alerts**: Get notified when approaching or exceeding limits

### 💡 Actionable Insights
- **Top Spending Analysis**: See your top 5 spending categories
- **Personalized Recommendations**: 
  - Reduce specific categories to meet budgets
  - Limit cash withdrawal frequency
  - Consolidate grocery trips
  - Fixed cost analysis
- **Next Month Planning**: AI-suggested budgets based on spending patterns

### ⚙️ Settings
- **Weekly Caps**: Configure limits for cash, dining, and groceries
- **Savings Goal**: Set monthly savings targets
- **Transfer Preferences**: Choose how to treat transfer-out transactions

## Tech Stack

- **Language**: Swift 5+
- **UI Framework**: SwiftUI
- **Architecture**: MVVM (Model-View-ViewModel)
- **Persistence**: SwiftData
- **Mode**: Offline-first, no backend required
- **Currency**: LKR formatting with proper comma separators

## Project Structure

```
MonthlyMoneyManager/
├── MonthlyMoneyManagerApp.swift         # App entry point
├── Models/                               # Data models
│   ├── Transaction.swift
│   ├── Category.swift
│   ├── MonthlyBudget.swift
│   ├── AppSettings.swift
│   └── Enums.swift
├── ViewModels/                           # Business logic
│   ├── DashboardViewModel.swift
│   ├── TransactionViewModel.swift
│   ├── BudgetViewModel.swift
│   ├── InsightsViewModel.swift
│   ├── ImportViewModel.swift
│   └── SettingsViewModel.swift
├── Views/                                # UI components
│   ├── Dashboard/
│   ├── Transactions/
│   ├── Import/
│   ├── Budgets/
│   ├── Insights/
│   ├── Settings/
│   └── Components/
├── Services/                             # Core services
│   ├── ImportParserService.swift
│   ├── CategorizationService.swift
│   ├── InsightsService.swift
│   └── DataSeeder.swift
├── Utilities/                            # Helper utilities
│   ├── MonthKey.swift
│   ├── CurrencyFormat.swift
│   └── Extensions.swift
└── Tests/                                # Unit tests
    ├── ImportParserTests.swift
    └── CategorizationTests.swift
```

## Requirements

- **Xcode**: 15.0 or later
- **iOS**: 17.0 or later
- **macOS**: Ventura 13.0 or later (for development)

## How to Run

1. **Open the Project**:
   ```bash
   cd MonthlyMoneyManager
   open MonthlyMoneyManager.xcodeproj
   ```

2. **Select Target**: Choose your simulator or connected device

3. **Build and Run**: Press `Cmd + R` or click the Play button

4. **Sample Data**: The app includes pre-seeded data for December 2025 to demonstrate features

## How Import Works

### Step-by-Step Import Process

1. **Navigate to Transactions Tab**: Tap the "+" icon and select "Import from Bank"

2. **Copy Bank Statement**: 
   - Open your Commercial Bank PDF/statement
   - Copy the transaction history text

3. **Paste Text**: 
   - Paste the copied text into the import screen
   - Tap "Parse Transactions"

4. **Review & Confirm**:
   - Review automatically categorized transactions
   - Edit category or type if needed
   - Transactions marked as "Loan Credit" won't be included in earnings

5. **Save**: Tap "Save All Transactions" to import

### Supported Transaction Patterns

**Commercial Bank Format Examples**:
```
29/12/2025 PURCHASE OPENAI *CHATGPT SUB 6,409.77
25/12/2025 FAST CASH KADAWATH-CRM1 BR 10,000.00
20/12/2025 PURCHASE KEELLS SUPER COLOMBO 8,500.00
01/12/2025 SALARY CT0036 COMPANY NAME 150,000.00
02/12/2025 PMT LOAN 4873937 3508386 102,533.00
```

### Auto-Classification Rules

**Income Keywords**: `SALARY`, `CT0036`, `CEFTSURS`, `IB CEFT`, `CREDIT`

**Expense Keywords**:
- Cash: `FAST CASH`, `WITHDRAWAL`
- Groceries: `KEELLS`, `CARGILLS`, `FOOD MART`
- Dining: `KFC`, `PIZZA HUT`, `RESTAURANT`
- Utilities: `CEB`
- Telecom: `HUTCHISON`, `TELECOM`
- Subscriptions: `OPENAI`, `CHATGPT`
- Fees: `CHGS`

## Real Income Calculation

The app distinguishes between **real income** and **loan credits**:

### Why Loan Credit is Excluded

- **Loan Credit** represents loan disbursements, not actual earnings
- Including loan credits would artificially inflate your income and savings rate
- The `includeInEarnings` flag is set to `false` for loan credits

### Formula

```
Real Income = Sum of (Income Transactions where includeInEarnings = true)
Total Outflow = Sum of (All Expense Transactions)
Savings = Real Income - Total Outflow
Savings Rate = (Savings / Real Income) × 100
```

### Example

If you received:
- Salary: Rs. 150,000 (includeInEarnings = true)
- Loan Disbursement: Rs. 500,000 (includeInEarnings = false)

Your **Real Income** = Rs. 150,000 (not Rs. 650,000)

This gives you an accurate picture of your financial health.

## Budget Setup

### Creating Budgets

1. **Navigate to Budgets Tab**
2. **Tap "+" Icon** → Select "Set Budget"
3. **Choose Category**: Select from budgetable categories
4. **Enter Amount**: Set your monthly limit
5. **Save**: Budget is active for current month

### Copy from Previous Month

- Tap the "..." menu icon
- Select "Copy from Previous Month"
- All budgets from previous month are replicated

### Budget Progress

- **Green**: Under 80% of budget ✅
- **Yellow**: 80-99% of budget ⚠️
- **Red**: Over budget 🚫

## Insights Interpretation

### Recommendations

The app analyzes your spending and provides actionable recommendations:

#### High Priority (Red)
- **Budget Overruns**: Specific amount to reduce in each category
- Requires immediate attention

#### Medium Priority (Orange)
- **High Cash Withdrawal**: Too many withdrawals or high amounts
- **Frequent Dining Out**: More than 8 transactions per month
- Suggests behavior changes

#### Low Priority (Blue)
- **Grocery Trip Consolidation**: More than 12 trips per month
- **Fixed Cost Analysis**: When fixed costs exceed optimal percentage
- Long-term optimization

### Next Month Plan

Based on:
- **Current Spending**: Last month's actual spending
- **Savings Goal**: Your configured target
- **Historical Patterns**: Trends over time

**Suggestions**:
- **Fixed Costs**: Maintain current spending
- **Variable Costs**: Reduce by 10% to increase savings
- **Rationale**: Explanation for each suggestion

## Sample Data

The app includes pre-seeded data for **December 2025**:

### Income
- **Salary**: Rs. 150,000 (included in earnings)
- **Loan Credit**: Rs. 500,000 (excluded from earnings)

### Expenses
- **Loan EMI**: Rs. 102,533
- **Groceries**: Rs. 25,000 (3 transactions)
- **Dining Out**: Rs. 13,500 (3 transactions - **over budget**)
- **Cash Withdrawals**: Rs. 30,000 (3 transactions - **over budget**)
- **Subscriptions**: Rs. 6,409.77
- **Utilities**: Rs. 5,500
- **Telecom**: Rs. 1,500
- **Bank Charges**: Rs. 25

### Budgets
- Dining Out: Rs. 10,000 (overspent by Rs. 3,500)
- Groceries: Rs. 40,000
- Cash Withdrawal: Rs. 20,000 (overspent by Rs. 10,000)
- Utilities: Rs. 6,000
- Telecom: Rs. 2,000
- Subscriptions: Rs. 7,000

**This demonstrates**: Budget alerts, overspending warnings, and actionable insights.

## Testing

### Running Unit Tests

1. **Open Xcode**: Load the project
2. **Test Navigator**: Press `Cmd + 6`
3. **Run Tests**: Click the play icon next to test suite or press `Cmd + U`

### Test Coverage

**ImportParserTests**:
- ✅ Valid transaction parsing
- ✅ Multiple transaction handling
- ✅ Date format extraction (dd/MM/yyyy)
- ✅ Amount parsing with commas
- ✅ Income vs expense classification
- ✅ Edge cases (empty text, malformed data)

**CategorizationTests**:
- ✅ Keyword matching for all categories
- ✅ Loan Credit special case (includeInEarnings = false)
- ✅ Case-insensitive matching
- ✅ Default category fallback

### Test Data

Tests use realistic Commercial Bank transaction examples to ensure robust parsing.

## Currency Formatting

All amounts are formatted as:
- **Symbol**: Rs. (Sri Lankan Rupees)
- **Format**: `Rs. 150,000.00`
- **Separators**: Comma for thousands, decimal point for cents
- **Decimals**: Always 2 decimal places
- **Large Amounts**: Properly handles lakhs (e.g., Rs. 500,000.00)

### Examples
```swift
150000.00   → Rs. 150,000.00
6409.77     → Rs. 6,409.77
102533      → Rs. 102,533.00
```

## Architecture: MVVM

### Models
- SwiftData models with `@Model` macro
- Represent core business entities
- Persist data locally

### ViewModels
- Marked with `@Observable` for SwiftUI
- Contain business logic and state
- Fetch and transform data for views

### Views
- Pure SwiftUI declarative views
- Observe ViewModels for state changes
- No business logic

### Services
- Stateless utility services
- Parsing, categorization, insights generation
- Reusable across ViewModels

## Accessibility

- **VoiceOver**: All UI elements have proper labels
- **Dynamic Type**: Supports system font sizing
- **Dark Mode**: Full dark mode support
- **Color Contrast**: Meets WCAG guidelines

## Future Enhancements (V2)

- ✨ Export month data to CSV
- ☁️ iCloud sync across devices
- 🔒 FaceID/TouchID lock
- 📈 Charts and graphs for spending trends
- 📊 Multi-month comparison
- 🔄 Recurring transaction templates
- 🌍 Multiple currency support
- 📱 iPad optimization
- ⚡ Widgets for iOS home screen

## Troubleshooting

### Build Errors

**SwiftData Import Issues**:
- Ensure iOS deployment target is 17.0+
- Clean build folder: `Shift + Cmd + K`

**Model Context Issues**:
- Verify `.modelContainer` is added in App file
- Check all models are registered

### Import Issues

**No Transactions Found**:
- Verify date format is dd/MM/yyyy
- Ensure amounts have decimal points
- Check for proper line breaks between transactions

**Wrong Categories**:
- Use the confirmation screen to adjust
- Categories can be edited after import

## Contributing

This is a personal finance management tool. For bugs or feature requests, please document them clearly with:
- Steps to reproduce
- Expected behavior
- Actual behavior
- Screenshots if applicable

## License

This project is for personal use. Commercial use requires permission.

## Contact

For questions or support, please reach out to the repository owner.

---

**Built with ❤️ for better financial management in Sri Lanka**