//
//  Theme.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 03. 31..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import UIKit

enum Theme {
    enum Style: String {
        case normal
        case dark
    }
    
    private static let key = "theme"
    
    private static var _currentStyle: Style?
    
    private static var savedStyle: Style {
        get {
            guard let styleString = UserDefaults.standard.string(forKey: key) else {
                UserDefaults.standard.set(Style.normal.rawValue, forKey: key)
                return .normal
            }
            return Style(rawValue: styleString) ?? .normal
        }
        
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: key)
            NotificationCenter.default.post(name: .themeChanged)
        }
    }
    
    static var currentStyle: Style {
        get {
            guard let style = _currentStyle else {
                _currentStyle = savedStyle
                return _currentStyle!
            }
            return style
        }
        set {
            guard newValue != _currentStyle else { return }
            _currentStyle = newValue
            savedStyle = newValue
        }
    }
    
    static var isDefault: Bool {
        return currentStyle == .normal
    }
    
    static func change() {
        NotificationCenter.default.post(name: .themeChanged)
        currentStyle = isDefault ? .dark : .normal
    }
    
    static func register(_ object: Any, selector: Selector) {
        NotificationCenter.default.addObserver(object, selector: selector, name: .themeChanged)
    }
}

