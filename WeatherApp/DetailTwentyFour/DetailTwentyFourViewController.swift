//
//  DetailTwentyFourViewController.swift
//  WeatherApp
//
//  Created by ROMAN VRONSKY on 12.02.2023.
//

import UIKit

class DetailTwentyFourViewController: UIViewController {
    
    var list:[List]?
    var temp = [Int]()
    var time = [String]()
    private lazy var hoursTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(TwentyFourTableViewCell.self, forCellReuseIdentifier: "24")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var headerView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.7152544856, green: 0.7761872411, blue: 0.9439151287, alpha: 1)
        return view
    }()
    
    private lazy var timeLabel = WeatherLabels(size: 14, weight: .regular, color: .black)
    private lazy var timeLabel1 = WeatherLabels(size: 14, weight: .regular, color: .black)
    private lazy var timeLabel2 = WeatherLabels(size: 14, weight: .regular, color: .black)
    private lazy var timeLabel3 = WeatherLabels(size: 14, weight: .regular, color: .black)
    private lazy var timeLabel4 = WeatherLabels(size: 14, weight: .regular, color: .black)
    private lazy var timeLabel5 = WeatherLabels(size: 14, weight: .regular, color: .black)
    private lazy var timeLabel6 = WeatherLabels(size: 14, weight: .regular, color: .black)
    
    private lazy var iconLabel = WeatherLabels(size: 14, weight: .regular, color: .black)
    private lazy var iconLabel1 = WeatherLabels(size: 14, weight: .regular, color: .black)
    private lazy var iconLabel2 = WeatherLabels(size: 14, weight: .regular, color: .black)
    private lazy var iconLabel3 = WeatherLabels(size: 14, weight: .regular, color: .black)
    private lazy var iconLabel4 = WeatherLabels(size: 14, weight: .regular, color: .black)
    private lazy var iconLabel5 = WeatherLabels(size: 14, weight: .regular, color: .black)
    private lazy var iconLabel6 = WeatherLabels(size: 14, weight: .regular, color: .black)
    
    private lazy var iconImage = IconImageView(picture: "rain")
    private lazy var iconImage1 = IconImageView(picture: "rain")
    private lazy var iconImage2 = IconImageView(picture: "rain")
    private lazy var iconImage3 = IconImageView(picture: "rain")
    private lazy var iconImage4 = IconImageView(picture: "rain")
    private lazy var iconImage5 = IconImageView(picture: "rain")
    private lazy var iconImage6 = IconImageView(picture: "rain")
    
    private lazy var labelIconStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 20
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.alignment = .center
        view.addArrangedSubview(iconLabel)
        view.addArrangedSubview(iconLabel1)
        view.addArrangedSubview(iconLabel2)
        view.addArrangedSubview(iconLabel3)
        view.addArrangedSubview(iconLabel4)
        view.addArrangedSubview(iconLabel5)
        view.addArrangedSubview(iconLabel6)
        
        
        return view
    }()
    
    private lazy var iconstackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 20
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
//        view.alignment = .center
        view.addArrangedSubview(iconImage)
        view.addArrangedSubview(iconImage1)
        view.addArrangedSubview(iconImage2)
        view.addArrangedSubview(iconImage3)
        view.addArrangedSubview(iconImage4)
        view.addArrangedSubview(iconImage5)
        view.addArrangedSubview(iconImage6)
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
       let view = UIStackView()
        view.spacing = 10
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.addArrangedSubview(timeLabel)
        view.addArrangedSubview(timeLabel1)
        view.addArrangedSubview(timeLabel2)
        view.addArrangedSubview(timeLabel3)
        view.addArrangedSubview(timeLabel4)
        view.addArrangedSubview(timeLabel5)
        view.addArrangedSubview(timeLabel6)
        return view
    }()
    
    private lazy var graphView: GraphView = {
        let view = GraphView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        guard let list else {return}
        createChartArrays(list: list)
        
    }
    
    func createChartArrays(list:[List]) {
       
        for i in list{
            let temp = i.main?.temp ?? 0
            self.temp.append(Int(temp))
        }
        for t in list {
            let time = t.dt ?? 0
            let newTime = unixTimeFormatter(time: time)
            self.time.append(newTime)
        }
    
        graphView.temp = temp
        setupGraph()
    }
    
    func setupGraph() {
       
        let maxDayIndex = stackView.arrangedSubviews.count - 1
        let times = time.prefix(stackView.arrangedSubviews.count)
        
        for i in 0...maxDayIndex {
            let testimony = list?[i].pop ?? 0
            let test = testimony * 100
            let text = times[i]
            let image = list?[i].weather?.first?.icon ?? ""
            let imgeView = iconstackView.arrangedSubviews[i] as? UIImageView
            let label = stackView.arrangedSubviews[i] as? UILabel
            let iconlabel = labelIconStackView.arrangedSubviews[i] as? UILabel
            guard let iconlabel else {return}
            guard let imgeView else {return}
            guard let label else {return}
            imgeView.image = UIImage(named: image)
            label.text = text
            iconlabel.text = "\(Int(test))%"
            
        }
    }
    private func setupView() {
       
        self.view.backgroundColor = .white
        self.view.addSubview(self.hoursTableView)
        self.view.addSubview(self.headerView)
        self.headerView.addSubview(self.graphView)
        self.headerView.addSubview(self.stackView)
        self.headerView.addSubview(self.labelIconStackView)
        self.headerView.addSubview(self.iconstackView)
        
        
        
        NSLayoutConstraint.activate([
        
            self.headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.headerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.headerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.headerView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
            
            self.graphView.topAnchor.constraint(equalTo: self.headerView.topAnchor),
            self.graphView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.graphView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.graphView.heightAnchor.constraint(equalTo: self.headerView.heightAnchor, multiplier: 0.5),
            
            self.iconstackView.topAnchor.constraint(equalTo: self.graphView.bottomAnchor),
            self.iconstackView.leftAnchor.constraint(equalTo: self.headerView.leftAnchor, constant: 10),
            self.iconstackView.rightAnchor.constraint(equalTo: self.headerView.rightAnchor, constant: -10),
            self.iconstackView.heightAnchor.constraint(equalToConstant: 40),
            
            self.labelIconStackView.topAnchor.constraint(equalTo: self.iconstackView.bottomAnchor),
            self.labelIconStackView.leftAnchor.constraint(equalTo: self.headerView.leftAnchor, constant: 10),
            self.labelIconStackView.rightAnchor.constraint(equalTo: self.headerView.rightAnchor, constant: -10),
            self.labelIconStackView.heightAnchor.constraint(equalToConstant: 30),
            
            self.stackView.bottomAnchor.constraint(equalTo: self.headerView.bottomAnchor),
            self.stackView.leftAnchor.constraint(equalTo: self.headerView.leftAnchor,constant: 10),
            self.stackView.rightAnchor.constraint(equalTo: self.headerView.rightAnchor,constant: -10),
            self.stackView.heightAnchor.constraint(equalToConstant: 30),
            
            self.hoursTableView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor,constant: 16),
            self.hoursTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.hoursTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.hoursTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
        
        ])
        
        
    }
    
}
extension DetailTwentyFourViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "24", for: indexPath) as! TwentyFourTableViewCell
        cell.setup(list: list?[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChartViewController(temp: temp, time: time)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
