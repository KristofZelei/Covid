//
//  CustomFont.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 03. 31..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import UIKit

extension UIFont {
    private static var roundedFontNames: [UIFont.Weight: String] {
        return [
            .ultraLight: "SFProRounded-Ultralight",
            .heavy: "SFProRounded-Heavy",
            .bold: "SFProRounded-Bold",
            .thin: "SFProRounded-Thin",
            .regular: "SFProRounded-Regular",
            .light: "SFProRounded-Light",
            .semibold: "SFProRounded-Semibold",
            .medium: "SFProRounded-Medium",
            .black: "SFProRounded-Black"
        ]
    }

    static func roundedFont(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let fontName = roundedFontNames[weight]!
        return UIFont(name: fontName, size: size)!
    }
}
