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
        static let lineWidthRatio: CGFloat = 1/8
        static let firstSpacingToSumSpacing: CGFloat = 5/14
        static let spacingToSumSpacing: CGFloat = 3/14
    }
    
    private var confirmed: Int = 0
    private var recovered: Int = 0
    private var deaths: Int = 0
    private var active: Int {
        return confirmed - deaths - recovered
    }
    
    private var cornerRadius: CGFloat = 0
    private var lineWidth: CGFloat = 0
    private var firstSpacing: CGFloat = 0
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
        lineWidth = Constants.lineWidthRatio * frame.width
        let sumSpacing = frame.width - 5 * lineWidth
        firstSpacing = Constants.firstSpacingToSumSpacing * sumSpacing
        spacing = Constants.spacingToSumSpacing * sumSpacing
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
        createVerticalChart()
        let offset = lineWidth + firstSpacing
        let heights = [confirmedHeight, recoveredHeight, deathsHeight, activeHeight]
        let colors: [UIColor] = [.covidPink, .covidGreen, .deathColor, .covidOrange]
        heights.indices.forEach {
            let rect = CGRect(
                x: offset + CGFloat($0) * (lineWidth + spacing),
                y: frame.height - heights[$0],
                width: lineWidth,
                height: heights[$0]
            )
            let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            colors[$0].setFill()
            path.fill()
        }
    }
    
    func createVerticalChart() {        
        let chartSpacing = lineWidth
        let availableHeight = frame.height - 2 * chartSpacing
        guard availableHeight > 3 * lineWidth else { return }
        var heights = [deathsHeight, activeHeight, recoveredHeight]
        var index = 0
        while heights.sum > availableHeight {
            let newHeight = max(heights[index] - 1, lineWidth)
            heights[index] = newHeight
            index += 1
            index %= 3
        }
        
        let colors: [UIColor] = [.deathColor, .covidOrange, .covidGreen]
        
        heights.indices.forEach {
            let y = CGFloat($0) * (chartSpacing) + heights.sum(first: $0)
            let rect = CGRect(x: 0, y: y, width: lineWidth, height: heights[$0])
            let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            colors[$0].setFill()
            path.fill()
        }
    }
}
