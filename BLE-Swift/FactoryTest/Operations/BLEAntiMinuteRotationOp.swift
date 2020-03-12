//
//  BLEAntiMinuteRotationOp.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/3/9.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class BLEAntiMinuteRotationOp: BaseOperation {
    override func mainAction() {
        super.mainAction()
    
        if self.isCancelled {
            return
        }
    
        self.isTaskExecuting = true
        let queue:TestOpQueue = self.queue as! TestOpQueue
        
        queue.message = queue.message + "\n请留意分针逆转一圈"
        
        let _ = BLECenter.shared.pointerRotation(pointer: .pointerMin, direction: .antiClockwise, angle: 360, callback: { (success, error) in
            
            if self.isCancelled {
                return
            }
            
            if error != nil {
                if self.failedBlock != nil {
                    self.failedBlock!(error)
                }
            }
            else if success == true {
                queue.message = queue.message + "\n分针逆转一圈命令发送成功"
            }
            else if success == false {
                queue.message = queue.message + "\n分针逆转一圈命令发送失败"
            }

            DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                self.done()
            }
            
        }, toDeviceName: queue.device!.name)
        
    }
}
