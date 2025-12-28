# App Architecture Diagram

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      MonthlyMoneyManager                     │
│                     (SwiftUI + SwiftData)                    │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                         Tab Bar                              │
│  [Dashboard] [Transactions] [Budgets] [Insights] [Settings] │
└─────────────────────────────────────────────────────────────┘
```

## MVVM Pattern Flow

```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│              │         │              │         │              │
│    Views     │ ◄─────► │  ViewModels  │ ◄─────► │   Services   │
│   (SwiftUI)  │         │ (@Observable)│         │  (Stateless) │
│              │         │              │         │              │
└──────────────┘         └──────────────┘         └──────────────┘
                                │                         │
                                │                         │
                                ▼                         ▼
                         ┌──────────────┐         ┌──────────────┐
                         │              │         │              │
                         │    Models    │ ◄───────│ SwiftData    │
                         │  (@Model)    │         │ ModelContext │
                         │              │         │              │
                         └──────────────┘         └──────────────┘
```

## Data Flow Example: Import Transaction

```
User Action
    │
    ▼
ImportView (Paste Text)
    │
    ▼
ImportViewModel.parseText()
    │
    ▼
ImportParserService.parse()
    ├─── Extract Date (dd/MM/yyyy)
    ├─── Extract Amount (comma-separated)
    └─── Classify by Keywords
    │
    ▼
ParsedTransaction[]
    │
    ▼
TransactionConfirmationView (Review)
    │
    ▼
ImportViewModel.saveTransactions()
    │
    ▼
SwiftData ModelContext.insert()
    │
    ▼
Transaction Persisted ✅
```

## Module Dependencies

```
┌─────────────────────────────────────────────────────────────┐
│                          Views                               │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │Dashboard │  │Transaction│ │  Budget  │  │ Insights │   │
│  │   View   │  │   View    │ │   View   │  │   View   │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
                      │     │     │     │
                      ▼     ▼     ▼     ▼
┌─────────────────────────────────────────────────────────────┐
│                       ViewModels                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │Dashboard │  │Transaction│ │  Budget  │  │ Insights │   │
│  │ViewModel │  │ViewModel  │ │ViewModel │  │ViewModel │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
          │                 │                      │
          ▼                 ▼                      ▼
┌────────────────┐  ┌────────────────┐  ┌────────────────┐
│  DataSeeder    │  │ ImportParser   │  │ Insights       │
│  Service       │  │ Service        │  │ Service        │
└────────────────┘  └────────────────┘  └────────────────┘
          │                 │                      │
          └─────────────────┼──────────────────────┘
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                      SwiftData Models                        │
│  [Transaction] [Category] [MonthlyBudget] [AppSettings]    │
└─────────────────────────────────────────────────────────────┘
```

## Feature Breakdown

### 1. Dashboard Feature

```
DashboardView
    │
    ├─── MonthYearPicker
    │
    ├─── SummaryCardView (Real Income)
    ├─── SummaryCardView (Total Outflow)
    ├─── SummaryCardView (Savings)
    │
    ├─── Cost Breakdown (Fixed vs Variable)
    │
    └─── Warnings/Alerts List
         ├─── "Loan credit excluded"
         ├─── "Dining out overspent by X"
         └─── "Cash withdrawal high"

DashboardViewModel
    │
    ├─── fetchTransactions() → Filter by month
    ├─── fetchCategories() → Get category details
    ├─── fetchBudgets() → Get budget limits
    │
    ├─── calculateRealIncome() → Sum (income where includeInEarnings)
    ├─── calculateTotalOutflow() → Sum (all expenses)
    ├─── calculateSavings() → Income - Outflow
    ├─── calculateSavingsRate() → (Savings / Income) × 100
    │
    └─── generateWarnings() → Check budgets, loan credits, cash
```

### 2. Transaction Import Feature

```
TransactionsView
    │
    ├─── + Button → Menu
         ├─── Add Manual → AddTransactionView
         └─── Import from Bank → ImportView

ImportView
    │
    ├─── TextEditor (Paste text area)
    ├─── Parse Button
    │
    └─── ImportViewModel
         │
         ├─── pastedText: String
         ├─── parseText()
         │    │
         │    └─── ImportParserService.parse()
         │         │
         │         ├─── Split by lines
         │         ├─── Extract date (regex: dd/MM/yyyy)
         │         ├─── Extract amount (regex: \d+,?\d+\.\d{2})
         │         ├─── Classify transaction type
         │         │    ├─── Check expense keywords
         │         │    └─── Check income keywords
         │         │
         │         └─── Return ParsedTransaction[]
         │
         └─── saveTransactions()
              │
              └─── For each ParsedTransaction:
                   └─── ModelContext.insert(Transaction)

TransactionConfirmationView
    │
    ├─── List of ParsedTransactions
    │    │
    │    └─── Each row:
    │         ├─── Date, Amount, Description
    │         ├─── Type Picker (Income/Expense)
    │         └─── Category Picker
    │
    └─── Save All Button
```

### 3. Budget Management Feature

```
BudgetsView
    │
    ├─── MonthYearPicker
    │
    ├─── Budget Progress List
    │    │
    │    └─── BudgetCardView (for each budget)
    │         ├─── Category Name + Fixed Badge
    │         ├─── Spent vs Budget amounts
    │         ├─── ProgressBar (color-coded)
    │         └─── Percentage used + Remaining
    │
    └─── Actions Menu
         ├─── Set Budget
         └─── Copy from Previous Month

BudgetViewModel
    │
    ├─── fetchBudgets() → Get budgets for month
    ├─── fetchTransactions() → Get expenses for month
    ├─── fetchCategories() → Get category details
    │
    ├─── calculateProgress()
    │    │
    │    └─── For each budget:
    │         ├─── spent = Sum(expenses for category)
    │         ├─── remaining = budget - spent
    │         ├─── percentage = (spent / budget) × 100
    │         └─── color = Green/Yellow/Red based on %
    │
    ├─── setBudget(categoryId, amount)
    └─── copyFromPreviousMonth()
```

### 4. Insights Generation Feature

```
InsightsView
    │
    ├─── Top Spending Categories (Top 5)
    │    └─── Horizontal bar chart representation
    │
    ├─── Recommendations
    │    └─── RecommendationCardView (for each)
    │         ├─── Priority Icon (High/Medium/Low)
    │         ├─── Title
    │         └─── Message
    │
    └─── Next Month Plan
         └─── NextMonthPlanView
              └─── Budget Suggestions
                   ├─── Category Name
                   ├─── Current → Suggested
                   └─── Reasoning

InsightsService
    │
    ├─── generateRecommendations()
    │    │
    │    ├─── Check Budget Overruns
    │    │    └─── If spent > budget: Recommend reduction
    │    │
    │    ├─── Check Cash Withdrawal Frequency
    │    │    └─── If count > 4: Recommend weekly cap
    │    │
    │    ├─── Check Dining Out Frequency
    │    │    └─── If count > 8: Recommend reduction
    │    │
    │    └─── Check Grocery Frequency
    │         └─── If count > 12: Recommend consolidation
    │
    └─── generateBudgetSuggestions()
         │
         └─── For each expense category:
              ├─── If fixed: Suggest current spending
              └─── If variable: Suggest 10% reduction
```

## Data Models Relationships

```
┌─────────────────┐
│  AppSettings    │
│  ┌───────────┐  │
│  │WeeklyCaps │  │
│  │ - cash    │  │
│  │ - dining  │  │
│  │ - grocery │  │
│  └───────────┘  │
└─────────────────┘

┌─────────────────┐        ┌─────────────────┐
│  Transaction    │───────▶│    Category     │
│  - id           │        │    - id         │
│  - date         │        │    - name       │
│  - amount       │        │    - kind       │
│  - type         │        │    - keywords[] │
│  - categoryId   │        │    - isFixed    │
│  - includeIn... │        │    - isBudget.. │
│  - source       │        └─────────────────┘
└─────────────────┘                 ▲
                                    │
                          ┌─────────────────┐
                          │ MonthlyBudget   │
                          │  - id           │
                          │  - monthKey     │
                          │  - categoryId   │
                          │  - limitAmount  │
                          └─────────────────┘
```

## Import Parser Flow (Detailed)

```
Input Text:
"29/12/2025 PURCHASE OPENAI *CHATGPT SUB 6,409.77"
    │
    ▼
1. Split by newlines
    │
    ▼
2. For each line:
   Check for date pattern (dd/MM/yyyy)
    │
    ├─── If date found:
    │    ├─── Save previous transaction
    │    ├─── Extract date: 29/12/2025
    │    ├─── Extract remaining text: "PURCHASE OPENAI..."
    │    └─── Extract amount: 6,409.77
    │
    └─── If no date:
         └─── Append to current description
    │
    ▼
3. Classify transaction:
   description.contains("OPENAI") || description.contains("CHATGPT")
    │
    ├─── Type: Expense
    ├─── Category: "Subscriptions"
    └─── includeInEarnings: true
    │
    ▼
4. Create ParsedTransaction:
   - date: 2025-12-29
   - amount: 6409.77
   - description: "PURCHASE OPENAI *CHATGPT SUB"
   - type: .expense
   - suggestedCategoryName: "Subscriptions"
   - includeInEarnings: true
    │
    ▼
Output: ParsedTransaction[]
```

## State Management Flow

```
View Creates ViewModel
    │
    ▼
ViewModel marked @Observable
    │
    ▼
View observes ViewModel properties
    │
    ▼
User Interaction (tap, input, etc.)
    │
    ▼
View calls ViewModel method
    │
    ▼
ViewModel updates properties
    │
    ▼
SwiftUI automatically re-renders View
```

Example:
```swift
@Observable
class DashboardViewModel {
    var realIncome: Decimal = 0  // Observed property
    
    func loadData() {
        // Fetch and calculate
        realIncome = calculateRealIncome()
        // View automatically updates when realIncome changes
    }
}
```

## File Organization Visual

```
MonthlyMoneyManager/
│
├── 📱 MonthlyMoneyManagerApp.swift (Entry Point)
│   └── ContentView with TabView
│
├── 📦 Models/ (Data Layer)
│   ├── Transaction.swift
│   ├── Category.swift
│   ├── MonthlyBudget.swift
│   ├── AppSettings.swift
│   └── Enums.swift
│
├── 🧠 ViewModels/ (Business Logic)
│   ├── DashboardViewModel.swift
│   ├── TransactionViewModel.swift
│   ├── BudgetViewModel.swift
│   ├── InsightsViewModel.swift
│   ├── ImportViewModel.swift
│   └── SettingsViewModel.swift
│
├── 🎨 Views/ (UI Layer)
│   ├── Dashboard/
│   ├── Transactions/
│   ├── Import/
│   ├── Budgets/
│   ├── Insights/
│   ├── Settings/
│   └── Components/
│
├── ⚙️ Services/ (Business Services)
│   ├── ImportParserService.swift
│   ├── CategorizationService.swift
│   ├── InsightsService.swift
│   └── DataSeeder.swift
│
├── 🛠️ Utilities/ (Helpers)
│   ├── MonthKey.swift
│   ├── CurrencyFormat.swift
│   └── Extensions.swift
│
└── ✅ Tests/
    ├── ImportParserTests.swift
    └── CategorizationTests.swift
```

## Key Design Decisions

### 1. Why `includeInEarnings` Flag?

```
Problem: Loan disbursements inflate income calculation
Solution: Flag to exclude from real income

Example:
  Salary: Rs. 150,000 (includeInEarnings = true)  ✅
  Loan:   Rs. 500,000 (includeInEarnings = false) ❌
  
  Real Income = Rs. 150,000 (accurate)
  Not Rs. 650,000 (misleading)
```

### 2. Why Separate Parser Service?

```
Reason: Testability and reusability
- Pure function (no state)
- Easy to unit test
- Can be used in multiple contexts
- Clear separation of concerns
```

### 3. Why MVVM Pattern?

```
Benefits:
- Clear separation: View ↔ ViewModel ↔ Model
- Testable: ViewModels can be unit tested
- SwiftUI integration: @Observable works seamlessly
- Maintainable: Each layer has single responsibility
```

### 4. Why SwiftData over CoreData?

```
Advantages:
- Modern Swift API (no Objective-C baggage)
- Type-safe with @Model macro
- Less boilerplate code
- Native SwiftUI integration
- Better performance
```

---

This architecture ensures:
- ✅ Scalability
- ✅ Maintainability
- ✅ Testability
- ✅ Clear separation of concerns
- ✅ Easy to understand and extend
