//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by ROMAN VRONSKY on 01.02.2023.
//

import UIKit
import CoreLocation
import CoreData

class WeatherViewController: UIViewController {
    
    private var list = [List]()
    private var daily = [Daily]()
    private var locationManager = CLLocationManager()
    private var lat: Double = 0
    private var lon: Double = 0
  
    let fetchResultController: NSFetchedResultsController = {
        let fetchRequest = NowWeather.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dt", ascending: false)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Идет обновление...")
        refresh.addTarget(self, action: #selector(refreshing), for: UIControl.Event.valueChanged)
       return refresh
    }()
    
    private lazy var notAuthView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.setImage(UIImage(named: "buttonGeo"), for: .normal)
        button.addTarget(self, action: #selector(geoForName), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var dailyTableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
//        tableView.setContentOffset(CGPoint(x: 16, y: 16), animated: true)
//        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
        formatter.locale = Locale(identifier: "ru")
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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .darkGray
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupNavigationBar()
        if UserDefaults.standard.bool(forKey: "WithGeo") {
            self.getWeatherWithLocation()
            UserDefaults.standard.set(true, forKey: "firstTime")
        } else {
            if locationManager.authorizationStatus == .restricted {
                self.notAuthView.isHidden = false
                self.addButton.isHidden = false
            } else if locationManager.authorizationStatus == .denied {
                self.notAuthView.isHidden = false
                self.addButton.isHidden = false
            } else if locationManager.authorizationStatus == .notDetermined {
                self.notAuthView.isHidden = false
                self.addButton.isHidden = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.bool(forKey: "WithGeo") {
            self.getWeatherWithLocation()
        } else {
            self.getWeather()
        }
    }
    
    private func getWeatherWithLocation() {
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().async {
            self.location()
            group.leave()
        }
        group.notify(queue: .main) {
            self.getWeather()
        }
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.tintColor = .black
        let rightButton = UIBarButtonItem(image: UIImage(named: "geo"), style: .done, target: self, action: #selector(geoForName))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc private func geoForName() {
        let alertController = UIAlertController(title: "Введите имя города", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Город"
        }
        
        let saveAction = UIAlertAction(title: "Ввести", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            guard let name = firstTextField.text else {return}
            getWeatherWithoutGeo(name: name) { answer in
                DispatchQueue.main.async {
                    self.notAuthView.isHidden = true
                    self.addButton.isHidden = true
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                    let lat = answer.coord?.lat ?? 0
                    let lon = answer.coord?.lon ?? 0
                    self.lat = lat
                    self.lon = lon
                    print(lat, lon)
                    self.getWeather()
                }
            }
        })
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil )
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.weatherView)
        self.view.addSubview(self.weatherCollectionView)
        self.view.addSubview(self.dailyTableView)
        self.dailyTableView.addSubview(self.refreshControl)
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
        self.view.addSubview(self.notAuthView)
        self.notAuthView.addSubview(self.addButton)
        self.view.addSubview(self.activityIndicator)
        NSLayoutConstraint.activate([
            self.refreshControl.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.refreshControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.notAuthView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.notAuthView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.notAuthView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.notAuthView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            
            self.addButton.centerXAnchor.constraint(equalTo: self.notAuthView.centerXAnchor),
            self.addButton.centerYAnchor.constraint(equalTo: self.notAuthView.centerYAnchor),
            self.addButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3),
            self.addButton.heightAnchor.constraint(equalTo: self.addButton.widthAnchor),
            
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
    
   @objc private func refreshing(sender:AnyObject) {
        refreshBegin(newtext: "Refresh",
              refreshEnd: {(x:Int) -> () in
              self.getWeather()
              self.refreshControl.endRefreshing()
            
              })
      }
      
    func refreshBegin(newtext:String, refreshEnd: @escaping (Int) -> ()) {
        DispatchQueue.global().async {
            sleep(2)
        }
        
        DispatchQueue.main.async {
            refreshEnd(0)
        }
    }
    
    
    
    private func location() {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        self.locationManager.delegate = self
    }
    
    @objc private func getWeather() {
        getNowWeather(lat: self.lat, lon: self.lon) { weather in
            let timeZone = weather.timezone ?? 0
            timezone = timeZone
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
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
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
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
        let sunriseTime = unixTimeFormatter(time: sunrise)
        let sunset = data.sys?.sunset ?? 0
        let sunsetTime = unixTimeFormatter(time: sunset)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailTwentyFourViewController()
        vc.list = self.list
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.daily.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as! DailyTableViewCell
        cell.setup(data: daily[indexPath.row])
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
