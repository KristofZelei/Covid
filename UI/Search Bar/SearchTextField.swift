//
//  SearchTextField.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 03. 22..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import UIKit

class SearchTextField: UITextField {
    // MARK: - Constants
    private enum Constants {
        static let leftViewInset: CGFloat = 8
        static let rightViewInset: CGFloat = 8
        static let leftViewSize = CGSize(width: 16, height: 16)
        static let rightViewSize = CGSize(width: 16, height: 16)
        static let textInset: CGFloat = 8
        static let searchIcon = UIImage(named: "searchIcon")
        static let clearIcon = UIImage(named: "searchClearIcon")
    }

    // MARK: - UI Properties
    lazy var searchIconView = UIImageView(image: Constants.searchIcon)
    lazy var clearButton = UIButton(image: Constants.clearIcon)

    // MARK: - Initial Setup
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    init() {
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        returnKeyType = .search
        leftView = searchIconView
        rightView = clearButton
        leftViewMode = .always
        rightViewMode = .always
        let action = #selector(clearButtonTapped)
        clearButton.addTarget(self, action: action, for: .touchUpInside)
    }
    
    @objc func clearButtonTapped() {
        text = nil
        sendActions(for: .editingChanged)
    }

    // MARK: - Overrides
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let heightDiff = bounds.height - Constants.leftViewSize.height
        let origin = CGPoint(x: Constants.leftViewInset, y: heightDiff / 2)
        return CGRect(origin: origin, size: Constants.leftViewSize)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let x = Constants.leftViewInset + Constants.leftViewSize.width + Constants.textInset
        let origin = CGPoint(x: x, y: 0)
        let width = bounds.width - origin.x - rightViewRect(forBounds: bounds).width - Constants.textInset
        let size = CGSize(width: width, height: bounds.height)
        return CGRect(origin: origin, size: size)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let x = bounds.width - Constants.rightViewSize.width - Constants.rightViewInset
        let y = (bounds.height - Constants.rightViewSize.height) / 2
        let origin = CGPoint(x: x, y: y)
        return CGRect(origin: origin, size: Constants.rightViewSize)
    }
}
