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
    
    private(set) var transactions: [Transaction] = []
    private(set) var isHidden: Bool = false
    
    var balance: Double {
        let income = transactions.filter { $0.type == .income }.map { $0.amount }.reduce(0, +)
        let expenses = transactions.filter { $0.type == .expense }.map { $0.amount }.reduce(0, +)
        return income - expenses
    }
    
    init() {
        loadData()
    }
    
    func addtransaction(_ transaction: Transaction) {
        transactions.insert(transaction, at: 0)
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
    }
    
    private func saveHiddenState() {
        UserDefaults.standard.set(isHidden, forKey: hiddenKey)
    }
    
}
