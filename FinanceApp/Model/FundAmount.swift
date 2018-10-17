//
//  FundAmount.swift
//  FinanceApp
//
//  Created by yura on 13.08.2018.
//  Copyright © 2018 yura. All rights reserved.
//

import ObjectMapper

struct FundAmount: Mappable {
    
    var amount: Double = 0.0
    var currency: String = ""
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        amount    <-  (map["amount"], ConvertFundAmount())
        currency  <-  map["currency"]
    }
    
}

class ConvertFundAmount: TransformType {
    
    typealias Object = Double
    typealias JSON = String
    
    
    func transformFromJSON(_ value: Any?) -> Double? {
        if let v = value as? String {
            return Double(v)
        } else if let v = value as? Double {
            return v
        }
        return nil
        
    }
    
    func transformToJSON(_ value: Double?) -> String? {
        return nil
    }
}
