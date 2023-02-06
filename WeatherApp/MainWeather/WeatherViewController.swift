//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by ROMAN VRONSKY on 01.02.2023.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    private let backgroundColor = #colorLiteral(red: 0.1254122257, green: 0.3044758141, blue: 0.778311789, alpha: 1)
    private var list = [List]()
    private var daily = [Daily]()
    private var locationManager = CLLocationManager()
    private var lat: Double = 0
    private var lon: Double = 0
  
//    private lazy var addWalletButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("Создать кошелек", for: .normal)
//        button.backgroundColor = .systemRed
//        button.layer.cornerRadius = 20
//        button.addTarget(self, action: #selector(didTapWalletButton), for: .touchUpInside)
//        return button
//    }()
    
    private lazy var dailyTableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
//        tableView.setContentOffset(CGPoint(x: 16, y: 16), animated: true)
//        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        tableView.contentInset = UIEdgeInsets(top: -16, left: 0, bottom: -16, right: 0)
        tableView.register(DailyTableViewCell.self, forCellReuseIdentifier: "DailyCell")
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
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: "WeatherCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
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
        formatter.dateFormat = "HH:mm, E d MMMM"
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
        self.setupNavigationBar()
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().async {
            self.location()
            group.leave()
        }
        group.notify(queue: .main) {
            self.getWeather()
        }
        
        UserDefaults.standard.set(true, forKey: "firstTime")
        
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.weatherView)
        self.view.addSubview(self.weatherCollectionView)
        self.view.addSubview(self.dailyTableView)
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
            
            self.weatherCollectionView.topAnchor.constraint(equalTo: self.weatherView.bottomAnchor, constant: 20),
            self.weatherCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.weatherCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.weatherCollectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.150),
            
            self.dailyTableView.topAnchor.constraint(equalTo: self.weatherCollectionView.bottomAnchor, constant: 16),
            self.dailyTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.dailyTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.dailyTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            
            
        ])
        
        
    }
    
    private func location() {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        self.locationManager.delegate = self
    }
    
    private func getWeather() {
        getNowWeather(lat: self.lat, lon: self.lon) { weather in
            let timeZone = weather.timezone ?? 0
            timezone = timeZone
            DispatchQueue.main.async {
                self.wheather(data: weather)
            }
            
        }
        weatherSoon(lat: self.lat, lon: self.lon) { list in
            self.list = list
            DispatchQueue.main.async {
                self.weatherCollectionView.reloadData()
            }
        }
        weatherDaily(lat: self.lat, lon: self.lon) { daily in
            self.daily = daily
            DispatchQueue.main.async {
                self.dailyTableView.reloadData()
            }
        }
    }

   private func wheather(data: WheatherAnswer) {
        let temp = data.main?.temp ?? 0
        let maxTemp = data.main?.tempMax ?? 0
        let minTemp = data.main?.tempMin ?? 0
        let clouds = data.clouds?.all ?? 0
        let humidity = data.main?.humidity ?? 0
        let wind = data.wind?.speed ?? 0
        let cityName = data.name ?? ""
        let description = data.weather.first?.description ?? ""
        self.maxMinLabel.text = "\(Int(minTemp))˚/ \(Int(maxTemp))˚"
        self.tempLabel.text = "\(Int(temp))˚"
        let sunrise = data.sys?.sunrise ?? 0
        var correctTime = 0
        if timezone < 0 {
            correctTime = timezone + sunrise
        } else {
            correctTime = sunrise + timezone
        }
        let date = Date(timeIntervalSince1970: TimeInterval(correctTime))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        dateFormatter.timeZone = .gmt
        let sunriseTime = dateFormatter.string(from: date)
        let sunset = data.sys?.sunset ?? 0
        if timezone < 0 {
            correctTime = timezone + sunset
        } else {
            correctTime = sunset + timezone
        }
        let date1 = Date(timeIntervalSince1970: TimeInterval(correctTime))
        let formatter = DateFormatter()
        formatter.timeZone = .gmt
        formatter.dateFormat = "H:mm"
        let sunsetTime = dateFormatter.string(from: date1)
        self.sunsetLabel.text = sunsetTime
        self.sunriseLabel.text = sunriseTime
        self.windLabel.text = "\(Int(wind)) м/с"
        self.humidityLabel.text = "\(Int(humidity))%"
        self.cloudinessLabel.text = "\(clouds)"
        self.descriptionLabel.text = description.capitalizedSentence
        self.navigationItem.title = cityName
    }
 
}
extension WeatherViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherCollectionViewCell
        cell.setup(list: list[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.frame.width - 32) / 6.2
        let itemHeigth = itemWidth * 2
        return CGSize(width: itemWidth, height: itemHeigth )
    }
    
}
extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return daily.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as! DailyTableViewCell
        cell.setup(data: daily[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.navigationController?.pushViewController(DayDetailViewController(daily: self.daily), animated: true)
    }
}
extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lat = manager.location?.coordinate.latitude ?? 0
        let lon = manager.location?.coordinate.longitude ?? 0
        manager.stopUpdatingLocation()
        self.lat = lat
        self.lon = lon
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        print("Can't get location")
         
    }
}
