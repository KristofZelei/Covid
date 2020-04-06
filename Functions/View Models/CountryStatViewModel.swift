//
//  CountryStatViewModel.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 03. 31..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import UIKit

struct CountryStatViewModel: CovidStatViewModel {
    var country: String
    var flag: UIImage?
    var confirmed: Int
    var deaths: Int
    var recovered: Int
    var active: Int
    var lastUpdated: String
    var regionCode: String
}

extension CountryStatViewModel {
    init(of country: Country, with records: [CovidRecord]) {
        let sumRecovered = records.sumRecovered
        let sumConfirmed = records.sumConfirmed
        let sumDeaths = records.sumDeaths
        let sumActive = sumConfirmed - sumDeaths - sumRecovered
        let lastUpdated = records.map { $0.lastUpdate }.max()
        var lastUpdatedString = String()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM. dd HH:mm"
        if let date = lastUpdated {
           lastUpdatedString = formatter.string(from: date)
        }
        self.init(
            country: country.name,
            flag: country.flag,
            confirmed: sumConfirmed,
            deaths: sumDeaths,
            recovered: sumRecovered,
            active: sumActive,
            lastUpdated: lastUpdatedString,
            regionCode: country.regionCode
        )
    }
}

extension Country {
    var flag: UIImage? {
        switch self {
        case .southKorea:
            return UIImage(named: "south-korea")
        case .southAfrica:
            return UIImage(named: "south-africa")
        case .newZealand:
            return UIImage(named: "new-zealand")
        case .unitedKingdom:
            return UIImage(named: "uk")
        default:
            return UIImage(named: rawValue)
        }
    }
}

extension Array where Element == CountryStatViewModel {
    mutating func prioritizeCurrentLocale() {
        makeFirstIf { $0.regionCode == Locale.current.regionCode }
    }
}
