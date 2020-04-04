//
//  CovidStatsDataSource.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 03. 31..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

protocol CovidStatsDataSource {
    func getCovidData(completion: @escaping (CovidStats?, Error?) -> Void)
    func getCovidData(for country: Country, completion: @escaping (CovidStats?, Error?) -> Void)
}
