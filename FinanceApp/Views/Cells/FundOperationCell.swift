//
//  FundOperationCell.swift
//  FinanceApp
//
//  Created by yura on 14.08.2018.
//  Copyright © 2018 yura. All rights reserved.
//

import UIKit

class FundOperationCell: UITableViewCell {
    
    @IBOutlet weak var circleView: UIView! {
        didSet {
            circleView.layer.borderWidth = 1
            circleView.layer.masksToBounds = false
            circleView.layer.borderColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
            circleView.layer.cornerRadius = circleView.bounds.width/2
            circleView.clipsToBounds = true
        }
    }
    @IBOutlet weak var upDownImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private let green = #colorLiteral(red: 0.3058823529, green: 0.6431372549, blue: 0.1137254902, alpha: 1)
    private let red = #colorLiteral(red: 0.8745098039, green: 0.1607843137, blue: 0.1607843137, alpha: 1)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initCell(operation: FundOperation) {
        nameLabel.text = operation.title
        dateLabel.text = Utils.convertDate(str: operation.date)
        guard let v = operation.value else {
            priceLabel.text = "---"
            return
        }
        upDownImageView?.image = v.amount < 0 ? UIImage(named: "symbol42") : UIImage(named: "symbol71")
        priceLabel.textColor = v.amount < 0 ? red : green
        priceLabel.text = String(v.amount.magnitude.formattedWithSeparator) + " " + Utils.getCurrencySymbol(curr: v.currency)
    }
    
}
