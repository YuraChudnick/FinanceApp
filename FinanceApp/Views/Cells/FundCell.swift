//
//  FundCell.swift
//  FinanceApp
//
//  Created by yura on 13.08.2018.
//  Copyright © 2018 yura. All rights reserved.
//

import UIKit

class FundCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var roundedCornersView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var date: String?
    var fund: Fund? {
        didSet {
            loadData()
        }
    }
    var restApi: RestApi?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activityIndicator.isHidden = true
        roundedCornersView.layer.cornerRadius = 5
        roundedCornersView.layer.masksToBounds = true
    }
    
    func initCell(date: String, data: Fund, restApi: RestApi) {
        self.restApi = restApi
        self.name.text = data.name
        self.date = date
        self.fund = data
    }
    
    private func loadData() {
        guard let f = fund, let d = date else {
            value.text = "---"
            return
        }
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        restApi?.getFundAmount(fundId: f.id, date: d) { [weak self] (data) in
            if let d = data {
                UserDefaults.standard.set(d.amount.formattedWithSeparator + " " + Utils.getCurrencySymbol(curr: d.currency), forKey: String(f.id))
                self?.value.text = d.amount.formattedWithSeparator + " " + Utils.getCurrencySymbol(curr: d.currency)
            } else {
                self?.value.text = "---"
            }
            self?.activityIndicator.stopAnimating()
        }
    }
    
}
