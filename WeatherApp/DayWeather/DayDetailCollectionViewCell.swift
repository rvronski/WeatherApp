//
//  DayDetailCollectionViewCell.swift
//  WeatherApp
//
//  Created by ROMAN VRONSKY on 05.02.2023.
//

import UIKit

class DayDetailCollectionViewCell: UICollectionViewCell {
    
    private lazy var dayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
     lazy var dayLabel = WeatherLabels(size: 18, weight: .regular, color: .black)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(daily: Daily) {
        let day = daily.dt ?? 0
        let date = Date(timeIntervalSince1970: TimeInterval(day))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/MM E"
        let newDay = dateFormatter.string(from: date)
        self.dayLabel.text = newDay
    }
    
    private func setupView() {
        self.contentView.addSubview(self.dayView)
        self.dayView.addSubview(self.dayLabel)
        
        NSLayoutConstraint.activate([
        
            self.dayView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.dayView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.dayView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.dayView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            
            self.dayLabel.topAnchor.constraint(equalTo:self.dayView.topAnchor, constant: 7),
            self.dayLabel.bottomAnchor.constraint(equalTo:self.dayView.bottomAnchor, constant: -7),
            self.dayLabel.leftAnchor.constraint(equalTo:self.dayView.leftAnchor, constant: 6),
            self.dayLabel.rightAnchor.constraint(equalTo:self.dayView.rightAnchor, constant: -6),
        
        
        ])
    }
}
