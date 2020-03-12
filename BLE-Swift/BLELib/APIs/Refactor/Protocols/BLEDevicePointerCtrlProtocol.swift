//
//  BLEDevicePointerCtrlProtocol.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/3/9.
//  Copyright © 2020 ss. All rights reserved.
//

import Foundation

enum LYBCClockPointer:UInt8, Codable {
    case pointerHour = 0
    case pointerMin
    case pointerSecond
}

enum LYBCDirection:UInt8, Codable {
    case antiClockwise = 0
    case clockwise
    case expand
}

protocol BLEDevicePointerCtrlProtocol {
    func pointerRotation(pointer:LYBCClockPointer, direction:LYBCDirection, angle:UInt16, callback:BoolCallback?, toDeviceName deviceName:String) -> BLETask?
}

extension BLEDevicePointerCtrlProtocol {
    func pointerRotation(pointer:LYBCClockPointer, direction:LYBCDirection, angle:UInt16, callback:BoolCallback?, toDeviceName deviceName:String) -> BLETask? {
        
//        let degree:Int = 360
        let degreeData = angle.data(byteCount: 2)
        
        let data = Data(bytes: [0x6F,0xB6,0x71,0x04,0x00,pointer.rawValue,direction.rawValue,degreeData[0],degreeData[1],0x8F])
           return BLECenter.shared.send(data: data, boolCallback: callback, toDeviceName: deviceName)
    }
}
