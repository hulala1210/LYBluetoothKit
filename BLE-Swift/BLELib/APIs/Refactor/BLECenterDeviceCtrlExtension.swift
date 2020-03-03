//
//  BLECenterDeviceCtrlExtension.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/2/25.
//  Copyright © 2020 ss. All rights reserved.
//

import Foundation

extension BLECenter {
    public func cancelPairCommand(callback:BoolCallback?, toDeviceName deviceName:String) -> BLETask? {
        let data = Data(bytes: [0x6f, 0x1A, 0x71, 0x01, 0x00, 0x16, 0x8f])
        return send(data: data, boolCallback: callback, toDeviceName: deviceName)
    }
}
