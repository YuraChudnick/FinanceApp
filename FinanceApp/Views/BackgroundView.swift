//
//  BackgroundView.swift
//  FinanceApp
//
//  Created by yura on 13.08.2018.
//  Copyright © 2018 yura. All rights reserved.
//

import UIKit

@IBDesignable class BackgroundView: UIView {
    
    let colors: [CGColor] = [UIColor( red:0.110, green:0.118, blue:0.365, alpha:1.000).cgColor, UIColor( red:0.376, green:0.157, blue:0.349, alpha:1.000).cgColor]
    
    override func layoutSubviews() {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor( red:0.110, green:0.118, blue:0.365, alpha:1.000).cgColor,UIColor( red:0.376, green:0.157, blue:0.349, alpha:1.000).cgColor]
        gradient.startPoint = CGPoint(x: 0.00, y: 0.00)
        gradient.endPoint = CGPoint(x: 1.00, y: 1.00)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}
