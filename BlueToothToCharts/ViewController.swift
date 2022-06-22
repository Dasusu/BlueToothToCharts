//
//  ViewController.swift
//  BlueToothToCharts
//
//  Created by Dasu on 2022/6/21.
//

import UIKit
import SnapKit
import Charts

class ViewController: UIViewController {


    var blueToothManager = HeartBlueTooth()
//    var timer:Timer?
    var x:Double = 0
    var currentData:[ChartDataEntry] = []{
        didSet{
            setData()
        }
    }

    
    //MARK: - properties
    private lazy var liveChart:LineChartView = {
        let chart = LineChartView()
        chart.backgroundColor = .systemRed
        chart.animate(xAxisDuration: 1.5)
        return chart
    }()
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        blueToothManager.dataArrayDelegate = self
//        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(fakeData), userInfo: nil, repeats: true)
        configure()
        setData()
    }
    
    func setData(){
        let setData = LineChartDataSet(entries: currentData)
        setData.drawCirclesEnabled = false
        let data = LineChartData(dataSet: setData)
        data.setDrawValues(false)
        liveChart.data = data
    }
    
    //MARK: - selectors
//    @objc func fakeData(){
//        setData()
//    }
    
    //MARK: - configure
    func configure(){
        view.addSubview(liveChart)
        
        liveChart.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(liveChart.snp.width)
        }
    }
}

extension ViewController: DataArrayDelegate {
    func updateBreathArray(_ breath: Double) {
        x += 1
        currentData.append(ChartDataEntry(x: x, y: breath))
    }

}
