//
//  StringExtensions.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 03. 31..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import UIKit

extension String {
    var numberFormatted: String {
        var result = [String]()
        for i in stride(from: 0, to: count, by: 3) {
            let token = self.dropLast(i).suffix(3)
            result.append(String(token))
        }
        return result.reversed().joined(separator: " ")
    }
}
