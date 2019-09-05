//
//  DogsTableViewHeader.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 07/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class DogsTableViewHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var headerTextLabel: UILabel!
    
    var viewmodel: DogsTableViewHeaderViewModel! {
        didSet {
            headerTextLabel.text = viewmodel.breedNameString
        }
    }
}
