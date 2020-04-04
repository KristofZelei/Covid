//
//  WorldStatCell.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 03. 31..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import UIKit
import ClosureLayout

protocol WorldStatCellDelegate: AnyObject {
    func sortButtonTapped()
    func moreButtonTapped()
}

class WorldStatCell: UITableViewCell {
    // MARK: - Constants
    private enum Constants {
        static let sortIcon = UIImage(named: "sortIcon")
        static let confirmedIcon = UIImage(named: "confirmedIcon")
        static let recoveredIcon = UIImage(named: "recoveredIcon")
        static let deathsIcon = UIImage(named: "deathsIcon")
        static let activeIcon = UIImage(named: "activeIcon")
        static let moreIcon = UIImage(named: "moreIcon")
    }
    
    // MARK: - Delegate
    weak var delegate: WorldStatCellDelegate?
    
    // MARK: - UI Properties
    let contentStackView = UIStackView()
    let subtitleLabel = UILabel()
    let titleLabel = UILabel()
    let lastUpdatedLabel = UILabel()
    
    lazy var sortButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .roundedFont(ofSize: 15, weight: .semibold)
        button.setTitleColor(.gray, for: .normal)
        button.setImage(Constants.sortIcon, for: .normal)
        button.imagePadding = 5
        button.tintColor = .gray
        button.tintAdjustmentMode = .normal
        return button
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.tintColor = .gray
        button.setImage(Constants.moreIcon, for: .normal)
        button.tintAdjustmentMode = .normal
        return button
    }()
    
    private lazy var confirmedView = createStatField(
        icon: Constants.confirmedIcon,
        tintColor: .covidPink
    )
    private lazy var recoveredView = createStatField(
        icon: Constants.recoveredIcon,
        tintColor: .covidGreen
    )
    private lazy var deathsView = createStatField(
        icon: Constants.deathsIcon,
        tintColor: .deathColor
    )
    private lazy var activeView = createStatField(
        icon: Constants.activeIcon,
        tintColor: .covidOrange
    )
    
    // MARK: - Initial Setup
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .clear
        subtitleLabel.font = .roundedFont(ofSize: 15, weight: .medium)
        subtitleLabel.textColor = UIColor(0xCDCDCD)
        titleLabel.font = .roundedFont(ofSize: 36, weight: .bold)
        titleLabel.textColor = .accentColor
        titleLabel.adjustsFontSizeToFitWidth = true
        lastUpdatedLabel.font = .roundedFont(ofSize: 12, weight: .medium)
        lastUpdatedLabel.textColor = .secondaryColor
        let header = createHeader()
        contentStackView.axis = .vertical
        contentStackView.addArrangedSubview(header)
        contentStackView.setCustomSpacing(16, after: header)
        let insets = UIEdgeInsets(top: 8, left: 30, bottom: 24, right: 30)
        contentView.fillWith(contentStackView, insets: insets)
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        Theme.register(self, selector: #selector(themeChanged))
    }
    
    // MARK: - Actions
    @objc func sortButtonTapped() {
        delegate?.sortButtonTapped()
    }
    
    @objc func moreButtonTapped() {
        delegate?.moreButtonTapped()
    }
    
    @objc func themeChanged() {
        titleLabel.textColor = .accentColor
        deathsView.iconView.tintColor = .deathColor
        deathsView.valueLabel.textColor = .deathColor
        [confirmedView, recoveredView, deathsView, activeView].forEach {
            $0.nameLabel.textColor = .accentColor
        }
    }
    
    // MARK: - Helpers
    private func createHeader() -> UIStackView {
        let titleStackView = UIStackView(titleLabel, sortButton)
        sortButton.setContentHuggingPriority(.required, for: .horizontal)
        titleStackView.alignment = .center
        titleStackView.spacing = 24
        
        let dateWrapper = UIView()
        let insets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        dateWrapper.fillWith(lastUpdatedLabel, insets: insets)
        
        let subTitleStackView = UIStackView(subtitleLabel, moreButton)
        moreButton.setContentHuggingPriority(.required, for: .horizontal)
        subTitleStackView.alignment = .center
        subTitleStackView.spacing = 8
        
        let headerStackView = UIStackView(subTitleStackView, titleStackView, dateWrapper)
        headerStackView.setCustomSpacing(4, after: titleStackView)
        headerStackView.axis = .vertical
        return headerStackView
    }
    
    typealias StatField = (iconView: UIImageView, nameLabel: UILabel,  valueLabel: UILabel)
    private func createStatField(icon: UIImage?, tintColor: UIColor) -> StatField {
        let iconView = UIImageView(image: icon)
        iconView.tintColor = tintColor
        iconView.tintAdjustmentMode = .normal
        iconView.contentMode = .scaleAspectFit
        iconView.layout {
            $0.height == 14
            $0.width == 14
        }

        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        nameLabel.textColor = .accentColor
        nameLabel.layout { $0.width == UIScreen.main.bounds.midX }        
        
        let valueLabel = UILabel()
        valueLabel.font = .roundedFont(ofSize: 20, weight: .bold)
        valueLabel.textColor = tintColor
        valueLabel.adjustsFontSizeToFitWidth = true

        let stackView = UIStackView(iconView, nameLabel, valueLabel)
        stackView.layout { $0.height == 40 }
        stackView.spacing = 8
        stackView.alignment = .center
        contentStackView.addArrangedSubview(stackView)
        
        return (iconView, nameLabel, valueLabel)
    }
    
    // MARK: - Configuration
    func configure(with vm: WorldStatViewModel) {
        subtitleLabel.text = vm.subtitle
        titleLabel.text = vm.title
        sortButton.setTitle(vm.sortTitle, for: .normal)
        lastUpdatedLabel.text = vm.lastUpdated
        confirmedView.nameLabel.text = vm.confirmed.name
        confirmedView.valueLabel.text = vm.confirmed.value
        recoveredView.nameLabel.text = vm.recovered.name
        recoveredView.valueLabel.text = vm.recovered.value
        deathsView.nameLabel.text = vm.deaths.name
        deathsView.valueLabel.text = vm.deaths.value
        activeView.nameLabel.text = vm.active.name
        activeView.valueLabel.text = vm.active.value
    }
}
