//
//  Store.swift
//  BlueToothToCharts
//
//  Created by 曾子庭 on 2022/6/22.
//

import Foundation
import Charts

//假資料
class Store{
    
    var fakeData = [ChartDataEntry]()
    var xAxis:Double = 0
//    var timer:Timer?
    
//    var timer = Timer.scheduledTimer(timeInterval: 0.1, target: ViewController(), selector: #selector(repeatData), userInfo: nil, repeats: true)
    
    func updateData(){
        let number = Double.random(in: -50...50)
        xAxis += 1
        fakeData.append(ChartDataEntry(x: xAxis, y: number))
//        if fakeData.count>20{
//            fakeData.remove(at: 0)
//        }
    }
    
    //MARK: - selectors
//    @objc func repeatData(){
//        updateData()
//    }
}
