//
//  CountryStatCell.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 03. 31..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import UIKit
import ClosureLayout

class CountryStatCell: UITableViewCell {
    // MARK: - Constants
    private enum Constants {
        static let plotSize = CGSize(width: 37, height: 48)
        static let flagSize = CGSize(width: 46, height: 30)
        static let leftInset: CGFloat = 24
        static let rightInset: CGFloat = 40
        static let confirmedIcon = UIImage(named: "confirmedIcon")
        static let recoveredIcon = UIImage(named: "recoveredIcon")
        static let deathsIcon = UIImage(named: "deathsIcon")
        static let activeIcon = UIImage(named: "activeIcon")
    }
    
    // MARK: - UI Properties
    let titleLabel = UILabel()
    let lastUpdatedLabel = UILabel()
    let flagView = UIImageView()
    let plotView = PlotView()
    
    let confirmedView = StatView(tintColor: .covidPink)
    let recoveredView = StatView(tintColor: .covidGreen)
    let deathsView = StatView(tintColor: .deathColor)
    let activeView = StatView(tintColor: .covidOrange)
    
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
        Theme.register(self, selector: #selector(themeChanged))
        backgroundColor = .clear
        titleLabel.font = .roundedFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .accentColor
        lastUpdatedLabel.font = .roundedFont(ofSize: 10, weight: .medium)
        lastUpdatedLabel.textColor = .secondaryColor
        flagView.contentMode = .scaleAspectFit
        plotView.backgroundColor = .clear

        let separator = UIView()
        separator.backgroundColor = UIColor(0x7B7B7B).withAlphaComponent(0.2)
        contentView.addSubview(separator)
        separator.layout {
            $0.top == contentView.topAnchor
            $0.leading == contentView.leadingAnchor + Constants.leftInset
            $0.trailing == contentView.trailingAnchor - 30
            $0.height == 1
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.layout {
            $0.top == contentView.topAnchor + 16
            $0.leading == contentView.leadingAnchor + Constants.leftInset
        }
        
        contentView.addSubview(lastUpdatedLabel)
        lastUpdatedLabel.layout {
            $0.top == contentView.topAnchor + 16
            $0.trailing == contentView.trailingAnchor - 30
        }
        
        let firstColumn = UIStackView(confirmedView, deathsView)
        firstColumn.axis = .vertical
        firstColumn.spacing = 8
        let secondColumn = UIStackView(recoveredView, activeView)
        secondColumn.axis = .vertical
        secondColumn.spacing = 8
        let statStackView = UIStackView(firstColumn, secondColumn)
        statStackView.spacing = 16
        
        flagView.layout { $0.size == Constants.flagSize }
        plotView.layout { $0.size == Constants.plotSize }
        
        let contentStackView = UIStackView(statStackView, plotView, flagView)
        contentStackView.spacing = 40
        contentStackView.alignment = .bottom
        contentView.addSubview(contentStackView)
        contentStackView.layout {
            $0.top == titleLabel.bottomAnchor + 16
            $0.bottom == contentView.bottomAnchor - 30
            $0.leading == contentView.leadingAnchor + Constants.leftInset
            $0.trailing == contentView.trailingAnchor - Constants.rightInset
        }
    }
    
    func configure(with vm: CountryStatViewModel) {
        titleLabel.text = vm.country.name
        flagView.image = vm.country.flag
        lastUpdatedLabel.text = vm.lastUpdated
        confirmedView.label.text = vm.confirmed.asString.numberFormatted
        confirmedView.imageView.image = Constants.confirmedIcon
        deathsView.label.text = vm.deaths.asString.numberFormatted
        deathsView.imageView.image = Constants.deathsIcon
        recoveredView.label.text = vm.recovered.asString.numberFormatted
        recoveredView.imageView.image = Constants.recoveredIcon
        activeView.label.text = vm.active.asString.numberFormatted
        activeView.imageView.image = Constants.activeIcon
        plotView.configure(confirmed: vm.confirmed, recovered: vm.recovered, deaths: vm.deaths)
    }
    
    @objc func themeChanged() {
        titleLabel.textColor = .accentColor
        lastUpdatedLabel.textColor = .secondaryColor
        deathsView.tintColor = .deathColor
        plotView.setNeedsDisplay()
    }
}
