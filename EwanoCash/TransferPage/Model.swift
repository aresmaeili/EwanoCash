//
//  Model.swift
//  EwanoCash
//
//  Created by Roham on 7/11/1400 AP.
//

import Foundation


struct TransfersModel : Codable {
    
    var titleOfTransaction: String
    var amountOfTransaction: String
    var dateOfTransaction: Date
    var isIncome: Bool
    

}

