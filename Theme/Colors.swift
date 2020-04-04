//
//  Colors.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 03. 31..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import UIKit

extension UIColor {
    enum CustomColorNames: String {
        case covidBlack
        case covidOrange
        case covidPink
        case covidGreen
        case covidLightGray
        case covidDarkGray
        case covidGray
    }
    static let covidBlack = UIColor(named: UIColor.CustomColorNames.covidBlack.rawValue)!
    static let covidOrange = UIColor(named: UIColor.CustomColorNames.covidOrange.rawValue)!
    static let covidPink = UIColor(named: UIColor.CustomColorNames.covidPink.rawValue)!
    static let covidGreen = UIColor(named: UIColor.CustomColorNames.covidGreen.rawValue)!
    static let covidLightGray = UIColor(named: UIColor.CustomColorNames.covidLightGray.rawValue)!
    static let covidDarkGray = UIColor(named: UIColor.CustomColorNames.covidDarkGray.rawValue)!
    static let covidGray = UIColor(named: UIColor.CustomColorNames.covidGray.rawValue)!
}

extension UIColor {
    static var backgroundColor: UIColor {
        return Theme.isDefault ? .white : .covidBlack
    }
    
    static var accentColor: UIColor {
        return Theme.isDefault ? .black : .covidLightGray
    }
    
    static var secondaryColor: UIColor {
        return Theme.isDefault ? .covidGray : UIColor(0xB6B6BD)
    }
    
    static var deathColor: UIColor {
        return Theme.isDefault ? .covidDarkGray : .white
    }
}
