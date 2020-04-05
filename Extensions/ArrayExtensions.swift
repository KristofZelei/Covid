//
//  ArrayExtensions.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 04. 04..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import UIKit

extension Array {
    mutating func makeFirstIf(_ match: (Element) -> Bool) {
        enumerated().forEach {
            guard match($1) else { return }
            remove(at: $0)
            insert($1, at: 0)
            return
        }
    }
}

extension Array where Element: AdditiveArithmetic {
    var sum: Element {
        reduce(.zero, +)
    }
    
    func sum(first n: Int) -> Element {
        return prefix(n).sum
    }
}

extension ArraySlice where Element: AdditiveArithmetic {
    var sum: Element {
        reduce(.zero, +)
    }
}
