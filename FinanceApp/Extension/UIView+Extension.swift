//
//  UIView+Extension.swift
//  FinanceApp
//
//  Created by yura on 15.08.2018.
//  Copyright © 2018 yura. All rights reserved.
//

import UIKit

extension UIView {
    
    func addRoundedCorners(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
}

