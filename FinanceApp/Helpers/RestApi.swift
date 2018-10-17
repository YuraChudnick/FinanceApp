//
//  RestApi.swift
//  FinanceApp
//
//  Created by yura on 13.08.2018.
//  Copyright © 2018 yura. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper


enum Response {
    case success(date: String)
    case error(erroe: Error)
}

class RestApi: RestApiProtocol {

    func getMaxDate(completitionHandler: @escaping (Response) -> Void) {
        Alamofire.request(FinanceAppRouter.API001).responseObject(completionHandler: { (response: DataResponse<MaxDate>) in
            response.result.value.map({ (data) in
                print(data.maxDate)
                completitionHandler(Response.success(date: data.maxDate))
            })
            response.result.error.map({ (error) in
                print(error.localizedDescription)
                completitionHandler(Response.error(erroe: error))
            })
        })
    }
    
    func getPortfolioValue(date: String, currency: String, completitionHandler: @escaping (PortfolioValue?) -> Void) {
        Alamofire.request(FinanceAppRouter.API002(date: date, currency: currency)).responseObject { (response: DataResponse<PortfolioValue>) in
            response.result.value.map({ (data) in
                completitionHandler(data)
            })
            response.result.error.map({ (error) in
                completitionHandler(nil)
                print(error.localizedDescription)
            })
        }
    }
    
    func getPortfolio(date: String, completitionHandler: @escaping ([Fund]) -> Void) {
        Alamofire.request(FinanceAppRouter.API003(date: date)).responseObject { (response: DataResponse<Portfolio>) in
            response.result.value.map({ (data) in
                completitionHandler(data.funds)
            })
            response.result.error.map({ (error) in
                completitionHandler([])
                print(error.localizedDescription)
            })
        }
    }
    
    func getFundAmount(fundId: Int, date: String, completitionHandler: @escaping(FundAmount?) -> Void) {
        Alamofire.request(FinanceAppRouter.API004(fund_id: fundId, date: date)).responseObject { (response: DataResponse<FundAmount>) in
            response.result.value.map({ (data) in
                completitionHandler(data)
            })
            response.result.error.map({ (error) in
                completitionHandler(nil)
                print(error.localizedDescription)
            })
        }
    }
    
    func getFundOperations(fundId: Int, comletitionHandeler: @escaping ([FundOperation]) -> Void) {
        Alamofire.request(FinanceAppRouter.API005(fund_id: fundId)).responseArray { (response: DataResponse<[FundOperation]>) in
            response.result.value.map({ (data) in
                comletitionHandeler(data)
            })
            response.result.error.map({ (error) in
                comletitionHandeler([])
                print(error.localizedDescription)
            })
        }
    }
    
    func getDisclaimers(fundIds: String, comletitionHandler: @escaping ([Disclaimer]) -> Void) {
        Alamofire.request(FinanceAppRouter.API006(fund_ids: fundIds)).responseArray { (response: DataResponse<[Disclaimer]>) in
            response.result.value.map({ (data) in
                comletitionHandler(data)
            })
            response.result.error.map({ (error) in
                comletitionHandler([])
                print(error.localizedDescription)
            })
        }
    }
    
}
