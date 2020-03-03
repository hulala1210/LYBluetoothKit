//
//  BLEGesensorTestOp.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/2/26.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class BLEGesensorTestOp: BaseOperation {
    override func mainAction() {
        super.mainAction()
        self.isTaskExecuting = true
        let queue:TestOpQueue = self.queue as! TestOpQueue
        
        let _ = BLECenter.shared.checkGesensor(callback: { (gesensorString, error) in
            if gesensorString == nil || error != nil {
                if self.failedBlock != nil {
                    self.failedBlock!(error)
                }
            }
            else {
                queue.message = queue.message + "\nGesensor:\(gesensorString!)"
            }
        }, toDeviceName: queue.device?.name)
        
    }
}
