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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blueToothManager.dataArrayDelegate = self
        // Do any additional setup after loading the view.
    }


}

extension ViewController: DataArrayDelegate {
    func updateBreathArray(_ breath: Double) {
        
    }
    
    
}
