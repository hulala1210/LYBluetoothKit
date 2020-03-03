//
//  BLEFactoryOnlyProtocol.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/3/3.
//  Copyright © 2020 ss. All rights reserved.
//

import Foundation
protocol BLEFactoryOnlyProtocol {
    // protocol definition goes here
    func checkGesensor(callback:StringCallback?, toDeviceName deviceName:String?) -> BLETask?
    
    func checkMotor(callback:BoolCallback?, toDeviceName deviceName:String?) -> BLETask?
    
    func checkFlash(callback:BoolCallback?, toDeviceName deviceName:String?) -> BLETask?
    
    func checkHeartRate(callback:BoolCallback?, toDeviceName deviceName:String?) -> BLETask?
    
    func checkBLEName(callback:StringCallback?, toDeviceName deviceName:String?) -> BLETask?
}

extension BLEFactoryOnlyProtocol {

    func checkGesensor(callback:StringCallback?, toDeviceName deviceName:String?) -> BLETask? {
        let data = Data(bytes: [0x6f, 0xfc, 0x70, 0x01, 0x00, 0x00, 0x8f])
        return BLECenter.shared.send(data: data, stringCallback: callback, toDeviceName: deviceName)
    }

    func checkMotor(callback:BoolCallback?, toDeviceName deviceName:String?) -> BLETask? {
        let data = Data(bytes: [0x6F, 0xFA, 0x71, 0x01, 0x00, 0x01, 0x8F])
        return BLECenter.shared.send(data: data, boolCallback: callback, toDeviceName: deviceName)
    }

    func checkFlash(callback:BoolCallback?, toDeviceName deviceName:String?) -> BLETask? {
        let data = Data(bytes: [0x6F, 0xF7, 0x70, 0x01, 0x00, 0x00, 0x8F])
        return BLECenter.shared.send(data: data, boolCallback: callback, toDeviceName: deviceName)
    }

    func checkHeartRate(callback:BoolCallback?, toDeviceName deviceName:String?) -> BLETask? {
        let data = Data(bytes: [0x6F, 0xFB, 0x70, 0x01, 0x00, 0x00, 0x8F])
        return BLECenter.shared.send(data: data, boolCallback: callback, toDeviceName: deviceName)
    }

    func checkBLEName(callback:StringCallback?, toDeviceName deviceName:String?) -> BLETask? {
        let data = Data(bytes: [0x6f, 0xf9, 0x70, 0x01, 0x00, 0x00, 0x8f])
        return BLECenter.shared.send(data: data, stringCallback: callback, toDeviceName: deviceName)
    }
}
