//
//  Disclaimer.swift
//  FinanceApp
//
//  Created by yura on 13.08.2018.
//  Copyright © 2018 yura. All rights reserved.
//

import ObjectMapper

struct Disclaimer: Mappable {
    
    var fundId: String = ""
    var text: String = ""
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        fundId    <-   map["fund_id"]
        text      <-   map["text"]
    }
    
}
