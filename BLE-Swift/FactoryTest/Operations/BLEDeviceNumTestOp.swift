//
//  BLEDeviceNumTestOp.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/2/26.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class BLEDeviceNumTestOp: BaseOperation {
    override func mainAction() {
        super.mainAction()
        self.isTaskExecuting = true
        let queue:TestOpQueue = self.queue as! TestOpQueue
        let _ = BLECenter.shared.getDeviceID(stringCallback: { (versionString, error) in
            
            if versionString == nil || error != nil {
                if self.failedBlock != nil {
                    self.failedBlock!(error)
                }
            }
            else {
                queue.message = queue.message + "\nDevice ID:\(versionString!)"
            }
            
            self.isTaskExecuting = false
            self.isTaskFinished = true
        }, toDeviceName: queue.device?.name)
    }
}
