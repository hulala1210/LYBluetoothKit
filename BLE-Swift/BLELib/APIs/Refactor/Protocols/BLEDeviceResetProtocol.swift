//
//  BLEDeviceResetProtocol.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/3/10.
//  Copyright © 2020 ss. All rights reserved.
//

import Foundation
protocol BLEDeviceResetProtocol {
//    func pointerRotation(pointer:LYBCClockPointer, direction:LYBCDirection, angle:UInt16, callback:BoolCallback?, toDeviceName deviceName:String) -> BLETask?
    func resetDevice(boolCallback:BoolCallback?, toDeviceName deviceName:String?) -> BLETask?

}

extension BLEDeviceResetProtocol {
    
    func resetDevice(boolCallback:BoolCallback?, toDeviceName deviceName:String?) -> BLETask? {
        let data = Data(bytes: [0x6F,0x0D,0x71,0x01,0x00,0x00,0x8F])
        return BLECenter.shared.send(data: data, boolCallback: boolCallback, toDeviceName: deviceName)
    }
    
}
