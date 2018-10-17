//
//  Array+Extension.swift
//  FinanceApp
//
//  Created by yura on 15.08.2018.
//  Copyright © 2018 yura. All rights reserved.
//

import Foundation

extension Array where Element == FundOperation {
    
    mutating func getLastFiveElements() -> [FundOperation] {
        self.sort { (l, r) -> Bool in
            if l.date == r.date {
                return l.title < r.title
            } else {
                return l.date > r.date
            }
        }
        
        return self.isEmpty ? [] : Array(self[0..<5])
    }
    
}
