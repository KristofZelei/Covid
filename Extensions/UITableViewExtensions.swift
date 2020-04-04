//
//  UITableViewExtensions.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 03. 31..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeuCellOfType<Cell: UITableViewCell>(_ type: Cell.Type, id: String? = nil) -> Cell {
        let reuseIdentifier = id ?? Cell.identifier
        guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier) as? Cell else {
            fatalError("Could not dequeue cell with identifier: \(reuseIdentifier)")
        }
        return cell
    }

    func register<Cell: UITableViewCell>(_ type: Cell.Type) {
        register(type, forCellReuseIdentifier: Cell.identifier)
    }
    
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
