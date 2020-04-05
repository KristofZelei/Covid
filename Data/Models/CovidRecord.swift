//
//  CovidRecord.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 03. 30..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import Foundation

struct CovidRecord {
    var keyId: String
    var country: String
    var province: String?
    var city: String?
    var confirmed: Int
    var recovered: Int
    var deaths: Int
    var lastUpdate: Date
}

extension CovidRecord: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        keyId = try container.decode(String.self, forKey: .keyId)
        country = try container.decode(String.self, forKey: .country)
        let provinceStr = try container.decode(String.self, forKey: .province)
        province = provinceStr.isEmpty ? nil : provinceStr
        let cityStr = try container.decode(String.self, forKey: .city)
        city = cityStr.isEmpty ? nil : cityStr
        confirmed = try container.decode(Int.self, forKey: .confirmed)
        recovered = try container.decode(Int.self, forKey: .recovered)
        deaths = try container.decode(Int.self, forKey: .deaths)
        let lastUpdateStr = try container.decode(String.self, forKey: .lastUpdate)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let lastUpdateDate = formatter.date(from: lastUpdateStr) else {
            throw DecodingError.dataCorruptedError(
                forKey: .lastUpdate,
                in: container,
                debugDescription: "Wrong date format."
            )
        }
        lastUpdate = lastUpdateDate
    }
}
