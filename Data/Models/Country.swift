//
//  Country.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 03. 30..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

enum Country: String, CaseIterable {
    case southAfrica = "south africa"
    case newZealand = "new zealand"
    case unitedKingdom = "united kingdom"
    case southKorea = "Korea, South"
    case argentina, iceland, portugal, australia, india, romania,
        austria, indonesia, russia, belgium, iran, serbia,
        bolivia, iraq, slovakia, brazil, ireland, slovenia,
        canada, israel, china, italy, spain, croatia,
        japan, sweden, luxembourg, switzerland, denmark, mexico,
        turkey, finland, netherlands, france , ukraine, germany,
        niger, us, greece, norway, hungary, poland, czechia
}

extension Country {
    var formattedTokens: [String] {
        guard self != .us else { return ["US"] }
        let words = rawValue.split(separator: " ")
        return words.map { $0.capitalized }
    }
    
    var query: String {
        formattedTokens.joined(separator: "+")
    }
    
    var name: String {
        return formattedTokens.joined(separator: " ")
    }
}
