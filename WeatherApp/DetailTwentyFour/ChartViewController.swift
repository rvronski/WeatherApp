//
//  ChartViewController.swift
//  WeatherApp
//
//  Created by ROMAN VRONSKY on 13.02.2023.
//

import UIKit
import Charts
class ChartViewController: UIViewController {

    
    var temp:[Int]
    var time:[String]
    
    init(temp: [Int], time: [String]) {
        self.temp = temp
        self.time = time
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView: UIScrollView = {
       let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var lineChartView: LineChartView = {
        let view = LineChartView()
        view.accessibilityScroll(.right)
        view.backgroundColor = myYellowBack
        view.leftAxis.enabled = false
        view.rightAxis.enabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        let xAxis = view.xAxis
        xAxis.labelFont = .systemFont(ofSize: 15)
        xAxis.setLabelCount(9, force: false)
        xAxis.labelPosition = .bottomInside
        xAxis.labelTextColor = .black
        
        view.animate(xAxisDuration: 2.0)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupView()
        setChart(time: time, temp: temp)
        print(temp)
        print(time)
    }
//    func setChart(dataPoints: [String], values: [Double]) {
    func setChart(time: [String], temp: [Int] ) {
        
        lineChartView.noDataText = "You need to provide data for the chart."
        var dataEntries = [ChartDataEntry]()
                
        for i in 0..<time.count {
            
            let dataEntry = ChartDataEntry(x:Double(temp[i]) , y: 5.0, icon: UIImage(named: "cloudy"), data: time[i])
                //(x: Double(i), y: Double(temp[i]))
                dataEntries.append(dataEntry)
          
        }
                
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Температура")
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.mode = .cubicBezier
        lineChartDataSet.lineWidth = 3
        lineChartDataSet.setColor(.white)
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartData.setValueFont(.systemFont(ofSize: 14, weight: .regular))
        lineChartView.data = lineChartData
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.lineChartView)
        
        NSLayoutConstraint.activate([
        
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            
            self.lineChartView.topAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.topAnchor),
            self.lineChartView.bottomAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.bottomAnchor),
            self.lineChartView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.lineChartView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            
        ])
    }
}
