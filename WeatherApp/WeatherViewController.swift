//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by ROMAN VRONSKY on 01.02.2023.
//

import UIKit

class WeatherViewController: UIViewController {
    private let backgroundColor = #colorLiteral(red: 0.1254122257, green: 0.3044758141, blue: 0.778311789, alpha: 1)
    private lazy var weatherView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = 5
        return view
    }()
    
    private lazy var ellipseImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "Ellipse")
        return view
    }()
    
    private lazy var sunriseImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "daytime")
        return view
    }()
    
    private lazy var sunsetImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "sunset")
        return view
    }()
    private lazy var windImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "wind")
        return view
    }()
    private lazy var humidityImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "humidity")
        return view
    }()
    private lazy var cloudinessImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "cloud")
        return view
    }()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:MM, E d MMMM"
        let dateString = formatter.string(from: Date())
        label.text = dateString
        label.textColor = .yellow
        return label
    }()
    
    private lazy var tempLabel = WeatherLabels(size: 36, weight: .medium, color: .white)
    private lazy var sunsetLabel = WeatherLabels(size: 14, weight: .medium, color: .white)
    private lazy var sunriseLabel = WeatherLabels(size: 14, weight: .medium, color: .white)
    private lazy var maxMinLabel = WeatherLabels(size: 16, weight: .regular, color: .white)
    private lazy var cloudinessLabel = WeatherLabels(size: 14, weight: .regular, color: .white)
    private lazy var humidityLabel = WeatherLabels(size: 14, weight: .regular, color: .white)
    private lazy var windLabel = WeatherLabels(size: 14, weight: .regular, color: .white)
    private lazy var descriptionLabel = WeatherLabels(size: 16, weight: .regular, color: .white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        getWeather { weather in
            DispatchQueue.main.async {
                self.wheather(data: weather)
            }
            
        }
        
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.weatherView)
        self.weatherView.addSubview(self.ellipseImageView)
        self.weatherView.addSubview(self.sunriseImageView)
        self.weatherView.addSubview(self.sunsetImageView)
        self.weatherView.addSubview(self.dateLabel)
        self.weatherView.addSubview(self.tempLabel)
        self.weatherView.addSubview(self.sunriseLabel)
        self.weatherView.addSubview(self.sunsetLabel)
        self.weatherView.addSubview(self.maxMinLabel)
        self.weatherView.addSubview(self.cloudinessLabel)
        self.weatherView.addSubview(self.humidityLabel)
        self.weatherView.addSubview(self.windLabel)
        self.weatherView.addSubview(self.windImageView)
        self.weatherView.addSubview(self.humidityImageView)
        self.weatherView.addSubview(self.cloudinessImageView)
        self.weatherView.addSubview(self.descriptionLabel)
        
        NSLayoutConstraint.activate([
        
            self.weatherView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.weatherView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.weatherView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            self.weatherView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.248),
        
            self.ellipseImageView.topAnchor.constraint(equalTo: self.weatherView.topAnchor, constant: 17),
            self.ellipseImageView.leftAnchor.constraint(equalTo: self.weatherView.leftAnchor, constant: 33),
            self.ellipseImageView.rightAnchor.constraint(equalTo: self.weatherView.rightAnchor, constant: -33),
            
            self.sunriseImageView.topAnchor.constraint(equalTo: self.ellipseImageView.bottomAnchor, constant: 5),
            self.sunriseImageView.leftAnchor.constraint(equalTo: self.weatherView.leftAnchor, constant: 25),
            self.sunriseImageView.heightAnchor.constraint(equalTo: self.weatherView.heightAnchor, multiplier: 0.08),
            self.sunriseImageView.widthAnchor.constraint(equalTo: self.sunriseImageView.heightAnchor),
            
            self.sunsetImageView.topAnchor.constraint(equalTo: self.ellipseImageView.bottomAnchor, constant: 5),
            self.sunsetImageView.rightAnchor.constraint(equalTo: self.weatherView.rightAnchor, constant: -25),
            self.sunsetImageView.heightAnchor.constraint(equalTo: self.weatherView.heightAnchor, multiplier: 0.08),
            self.sunsetImageView.widthAnchor.constraint(equalTo: self.sunsetImageView.heightAnchor),
        
            self.dateLabel.centerXAnchor.constraint(equalTo: self.weatherView.centerXAnchor),
            self.dateLabel.bottomAnchor.constraint(equalTo: self.weatherView.bottomAnchor, constant: -21),
            
            self.maxMinLabel.centerXAnchor.constraint(equalTo: self.weatherView.centerXAnchor),
            self.maxMinLabel.topAnchor.constraint(equalTo: self.weatherView.topAnchor, constant: 33),
            
            self.tempLabel.centerXAnchor.constraint(equalTo: self.maxMinLabel.centerXAnchor),
            self.tempLabel.topAnchor.constraint(equalTo: self.weatherView.topAnchor, constant: 58),
            
            self.descriptionLabel.centerXAnchor.constraint(equalTo: self.weatherView.centerXAnchor),
            self.descriptionLabel.topAnchor.constraint(equalTo: self.tempLabel.bottomAnchor, constant: 5),
            
            self.sunriseLabel.centerXAnchor.constraint(equalTo: self.sunriseImageView.centerXAnchor),
            self.sunriseLabel.topAnchor.constraint(equalTo: self.sunriseImageView.bottomAnchor, constant: 5),
            
            self.sunsetLabel.centerXAnchor.constraint(equalTo: self.sunsetImageView.centerXAnchor),
            self.sunsetLabel.topAnchor.constraint(equalTo: self.sunsetImageView.bottomAnchor, constant: 5),
            
            self.windLabel.centerXAnchor.constraint(equalTo: self.weatherView.centerXAnchor),
            self.windLabel.topAnchor.constraint(equalTo: self.weatherView.topAnchor, constant: 138),
            
            self.windImageView.centerYAnchor.constraint(equalTo: self.windLabel.centerYAnchor),
            self.windImageView.rightAnchor.constraint(equalTo: self.windLabel.leftAnchor, constant: -5),
            self.windImageView.heightAnchor.constraint(equalTo: self.weatherView.heightAnchor, multiplier: 0.084),
            self.windImageView.widthAnchor.constraint(equalTo: self.weatherView.widthAnchor, multiplier: 0.072),
            
            self.humidityLabel.centerYAnchor.constraint(equalTo: self.windLabel.centerYAnchor),
            self.humidityLabel.rightAnchor.constraint(equalTo: self.sunsetImageView.leftAnchor, constant: -42),
            
            self.humidityImageView.centerYAnchor.constraint(equalTo: self.windLabel.centerYAnchor),
            self.humidityImageView.rightAnchor.constraint(equalTo: self.humidityLabel.leftAnchor, constant: -5),
            self.humidityImageView.heightAnchor.constraint(equalTo: self.weatherView.heightAnchor, multiplier: 0.084),
            self.humidityImageView.widthAnchor.constraint(equalTo: self.humidityImageView.heightAnchor),
            
            self.cloudinessLabel.centerYAnchor.constraint(equalTo: self.windLabel.centerYAnchor),
            self.cloudinessLabel.leftAnchor.constraint(equalTo: self.sunriseImageView.rightAnchor, constant: 61),
            
            self.cloudinessImageView.centerYAnchor.constraint(equalTo: self.windLabel.centerYAnchor),
            self.cloudinessImageView.rightAnchor.constraint(equalTo: self.cloudinessLabel.leftAnchor, constant: -5),
            self.cloudinessImageView.heightAnchor.constraint(equalTo: self.weatherView.heightAnchor, multiplier: 0.084),
            self.cloudinessImageView.widthAnchor.constraint(equalTo: self.weatherView.widthAnchor, multiplier: 0.072),
            
           
            
        ])
        
        
    }

    func wheather(data: WheatherAnswer) {
        guard let temp = data.main?.temp else { return }
        guard let maxTemp = data.main?.tempMax else { return }
        guard let minTemp = data.main?.tempMin else { return }
        guard let clouds = data.clouds?.all else {return}
        guard let humidity = data.main?.humidity else {return}
        guard let wind = data.wind?.speed else { return }
        guard let description = data.weather.first?.description else { return }
        let newTemp = temp - 273.15
        let newMaxTemp = maxTemp - 273.15
        let newMinTemp = minTemp - 273.15
        self.maxMinLabel.text = "\(Int(newMinTemp))˚/\(Int(newMaxTemp))˚"
        self.tempLabel.text = "\(Int(newTemp))˚"
        guard let sunrise = data.sys?.sunrise else { return }
        let date = Date(timeIntervalSince1970: TimeInterval(sunrise))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:MM"
        let sunriseTime = dateFormatter.string(from: date)
        self.sunsetLabel.text = sunriseTime
        guard let sunset = data.sys?.sunset else { return }
        let date1 = Date(timeIntervalSince1970: TimeInterval(sunset))
        let formatter = DateFormatter()
        formatter.dateFormat = "H:MM"
        let sunsetTime = dateFormatter.string(from: date1)
        self.sunriseLabel.text = sunsetTime
        self.windLabel.text = "\(Int(wind)) м/с"
        self.humidityLabel.text = "\(Int(humidity))%"
        self.cloudinessLabel.text = "\(clouds)"
        self.descriptionLabel.text = description.capitalizedSentence
    }
 
}
extension String {
    var capitalizedSentence: String {
        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst().lowercased()
        return firstLetter + remainingLetters
        
    }
    
}
