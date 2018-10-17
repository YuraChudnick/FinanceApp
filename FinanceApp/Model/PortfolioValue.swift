//
//  PortfolioValue.swift
//  FinanceApp
//
//  Created by yura on 13.08.2018.
//  Copyright © 2018 yura. All rights reserved.
//

import ObjectMapper

struct PortfolioValue: Mappable {
    
    var amount: String = ""
    var currency: String = ""
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        amount    <-   map["amount"]
        currency  <-   map["currency"]
    }
}
