//
//  BLEConnectOp.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/2/19.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class BLEConnectOp: BaseOperation {
    override func mainAction() {
        super.mainAction()
        self.isTaskExecuting = true

        let queue:TestOpQueue = self.queue as! TestOpQueue
        BLECenter.shared.connect(device: queue.device!, callback: { (device, error) in
            if error != nil || device == nil {
                if self.failedBlock != nil {
                    self.failedBlock!(error)
                }
            }
            else {
                queue.message = queue.message + "\n连接上设备:\(device!.name)"
            }
            self.isTaskExecuting = false
            self.isTaskFinished = true
        }, timeout: 15)
//        BLECenter.shared.connect(device: queue.device) { (device, error) in
//            if error != nil {
//
//            }
//
//            self.isTaskExecuting = false
//            self.isTaskFinished = true
//        }
        
    }
}
