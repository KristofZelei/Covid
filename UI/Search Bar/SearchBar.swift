//
//  SearchBar.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 03. 21..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import ClosureLayout
import UIKit

protocol SearchBarDelegate: AnyObject {
    func searchBarTextDidBeginEditing(_ searchBar: SearchBar)
    func searchBarTextDidEndEditing(_ searchBar: SearchBar)
    func searchBar(_ searchBar: SearchBar, textDidChange searchText: String)
    func searchBarSearchButtonClicked(_ searchBar: SearchBar)
    func searchBarCancelButtonClicked(_ searchBar: SearchBar)
}

extension SearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: SearchBar) {}
    func searchBarTextDidEndEditing(_ searchBar: SearchBar) {}
    func searchBar(_ searchBar: SearchBar, textDidChange searchText: String) {}
    func searchBarSearchButtonClicked(_ searchBar: SearchBar) {}
    func searchBarCancelButtonClicked(_ searchBar: SearchBar) {}
}

class SearchBar: UIView {
    // MARK: - Constants
    private enum Constants {
        static let cancelButtonWidth: CGFloat = 53
        static let height: CGFloat = 36
        static let cornerRadius: CGFloat = 10
        static let defaultTintColor = UIColor(0x8F8F94)
        static let defaultBackroundColor = UIColor(0x8B868B).withAlphaComponent(0.1)
    }
    
    // MARK: - Delegate
    weak var delegate: SearchBarDelegate?
    
    // MARK: - Public Properties
    var text: String? {
        get { return textField.text }
        set {
            textField.text = newValue
            if let newValue = newValue, newValue.isEmpty {
                textField.rightViewMode = .never
            }
        }
    }
    
    var textColor: UIColor? {
        get { return textField.textColor }
        set { textField.textColor = newValue }
    }
    
    override var tintColor: UIColor? {
        didSet {
            textField.tintColor = tintColor
            
        }
    }
    
    var showsCancelButton = false {
        didSet { setShowsCancelButton(showsCancelButton) }
    }
    
    // MARK: - UI Properties
    lazy var textField: SearchTextField = {
        let textField = SearchTextField()
        textField.placeholder = "Keresés"
        textField.backgroundColor = Constants.defaultBackroundColor
        textField.placeholderColor = Constants.defaultTintColor
        textField.searchIconView.tintColor = Constants.defaultTintColor
        textField.clearButton.tintColor = Constants.defaultTintColor
        textField.rightViewMode = .never
        return textField
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.accentColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        return button
    }()
    
    // MARK: - Private Properties
    private var cancelButtonConstant = Constants.cancelButtonWidth + 8
    private var cancelButtonConstraint: NSLayoutConstraint?
    
    // MARK: - Initial Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
        
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    private func setup() {
        addSubview(textField)
        addSubview(cancelButton)
        
        textField.layout {
            $0.leading == leadingAnchor
            $0.top == topAnchor
            $0.bottom == bottomAnchor
            $0.trailing == cancelButton.leadingAnchor - 8
        }
        
        cancelButton.layout {
            $0.centerY == centerYAnchor
            $0.width == Constants.cancelButtonWidth
        }
        
        cancelButton.alpha = 0
        cancelButtonConstraint = cancelButton.trailingAnchor.constraint(
            equalTo: trailingAnchor,
            constant: cancelButtonConstant
        )
        
        cancelButtonConstraint?.isActive = true
        
        layer.masksToBounds = true
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = Constants.cornerRadius
        
        if #available(iOS 13.0, *) {
            textField.layer.cornerCurve = .continuous
        }
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Overrides
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: Constants.height)
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    @objc private func textFieldDidChange() {
        let text = textField.text ?? ""
        delegate?.searchBar(self, textDidChange: text)
        textField.rightViewMode = text.isEmpty ? .never : .always
    }
    
    @objc private func cancelButtonTapped() {
        delegate?.searchBarCancelButtonClicked(self)
    }
    
    func setShowsCancelButton(_ shows: Bool) {
        textField.layoutIfNeeded()
        UIView.animate(withDuration: 0.25) {
            self.cancelButton.alpha = shows ? 1 : 0
            let constant =  shows ? 0 : self.cancelButtonConstant
            self.cancelButtonConstraint?.constant = constant
            self.layoutIfNeeded()
        }
    }
}

// MARK: - Text Field Delegate
extension SearchBar: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.searchBarTextDidBeginEditing(self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.searchBarTextDidEndEditing(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.searchBarSearchButtonClicked(self)
        return true
    }
}
