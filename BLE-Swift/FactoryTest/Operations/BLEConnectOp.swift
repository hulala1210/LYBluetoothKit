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
        
        if self.isCancelled {
            return
        }
        
        self.isTaskExecuting = true

        let queue:TestOpQueue = self.queue as! TestOpQueue
        
        queue.message = queue.message + "\n开始连接设备:\(queue.device!.name)"

        BLECenter.shared.connect(device: queue.device!, callback: { (device, error) in
            
            if self.isCancelled {
                return
            }
            
            if error != nil || device == nil {
                if self.failedBlock != nil {
                    self.failedBlock!(error)
                }
            }
            else {
                queue.message = queue.message + "\n连接上设备:\(device!.name)"
            }
            self.done()
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
