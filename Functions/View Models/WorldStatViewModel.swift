//
//  WorldStatViewModel.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 03. 31..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import UIKit

struct WorldStatViewModel: CovidStatViewModel {
    typealias WorldStat = (name: String, value: String)
    var title: String
    var subtitle: String
    var sortTitle: String
    var confirmed: WorldStat
    var deaths: WorldStat
    var recovered: WorldStat
    var active: WorldStat
    var lastUpdated: String
}

extension WorldStatViewModel {
    init(from stats: CovidStats) {
        let sumRecovered = stats.records.sumRecovered
        let sumConfirmed = stats.records.sumConfirmed
        let sumDeaths = stats.records.sumDeaths
        let sumActive = sumConfirmed - sumDeaths - sumRecovered
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM. dd HH:mm"
        let lastUpdated = formatter.string(from: stats.lastChecked)
        self.init(
            title: "World Stats",
            subtitle: "COVID19",
            sortTitle: "Sort by",
            confirmed: ("Total confirmed:", sumConfirmed.asString.numberFormatted),
            deaths: ("Total deaths:", sumDeaths.asString.numberFormatted),
            recovered: ("Total recovered:", sumRecovered.asString.numberFormatted),
            active: ("Total active cases:", sumActive.asString.numberFormatted),
            lastUpdated: lastUpdated
        )
    }
}
