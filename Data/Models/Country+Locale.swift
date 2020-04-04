//
//  Country+Locale.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 04. 04..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import Foundation

extension Country {
    var regionCode: String {
        switch self {
        case .argentina:
            return "AR"
        case .iceland:
            return "IS"
        case .portugal:
            return "PT"
        case .australia:
            return "AU"
        case .india:
            return "IN"
        case .romania:
            return "RO"
        case .austria:
            return "AT"
        case .indonesia:
            return "ID"
        case .russia:
            return "RU"
        case .belgium:
            return "BE"
        case .iran:
            return "IR"
        case .serbia:
            return "RS"
        case .bolivia:
            return "BO"
        case .iraq:
            return "IQ"
        case .slovakia:
            return "SK"
        case .brazil:
            return "BR"
        case .ireland:
            return "IE"
        case .slovenia:
            return "SI"
        case .canada:
            return "CA"
        case .israel:
            return "IL"
        case .china:
            return "CN"
        case .italy:
            return "IT"
        case .spain:
            return "ES"
        case .croatia:
            return "HR"
        case .japan:
            return "JP"
        case .sweden:
            return "SE"
        case .luxembourg:
            return "LU"
        case .switzerland:
            return "CH"
        case .denmark:
            return "DK"
        case .mexico:
            return "MX"
        case .turkey:
            return "TR"
        case .finland:
            return "FI"
        case .netherlands:
            return "NL"
        case .france :
            return "FR"
        case .ukraine:
            return "UA"
        case .germany:
            return "DE"
        case .niger:
            return "NE"
        case .us:
            return "US"
        case .greece:
            return "GR"
        case .norway:
            return "NO"
        case .hungary:
            return "HU"
        case .poland:
            return "PL"
        case .southAfrica:
            return "ZA"
        case .czechia:
            return "CZ"
        case .newZealand:
            return "NZ"
        case .unitedKingdom:
            return "GB"
        case .southKorea:
            return "KR"
        }
    }
}
