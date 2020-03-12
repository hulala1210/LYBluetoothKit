//
//  BLESearchOp.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/2/25.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class BLESearchOp: BaseOperation {
    
    public var bleNamePrefix:String? = nil
    
    override func mainAction() {
        
        super.mainAction()
        
        if self.isCancelled {
            return
        }
        
        if bleNamePrefix == nil {
            self.cancel()
            return
        }
        
        self.isTaskExecuting = true
        
        let queue:TestOpQueue = self.queue as! TestOpQueue
        queue.message = queue.message + "\n开始搜索蓝牙"

        BLECenter.shared.scan(callback: { (deviceArray, error) in
            
            if self.isCancelled {
                return
            }
            
            let array = deviceArray

            if error != nil {
                if self.failedBlock != nil {
                    self.failedBlock!(error)
                }
            }
            else if array != nil && array!.count != 0 {
                
                let filterNameArr = array?.filter({ (device) -> Bool in
                    if device.name.hasPrefix(self.bleNamePrefix!) {
                        return true
                    }
                    return false
                })
                
                if filterNameArr?.count != 0 {
                    let maxRssiDevice:BLEDevice = filterNameArr!.max(by: { (device1, device2) -> Bool in
                        if device1.rssi > device2.rssi {
                             return false
                        }
                        else {
                             return true
                        }
                    })!
                    
                    if maxRssiDevice.name.hasPrefix(self.bleNamePrefix!) && maxRssiDevice.rssi >= -67 {
                        let queue:TestOpQueue = self.queue as! TestOpQueue
                        queue.device = maxRssiDevice
                        
                        BLECenter.shared.stopScan()
                    }
                }
                
            }
            else {
                
            }

        }, stop: {
            self.done()
        }, after: TimeInterval(MAXFLOAT))
    }
}
