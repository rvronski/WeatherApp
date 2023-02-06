//
//  DayHeaderView.swift
//  WeatherApp
//
//  Created by ROMAN VRONSKY on 06.02.2023.
//

import UIKit

class DayHeaderView: UITableViewHeaderFooterView {
    
    private lazy var descriptLabel = WeatherLabels(size: 18, weight: .regular, color: .black)
    private lazy var tempLabel = WeatherLabels(size: 30, weight: .regular, color: .black)
    private lazy var dayNightLabel = WeatherLabels(size: 18, weight: .regular, color: .black)
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
   
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(dayNight: String, temp: String, description: String, image: String) {
        self.dayNightLabel.text = dayNight
        self.tempLabel.text = temp
        self.descriptLabel.text = description
        self.iconImageView.image = UIImage(named: image)
        
    }
    
    private func setupView() {
        self.contentView.backgroundColor = #colorLiteral(red: 0.9141461849, green: 0.9332635999, blue: 0.9784278274, alpha: 1)
        self.contentView.addSubview(self.iconImageView)
        self.contentView.addSubview(self.descriptLabel)
        self.contentView.addSubview(self.dayNightLabel)
        self.contentView.addSubview(self.tempLabel)
    
        NSLayoutConstraint.activate([
        
            self.iconImageView.centerYAnchor.constraint(equalTo: self.tempLabel.centerYAnchor),
            self.iconImageView.rightAnchor.constraint(equalTo: self.tempLabel.leftAnchor, constant: -10),
            self.iconImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.6),
            self.iconImageView.widthAnchor.constraint(equalTo: self.iconImageView.heightAnchor),
            
            self.descriptLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.descriptLabel.topAnchor.constraint(equalTo: self.iconImageView.bottomAnchor, constant: 10),
            self.descriptLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            
            self.tempLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.tempLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
           
            self.dayNightLabel.centerYAnchor.constraint(equalTo: self.tempLabel.centerYAnchor),
            self.dayNightLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16)
        
        ])
    }
}
