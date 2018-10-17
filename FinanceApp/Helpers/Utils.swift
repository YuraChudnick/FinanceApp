//
//  Utils.swift
//  FinanceApp
//
//  Created by yura on 13.08.2018.
//  Copyright © 2018 yura. All rights reserved.
//

import Foundation

struct Utils {
    
    static func getCurrencySymbol(curr: String) -> String {
        let currencies = ["USD": "$", "RUB": "₽", "EUR": "€"]
        if let c = currencies[curr] {
            return c
        }
        return curr
    }
    
    static func convertDate(str: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: str)
        guard let d = date else { return str }
        let dF = DateFormatter()
        dF.dateFormat = "dd.MM.yyyy"
        return dF.string(from: d)
    }
}
