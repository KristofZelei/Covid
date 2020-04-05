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
        static let plotSize = CGSize(width: 60, height: 60)
        static let flagSize = CGSize(width: 23, height: 15)
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
    
    let deathRateLabel = UILabel()
    let activeRateLabel = UILabel()
    let recoveredRateLabel = UILabel()

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
        addSeparator()
        addTitleViews()
        addStatViews()
        addPercentages()
    }
    
    private func addSeparator() {
        let separator = UIView()
        separator.backgroundColor = UIColor(0x7B7B7B).withAlphaComponent(0.2)
        contentView.addSubview(separator)
        separator.layout {
            $0.top == contentView.topAnchor
            $0.leading == contentView.leadingAnchor + Constants.leftInset
            $0.trailing == contentView.trailingAnchor - Constants.rightInset
            $0.height == 1
        }
    }
    
    private func addTitleViews() {
        flagView.layout { $0.size == Constants.flagSize }
        let titleStackView = UIStackView(flagView, titleLabel)
        titleStackView.spacing = 8
        titleStackView.alignment = .center
        contentView.addSubview(titleStackView)
        titleStackView.layout {
            $0.top == contentView.topAnchor + 14
            $0.leading == contentView.leadingAnchor + Constants.leftInset
        }
        contentView.addSubview(lastUpdatedLabel)
        lastUpdatedLabel.layout {
            $0.top == contentView.topAnchor + 16
            $0.trailing == contentView.trailingAnchor - Constants.rightInset
            
        }
    }
    
    private func addStatViews() {
        let firstColumn = UIStackView(confirmedView, deathsView)
        firstColumn.axis = .vertical
        firstColumn.spacing = 14
        let secondColumn = UIStackView(recoveredView, activeView)
        secondColumn.axis = .vertical
        secondColumn.spacing = 14
        let statStackView = UIStackView(firstColumn, secondColumn)
        statStackView.spacing = 16
        contentView.addSubview(statStackView)
        statStackView.layout {
            $0.bottom == contentView.bottomAnchor - 30
            $0.leading == contentView.leadingAnchor + Constants.leftInset
        }
        contentView.addSubview(plotView)
        plotView.layout {
            $0.top == lastUpdatedLabel.bottomAnchor + 22
            $0.trailing == contentView.trailingAnchor - Constants.rightInset
            $0.bottom == contentView.bottomAnchor - 30
            $0.size == Constants.plotSize
        }
    }
    
    private func addPercentages() {
        let rateLabels = [deathRateLabel, activeRateLabel, recoveredRateLabel]
        rateLabels.forEach {
            $0.textColor = .accentColor
            $0.font = .roundedFont(ofSize: 10, weight: .bold)
        }
        let stackView = UIStackView(arrangedSubviews: rateLabels)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .trailing
        contentView.addSubview(stackView)
        stackView.layout {
            $0.bottom == plotView.bottomAnchor
            $0.top == plotView.topAnchor
            $0.trailing == plotView.leadingAnchor - 8
        }
    }
    
    func configure(with vm: CountryStatViewModel) {
        titleLabel.text = vm.country
        flagView.image = vm.flag
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
        deathRateLabel.text = Int(100 * vm.deaths / vm.confirmed).asString + "%"
        activeRateLabel.text = Int(100 * vm.active / vm.confirmed).asString + "%"
        recoveredRateLabel.text = Int(100 * vm.recovered / vm.confirmed).asString + "%"
    }
    
    @objc func themeChanged() {
        titleLabel.textColor = .accentColor
        lastUpdatedLabel.textColor = .secondaryColor
        deathsView.tintColor = .deathColor
        [deathRateLabel, activeRateLabel, recoveredRateLabel].forEach {
            $0.textColor = .accentColor
        }
        plotView.setNeedsDisplay()
    }
}
