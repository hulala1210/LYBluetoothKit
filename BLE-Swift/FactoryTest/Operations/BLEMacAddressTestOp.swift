//
//  BLEMacAddressTestOp.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/3/6.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLEMacAddressTestOp: BaseOperation {
    override func mainAction() {
        super.mainAction()
    
        if self.isCancelled {
            return
        }
        
        self.isTaskExecuting = true
        let queue:TestOpQueue = self.queue as! TestOpQueue
            
        let macString = queue.device?.advertisementData![CBAdvertisementDataManufacturerDataKey]
        
        if macString != nil {
            queue.message = queue.message + "\n蓝牙设备Mac地址是:\(macString!)"
        }
        else {
            queue.message = queue.message + "\n没有获取到Mac地址"
        }
        
        self.done()

    }
}
