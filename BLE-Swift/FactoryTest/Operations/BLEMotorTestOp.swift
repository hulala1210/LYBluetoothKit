//
//  BLEMotorTestOp.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/2/27.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class BLEMotorTestOp: BaseOperation {
    override func mainAction() {
        super.mainAction()
        self.isTaskExecuting = true
        let queue:TestOpQueue = self.queue as! TestOpQueue
        
        let _ = BLECenter.shared.checkMotor(callback: { (success, error) in
            if success == false || error != nil {
                if self.failedBlock != nil {
                    self.failedBlock!(error)
                }
            }
            else {
                queue.message = queue.message + "\n马达命令发送成功，请留意马达。"
            }
        }, toDeviceName: queue.device?.name)
//        
    }
}
