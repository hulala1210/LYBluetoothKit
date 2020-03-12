//
//  BLEHidePairOp.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/2/25.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class BLEHidePairOp: BaseOperation {
    override func mainAction() {
        self.isTaskExecuting = true

        if self.isCancelled {
            return
        }
        
        let queue:TestOpQueue = self.queue as! TestOpQueue

        let _ = BLECenter.shared.cancelPairCommand(callback: { (success, error) in
            
            if self.isCancelled {
                return
            }
            
            if error == nil {
                print("连接成功")
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
