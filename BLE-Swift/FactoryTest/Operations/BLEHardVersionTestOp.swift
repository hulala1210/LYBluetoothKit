//
//  BLEHardVersionTestOp.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/2/26.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class BLEHardVersionTestOp: BaseOperation {
    override func mainAction() {
        super.mainAction()
        
        if self.isCancelled {
            return
        }
        
        self.isTaskExecuting = true
        let queue:TestOpQueue = self.queue as! TestOpQueue
        let _ = BLECenter.shared.getHardwareVersion(stringCallback: { (versionString, error) in
            
            if self.isCancelled {
                return
            }
            
            if versionString == nil || error != nil {
                if self.failedBlock != nil {
                    self.failedBlock!(error)
                }
            }
            else {
                queue.message = queue.message + "\n硬件版本号:\(versionString!)"
                
                let standardHardwareVersion = UserDefaults.standard.double(forKey: FactoryHardwareVersionCodeCacheKey)

                let versionDict = parseVersion(versionString: versionString)
                if versionDict["H"] != standardHardwareVersion {
                    queue.message = queue.message + "\n硬件版本号比对不符"
                    queue.badMessage = queue.badMessage + "\n硬件版本号比对不符"
                }
                else {
                    queue.message = queue.message + "\n硬件版本号比对正常"
                }
            }
            
            self.done()
        }, toDeviceName: queue.device?.name)
    }
    
}
