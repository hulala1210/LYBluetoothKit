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
    
        if self.isCancelled {
            return
        }
        
        self.isTaskExecuting = true
        let queue:TestOpQueue = self.queue as! TestOpQueue
            
        
        let _ = BLECenter.shared.checkBLEName(callback: { (bleName, error) in
            
            if self.isCancelled {
                return
            }
            
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
            self.done()
        }, toDeviceName: queue.device?.name)
    }
}
