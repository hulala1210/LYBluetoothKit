//
//  BLEGesensorTestOp.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/2/26.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class BLEGesensorTestOp: BaseOperation {
    
    var gesensorRecords:Array<String> = []
    
    var gesensorCheckCount:Int = 5
    
    override func mainAction() {
        super.mainAction()
        
        if self.isCancelled {
            return
        }
        
        self.isTaskExecuting = true
        let queue:TestOpQueue = self.queue as! TestOpQueue
        
        checkGesensor(callback: { (dataArray, error) in
            self.gesensorCheckCount = self.gesensorCheckCount - 1
            
            if dataArray == nil || dataArray!.count <= 0 || error != nil {
                if self.failedBlock != nil {
                    self.failedBlock!(error)
                }
            }
            else {
                
                let data = dataArray!.first
                let gesensorString = data!.hexEncodedString()
                self.gesensorRecords.append(gesensorString)
                
                let compareResult = self.checkGesensorAction()
                if compareResult {
                    
                }
                
                queue.message = queue.message + "\nGesensor:\(gesensorString)"
            }
            
        }, toDeviceName: queue.device?.name)
        
//        let _ = BLECenter.shared.checkGesensor(callback: { (dataArray, error) in
//
//            self.gesensorCheckCount = self.gesensorCheckCount - 1
//
//            if dataArray == nil || dataArray!.count <= 0 || error != nil {
//                if self.failedBlock != nil {
//                    self.failedBlock!(error)
//                }
//            }
//            else {
//
//                let data = dataArray!.first
//                let gesensorString = data!.hexEncodedString()
//                self.gesensorRecords.append(gesensorString)
//
//                let compareResult = self.checkGesensorAction()
//                if compareResult {
//
//                }
//
//                queue.message = queue.message + "\nGesensor:\(gesensorString)"
//            }
//
//            self.done()
//
//        }, toDeviceName: queue.device?.name)
        
    }
    
    private func checkGesensor(callback:DataArrayCallback?, toDeviceName deviceName:String?) {
        let queue:TestOpQueue = self.queue as! TestOpQueue

        let _ = BLECenter.shared.checkGesensor(callback: { (dataArray, error) in
            
            if self.isCancelled {
                return
            }
            
            self.gesensorCheckCount = self.gesensorCheckCount - 1
            
            if dataArray == nil || dataArray!.count <= 0 || error != nil {
                
                if self.gesensorCheckCount == 0 {
                    if self.failedBlock != nil {
                        self.failedBlock!(error)
                    }
                    self.done()
                }
                else {
                    self.checkGesensor(callback: callback, toDeviceName: deviceName)
                }
                
            }
            else {
                
                let data = dataArray!.first
                let gesensorString = data!.hexEncodedString()
                self.gesensorRecords.append(gesensorString)
                
                let compareResult = self.checkGesensorAction()
                if compareResult {
                    self.done()
                }
                else {
                    
                    if self.gesensorCheckCount == 0 {
                        queue.message = queue.message + "\nGesensor模块有问题"
                        queue.badMessage = queue.badMessage + "\nGesensor模块有问题"
                        self.done()
                    }
                    else {
                        self.checkGesensor(callback: callback, toDeviceName: deviceName)
                    }
                    
                }
                
                queue.message = queue.message + "\nGesensor:\(gesensorString)"
            }
            
        }, toDeviceName: queue.device?.name)
    }
    
    private func checkGesensorAction() ->Bool {
        if gesensorRecords.count <= 1 {
            return false
        }
        else {
            if gesensorRecords.last != gesensorRecords.first {
                return true
            }
            else {
                return false
            }
        }
    }
}
