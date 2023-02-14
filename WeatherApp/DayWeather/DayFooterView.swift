//
//  DayFooterView.swift
//  WeatherApp
//
//  Created by ROMAN VRONSKY on 06.02.2023.
//

import UIKit

class DayFooterView: UITableViewHeaderFooterView {
    
    private lazy var moonSunLabel = WeatherLabels(size: 18, weight: .regular, color: .black)
    private lazy var sunsetLabel = WeatherLabels(size: 14, weight: .regular, color: .lightGray)
    private lazy var sunriseLabel = WeatherLabels(size: 14, weight: .regular, color: .lightGray)
    private lazy var moonsetLabel = WeatherLabels(size: 14, weight: .regular, color: .lightGray)
    private lazy var moonriseLabel = WeatherLabels(size: 14, weight: .regular, color: .lightGray)
    
    private lazy var sunsetTimeLabel = WeatherLabels(size: 16, weight: .regular, color: .black)
    private lazy var sunriseTimeLabel = WeatherLabels(size: 16, weight: .regular, color: .black)
    private lazy var moonsetTimeLabel = WeatherLabels(size: 16, weight: .regular, color: .black)
    private lazy var moonriseTimeLabel = WeatherLabels(size: 16, weight: .regular, color: .black)
    
    private lazy var moonPhaseLabel = WeatherLabels(size: 14, weight: .regular, color: .black)
    
    private lazy var sunIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "solar")
        return imageView
    }()
    
    private lazy var moonIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "moon")
        return imageView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(daily: Daily) {
        self.sunsetLabel.text = "Заход"
        self.sunriseLabel.text = "Восход"
        self.moonsetLabel.text = "Заход"
        self.moonriseLabel.text = "Восход"
        self.moonSunLabel.text = "Солнце и Луна"
        let sunrise = daily.sunrise ?? 0
        let sunset = daily.sunset ?? 0
        let moonrise = daily.moonrise ?? 0
        let moonset = daily.moonset ?? 0
        let phase = daily.moonPhase ?? 0
        let moonsetTime = unixTimeFormatter(time: moonset)
        let moonriseTime = unixTimeFormatter(time: moonrise)
        let sunsetTime = unixTimeFormatter(time: sunset)
        let sunriseTime = unixTimeFormatter(time: sunrise)
        let moonPhase = moonPhaseFormatter(phase: phase)
        self.sunsetTimeLabel.text = sunsetTime
        self.sunriseTimeLabel.text = sunriseTime
        self.moonsetTimeLabel.text = moonsetTime
        self.moonriseTimeLabel.text = moonriseTime
        self.moonPhaseLabel.text = moonPhase
        
    
    }
    
    private func setupView() {
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(self.moonIconImageView)
        self.contentView.addSubview(self.sunIconImageView)
        self.contentView.addSubview(self.moonSunLabel)
        self.contentView.addSubview(self.sunsetLabel)
        self.contentView.addSubview(self.sunriseLabel)
        self.contentView.addSubview(self.moonsetLabel)
        self.contentView.addSubview(self.sunsetTimeLabel)
        self.contentView.addSubview(self.sunriseTimeLabel)
        self.contentView.addSubview(self.moonsetTimeLabel)
        self.contentView.addSubview(self.moonriseTimeLabel)
        self.contentView.addSubview(self.moonPhaseLabel)
        self.contentView.addSubview(self.moonriseLabel)
        
        NSLayoutConstraint.activate([
        
            self.moonSunLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.moonSunLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            
            self.moonPhaseLabel.centerYAnchor.constraint(equalTo: self.moonSunLabel.centerYAnchor),
            self.moonPhaseLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            
            self.sunIconImageView.topAnchor.constraint(equalTo: self.moonSunLabel.bottomAnchor,constant: 20),
            self.sunIconImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor,constant: 37),
            self.sunIconImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor,multiplier: 0.05),
            self.sunIconImageView.heightAnchor.constraint(equalTo: self.sunIconImageView.widthAnchor),
            
            self.moonIconImageView.centerYAnchor.constraint(equalTo: self.sunIconImageView.centerYAnchor),
            self.moonIconImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor,constant: -140),
            self.moonIconImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor,multiplier: 0.04),
            self.moonIconImageView.heightAnchor.constraint(equalTo: self.moonIconImageView.widthAnchor),
            
            self.sunriseLabel.topAnchor.constraint(equalTo: self.sunIconImageView.bottomAnchor,constant: 20),
            self.sunriseLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor,constant: 34),
            
            self.sunsetLabel.topAnchor.constraint(equalTo: self.sunriseLabel.bottomAnchor,constant: 17),
            self.sunsetLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor,constant: 34),
            self.sunsetLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -16),
            
            self.sunsetTimeLabel.centerYAnchor.constraint(equalTo: self.sunsetLabel.centerYAnchor),
            self.sunsetTimeLabel.leftAnchor.constraint(equalTo: self.sunsetLabel.rightAnchor,constant: 46),
            
            self.moonsetLabel.centerYAnchor.constraint(equalTo: self.sunsetLabel.centerYAnchor),
            self.moonsetLabel.leftAnchor.constraint(equalTo: self.moonriseLabel.leftAnchor),
            
            self.moonsetTimeLabel.centerYAnchor.constraint(equalTo: self.sunsetLabel.centerYAnchor),
            self.moonsetTimeLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor,constant: -20),
            
            self.sunriseTimeLabel.centerYAnchor.constraint(equalTo: self.sunriseLabel.centerYAnchor),
            self.sunriseTimeLabel.leftAnchor.constraint(equalTo: self.sunriseLabel.rightAnchor,constant: 46),
            
            self.moonriseLabel.centerYAnchor.constraint(equalTo: self.sunriseLabel.centerYAnchor),
            self.moonriseLabel.leftAnchor.constraint(equalTo: self.sunriseTimeLabel.rightAnchor, constant: 44),
            
            self.moonriseTimeLabel.centerYAnchor.constraint(equalTo: self.sunriseLabel.centerYAnchor),
            self.moonriseTimeLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor,constant: -20),
            
            
            
        
        ])
    }
}
