//
//  PlotView.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 03. 31..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import UIKit

class PlotView: UIView {
    private enum Constants {
        static let lineWidthRatio: CGFloat = 1/6
    }
    
    private var confirmed: Int = 0
    private var recovered: Int = 0
    private var deaths: Int = 0
    private var active: Int {
        return confirmed - deaths - recovered
    }
    
    private var cornerRadius: CGFloat = 0
    private var lineWidth: CGFloat = 0
    private var spacing: CGFloat = 0
    
    private var confirmedHeight: CGFloat = 0
    private var recoveredHeight: CGFloat = 0
    private var deathsHeight: CGFloat = 0
    private var activeHeight: CGFloat = 0
    
    func configure(confirmed: Int, recovered: Int, deaths: Int) {
        self.confirmed = confirmed
        self.recovered = recovered
        self.deaths = deaths
        calculateDimensions()
        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        calculateDimensions()
    }
    
    private func calculateDimensions() {
        lineWidth = frame.width * Constants.lineWidthRatio
        spacing = (frame.width - 4 * lineWidth) / 3
        cornerRadius = lineWidth / 2
        confirmedHeight = frame.height
        recoveredHeight = heightPortion(of: frame.height, like: recovered, to: confirmed)
        deathsHeight = heightPortion(of: frame.height, like: deaths, to: confirmed)
        activeHeight = heightPortion(of: frame.height, like: active, to: confirmed)
        recoveredHeight = max(lineWidth, recoveredHeight)
        deathsHeight = max(lineWidth, deathsHeight)
        activeHeight = max(lineWidth, activeHeight)
    }
    
    private func heightPortion(of height: CGFloat, like part: Int, to whole: Int) -> CGFloat {
        guard whole > 0 else { return 0 }
        return (CGFloat(part) * height) / CGFloat(whole)
    }
    
    override func draw(_ rect: CGRect) {
        let heights = [confirmedHeight, recoveredHeight, deathsHeight, activeHeight]
        let colors: [UIColor] = [.covidPink, .covidGreen, .deathColor, .covidOrange]
        heights.indices.forEach {
            let rect = CGRect(
                x: CGFloat($0) * (lineWidth + spacing),
                y: frame.height - heights[$0],
                width: lineWidth,
                height: heights[$0]
            )
            let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            colors[$0].setFill()
            path.fill()
        }
    }
}
