//
//  DetailTwentyFourViewController.swift
//  WeatherApp
//
//  Created by ROMAN VRONSKY on 12.02.2023.
//

import UIKit

class DetailTwentyFourViewController: UIViewController {
    
    var list:[List]?
    
    private lazy var hoursTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(TwentyFourTableViewCell.self, forCellReuseIdentifier: "24")
//        tableView.register(DayHeaderView.self, forHeaderFooterViewReuseIdentifier: "DayHeader")
//        tableView.register(DayFooterView.self, forHeaderFooterViewReuseIdentifier: "DayFooter")
//        tableView.register(UITableViewHeaderFooterView.self, forCellReuseIdentifier: "DefaultFooter")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.hoursTableView)
        
        NSLayoutConstraint.activate([
        
            self.hoursTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
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
    
    
}
