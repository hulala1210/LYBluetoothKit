//
//  BLENameTestOp.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/2/26.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit


public enum FWVersionKey: String, Codable {
    case tlr = "TE"
    case apollo = "A"
    case nordic = "N"
    case heartRate = "H"
    case touch = "T"
    case picture = "R"
    case fresscale = "K"
    case build = "B"
}

class BLEVersionTestOp: BaseOperation {
    override func mainAction() {
        super.mainAction()
        
        if self.isCancelled {
            return
        }
        
        self.isTaskExecuting = true
        let queue:TestOpQueue = self.queue as! TestOpQueue
        queue.message = queue.message + "\n开始检查设备版本号"

        let _ = BLECenter.shared.getFirmwareVersionWithBuild(stringCallback: { (versionString, error) in
            
            if self.isCancelled {
                return
            }
            
            if versionString == nil || error != nil {
                if self.failedBlock != nil {
                    self.failedBlock!(error)
                }
            }
            else {
                queue.message = queue.message + "\n设备版本号:\(versionString!)"
                
                let versionDict:Dictionary<String,Double> = parseVersion(versionString: versionString)
                print(versionDict)
                
                let standardFWVersion = UserDefaults.standard.double(forKey: FactoryFirmwareVersionCodeCacheKey)
                let standardBuildVersion = UserDefaults.standard.integer(forKey: FactoryBuildVersionCodeCacheKey)
//                let standardHardwareVersion = UserDefaults.standard.double(forKey: FactoryHardwareVersionCodeCacheKey)

                var fwVersion:Double = versionDict[FWVersionKey.tlr.rawValue] ?? 0.0
                if fwVersion == 0.0 {
                    fwVersion = versionDict[FWVersionKey.apollo.rawValue] ?? 0.0
                }
                else if fwVersion == 0.0 {
                    fwVersion = versionDict[FWVersionKey.nordic.rawValue] ?? 0.0
                }
                
                let buildFWVersion = versionDict[FWVersionKey.build.rawValue] ?? 0.0
                
                if (fwVersion != standardFWVersion || Int(buildFWVersion * 10) != standardBuildVersion) {
                    queue.message = queue.message + "\n设备版本号比对不符"
                    queue.badMessage = queue.badMessage + "\n设备版本号比对不符"
                }
                else {
                    queue.message = queue.message + "\n设备版本号比对正常"
                }

            }
            
            self.done()
        }, toDeviceName: queue.device?.name)
    }

}
