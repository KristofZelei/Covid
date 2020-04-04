//
//  CovidStatListPresenter.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 04. 04..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import Foundation

protocol CovidStatListPresenter {
    var view: CovidStatListViewLogic? { get set }
    func loadData()
}

class CovidStatListPresenterImpl: CovidStatListPresenter {
    
    weak var view: CovidStatListViewLogic?
    
    // Use the mock data source for testing: CovidStatsMockDataSource()
    private var dataSource: CovidStatsDataSource = CovidStatsRemoteDataSource()
    
    private var lastFetched: Date = .distantPast

    var minFetchIntervalInHours: Double = (1/60)
    
    func loadData() {
        let elapsed = Date().timeIntervalSince(lastFetched)
        let elapsedHours = elapsed / 60 / 60
        guard elapsedHours > minFetchIntervalInHours else { return }
        lastFetched = Date()
        view?.startLoading()
        dataSource.getCovidData { (response, error) in
            guard let response = response else { return }
            var countries = [CountryStatViewModel]()
            for country in Country.allCases {
                let records: [CovidRecord] = response.records.filter {
                    $0.country == country.name
                }
                guard !records.isEmpty else { continue }
                let viewModel = CountryStatViewModel(of: country, with: records)
                countries.append(viewModel)
            }
            let world = WorldStatViewModel(from: response)
            countries.sort { $0.active > $1.active }
            countries.prioritizeCurrentLocale()
            DispatchQueue.main.async {
                self.view?.showData([world] + countries)
            }
        }
    }
}


