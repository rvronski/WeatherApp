//
//  infoLabel.swift
//  WeatherApp
//
//  Created by ROMAN VRONSKY on 31.01.2023.
//

import UIKit

class InfoLabels: UILabel {
    init(inform: String, frame: CGRect, size: CGFloat, weight: UIFont.Weight, color: UIColor) {
        super.init(frame: frame)
        text = inform
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

class WeatherLabels: UILabel {
    init(size: CGFloat, weight: UIFont.Weight, color: UIColor ) {
        super.init(frame: .zero)
        textColor = color
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
        font = UIFont.systemFont(ofSize: size, weight: weight)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class IconImageView: UIImageView {
    init(picture: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        image = UIImage(named: picture)
        clipsToBounds = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

