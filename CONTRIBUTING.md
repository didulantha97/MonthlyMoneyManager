# Contributing to Monthly Money Manager

Thank you for your interest in contributing to Monthly Money Manager! This document provides guidelines and best practices.

## Code of Conduct

- Be respectful and constructive
- Focus on the issue, not the person
- Help others learn and grow
- Follow Swift and iOS best practices

## Development Environment

### Prerequisites
- macOS Ventura 13.0+
- Xcode 15.0+
- iOS 17.0+ device or simulator
- Basic Swift/SwiftUI knowledge

### Setup
1. Fork the repository
2. Clone your fork
3. Follow `SETUP.md` to create Xcode project
4. Create a feature branch: `git checkout -b feature/your-feature-name`

## Architecture Guidelines

### MVVM Pattern

**Models** (SwiftData):
```swift
@Model
class Transaction {
    var id: UUID
    var amount: Decimal
    // ... properties
}
```

**ViewModels** (@Observable):
```swift
@Observable
class DashboardViewModel {
    private var modelContext: ModelContext
    
    func loadData() {
        // Fetch from SwiftData
        // Transform data for views
    }
}
```

**Views** (SwiftUI):
```swift
struct DashboardView: View {
    @State private var viewModel: DashboardViewModel?
    
    var body: some View {
        // Pure UI, no business logic
    }
}
```

### Services (Stateless):
```swift
class ImportParserService {
    static func parse(_ text: String) -> [ParsedTransaction] {
        // Pure function, no state
    }
}
```

## Coding Standards

### Swift Style

1. **Naming**:
   ```swift
   // Good
   var realIncome: Decimal
   func calculateSavingsRate() -> Double
   
   // Bad
   var real_income: Decimal
   func calc_savings() -> Double
   ```

2. **Properties**:
   ```swift
   // Use computed properties when appropriate
   var savings: Decimal {
       realIncome - totalOutflow
   }
   ```

3. **Access Control**:
   ```swift
   // Explicit access modifiers
   private var modelContext: ModelContext
   public func loadData()
   ```

4. **Comments**:
   ```swift
   // Use for complex logic only
   /// Calculate real income (excludes loan credits)
   func calculateRealIncome() -> Decimal {
       // ...
   }
   ```

### SwiftUI Best Practices

1. **Extract Complex Views**:
   ```swift
   // Good
   struct BudgetProgressView: View {
       var budget: BudgetProgress
       var body: some View { /* ... */ }
   }
   
   // Use in parent
   ForEach(budgets) { budget in
       BudgetProgressView(budget: budget)
   }
   ```

2. **State Management**:
   ```swift
   // Local state
   @State private var isShowingSheet = false
   
   // Observed ViewModel
   @State private var viewModel: DashboardViewModel?
   
   // Environment
   @Environment(\.modelContext) private var modelContext
   ```

3. **Async Operations**:
   ```swift
   .task {
       await viewModel.loadData()
   }
   ```

## Adding Features

### 1. Add New Transaction Category

**Step 1**: Update `DataSeeder.swift`
```swift
Category(
    name: "Transportation",
    kind: .expense,
    isBudgetable: true,
    keywords: ["UBER", "TAXI", "GRAB"],
    colorHex: "#5AC8FA"
)
```

**Step 2**: Update `ImportParserService.swift`
```swift
if description.contains("UBER") || description.contains("TAXI") {
    return (.expense, "Transportation", true)
}
```

**Step 3**: Add tests in `CategorizationTests.swift`

### 2. Add New Insight Rule

**Update** `InsightsService.swift`:
```swift
// In generateRecommendations()
if transportationSpending > threshold {
    recommendations.append(Recommendation(
        title: "High Transportation Costs",
        message: "Consider carpooling or public transport",
        priority: .medium
    ))
}
```

### 3. Add New View

**Create** `Views/NewFeature/NewView.swift`:
```swift
struct NewView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: NewViewModel?
    
    var body: some View {
        NavigationView {
            // ... UI
        }
        .onAppear {
            if viewModel == nil {
                viewModel = NewViewModel(modelContext: modelContext)
            }
            viewModel?.loadData()
        }
    }
}
```

## Testing

### Unit Tests

**Location**: `MonthlyMoneyManager/Tests/`

**Template**:
```swift
import XCTest
@testable import MonthlyMoneyManager

final class NewFeatureTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Setup test data
    }
    
    func testFeature() {
        // Given
        let input = "test input"
        
        // When
        let result = Service.process(input)
        
        // Then
        XCTAssertEqual(result, expectedOutput)
    }
}
```

**Run Tests**:
```bash
# All tests
Cmd + U

# Single test
Click test diamond in gutter
```

### Test Coverage Goals

- ✅ Services: 80%+ coverage
- ✅ ViewModels: 60%+ coverage
- ⚠️ Views: Not required (UI tests complex)

## Pull Request Process

### Before Submitting

1. **Build**: `Cmd + B` (no errors)
2. **Test**: `Cmd + U` (all pass)
3. **Format**: Follow Swift style guide
4. **Document**: Update README if needed

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Manually tested on simulator
- [ ] Tested on physical device

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No new warnings
```

### Review Process

1. Submit PR to `main` branch
2. Wait for CI checks (if configured)
3. Address review comments
4. Maintain PR hygiene (rebase if needed)
5. Await approval and merge

## Common Issues

### Issue: Preview Not Working

**Cause**: SwiftData requires proper context

**Solution**: Use simulator instead of preview
```swift
#Preview {
    // May not work with SwiftData
    ContentView()
}
```

### Issue: Tests Failing on Model Context

**Solution**: Mock ModelContext or use in-memory store
```swift
let container = try ModelContainer(
    for: Transaction.self,
    configurations: ModelConfiguration(isStoredInMemoryOnly: true)
)
```

### Issue: Build Error After Adding File

**Solution**: 
1. Select file in Project Navigator
2. File Inspector → Target Membership
3. Check appropriate target

## Documentation

### Update Documentation When

- Adding new feature
- Changing API
- Modifying data models
- Adding new category or classification rule

### Files to Update

- `README.md`: User-facing documentation
- `SETUP.md`: If setup process changes
- `QUICKSTART.md`: If fast-track changes
- Code comments: For complex logic

## Feature Requests

### Before Requesting

1. Check existing issues
2. Consider if it fits MVP scope
3. Think about implementation complexity

### Request Template

```markdown
## Feature Description
Clear description of feature

## Use Case
Why is this needed?

## Proposed Solution
How could it work?

## Alternatives Considered
What else was considered?

## Additional Context
Screenshots, mockups, examples
```

## Bug Reports

### Template

```markdown
## Bug Description
Clear and concise description

## Steps to Reproduce
1. Go to '...'
2. Click on '...'
3. See error

## Expected Behavior
What should happen

## Actual Behavior
What actually happens

## Screenshots
If applicable

## Environment
- iOS version
- Device model
- App version
```

## Release Process

### Version Numbers

- **Major** (1.0.0): Breaking changes
- **Minor** (1.1.0): New features
- **Patch** (1.0.1): Bug fixes

### Release Checklist

- [ ] All tests pass
- [ ] Documentation updated
- [ ] CHANGELOG updated
- [ ] Version number incremented
- [ ] App Store screenshots updated (if needed)
- [ ] Release notes written

## Questions?

- Check `README.md` for features
- Check `SETUP.md` for project setup
- Check `QUICKSTART.md` for development
- Open an issue for bugs
- Start a discussion for questions

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for contributing! 🎉
