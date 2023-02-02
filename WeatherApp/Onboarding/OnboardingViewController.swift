//
//  ViewController.swift
//  WeatherApp
//
//  Created by ROMAN VRONSKY on 31.01.2023.
//

import UIKit
import CoreLocation

class OnboardingViewController: UIViewController {
    
    var locationManager = CLLocationManager()
    private let backgroundColor = #colorLiteral(red: 0.1254122257, green: 0.3044758141, blue: 0.778311789, alpha: 1)
    private let buttonBackgroundColor = #colorLiteral(red: 0.9473686814, green: 0.4318209291, blue: 0.06725039333, alpha: 1)
    
    private lazy var onboardingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "Frame")
        return imageView
    }()
    
    
    private lazy var acceptButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("ИСПОЛЬЗОВАТЬ МЕСТОПОЛОЖЕНИЕ УСТРОЙСТВА", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.backgroundColor = buttonBackgroundColor
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapAcceptButton), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("НЕТ, Я БУДУ ДОБАВЛЯТЬ ЛОКАЦИИ", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
//        button.addTarget(self, action: #selector(didTapWalletButton), for: .touchUpInside)
        return button
    }()
    
    private let firstTextLabel = InfoLabels(inform: "Разрешить приложению  Weather использовать данные \nо местоположении вашего устройства", frame: .zero, size: 16, weight: .semibold)
    
    private let secondLabel = InfoLabels(inform: "Чтобы получить более точные прогнозы погоды во время движения или путешествия", frame: .zero, size: 14, weight: .regular)
    
    private let thirdLabel = InfoLabels(inform: "Вы можете изменить свой выбор в любое время из меню приложения", frame: .zero, size: 14, weight: .regular)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
       
    }
    
    private func setupView() {
        self.view.backgroundColor = self.backgroundColor
        self.view.addSubview(self.onboardingImageView)
        self.view.addSubview(self.firstTextLabel)
        self.view.addSubview(self.secondLabel)
        self.view.addSubview(self.thirdLabel)
        self.view.addSubview(self.acceptButton)
        self.view.addSubview(self.cancelButton)
        
        NSLayoutConstraint.activate([
            
            self.onboardingImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.onboardingImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 147),
            
            self.firstTextLabel.topAnchor.constraint(equalTo: self.onboardingImageView.bottomAnchor, constant: 57),
            self.firstTextLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 27),
            self.firstTextLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -27),
            
            self.secondLabel.topAnchor.constraint(equalTo: self.firstTextLabel.bottomAnchor, constant: 56),
            self.secondLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30),
            self.secondLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30),
            
            self.thirdLabel.topAnchor.constraint(equalTo: self.secondLabel.bottomAnchor, constant: 14),
            self.thirdLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30),
            self.thirdLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30),
            
            self.acceptButton.topAnchor.constraint(equalTo: self.thirdLabel.bottomAnchor,constant: 57),
            self.acceptButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.acceptButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            self.acceptButton.heightAnchor.constraint(equalToConstant: 40),
            
            self.cancelButton.topAnchor.constraint(equalTo: self.acceptButton.bottomAnchor,constant: 25),
            self.cancelButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16)
           
        ])
        
    }
    
    @objc private func didTapAcceptButton() {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.delegate = self
        self.navigationController?.pushViewController(WeatherViewController(), animated: true)
    }
    
}

extension OnboardingViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("lat= \(String(describing: manager.location?.coordinate.latitude))")
        print("lon= \(String(describing: manager.location?.coordinate.longitude))")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        print("Can't get location")
         
    }
}
