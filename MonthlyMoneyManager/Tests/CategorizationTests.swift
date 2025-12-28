//
//  CategorizationTests.swift
//  MonthlyMoneyManagerTests
//
//  Created on 2025-12-28.
//

import XCTest
@testable import MonthlyMoneyManager

final class CategorizationTests: XCTestCase {
    
    var categories: [Category] = []
    
    override func setUp() {
        super.setUp()
        
        // Create test categories
        categories = [
            Category(
                name: "Salary",
                kind: .income,
                includeInEarnings: true,
                keywords: ["SALARY", "CT0036"]
            ),
            Category(
                name: "Loan Credit",
                kind: .income,
                includeInEarnings: false,
                keywords: ["PMT LOAN"]
            ),
            Category(
                name: "Groceries",
                kind: .expense,
                keywords: ["KEELLS", "CARGILLS"]
            ),
            Category(
                name: "Dining Out",
                kind: .expense,
                keywords: ["KFC", "PIZZA HUT"]
            ),
            Category(
                name: "Cash Withdrawal",
                kind: .expense,
                keywords: ["FAST CASH", "WITHDRAWAL"]
            ),
            Category(
                name: "Subscriptions",
                kind: .expense,
                keywords: ["OPENAI", "CHATGPT"]
            )
        ]
    }
    
    func testCategorizeExpenseByKeyword() {
        let description = "PURCHASE OPENAI CHATGPT SUBSCRIPTION"
        
        let category = CategorizationService.categorize(
            description: description,
            categories: categories,
            type: .expense
        )
        
        XCTAssertNotNil(category)
        XCTAssertEqual(category?.name, "Subscriptions")
    }
    
    func testCategorizeIncomeByKeyword() {
        let description = "SALARY CT0036 COMPANY NAME"
        
        let category = CategorizationService.categorize(
            description: description,
            categories: categories,
            type: .income
        )
        
        XCTAssertNotNil(category)
        XCTAssertEqual(category?.name, "Salary")
        XCTAssertTrue(category?.includeInEarnings ?? false)
    }
    
    func testCategorizeLoanCredit() {
        let description = "PMT LOAN 4873937 DISBURSEMENT"
        
        let category = CategorizationService.categorize(
            description: description,
            categories: categories,
            type: .income
        )
        
        XCTAssertNotNil(category)
        XCTAssertEqual(category?.name, "Loan Credit")
        XCTAssertFalse(category?.includeInEarnings ?? true)
    }
    
    func testCategorizeGroceries() {
        let description1 = "PURCHASE KEELLS SUPER COLOMBO"
        let description2 = "PURCHASE CARGILLS FOOD CITY"
        
        let category1 = CategorizationService.categorize(
            description: description1,
            categories: categories,
            type: .expense
        )
        
        let category2 = CategorizationService.categorize(
            description: description2,
            categories: categories,
            type: .expense
        )
        
        XCTAssertEqual(category1?.name, "Groceries")
        XCTAssertEqual(category2?.name, "Groceries")
    }
    
    func testCategorizeDiningOut() {
        let description1 = "PURCHASE KFC COLOMBO"
        let description2 = "PURCHASE PIZZA HUT NUGEGODA"
        
        let category1 = CategorizationService.categorize(
            description: description1,
            categories: categories,
            type: .expense
        )
        
        let category2 = CategorizationService.categorize(
            description: description2,
            categories: categories,
            type: .expense
        )
        
        XCTAssertEqual(category1?.name, "Dining Out")
        XCTAssertEqual(category2?.name, "Dining Out")
    }
    
    func testCategorizeCashWithdrawal() {
        let description1 = "FAST CASH KADAWATH-CRM1 BR"
        let description2 = "WITHDRAWAL KADAWATHA-1 BR"
        
        let category1 = CategorizationService.categorize(
            description: description1,
            categories: categories,
            type: .expense
        )
        
        let category2 = CategorizationService.categorize(
            description: description2,
            categories: categories,
            type: .expense
        )
        
        XCTAssertEqual(category1?.name, "Cash Withdrawal")
        XCTAssertEqual(category2?.name, "Cash Withdrawal")
    }
    
    func testCategorizeUnknownDescription() {
        let description = "UNKNOWN TRANSACTION TYPE"
        
        let category = CategorizationService.categorize(
            description: description,
            categories: categories,
            type: .expense
        )
        
        // Should return nil for unknown
        XCTAssertNil(category)
    }
    
    func testCategorizeIsCaseInsensitive() {
        let description = "purchase openai chatgpt"
        
        let category = CategorizationService.categorize(
            description: description,
            categories: categories,
            type: .expense
        )
        
        XCTAssertNotNil(category)
        XCTAssertEqual(category?.name, "Subscriptions")
    }
    
    func testDefaultCategoryForType() {
        let expenseDefault = CategorizationService.defaultCategory(
            for: .expense,
            categories: categories
        )
        
        let incomeDefault = CategorizationService.defaultCategory(
            for: .income,
            categories: categories
        )
        
        XCTAssertNotNil(expenseDefault)
        XCTAssertEqual(expenseDefault?.kind, .expense)
        
        XCTAssertNotNil(incomeDefault)
        XCTAssertEqual(incomeDefault?.kind, .income)
    }
}
