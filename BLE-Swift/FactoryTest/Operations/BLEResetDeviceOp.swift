//
//  BLEResetDeviceOp.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/3/10.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class BLEResetDeviceOp: BaseOperation {
    override func mainAction() {
        super.mainAction()
    
        if self.isCancelled {
            return
        }
    
        self.isTaskExecuting = true
        let queue:TestOpQueue = self.queue as! TestOpQueue
        
        let _ = BLECenter.shared.resetDevice(boolCallback: { (success, error) in
            if self.isCancelled {
                return
            }
            
            if success {
                queue.message = queue.message + "\n重置命令发送成功"
            }
            else {
                if self.failedBlock != nil {
                    self.failedBlock!(error)
                }
            }
            
            self.done()
            
        }, toDeviceName: queue.device!.name)
    }
}
