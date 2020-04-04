//
//  CovidStatsResponse.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 04. 01..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import Foundation

struct CovidStatsResponse: Response {
    var error: Bool
    var statusCode: Int
    var message: String
    var data: CovidStats
}
