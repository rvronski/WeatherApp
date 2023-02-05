//
//  WeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by ROMAN VRONSKY on 02.02.2023.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    private lazy var weatherDetailView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = self.frame.width/2
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    private lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    private lazy var timeLabel = WeatherLabels(size: 14, weight: .regular, color: .black)
    private lazy var tempLabel = WeatherLabels(size: 16, weight: .regular, color: .black)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(list: List) {
        let image = list.weather?.first?.icon ?? ""
        let time = list.dt ?? 0
        var correctTime = 0
        if timezone < 0 {
            correctTime = timezone + time
        } else {
            correctTime = time + timezone
        }
        let date = Date(timeIntervalSince1970: TimeInterval(correctTime))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .gmt
        dateFormatter.dateFormat = "HH:mm"
        let newTime = dateFormatter.string(from: date)
        let temp = list.main?.temp ?? 0
        self.timeLabel.text = newTime
        self.tempLabel.text = "\(Int(temp))˚"
        self.iconImageView.image = UIImage(named: image)
    }
    
    
    
    private func setupView() {
        self.contentView.addSubview(self.weatherDetailView)
        self.weatherDetailView.addSubview(self.timeLabel)
        self.weatherDetailView.addSubview(self.tempLabel)
        self.weatherDetailView.addSubview(self.iconImageView)
        
        NSLayoutConstraint.activate([
            self.weatherDetailView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.weatherDetailView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.weatherDetailView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.weatherDetailView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            
            self.timeLabel.topAnchor.constraint(equalTo: self.weatherDetailView.topAnchor, constant: 15),
            self.timeLabel.leftAnchor.constraint(equalTo: self.weatherDetailView.leftAnchor, constant: 2),
            self.timeLabel.rightAnchor.constraint(equalTo: self.weatherDetailView.rightAnchor, constant: -2),
            
            self.tempLabel.centerXAnchor.constraint(equalTo: self.weatherDetailView.centerXAnchor),
            self.tempLabel.bottomAnchor.constraint(equalTo: self.weatherDetailView.bottomAnchor, constant: -8),
           
            self.iconImageView.centerXAnchor.constraint(equalTo: self.weatherDetailView.centerXAnchor),
            self.iconImageView.centerYAnchor.constraint(equalTo: self.weatherDetailView.centerYAnchor),
            self.iconImageView.heightAnchor.constraint(equalTo: self.weatherDetailView.widthAnchor, multiplier: 0.6),
            self.iconImageView.widthAnchor.constraint(equalTo: self.iconImageView.heightAnchor)
        
        ])
    }
}
