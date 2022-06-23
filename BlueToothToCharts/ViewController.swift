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

    var store = Store()
    var blueToothManager = HeartBlueTooth()
    var xAxis:Double = 0
    var currentData:[ChartDataEntry] = []{
        didSet{
            setCharts()
        }
    }
    
    //MARK: - properties
    private lazy var liveChart:LineChartView = {
        let chart = LineChartView()
        chart.backgroundColor = .systemRed
//        chart.animate(xAxisDuration: 0.1)
        chart.dragXEnabled = true
        return chart
    }()
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        blueToothManager.dataArrayDelegate = self
        configure()
        setCharts()
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        store.timer.invalidate()
//    }
    
    func setCharts(){
        let setData = LineChartDataSet(entries: store.fakeData)
        setData.drawCirclesEnabled = false
        let data = LineChartData(dataSet: setData)
        data.setDrawValues(false)
        liveChart.data = data
        if store.fakeData.count > 10{
            liveChart.setVisibleXRangeMaximum(10)
            liveChart.moveViewToX(Double(store.fakeData.count))
        }
    }
    
//    func updateChart(){
//        liveChart.notifyDataSetChanged()
//        if store.fakeData.count > 10{
//            liveChart.setVisibleXRangeMaximum(10)
//            liveChart.moveViewToX(Double(store.fakeData.count))
//        }
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
        xAxis += 1
        currentData.append(ChartDataEntry(x: xAxis, y: breath))
    }

}
