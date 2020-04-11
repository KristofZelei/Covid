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
    func loadDataIfNeeded()
    func loadData()
}

class CovidStatListPresenterImpl: CovidStatListPresenter {
    
    weak var view: CovidStatListViewLogic?
    
    // Use the mock data source for testing: CovidStatsMockDataSource()
    private var dataSource: CovidStatsDataSource = CovidStatsRemoteDataSource()
    
    private var lastFetched: Date = .distantPast
    
    private var hoursSinceFetch: Double {
        return Date().timeIntervalSince(lastFetched) / 60 / 60
    }

    var minFetchInterval: Double = 4
    
    func loadDataIfNeeded() {
        guard hoursSinceFetch > minFetchInterval else { return }
        loadData()
    }
    
    func loadData() {
        view?.startLoading()
        dataSource.getCovidData { (response, error) in
            guard let response = response, error == nil else {
                DispatchQueue.main.async { self.view?.showError() }
                return
            }
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
            countries.sort(by: \.active, using: >)
            countries.prioritizeCurrentLocale()
            DispatchQueue.main.async {
                self.lastFetched = Date()
                self.view?.showData([world] + countries)
            }
        }
    }
}


