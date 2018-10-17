//
//  FinanceAppRouter.swift
//  FinanceApp
//
//  Created by yura on 13.08.2018.
//  Copyright © 2018 yura. All rights reserved.
//

import Alamofire

public enum FinanceAppRouter: URLRequestConvertible {
    
    enum Constants {
        static let baseUrlPath = "http://test-ios.w-m.ru"
    }
    
    case API001
    case API002(date: String, currency: String)
    case API003(date: String)
    case API004(fund_id: Int, date: String)
    case API005(fund_id: Int)
    case API006(fund_ids: String)
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .API001:
            return "/api/v1/date"
        case .API002:
            return "/api/v1/portfolio-value"
        case .API003:
            return "/api/v1/portfolio"
        case .API004:
            return "/api/v1/fund-amount"
        case .API005:
            return "/api/v1/fund-operations"
        case .API006:
            return "/api/v1/disclaimers"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .API001:
            return [:]
        case .API002(let date, let currency):
            return ["date": date, "currency": currency]
        case .API003(let date):
            return ["date": date]
        case .API004(let fund_id, let date):
            return ["fund_id": fund_id, "date": date]
        case .API005(let fund_id):
            return ["fund_id": fund_id]
        case .API006(let fund_ids):
            return ["fund_ids": fund_ids]
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseUrlPath.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(15)
        return try URLEncoding.default.encode(request, with: parameters)
    }
    
    
}
