//
//  FinanceViewModel.swift
//  Finance
//
//  Created by Giorgi Zautashvili on 29.09.25.
//


import Foundation

class FinanceViewModel {
    
    private let transactionsKey = "transactions"
    private let hiddenKey = "hidden"
    
    var transactions: [Transaction] = [] {
        didSet {
            onTransactionsUpdated?()
        }
    }
    
    var isHidden: Bool = UserDefaults.standard.bool(forKey: "isHidden") {
        didSet {
            onVisibilityChanged?(isHidden)
        }
    }
    
    var onTransactionsUpdated: (() -> Void)?
    var onVisibilityChanged: ((Bool) -> Void)?
    
    var totalBalance: Double {
        transactions.reduce(0) { $0 + ($1.type == .income ? $1.amount : -$1.amount) }
    }
    
    var balance: Double {
        let income = transactions.filter { $0.type == .income }.map { $0.amount }.reduce(0, +)
        let expenses = transactions.filter { $0.type == .expense }.map { $0.amount }.reduce(0, +)
        return income - expenses
    }
    
    init() {
        loadData()
    }
    
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
        saveData()
    }
    
    func deleteTransaction(at index: Int) {
        guard transactions.indices.contains(index) else { return }
        transactions.remove(at: index)
        saveData()
    }
    
    func toggleHidden() {
        isHidden.toggle()
        saveHiddenState()
    }
    
    // MARK:  Presistence
    
    private func saveData() {
        if let encoded = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(encoded, forKey: transactionsKey)
        }
    }
    
    private func loadData() {
        if let savedData = UserDefaults.standard.data(forKey: transactionsKey),
           let decoded = try? JSONDecoder().decode([Transaction].self, from: savedData) {
            self.transactions = decoded
        }
        
        isHidden = UserDefaults.standard.bool(forKey: hiddenKey)
        onTransactionsUpdated?()
    }
    
    private func saveHiddenState() {
        UserDefaults.standard.set(isHidden, forKey: hiddenKey)
    }
    
    var totalIncome: Double {
        transactions.filter { $0.type == .income }.map { $0.amount }.reduce(0, +)
    }

    var totalExpenses: Double {
        transactions.filter { $0.type == .expense }.map { $0.amount }.reduce(0, +)
    }

    var categorySummary: [(category: String, total: Double, type: TransactionType)] {
        var result: [String: (Double, TransactionType)] = [:]
        
        for t in transactions {
            let current = result[t.category]?.0 ?? 0
            result[t.category] = (current + t.amount, t.type)
        }
        
        return result.map { ($0.key, $0.value.0, $0.value.1) }
    }
}
