//
//  BLENameTestOp.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/2/26.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit
import SwiftScanner

class BLEVersionTestOp: BaseOperation {
    override func mainAction() {
        super.mainAction()
        self.isTaskExecuting = true
        let queue:TestOpQueue = self.queue as! TestOpQueue
        let _ = BLECenter.shared.getFirmwareVersionWithBuild(stringCallback: { (versionString, error) in
            
            if versionString == nil || error != nil {
                if self.failedBlock != nil {
                    self.failedBlock!(error)
                }
            }
            else {
                queue.message = queue.message + "\n设备版本号:\(versionString!)"
                
                let versionDict:Dictionary<String,Double> = self.parseVersion(versionString: versionString)
                print(versionDict)
            }
            
            self.isTaskExecuting = false
            self.isTaskFinished = true
        }, toDeviceName: queue.device?.name)
    }
    
    private func parseVersion(versionString:String!) -> Dictionary<String,Double> {
        
        var version:String! = versionString
        
        var scanner = StringScanner(version)
        
        var result = Dictionary<String,Double>.init()
        
        while version.count > 0 {
            do {
                let partialString = try scanner.scan(upTo: CharacterSet.decimalDigits)
                let versionCode = try scanner.scanFloat()
                
                result[partialString!] = Double(versionCode)
                
                version = String(versionString.suffix(from: scanner.endIndex))
                scanner = StringScanner(version)
                
            } catch let error {
                print(error)
            }
        }
     
        return result
    }
}
