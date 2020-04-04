//
//  UIColorExtensions.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 03. 31..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(_ hex: Int) {
        let red = (hex >> 16) & 0xFF
        let green = (hex >> 8) & 0xFF
        let blue = hex & 0xFF
        
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: 1.0
        )
    }
}
