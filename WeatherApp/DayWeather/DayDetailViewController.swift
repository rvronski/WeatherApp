//
//  DayDetailViewController.swift
//  WeatherApp
//
//  Created by ROMAN VRONSKY on 05.02.2023.
//

import UIKit

class DayDetailViewController: UIViewController {
    
    private var index = 0
    private let backgroundColor = #colorLiteral(red: 0.1254122257, green: 0.3044758141, blue: 0.778311789, alpha: 1)
    private let images = ["term","wind","solar","rain","cloudy"]
    private let descript = ["По ощущениям","Ветер","Уф индекс","Дождь","Облачность"]
    private var dayTestimony: [String] = []
    private var nightTestimony: [String] = []
    var daily:[Daily]
    
    init(daily: [Daily]) {
        self.daily = daily
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var dayTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(DayTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(DayHeaderView.self, forHeaderFooterViewReuseIdentifier: "DayHeader")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0 , right: 16)
        return layout
    }()
    
    private lazy var weatherCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(DayDetailCollectionViewCell.self, forCellWithReuseIdentifier: "DayCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
       
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.testimony(daily: daily[index])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.weatherCollectionView.reloadData()
        self.dayTableView.reloadData()
    }
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.weatherCollectionView)
        self.view.addSubview(self.dayTableView)
        NSLayoutConstraint.activate([
        
            self.weatherCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.weatherCollectionView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.115),
            self.weatherCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.weatherCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            
            self.dayTableView.topAnchor.constraint(equalTo: self.weatherCollectionView.bottomAnchor),
            self.dayTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.dayTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.dayTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            
        
        ])
    }
    
    private func testimony(daily: Daily) {
        let dayFeelTemp = daily.feelsLike?.day ?? 0
        let nightFeelTemp = daily.feelsLike?.night ?? 0
        let wind = daily.windSpeed ?? 0
        let solar = daily.uvi ?? 0
        let pop = daily.pop ?? 0
        let clouds = daily.clouds ?? 0
        let rains = pop * 100
        let dayTemp = "\(Int(dayFeelTemp))˚"
        let nightTemp = "\(Int(nightFeelTemp))˚"
        let rain = "\(Int(rains))%"
        let cloudy = "\(clouds)%"
        let windy = "\(Int(wind))m/s"
        let uvi = "\(Int(solar))"
        self.dayTestimony.insert(dayTemp, at: 0)
        self.dayTestimony.insert(windy, at: 1)
        self.dayTestimony.insert(uvi, at: 2)
        self.dayTestimony.insert(rain, at: 3)
        self.dayTestimony.insert(cloudy, at: 4)
        self.nightTestimony.insert(nightTemp, at: 0)
        self.nightTestimony.insert(windy, at: 1)
        self.nightTestimony.insert(uvi, at: 2)
        self.nightTestimony.insert(rain, at: 3)
        self.nightTestimony.insert(cloudy, at: 4)
        self.dayTableView.reloadData()
    }
}
extension DayDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DayHeader") as? DayHeaderView else { return nil }
        let dayTemp = daily[index].temp?.day ?? 0
        let nightTemp = daily[index].temp?.night ?? 0
        let dayNewTemp = "\(Int(dayTemp))˚"
        let nightNewTemp = "\(Int(nightTemp))˚"
        let description = daily[index].weather?.first?.description ?? ""
        let image = daily[index].weather?.first?.icon ?? ""
        if section == 0 {
            headerView.setup(dayNight: "День", temp: dayNewTemp, description: description.capitalizedSentence, image: image)
        } else if section == 1 {
            headerView.setup(dayNight: "Ночь", temp: nightNewTemp, description: description.capitalizedSentence, image: image)
        }
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.daily.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayDetailCollectionViewCell
        cell.setup(daily: daily[indexPath.row])
        cell.layer.cornerRadius = 10
        if indexPath.row == self.index {
            cell.backgroundColor = self.backgroundColor
            cell.dayLabel.textColor = .white
        } else {
            cell.backgroundColor = .clear
            cell.dayLabel.textColor = .black
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.frame.width - 32) / 3.5
        let itemHeigth = itemWidth / 2.4
        return CGSize(width: itemWidth, height: itemHeigth )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.index = indexPath.row
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        self.testimony(daily: daily[index])
        collectionView.reloadData()
    }
    
}
extension DayDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DayTableViewCell
        if indexPath.section == 0 {
            cell.setup(descript: descript[indexPath.row], testimony: dayTestimony[indexPath.row], image: images[indexPath.row])
        } else if indexPath.section == 1 {
            cell.setup(descript: descript[indexPath.row], testimony: nightTestimony[indexPath.row], image: images[indexPath.row])
        }
        return cell
    }
    
    
}
