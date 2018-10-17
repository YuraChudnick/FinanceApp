//
//  FundOperation.swift
//  FinanceApp
//
//  Created by yura on 13.08.2018.
//  Copyright © 2018 yura. All rights reserved.
//

import ObjectMapper

struct FundOperation: Mappable, Comparable {
    
    var date: String = ""
    var unixTime: Double = 0.0
    var title: String = ""
    var value: FundAmount?
    var fundName: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        date     <-    map["date"]
        unixTime <-    (map["date"], ConvertDate())
        title    <-    map["title"]
        value    <-    map["value"]
    }
    
    static func < (lhs: FundOperation, rhs: FundOperation) -> Bool {
        return lhs.unixTime > rhs.unixTime
    }
    
    static func == (lhs: FundOperation, rhs: FundOperation) -> Bool {
        return lhs.date == rhs.date && lhs.title == rhs.title
    }
    
}

class ConvertDate: TransformType {

    typealias Object = Double
    typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> Double? {
        if let v = value as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: v)
            guard let d = date else { return nil }
            return d.timeIntervalSince1970
        }
        return nil
    }
    
    func transformToJSON(_ value: Double?) -> String? {
        return nil
    }
    
}
