//
//  CovidStats.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 03. 30..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import Foundation

struct CovidStats {
    var records: [CovidRecord]
    var lastChecked: Date
}

extension CovidStats: Codable {
    enum CodingKeys: String, CodingKey {
        case records = "covid19Stats"
        case lastChecked
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        records = try container.decode([CovidRecord].self, forKey: .records)
        let lastCheckedStr = try container.decode(String.self, forKey: .lastChecked)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let lastCheckedDate = formatter.date(from: lastCheckedStr) else {
            throw DecodingError.dataCorruptedError(
                forKey: .lastChecked,
                in: container,
                debugDescription: "Wrong date format."
            )
        }
        lastChecked = lastCheckedDate
    }
}
