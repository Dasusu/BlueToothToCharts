//
//  BlueToothManager.swift
//  BlueToothToCharts
//
//  Created by Dasu on 2022/6/21.
//

import Foundation
import CoreBluetooth

protocol DataArrayDelegate: AnyObject {
    
    func updateBreathArray(_ breath: Double)
    
}

class HeartBlueTooth: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    
    internal static let instance = HeartBlueTooth()
//    let queue = DispatchQueue.global()
    let queue = DispatchQueue(label: "Bluetooth", qos: .background, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
    weak var dataArrayDelegate: DataArrayDelegate?
//    var peripheralListener: (CBPeripheral) -> Void = { _ in}
    enum SendDataError: Error {
        case CharacteristicNotFound
    }
    
    
    // 中心物件
    var central: CBCentralManager?
    // 當前連線的裝置
    var connetctPeripheral: CBPeripheral!
    // 傳送資料特徵(連線到裝置之後可以把需要用到的特徵儲存起來，方便使用)
    var sendCharacteristic: CBCharacteristic?
    // 記錄所有的 characterstic (特徵)
    var charDictionary = [String: CBCharacteristic]()
    

    
    override init() {
        super.init()
        
        self.central = CBCentralManager(delegate: self, queue: queue)
        
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .poweredOn:
            print("藍芽開啟")
        case .poweredOff:
            print("藍芽關閉")
        case .unauthorized:
            print("沒有藍芽功能")
        case .resetting:
            print("藍芽重新設定")
        case .unknown:
            print("未知狀態")
        case .unsupported:
            print("不支援藍牙")
        @unknown default:
            print("未知狀態")
        }
        central.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        
        guard let deviceName = peripheral.name else { return }
        guard deviceName.contains("TM17") else { return }
        
        central.stopScan()
        
        connetctPeripheral = peripheral
        connetctPeripheral.delegate = self
        
        central.connect(connetctPeripheral, options: nil)
//        self.peripheralListener(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        charDictionary = [:]
        print("Did connected: \(peripheral.name)")
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            print("ERROR: \(#function)")
            print(error!.localizedDescription)
            return
        }
        
        for service in peripheral.services! {
            connetctPeripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil else {
            print("ERROR: \(#function)")
            print(error!.localizedDescription)
            return
        }
        
        for characteristic in service.characteristics! {
            let uuidString = characteristic.uuid.uuidString
            charDictionary[uuidString] = characteristic
            print("找到: \(uuidString)")
            connetctPeripheral.readValue(for: characteristic)
            connetctPeripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("ERROR: \(#function)")
            print(error!.localizedDescription)
            return
        }
        
        switch characteristic.uuid.uuidString {
        case "6E400003-B5A3-F393-E0A9-E50E24DCCA9E":
            queue.sync {
                if let data = characteristic.value {
                    let array = [UInt8](data)
                    
                }
            }
            
        case "6E400001-B5A3-F393-E0A9-E50E24DCCA9E":
            queue.sync {
                if let data = characteristic.value {
                    let array = [UInt8](data)
                    
                    
                    
                    var breath = Double(0)
                    var breathArr = [Double]()
                    
                    for i in 0...2{
                        breathArr.append(Double(array[i]))
                    }
                    
                    if breathArr[0] == 255 {
                        breathArr[0] = -1
                    }else{
                        breathArr[0] = 1
                    }
                    breath = breathArr[0] * (breathArr[1] * 256 + breathArr[2]) / 10
                    print(breath)
    //                breathDataArray.append(breath)
                    self.dataArrayDelegate?.updateBreathArray(breath)
                    
                }
            }
            
            
        default:
            break
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        central.scanForPeripherals(withServices: nil, options: nil)
    }
}
