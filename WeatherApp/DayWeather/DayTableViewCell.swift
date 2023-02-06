//
//  DayTableViewCell.swift
//  WeatherApp
//
//  Created by ROMAN VRONSKY on 06.02.2023.
//

import UIKit

class DayTableViewCell: UITableViewCell {

    private lazy var descriptLabel = WeatherLabels(size: 14, weight: .regular, color: .black)
    private lazy var testimonyLabel = WeatherLabels(size: 18, weight: .regular, color: .black)
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(descript: String, testimony: String, image: String) {
        self.descriptLabel.text = descript
        self.testimonyLabel.text = testimony
        self.iconImageView.image = UIImage(named: image)
    }
    
    
    private func setupView() {
        self.contentView.backgroundColor = #colorLiteral(red: 0.9141461849, green: 0.9332635999, blue: 0.9784278274, alpha: 1)
        self.contentView.addSubview(self.iconImageView)
        self.contentView.addSubview(self.descriptLabel)
        self.contentView.addSubview(self.testimonyLabel)
        
        
        
        NSLayoutConstraint.activate([
        
            self.iconImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 16),
            self.iconImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor,constant: 16),
            self.iconImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.4),
            self.iconImageView.widthAnchor.constraint(equalTo: self.iconImageView.heightAnchor),
            self.iconImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            
            self.descriptLabel.centerYAnchor.constraint(equalTo: self.iconImageView.centerYAnchor),
            self.descriptLabel.leftAnchor.constraint(equalTo: self.iconImageView.rightAnchor, constant: 16),
            
            self.testimonyLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.testimonyLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
           
        
        ])
    }
}
