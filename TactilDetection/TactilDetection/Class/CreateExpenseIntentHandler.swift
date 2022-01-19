//
//  CreateExpenseIntentHandler.swift
//  TactilDetection
//
//  Created by Developer on 9/1/22.
//

import Foundation


public class CreateExpenseIntentHandler: NSObject, CreateExpenseIntentHandling {
        
    private var currentExpense: ExpenseRecord?
    
    public init(currentExpense: ExpenseRecord? = nil) {
        self.currentExpense = currentExpense
    }
    
    public static func expense(for intent: CreateExpenseIntent) -> ExpenseRecord? {
        guard let title = intent.expense?.displayString,
            let category = ExpenseCategory(rawValue: intent.category.rawValue),
            let date = intent.date?.date,
            let amount = intent.amount?.amount?.intValue else {
                return nil
        }
        return ExpenseRecord(title: title, amount: amount, date: date, category: category)
    }

    //Resolve
    public func resolveCategory(for intent: CreateExpenseIntent, with completion: @escaping (ExpenseCategoryResponseResolutionResult) -> Void) {
        if intent.category == .unknown {
            // Indicates that a required parameter value is missing
            completion(ExpenseCategoryResponseResolutionResult.needsValue())
        } else {
            completion(ExpenseCategoryResponseResolutionResult.success(with: intent.category))
        }
    }
        
    public func resolveExpense(for intent: CreateExpenseIntent, with completion: @escaping (ExpenseResponseResolutionResult) -> Void) {
        if let expenseResponse = intent.expense {
            completion(ExpenseResponseResolutionResult.success(with: expenseResponse))
        } else {
            // Indicates that a required parameter value is missing
            completion(ExpenseResponseResolutionResult.needsValue())
            // If we have to provide disabiguation options following result type can also be used
            // The user is asked to select from among the strings you provide.
//            completion(INStringResolutionResult.disambiguation(with: ["title1", "title2"]))
        }
    }

    public func resolveAmount(for intent: CreateExpenseIntent, with completion: @escaping (CreateExpenseAmountResolutionResult) -> Void) {
        guard let intentAmount = intent.amount, let amt = intentAmount.amount?.floatValue else {
            completion(CreateExpenseAmountResolutionResult.needsValue())
            return
        }
        if amt < 0 {
            // When executing shortcut from shortcuts app this validation is required
            // When executing from Siri the amount auto corrected if entered negetive amount
            let reason = CreateExpenseAmountUnsupportedReason.negativeNumbersNotSupported
            completion(CreateExpenseAmountResolutionResult.unsupported(forReason: reason))
        } else {
            completion(CreateExpenseAmountResolutionResult.success(with: intentAmount))
        }
    }
    
    public func resolveDate(for intent: CreateExpenseIntent, with completion: @escaping (CreateExpenseDateResolutionResult) -> Void) {
        guard let dateComponents = intent.date, let completionDate = dateComponents.date else {
            completion(CreateExpenseDateResolutionResult.needsValue())
            return
        }
        
        let comparisonResult = completionDate.yearDescription().localizedCompare(Date().yearDescription())
        if  comparisonResult == .orderedSame  {
            completion(CreateExpenseDateResolutionResult.success(with: dateComponents))
        } else if comparisonResult == .orderedAscending {
            // Custom validation error added in the
            // Validation errors in intent definition parameters section
            let reason = CreateExpenseDateUnsupportedReason.tooOldExpense
            completion(CreateExpenseDateResolutionResult.unsupported(forReason: reason))
        } else {
            let reason = CreateExpenseDateUnsupportedReason.dateInFuture
            completion(CreateExpenseDateResolutionResult.unsupported(forReason: reason))
        }
    }
    
    //Confirm
    public func confirm(intent: CreateExpenseIntent, completion: @escaping (CreateExpenseIntentResponse) -> Void) {
        if CreateExpenseIntentHandler.expense(for: intent) != nil {
            completion(CreateExpenseIntentResponse(code: .ready, userActivity: nil))
        } else {
            completion(CreateExpenseIntentResponse(code: CreateExpenseIntentResponseCode.failure, userActivity: nil))
        }
    }
    
    //Handle
    public func handle(intent: CreateExpenseIntent, completion: @escaping (CreateExpenseIntentResponse) -> Void) {
        guard let expense = CreateExpenseIntentHandler.expense(for: intent),
              let title = intent.expense?.displayString,
            let amount = intent.amount else {
                completion(CreateExpenseIntentResponse(code: .failure, userActivity: nil))
                return
        }
        
        DataManager.shared.addExpenseRecord(for: expense) { isError in
            if isError {
                completion(CreateExpenseIntentResponse(code: .failure, userActivity: nil))
            } else {
                let intentResponse = CreateExpenseIntentResponse.success(title: title, amount: amount)
                completion(intentResponse)
            }
        }
    }
    
    // Provide options: This method will be called repeatedly while user is typing with the search term provided by the user
    public func provideExpenseOptionsCollection(for intent: CreateExpenseIntent, searchTerm: String?,
                                                with completion: @escaping (INObjectCollection<ExpenseResponse>?, Error?) -> Void) {
        var expenseResponses = (ExpenseCategory.allCases.map{ ExpenseResponse(identifier: $0.getDescription(), display: $0.getDescription()) })
        if let searchString = searchTerm, !searchString.isEmpty {
            expenseResponses = expenseResponses.filter{ $0.displayString.contains(searchString) }
        }
        let objectCollection = INObjectCollection<ExpenseResponse>(items: expenseResponses)
        completion(objectCollection, nil)
    }
}
