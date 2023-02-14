//
//  TwentyFourTableViewCell.swift
//  WeatherApp
//
//  Created by ROMAN VRONSKY on 12.02.2023.
//

import UIKit

class TwentyFourTableViewCell: UITableViewCell {

    private lazy var tempLabel = WeatherLabels(size: 18, weight: .medium, color: .black)
    private lazy var timeLabel = WeatherLabels(size: 14, weight: .regular, color: .systemGray)
    private lazy var dateLabel = WeatherLabels(size: 18, weight: .medium, color: .black)
    private lazy var feelTempLabel = WeatherLabels(size: 14, weight: .medium, color: .black)
    private lazy var windLabel = InfoLabels(inform: "Ветер", frame: .zero, size: 14, weight: .regular, color: .black)
    private lazy var precipitationLabel = InfoLabels(inform: "Атмосферные осадки", frame: .zero, size: 14, weight: .regular, color: .black)
    private lazy var cloudyLabel = InfoLabels(inform: "Облачность", frame: .zero, size: 14, weight: .regular, color: .black)
    private lazy var testimonyPrecipitationLabel = WeatherLabels(size: 14, weight: .regular, color: .black)
    private lazy var testimonyCloudyLabel = WeatherLabels(size: 14, weight: .regular, color: .black)
    private lazy var testimonyWindLabel = WeatherLabels(size: 14, weight: .regular, color: .black)
    
    private lazy var feelIconImage = IconImageView(picture: "moon")
    private lazy var windIconImage = IconImageView(picture: "wind")
    private lazy var precipitationIconImage = IconImageView(picture: "humidity")
    private lazy var cloudyIconImage = IconImageView(picture: "cloud")
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(list: List?) {
        if let list {
            let day = list.dt ?? 0
            let time = list.dt ?? 0
            let temp = list.main?.temp ?? 0
            let clouds = list.clouds?.all ?? 0
            let feelTemp = list.main?.feelsLike ?? 0
            let wind = list.wind?.speed ?? 0
            let pop = list.pop ?? 0
            let newPop = pop * 100
            let newTime = unixTimeFormatter(time: time)
            self.dateLabel.text = dateFormatter(day: day)
            self.timeLabel.text = newTime
            self.tempLabel.text = "\(Int(temp))˚"
            self.feelTempLabel.text = "По ощущению \(Int(feelTemp))˚"
            self.testimonyCloudyLabel.text = "\(clouds)%"
            self.testimonyWindLabel.text = "\(Int(wind)) m/s"
            self.testimonyPrecipitationLabel.text = "\(Int(newPop))%"
        } else {
            self.dateLabel.text = "0"
            self.timeLabel.text = "0"
            self.tempLabel.text = "0"
            self.feelTempLabel.text = "0"
            self.testimonyCloudyLabel.text = "0"
            self.testimonyWindLabel.text = "0"
            self.testimonyPrecipitationLabel.text = "0"
        }
        
    }
    
    private func setupView() {
        self.contentView.backgroundColor = #colorLiteral(red: 0.9141461849, green: 0.9332635999, blue: 0.9784278274, alpha: 1)
        self.contentView.addSubview(tempLabel)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(feelTempLabel)
        self.contentView.addSubview(windLabel)
        self.contentView.addSubview(precipitationLabel)
        self.contentView.addSubview(cloudyLabel)
        self.contentView.addSubview(testimonyPrecipitationLabel)
        self.contentView.addSubview(testimonyCloudyLabel)
        self.contentView.addSubview(testimonyWindLabel)
        self.contentView.addSubview(feelIconImage)
        self.contentView.addSubview(windIconImage)
        self.contentView.addSubview(precipitationIconImage)
        self.contentView.addSubview(cloudyIconImage)
        
        NSLayoutConstraint.activate([
        
            self.dateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 10),
            self.dateLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor,constant: 16),
            
            self.timeLabel.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor,constant: 8),
            self.timeLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor,constant: 16),
            
            self.tempLabel.topAnchor.constraint(equalTo: self.timeLabel.bottomAnchor,constant: 10),
            self.tempLabel.centerXAnchor.constraint(equalTo: self.timeLabel.centerXAnchor),
            
            self.feelIconImage.centerYAnchor.constraint(equalTo: self.timeLabel.centerYAnchor),
            self.feelIconImage.leftAnchor.constraint(equalTo: self.timeLabel.rightAnchor,constant: 16),
            self.feelIconImage.widthAnchor.constraint(equalTo: self.contentView.widthAnchor,multiplier: 0.04),
            self.feelIconImage.heightAnchor.constraint(equalTo: self.feelIconImage.widthAnchor),
            
            
            self.windIconImage.topAnchor.constraint(equalTo: self.feelIconImage.bottomAnchor,constant: 16),
            self.windIconImage.centerXAnchor.constraint(equalTo: self.feelIconImage.centerXAnchor),
            self.windIconImage.widthAnchor.constraint(equalTo: self.contentView.widthAnchor,multiplier: 0.04),
            self.windIconImage.heightAnchor.constraint(equalTo: self.windIconImage.widthAnchor),
            
            self.precipitationIconImage.topAnchor.constraint(equalTo: self.windIconImage.bottomAnchor,constant: 16),
            self.precipitationIconImage.centerXAnchor.constraint(equalTo: self.feelIconImage.centerXAnchor),
            self.precipitationIconImage.widthAnchor.constraint(equalTo: self.contentView.widthAnchor,multiplier: 0.04),
            self.precipitationIconImage.heightAnchor.constraint(equalTo: self.precipitationIconImage.widthAnchor),
            
            self.cloudyIconImage.topAnchor.constraint(equalTo: self.precipitationIconImage.bottomAnchor,constant: 16),
            self.cloudyIconImage.centerXAnchor.constraint(equalTo: self.feelIconImage.centerXAnchor),
            self.cloudyIconImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -8),
            self.cloudyIconImage.widthAnchor.constraint(equalTo: self.contentView.widthAnchor,multiplier: 0.04),
            self.cloudyIconImage.heightAnchor.constraint(equalTo: self.cloudyIconImage.widthAnchor),
            
            self.feelTempLabel.centerYAnchor.constraint(equalTo: self.feelIconImage.centerYAnchor),
            self.feelTempLabel.leftAnchor.constraint(equalTo: self.feelIconImage.rightAnchor, constant: 5),
            
            self.windLabel.centerYAnchor.constraint(equalTo: self.windIconImage.centerYAnchor),
            self.windLabel.leftAnchor.constraint(equalTo: self.windIconImage.rightAnchor, constant: 5),
            
            self.windLabel.centerYAnchor.constraint(equalTo: self.windIconImage.centerYAnchor),
            self.windLabel.leftAnchor.constraint(equalTo: self.windIconImage.rightAnchor, constant: 5),
            
            self.precipitationLabel.centerYAnchor.constraint(equalTo: self.precipitationIconImage.centerYAnchor),
            self.precipitationLabel.leftAnchor.constraint(equalTo: self.precipitationIconImage.rightAnchor, constant: 5),
            
            self.cloudyLabel.centerYAnchor.constraint(equalTo: self.cloudyIconImage.centerYAnchor),
            self.cloudyLabel.leftAnchor.constraint(equalTo: self.cloudyIconImage.rightAnchor, constant: 5),
            
            self.testimonyWindLabel.centerYAnchor.constraint(equalTo: self.windLabel.centerYAnchor),
            self.testimonyWindLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            
            self.testimonyPrecipitationLabel.centerYAnchor.constraint(equalTo: self.precipitationLabel.centerYAnchor),
            self.testimonyPrecipitationLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            
            self.testimonyCloudyLabel.centerYAnchor.constraint(equalTo: self.cloudyLabel.centerYAnchor),
            self.testimonyCloudyLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            
            
            
            
            
            
        
        ])
        
    }
}
