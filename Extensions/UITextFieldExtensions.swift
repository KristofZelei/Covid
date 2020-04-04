//
//  UITextFieldExtensions.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 03. 31..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import UIKit

extension UITextField {
    /** Sets the color of the placeholder.
     Note, that if the placholder is not yet set, this has no effect.
     Setting a new placholder resets the placholder color to its default value.*/
    var placeholderColor: UIColor? {
        get {
            guard let attributedText = attributedPlaceholder else { return nil }
            let attributes = attributedText.attributes(at: 0, effectiveRange: nil)
            for attribute in attributes where attribute.key == .foregroundColor {
                return (attribute.value as? UIColor)
            }
            return nil
        }
        set {
            guard let newColor = newValue, let text = placeholder else { return }
            let attributes = [NSAttributedString.Key.foregroundColor: newColor]
            attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
        }
    }
    
    /** Sets the font of the placeholder.
    Note, that if the placholder is not yet set, this has no effect.
    Setting a new placholder resets the placholder font to its default value.*/
    var placeHolderFont: UIFont? {
        get {
            guard let attributedText = attributedPlaceholder else { return nil }
            let attributes = attributedText.attributes(at: 0, effectiveRange: nil)
            for attribute in attributes where attribute.key == .font {
                return (attribute.value as? UIFont)
            }
            return nil
        }
        set {
            guard let newFont = newValue, let text = placeholder else { return }
            
            if var attributes = attributedPlaceholder?.attributes(at: 0, effectiveRange: nil) {
                attributes[.font] = newFont
                attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
            } else {
                let attributes = [NSAttributedString.Key.font: newFont]
                attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
            }
        }
    }
    
}
