//
//  BLENameTestOp.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/2/27.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class BLENameTestOp: BaseOperation {
    override func mainAction() {
            super.mainAction()
            self.isTaskExecuting = true
            let queue:TestOpQueue = self.queue as! TestOpQueue
            
//            let _ = BLECenter.shared.checkHeartRate(callback: { (success, error) in
//
//                if error != nil {
//                    if self.failedBlock != nil {
//                        self.failedBlock!(error)
//                    }
//                }
//                else if success == true {
//                    queue.message = queue.message + "\nHR模块正常"
//                }
//                else if success == false {
//                    queue.message = queue.message + "\nHR模块异常"
//                }
//            }, toDeviceName: queue.device?.name)
        
        let _ = BLECenter.shared.checkBLEName(callback: { (bleName, error) in
            
            if error != nil {
                if self.failedBlock != nil {
                    self.failedBlock!(error)
                }
            }
            else {
                if bleName == queue.device?.name {
                    queue.message = queue.message + "\n蓝牙名正常"
                }
                else {
                    queue.message = queue.message + "\n广播蓝牙名(\(queue.device!.name)) 不匹配 蓝牙名(\(bleName!))"
                }
            }
            
        }, toDeviceName: queue.device?.name)
    }
}
