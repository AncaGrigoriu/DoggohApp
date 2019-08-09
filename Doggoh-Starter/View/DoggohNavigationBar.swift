//
//  DoggohNavigationBar.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 03/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class DoggohNavigationBar: UINavigationBar {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        barTintColor = UIColor.white
        shadowImage = UIImage()
        titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Avenir-Black", size: 18)!]
        
        let navigationItem = UINavigationItem(title: "DOGGOH")
        setItems([navigationItem], animated: false)
    }
    
    
}
