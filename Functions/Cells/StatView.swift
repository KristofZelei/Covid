//
//  StatView.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 03. 31..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import UIKit
import ClosureLayout

class StatView: UIView {

    let imageView = UIImageView()
    let label = UILabel()
    
    convenience init(tintColor: UIColor) {
        self.init(frame: .zero)
        setupViews()
        self.tintColor = tintColor
    }
    
    private func setupViews() {
        imageView.contentMode = .scaleAspectFit
        label.font = .roundedFont(ofSize: 12, weight: .bold)
        imageView.layout {
            $0.width == 12
            $0.height == 12
        }
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.alignment = .center
        stackView.spacing = 4
        fillWith(stackView)
    }
    
    override var tintColor: UIColor! {
        didSet {
            imageView.tintColor = tintColor
            label.textColor = tintColor
        }
    }
}
