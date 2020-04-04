//
//  NotificationExtensions.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 03. 31..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let themeChanged = Notification.Name("themeChanged")
}

extension NotificationCenter {
    func post(name: Notification.Name) {
        post(name: name, object: nil)
    }
    
    func addObserver(_ observer: Any, selector: Selector, name: Notification.Name) {
        addObserver(observer, selector: selector, name: name, object: nil)
    }
}
