//
//  ImportParserTests.swift
//  MonthlyMoneyManagerTests
//
//  Created on 2025-12-28.
//

import XCTest
@testable import MonthlyMoneyManager

final class ImportParserTests: XCTestCase {
    
    func testParseValidTransaction() {
        let text = """
        29/12/2025 PURCHASE OPENAI *CHATGPT SUB 6,409.77
        """
        
        let transactions = ImportParserService.parse(text)
        
        XCTAssertEqual(transactions.count, 1)
        
        let transaction = transactions[0]
        XCTAssertEqual(transaction.amount, Decimal(string: "6409.77"))
        XCTAssertEqual(transaction.type, .expense)
        XCTAssertTrue(transaction.description.contains("OPENAI"))
        XCTAssertEqual(transaction.suggestedCategoryName, "Subscriptions")
    }
    
    func testParseMultipleTransactions() {
        let text = """
        29/12/2025 PURCHASE OPENAI *CHATGPT SUB 6,409.77
        25/12/2025 FAST CASH KADAWATH-CRM1 BR 10,000.00
        20/12/2025 PURCHASE KEELLS SUPER COLOMBO 8,500.00
        """
        
        let transactions = ImportParserService.parse(text)
        
        XCTAssertEqual(transactions.count, 3)
        XCTAssertEqual(transactions[0].suggestedCategoryName, "Subscriptions")
        XCTAssertEqual(transactions[1].suggestedCategoryName, "Cash Withdrawal")
        XCTAssertEqual(transactions[2].suggestedCategoryName, "Groceries")
    }
    
    func testParseDateFormat() {
        let text = """
        15/01/2025 PURCHASE TEST 1,000.00
        """
        
        let transactions = ImportParserService.parse(text)
        
        XCTAssertEqual(transactions.count, 1)
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: transactions[0].date)
        XCTAssertEqual(components.day, 15)
        XCTAssertEqual(components.month, 1)
        XCTAssertEqual(components.year, 2025)
    }
    
    func testParseAmountWithComma() {
        let text = """
        29/12/2025 PMT LOAN 4873937 3508386 102,533.00
        """
        
        let transactions = ImportParserService.parse(text)
        
        XCTAssertEqual(transactions.count, 1)
        XCTAssertEqual(transactions[0].amount, Decimal(string: "102533.00"))
    }
    
    func testParseIncomeTransaction() {
        let text = """
        01/12/2025 SALARY CT0036 COMPANY NAME 150,000.00
        """
        
        let transactions = ImportParserService.parse(text)
        
        XCTAssertEqual(transactions.count, 1)
        XCTAssertEqual(transactions[0].type, .income)
        XCTAssertEqual(transactions[0].suggestedCategoryName, "Salary")
        XCTAssertTrue(transactions[0].includeInEarnings)
    }
    
    func testParseExpenseTransactions() {
        let text = """
        10/12/2025 WITHDRAWAL KADAWATHA-1 BR 10,000.00
        """
        
        let transactions = ImportParserService.parse(text)
        
        XCTAssertEqual(transactions.count, 1)
        XCTAssertEqual(transactions[0].type, .expense)
        XCTAssertEqual(transactions[0].suggestedCategoryName, "Cash Withdrawal")
    }
    
    func testParseEmptyText() {
        let text = ""
        
        let transactions = ImportParserService.parse(text)
        
        XCTAssertEqual(transactions.count, 0)
    }
    
    func testParseMalformedText() {
        let text = """
        This is not a valid transaction
        No dates or amounts here
        """
        
        let transactions = ImportParserService.parse(text)
        
        XCTAssertEqual(transactions.count, 0)
    }
    
    func testParseGroceryTransactions() {
        let text = """
        12/12/2025 PURCHASE KEELLS SUPER COLOMBO 7,200.00
        18/12/2025 PURCHASE CARGILLS FOOD CITY 9,300.00
        """
        
        let transactions = ImportParserService.parse(text)
        
        XCTAssertEqual(transactions.count, 2)
        XCTAssertEqual(transactions[0].suggestedCategoryName, "Groceries")
        XCTAssertEqual(transactions[1].suggestedCategoryName, "Groceries")
    }
    
    func testParseDiningTransactions() {
        let text = """
        10/12/2025 PURCHASE KFC COLOMBO 3,200.00
        15/12/2025 PURCHASE PIZZA HUT NUGEGODA 4,500.00
        """
        
        let transactions = ImportParserService.parse(text)
        
        XCTAssertEqual(transactions.count, 2)
        XCTAssertEqual(transactions[0].suggestedCategoryName, "Dining Out")
        XCTAssertEqual(transactions[1].suggestedCategoryName, "Dining Out")
    }
    
    func testParseBankCharges() {
        let text = """
        25/12/2025 IB CEFT CHGS TRANSFER FEE 25.00
        """
        
        let transactions = ImportParserService.parse(text)
        
        XCTAssertEqual(transactions.count, 1)
        XCTAssertEqual(transactions[0].suggestedCategoryName, "Bank Fees/Charges")
        XCTAssertEqual(transactions[0].type, .expense)
    }
}
