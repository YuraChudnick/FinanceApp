//
//  Portfolio.swift
//  FinanceApp
//
//  Created by yura on 13.08.2018.
//  Copyright © 2018 yura. All rights reserved.
//

import ObjectMapper

struct Portfolio: Mappable {
    
    var funds: [Fund] = []
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        funds   <-  map["funds"]
    }
    
}

struct Fund: Mappable {
    
    var id: Int = 0
    var name: String = ""
    var link: String = ""
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id    <-   map["id"]
        name  <-   map["name"]
        link  <-   map["link"]
    }
    
}
