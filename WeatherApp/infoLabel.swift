//
//  infoLabel.swift
//  WeatherApp
//
//  Created by ROMAN VRONSKY on 31.01.2023.
//

import UIKit

class InfoLabels: UILabel {
    init(inform: String, frame: CGRect, size: CGFloat, weight: UIFont.Weight) {
        super.init(frame: frame)
        text = inform
        textColor = .white
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
        font = UIFont.systemFont(ofSize: size, weight: weight)
        translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WeatherLabels: UILabel {
    init(size: CGFloat, weight: UIFont.Weight, color: UIColor ) {
        super.init(frame: .zero)
        textColor = color
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
        font = UIFont.systemFont(ofSize: size, weight: weight)
        translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


