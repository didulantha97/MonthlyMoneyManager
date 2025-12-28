# Quick Start Guide

## For Developers Opening This Project

### TL;DR

This is a complete iOS app written in Swift/SwiftUI with SwiftData. All source files are in the `MonthlyMoneyManager/` directory. You need to create an Xcode project and add these files.

### Fast Track Setup (5 minutes)

1. **Open Xcode** → **File → New → Project**
2. Choose **iOS App** with **SwiftUI** and **SwiftData**
3. Name it `MonthlyMoneyManager`, iOS 17.0 minimum
4. **Delete** Xcode's default `ContentView.swift`
5. **Drag & drop** all folders from this repo into Xcode:
   - `MonthlyMoneyManager/Models/`
   - `MonthlyMoneyManager/ViewModels/`
   - `MonthlyMoneyManager/Views/`
   - `MonthlyMoneyManager/Services/`
   - `MonthlyMoneyManager/Utilities/`
   - `MonthlyMoneyManager/Tests/` (into test target)
6. **Replace** `MonthlyMoneyManagerApp.swift` with repo version
7. **Build**: `Cmd + B`
8. **Run**: `Cmd + R`

### What You'll See

- **Dashboard** with sample December 2025 data
- **Transactions** list with Rs. 150,000 salary and expenses
- **Import** feature ready to paste bank statements
- **Budgets** with visual progress bars
- **Insights** with actionable recommendations
- **Settings** for app preferences

### Key Files to Understand

| File | Purpose |
|------|---------|
| `MonthlyMoneyManagerApp.swift` | App entry point, seeds data |
| `Services/ImportParserService.swift` | **Critical**: Parses bank statements |
| `Services/DataSeeder.swift` | Creates sample data |
| `Models/Transaction.swift` | Core data model |
| `ViewModels/DashboardViewModel.swift` | Real income calculation |
| `Views/Import/ImportView.swift` | Bank import UI |

### Testing Import Feature

1. Run app → **Transactions** tab
2. Tap **+** → **Import from Bank**
3. Copy from `SampleBankStatement.md`
4. Paste and tap **Parse Transactions**
5. Review and tap **Save All Transactions**

### Running Tests

```bash
# In Xcode
Cmd + U  # Run all tests
```

Tests cover:
- ✅ Date parsing (dd/MM/yyyy)
- ✅ Amount extraction with commas
- ✅ Auto-categorization by keywords
- ✅ Loan credit special handling

### Architecture Overview

```
SwiftUI Views → ViewModels (@Observable) → Services → SwiftData Models
```

**Data Flow**:
1. Views bind to ViewModels
2. ViewModels fetch from SwiftData via ModelContext
3. Services provide business logic
4. Models persist with SwiftData

### Important Concepts

#### Real Income Calculation
```swift
// Salary: Rs. 150,000 (includeInEarnings = true)  ✅ Counted
// Loan:   Rs. 500,000 (includeInEarnings = false) ❌ Excluded
// Real Income = Rs. 150,000
```

#### Transaction Import Flow
```
Bank Text → Parser → ParsedTransaction[] → Review UI → Save to SwiftData
```

#### Budget Progress Colors
- **Green**: < 80% used
- **Yellow**: 80-99% used
- **Red**: ≥ 100% used

### Common Tasks

#### Add New Category
1. Edit `Services/DataSeeder.swift`
2. Add to `expenseCategories` or `incomeCategories`
3. Set keywords for auto-classification

#### Change Currency Format
1. Edit `Utilities/CurrencyFormat.swift`
2. Modify `formatLKR()` method

#### Add New Insight
1. Edit `Services/InsightsService.swift`
2. Add logic in `generateRecommendations()`

### Project Stats

- **Swift Files**: 42
- **Lines of Code**: ~4,500
- **Models**: 5 (Transaction, Category, MonthlyBudget, AppSettings, Enums)
- **ViewModels**: 6 (Dashboard, Transaction, Budget, Insights, Import, Settings)
- **Views**: 20+ (Dashboard, Transactions, Import, Budgets, Insights, Settings)
- **Services**: 4 (Parser, Categorization, Insights, DataSeeder)
- **Tests**: 22 unit tests

### Troubleshooting

**Build fails?**
- Check iOS deployment target: 17.0+
- Clean build folder: `Shift + Cmd + K`
- Verify all files added to target

**App crashes on launch?**
- Check ModelContainer includes all models
- Verify DataSeeder is called in `onAppear`

**Import doesn't work?**
- Test with `SampleBankStatement.md` examples
- Check date format: dd/MM/yyyy
- Verify amount has decimal: 1,234.56

### What's Already Implemented

✅ **All MVP Features**:
- Dashboard with real income calculation
- Transaction CRUD with filters
- Bank statement import with parser
- Budget management with progress
- Actionable insights
- Settings for preferences
- Sample data seeding
- Unit tests

✅ **UI/UX Features**:
- Month picker navigation
- Swipe to delete
- Pull to refresh
- Color-coded categories
- Progress bars
- Warning alerts
- Dark mode support

### What's NOT Implemented (V2)

❌ Export to CSV
❌ iCloud sync
❌ FaceID/TouchID
❌ Charts/graphs
❌ Multi-month comparison
❌ Recurring transactions
❌ iPad optimization

### Contributing

Before making changes:
1. Read the main `README.md`
2. Understand MVVM architecture
3. Follow Swift naming conventions
4. Add unit tests for new features
5. Update documentation

### Resources

- **Full Docs**: `README.md` (400+ lines)
- **Setup Guide**: `SETUP.md`
- **Test Data**: `SampleBankStatement.md`
- **SwiftData**: [Apple Docs](https://developer.apple.com/documentation/swiftdata)
- **SwiftUI**: [Apple Docs](https://developer.apple.com/documentation/swiftui)

### Contact

Questions? Check the repository issues or documentation.

---

**Ready to build?** Follow the Fast Track Setup above! 🚀
