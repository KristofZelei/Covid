//
//  CovidStatSumExtensions.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 03. 31..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import Foundation

extension Array where Element == CovidRecord {
    var sumConfirmed: Int {
        return map { $0.confirmed }
            .reduce(0, +)
    }
    
    var sumRecovered: Int {
        return map { $0.recovered }
            .reduce(0, +)
    }
    
    var sumDeaths: Int {
        return map { $0.deaths }
            .reduce(0, +)
    }
}
