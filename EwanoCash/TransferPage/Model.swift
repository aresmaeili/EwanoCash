//
//  Model.swift
//  EwanoCash
//
//  Created by Roham on 7/11/1400 AP.
//

import Foundation


struct TransactionData: Codable {
    var title = ""
    var amount: Double = 0
    var date: Date
    var isIncome = true
}

