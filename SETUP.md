# Setup Instructions for Xcode Project

This repository contains all the Swift source files for the Monthly Money Manager app. Since the Xcode project file cannot be properly created in a Linux environment, follow these steps to set up the project on macOS:

## Prerequisites

- macOS Ventura 13.0 or later
- Xcode 15.0 or later
- Basic familiarity with Xcode

## Step-by-Step Setup

### 1. Create New Xcode Project

1. Open Xcode
2. Select **File → New → Project**
3. Choose **iOS** → **App**
4. Click **Next**

### 2. Configure Project Settings

- **Product Name**: `MonthlyMoneyManager`
- **Team**: Select your team or personal team
- **Organization Identifier**: `com.yourname.monthlymoneymanager` (or your preference)
- **Bundle Identifier**: Will be auto-generated
- **Interface**: **SwiftUI**
- **Language**: **Swift**
- **Storage**: **SwiftData** (important!)
- **Include Tests**: Yes

Click **Next** and choose where to save the project.

### 3. Set Deployment Target

1. Select the project in the navigator
2. Select the **MonthlyMoneyManager** target
3. In **General** tab, set **Minimum Deployments** to **iOS 17.0**

### 4. Add Source Files

#### Delete Default Files
1. Delete the following files that Xcode created:
   - `ContentView.swift` (we have our own)
   - Any other placeholder files

#### Add Repository Files
1. In Finder, navigate to the cloned repository
2. Drag and drop the following folders into your Xcode project:
   - `MonthlyMoneyManager/Models/`
   - `MonthlyMoneyManager/ViewModels/`
   - `MonthlyMoneyManager/Views/`
   - `MonthlyMoneyManager/Services/`
   - `MonthlyMoneyManager/Utilities/`
   
3. When prompted, make sure to:
   - ✅ **Copy items if needed**
   - ✅ **Create groups** (not folder references)
   - ✅ **Add to targets: MonthlyMoneyManager**

#### Replace App File
1. Replace the default `MonthlyMoneyManagerApp.swift` with the one from the repository

### 5. Add Test Files

1. In the test target, delete any default test files
2. Drag and drop `MonthlyMoneyManager/Tests/` folder
3. When prompted:
   - ✅ **Copy items if needed**
   - ✅ **Add to targets: MonthlyMoneyManagerTests**

### 6. Verify File Structure

Your project navigator should look like this:

```
MonthlyMoneyManager/
├── MonthlyMoneyManagerApp.swift
├── Models/
│   ├── Enums.swift
│   ├── Transaction.swift
│   ├── Category.swift
│   ├── MonthlyBudget.swift
│   └── AppSettings.swift
├── ViewModels/
│   ├── DashboardViewModel.swift
│   ├── TransactionViewModel.swift
│   ├── BudgetViewModel.swift
│   ├── InsightsViewModel.swift
│   ├── ImportViewModel.swift
│   └── SettingsViewModel.swift
├── Views/
│   ├── Dashboard/
│   ├── Transactions/
│   ├── Import/
│   ├── Budgets/
│   ├── Insights/
│   ├── Settings/
│   └── Components/
├── Services/
│   ├── ImportParserService.swift
│   ├── CategorizationService.swift
│   ├── InsightsService.swift
│   └── DataSeeder.swift
├── Utilities/
│   ├── MonthKey.swift
│   ├── CurrencyFormat.swift
│   └── Extensions.swift
└── Info.plist

MonthlyMoneyManagerTests/
├── ImportParserTests.swift
└── CategorizationTests.swift
```

### 7. Build and Run

1. Select a simulator (e.g., iPhone 15 Pro)
2. Press **Cmd + B** to build
3. Fix any import or namespace issues if they arise
4. Press **Cmd + R** to run

### 8. Run Tests

1. Press **Cmd + U** to run all tests
2. Verify that ImportParserTests and CategorizationTests pass

## Common Issues and Solutions

### Issue: "Cannot find type 'Transaction' in scope"

**Solution**: Make sure all Model files are added to the target properly. Check the file inspector (right panel) and ensure "Target Membership" includes MonthlyMoneyManager.

### Issue: SwiftData import not found

**Solution**: 
1. Verify iOS deployment target is 17.0 or higher
2. Clean build folder: **Shift + Cmd + K**
3. Rebuild: **Cmd + B**

### Issue: Preview crashes or doesn't work

**Solution**: 
- Previews require proper SwiftData setup
- Try running on simulator instead
- Some ViewModels need model context which may not be available in previews

### Issue: Test target can't find source files

**Solution**:
1. Select the test file
2. Open File Inspector (right panel)
3. Under "Target Membership", ensure MonthlyMoneyManagerTests is checked
4. Make sure the test imports `@testable import MonthlyMoneyManager`

### Issue: App crashes on launch

**Solution**:
1. Check that `.modelContainer` includes all models in MonthlyMoneyManagerApp.swift
2. Verify DataSeeder is being called on app launch
3. Check console logs for specific error messages

## Project Configuration Summary

Once set up, your project should have these settings:

- **iOS Deployment Target**: 17.0
- **SwiftUI**: Yes
- **SwiftData**: Yes
- **Bundle ID**: com.yourname.monthlymoneymanager
- **Version**: 1.0
- **Build**: 1

## Alternative: Use Command Line (Advanced)

If you prefer command-line setup:

```bash
# Create Xcode project (requires macOS)
swift package init --type executable
# Then manually configure in Xcode
```

## Need Help?

If you encounter issues not covered here:

1. Check the main README.md for app documentation
2. Verify all files are correctly added to targets
3. Clean derived data: Xcode → Preferences → Locations → Derived Data → Delete
4. Restart Xcode

## Verification Checklist

Before running the app:

- [ ] All source files added to MonthlyMoneyManager target
- [ ] All test files added to MonthlyMoneyManagerTests target
- [ ] iOS deployment target set to 17.0
- [ ] SwiftData models registered in App file
- [ ] Project builds without errors
- [ ] Tests pass

## Next Steps

Once the project is set up:

1. **Run the app** - You'll see sample December 2025 data
2. **Explore features** - Dashboard, Transactions, Budgets, Insights
3. **Test import** - Try pasting sample transaction text
4. **Customize** - Adjust categories, budgets, and settings as needed

Happy coding! 🎉
