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
        
        if self.isCancelled {
            return
        }
        
        self.isTaskExecuting = true
        let queue:TestOpQueue = self.queue as! TestOpQueue
        
        let _ = BLECenter.shared.startMotor(callback: { (success, error) in
            
            if self.isCancelled {
                return
            }
            
            if success == false || error != nil {
                if self.failedBlock != nil {
                    self.failedBlock!(error)
                }
                self.done()

            }
            else {
                queue.message = queue.message + "\n马达命令发送成功，请留意马达是否开启。"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    BLECenter.shared.stopMotor(callback: { (stopSuccess, stopError) in
                        
                        if stopSuccess == true {
                            queue.message = queue.message + "\n马达命令发送成功，请留意马达是否关闭。"
                        }
                        else {
                            if self.failedBlock != nil {
                                self.failedBlock!(error)
                            }
                        }
                        self.done()

                    }, toDeviceName: queue.device?.name)
                }
                
            }
            
        }, toDeviceName: queue.device?.name)
//        
    }
}
