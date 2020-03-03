//
//  BLEFlashTestOp.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/2/27.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class BLEFlashTestOp: BaseOperation {
    override func mainAction() {
            super.mainAction()
            self.isTaskExecuting = true
            let queue:TestOpQueue = self.queue as! TestOpQueue
            
            let _ = BLECenter.shared.checkFlash(callback: { (success, error) in
                
                if error != nil {
                    if self.failedBlock != nil {
                        self.failedBlock!(error)
                    }
                }
                else if success == true {
                    queue.message = queue.message + "\nFlash正常"
                }
                else if success == false {
                    queue.message = queue.message + "\nFlash异常"
                }
            }, toDeviceName: queue.device?.name)
    //
        }
}
