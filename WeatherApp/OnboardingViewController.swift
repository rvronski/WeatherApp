//
//  ViewController.swift
//  WeatherApp
//
//  Created by ROMAN VRONSKY on 31.01.2023.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    
    private let backgroundColor = #colorLiteral(red: 0.1254122257, green: 0.3044758141, blue: 0.778311789, alpha: 1)
    private lazy var onboardingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "Frame")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = self.backgroundColor
        self.view.addSubview(self.onboardingImageView)
        
        NSLayoutConstraint.activate([
            
            self.onboardingImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.onboardingImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            
            
        ])
        
    }
    
}

