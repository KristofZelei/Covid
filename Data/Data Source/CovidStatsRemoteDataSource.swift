//
//  CovidStatsRemoteDataSource.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 03. 30..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import Foundation

class CovidStatsRemoteDataSource: CovidStatsDataSource {
    private enum Constants {
        static let urlErrorMessage = "Failed to construct URL"
        static let host = "covid-19-coronavirus-statistics.p.rapidapi.com"
        static let scheme = "https"
        static let path = "/v1"
        static let endpoint = "/stats"
        static let queryName = "country"
        static let headers = [
            "x-rapidapi-host": "covid-19-coronavirus-statistics.p.rapidapi.com",
            "x-rapidapi-key": PASTE.YOUR.OWN.API.KEY.HERE
        ]
    }
    
    enum NetworkError: Error {
        case requestFailed
        case wrongFormat
    }
    
    typealias Completion = (CovidStats?, Error?) -> Void
        
    private var baseComponents: URLComponents {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.host
        components.path = Constants.path
        return components
    }
        
    func getCovidData(completion: @escaping Completion) {
        fetchData(completion: completion)
    }
    
    func getCovidData(for country: Country, completion: @escaping Completion) {
        fetchData(for: country, completion: completion)
    }
        
    private func fetchData(for country: Country? = nil, completion: @escaping Completion) {
        var componenets = baseComponents
        componenets.path += Constants.endpoint
        if let country = country {
            let query = URLQueryItem(name: Constants.queryName, value: country.query)
            componenets.queryItems = [query]
        }
        guard let url = componenets.url else {
            preconditionFailure(Constants.urlErrorMessage)
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = Constants.headers
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil, NetworkError.requestFailed)
                return
            }
            let decoder = JSONDecoder()
            let res = try? decoder.decode(CovidStatsResponse.self, from: data)
            guard res != nil else {
                completion(nil, NetworkError.wrongFormat)
                return
            }
            completion(res?.data, nil)
        }
        task.resume()
    }
}
