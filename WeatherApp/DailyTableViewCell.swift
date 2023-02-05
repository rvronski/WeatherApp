//
//  DailyTableViewCell.swift
//  WeatherApp
//
//  Created by ROMAN VRONSKY on 04.02.2023.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    
    private lazy var dateLabel = WeatherLabels(size: 16, weight: .regular, color: .systemGray)
    private lazy var descriptionLabel = WeatherLabels(size: 16, weight: .regular, color: .black)
    private lazy var tempLabel = WeatherLabels(size: 18, weight: .regular, color: .black)
    private lazy var rainLabel = WeatherLabels(size: 12, weight: .regular, color: .black)

    private lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(data: Daily) {
        let tempMin = data.temp?.min ?? 0
        let tempMax = data.temp?.max ?? 0
        let day = data.dt ?? 0
        let humidity = data.humidity ?? 0
        let description = data.weather?.first?.description ?? ""
        let date = Date(timeIntervalSince1970: TimeInterval(day))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/MM"
        let newDay = dateFormatter.string(from: date)
        self.iconImageView.image = UIImage(named: "humidity")
        self.tempLabel.text = "\(Int(tempMin))˚/\(Int(tempMax))˚ "
        self.dateLabel.text = newDay
        self.descriptionLabel.text = description.capitalizedSentence
        self.rainLabel.text = "\(humidity)%"
    }
    
    
    private func setupView() {
        self.contentView.backgroundColor = #colorLiteral(red: 0.9141461849, green: 0.9332635999, blue: 0.9784278274, alpha: 1)
        self.contentView.layer.cornerRadius = 10
        self.contentView.addSubview(self.iconImageView)
        self.contentView.addSubview(self.dateLabel)
        self.contentView.addSubview(self.descriptionLabel)
        self.contentView.addSubview(self.tempLabel)
        self.contentView.addSubview(self.rainLabel)
        
        
        NSLayoutConstraint.activate([
        
            self.dateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 5),
            self.dateLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor,constant: 10),
            self.dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -31),
            
            
            self.iconImageView.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor,constant: 5),
            self.iconImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor,constant: 10),
            self.iconImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.30),
            self.iconImageView.widthAnchor.constraint(equalTo: self.iconImageView.heightAnchor),
            self.iconImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            
            self.rainLabel.centerYAnchor.constraint(equalTo: self.iconImageView.centerYAnchor),
            self.rainLabel.leftAnchor.constraint(equalTo: self.iconImageView.rightAnchor, constant: 5),
            
            self.descriptionLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.descriptionLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.descriptionLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.6),
            
            self.tempLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.tempLabel.leftAnchor.constraint(equalTo: self.descriptionLabel.rightAnchor, constant: 3),
            
        
        
        ])
    }
}
