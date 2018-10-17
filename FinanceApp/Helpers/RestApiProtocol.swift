//
//  RestApiProtocol.swift
//  FinanceApp
//
//  Created by yura on 16.08.2018.
//  Copyright © 2018 yura. All rights reserved.
//

import Foundation

protocol RestApiProtocol {
    
    func getMaxDate(completitionHandler: @escaping (Response) -> Void)
    
    func getPortfolioValue(date: String, currency: String, completitionHandler: @escaping (PortfolioValue?) -> Void)
    
     func getPortfolio(date: String, completitionHandler: @escaping ([Fund]) -> Void)
    
    func getFundAmount(fundId: Int, date: String, completitionHandler: @escaping(FundAmount?) -> Void)
    
    func getFundOperations(fundId: Int, comletitionHandeler: @escaping ([FundOperation]) -> Void)
    
    func getDisclaimers(fundIds: String, comletitionHandler: @escaping ([Disclaimer]) -> Void)
}
