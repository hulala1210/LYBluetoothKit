//
//  BLESearchOp.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/2/25.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class BLESearchOp: BaseOperation {
    override func mainAction() {
        
        self.isTaskExecuting = true
        
        BLECenter.shared.scan(callback: { (deviceArray, error) in
            let array = deviceArray

            if array != nil {
                
                let filterNameArr = array?.filter({ (device) -> Bool in
                    if device.name.hasPrefix("YoWatch#") {
                        return true
                    }
                    return false
                })
                
                let maxRssiDevice:BLEDevice = filterNameArr!.max(by: { (device1, device2) -> Bool in
                    if device1.rssi > device2.rssi {
                         return true
                    }
                    else {
                         return false
                    }
                })!
                
                if maxRssiDevice.name.hasPrefix("YoWatch#") && maxRssiDevice.rssi >= -65 {
                    let queue:TestOpQueue = self.queue as! TestOpQueue
                    queue.device = maxRssiDevice
                    
                    BLECenter.shared.stopScan()
                    
                }
                
            }
            else {
                if self.failedBlock != nil {
                    self.failedBlock!(error)
                }
            }

        }, stop: {
            self.isTaskExecuting = false
            self.isTaskFinished = true
        }, after: TimeInterval(MAXFLOAT))
    }
}
