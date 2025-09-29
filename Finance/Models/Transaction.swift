//
//  Transaction.swift
//  Finance
//
//  Created by Giorgi Zautashvili on 29.09.25.
//

import Foundation

struct Transaction: Codable {
    let id: UUID
    let type: TransactionType
    let amount: Double
    let category: String
    let date: Date
    let note: String?
}

enum TransactionType: String, Codable {
    case income, expense
}
