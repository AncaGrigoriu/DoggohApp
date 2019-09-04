//
//  ResultsViewModel.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 03/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

struct ResultsViewModel {
    let scoreString: String
    let totalScoreString: String
    
    init(score: Int, total: Int) {
        scoreString = score < 10 ? "0\(score)" : "\(score)"
        totalScoreString = "/\(total)"
    }
}
