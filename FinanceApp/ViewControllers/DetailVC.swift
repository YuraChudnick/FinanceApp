//
//  DetailVC.swift
//  FinanceApp
//
//  Created by yura on 13.08.2018.
//  Copyright © 2018 yura. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var contentView: UIView! {
        didSet {
            contentView.layer.cornerRadius = 10
            contentView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var circleView: UIView! {
        didSet {
            circleView.layer.borderWidth = 2
            circleView.layer.masksToBounds = false
            circleView.layer.borderColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
            circleView.layer.cornerRadius = circleView.bounds.width/2
            circleView.clipsToBounds = true
        }
    }
    @IBOutlet weak var upDownImageView: UIImageView!
    @IBOutlet weak var fundNameLabel: UILabel!
    @IBOutlet weak var operationDateLabel: UILabel!
    @IBOutlet weak var operationNameLabel: UILabel!
    @IBOutlet weak var sumLabel: UILabel!
    
    var operation: FundOperation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let o = operation, let v = o.value else { return }
        upDownImageView.image = v.amount < 0 ? UIImage(named: "symbol42") : UIImage(named: "symbol71")
        fundNameLabel.text = o.fundName
        operationDateLabel.text = Utils.convertDate(str: o.date)
        operationNameLabel.text = o.title
        sumLabel.text = String(v.amount.magnitude.formattedWithSeparator) + " " + Utils.getCurrencySymbol(curr: v.currency)
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
