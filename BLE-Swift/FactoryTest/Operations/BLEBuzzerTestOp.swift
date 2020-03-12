//
//  BLEBuzzerTestOp.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/3/9.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class BLEBuzzerTestOp: BaseOperation {
    override func mainAction() {
        super.mainAction()
    
        if self.isCancelled {
            return
        }
    
        self.isTaskExecuting = true
        let queue:TestOpQueue = self.queue as! TestOpQueue
        
        queue.message = queue.message + "\n请留意蜂鸣片响声"
        
        let _ = BLECenter.shared.checkBuzzer(callback: { (success, error) in
            
            if self.isCancelled {
                return
            }
            
            if error != nil {
                if self.failedBlock != nil {
                    self.failedBlock!(error)
                }
            }
            else if success == true {
                queue.message = queue.message + "\n蜂鸣片命令发送成功"
            }
            else if success == false {
                queue.message = queue.message + "\n蜂鸣片命令发送失败"
            }
            
            self.done()
        }, toDeviceName: queue.device?.name)
    //
    }
}
