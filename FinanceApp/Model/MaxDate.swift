//
//  MaxDate.swift
//  FinanceApp
//
//  Created by yura on 13.08.2018.
//  Copyright © 2018 yura. All rights reserved.
//

import ObjectMapper

struct MaxDate: Mappable {
    
    var maxDate: String = ""
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        maxDate   <-  map["max_date"]
    }
    
    
}
