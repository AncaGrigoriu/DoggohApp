//
//  RoundedTabBar.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 04/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class RoundedTabBar: UITabBar {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    private func config() {
        layer.masksToBounds = true
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
