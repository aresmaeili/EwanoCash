//
//  Datamanager.swift
//  EwanoCash
//
//  Created by Alireza on 10/14/21.
//

import Foundation

enum UserDefaultKeys: String {
    case transactions
}

class DataManager {
    
    static var shared = DataManager()

    var transactions: [TransactionData] {
        get {
            return UserDefaults.standard.retrieve(object: [TransactionData].self, fromKey: UserDefaultKeys.transactions.rawValue) ?? []
        }
        set (newValue) {
            UserDefaults.standard.save(customObject: newValue, inKey: UserDefaultKeys.transactions.rawValue)
        }
    }
}

extension UserDefaults {
    func save<T:Encodable>(customObject object: T, inKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            self.set(encoded, forKey: key)
        }
    }
    
    func retrieve<T:Decodable>(object type: T.Type, fromKey key: String) -> T? {
        if let data = self.data(forKey: key) {
            let decoder = JSONDecoder()
            if let object = try? decoder.decode(type, from: data) {
                return object
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
