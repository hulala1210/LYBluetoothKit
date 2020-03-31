//
//  FactoryOTAResetHelper.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/3/18.
//  Copyright © 2020 ss. All rights reserved.
//

import Foundation

protocol FactoryOTAResetHelperDelegate {
    func resetHelperPrintLog(helper:FactoryOTAResetHelper!, message:String!)
    func resetHelperTaskEnd(helper:FactoryOTAResetHelper!)
}

let resetStopCountdownLimited:Int = 5

class FactoryOTAResetHelper:BaseViewController {
    var config:OtaConfig!
    private var scanDevices: [BLEDevice]?
//    let shared = FactoryOTAResetHelper()
    private var successList:Array<BLEDevice> = []
    private var unusedList:Array<BLEDevice> = []

    var delegate:FactoryOTAResetHelperDelegate?
        
    private var stopCountDown:Int! = 0
    
    public func startTask() {
        stopCountDown = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.startScan()
        }
    }
    
    private func startScan() {
        
//        if isStop {
//            return
//        }
        
        printLog("开始扫描设备")
        weak var weakSelf = self
        BLECenter.shared.scan(callback: { (devices, err) in
            weakSelf?.scanDevices = devices
        }, stop: {
            weakSelf?.startConnect()
        }, after: 5)
    }
    
    private func startConnect() {
        printLog("开始筛选设备，进行连接")
        
        guard let devices = scanDevices, devices.count > 0 else {
            printLog("扫描到设备个数为0，5秒之后重新扫描")
            reScan(afterSecond: 5)
            return
        }
        printLog("开始挑选满足条件的，并连接设备")
        // 本次扫描是否有合适的设备
        var hasFitOne = false
        for d in devices {
            
            if !isDeviceAvaiable(name: d.name) {
                continue
            }
            
            if d.name.hasPrefix(config.deviceNamePrefix), d.rssi >= config.signalMin {
                hasFitOne = true
                // 只有ota准备好之后，这个值才会变成false
                // 在通知 otaTaskReady 处理方法里面
//                self.isConnecting = true
//                self.connectingName = d.name
                weak var weakSelf = self
                BLECenter.shared.connect(device: d, callback: { (device, err) in
                    
                    // 如果有错误，那处理错误
                    if err != nil {
                        let msg = weakSelf?.errorMsgFromBleError(err)
                        weakSelf?.printLog("连接(\(d.name))出错：\(msg ?? "")")
//                        weakSelf?.removeOtaTask(byName: d.name)
//                        weakSelf?.isConnecting = false
                        weakSelf?.reScan(afterSecond: 5)
                        return
                    }
                    // 如果成功，那就进行到下一步
                    weakSelf?.deviceConnected(device: device!)
                    
                }, timeout: 10)
                // 一次只连接一个
                break
            }
        }
        
        // 如果没有合适的，那5秒之后再重新扫描
        if !hasFitOne {
            
            self.stopCountDown = self.stopCountDown + 1
            
            if self.stopCountDown < resetStopCountdownLimited {
                printLog("扫描到合适的设备个数为0，5秒之后重新扫描")

                reScan(afterSecond: 5)
            }
            else {
                if delegate != nil {
                    printLog("扫描到合适的设备个数为0，重置任务连续\(resetStopCountdownLimited)次扫描不到，重启升级任务。")

                    delegate?.resetHelperTaskEnd(helper: self)
                }
            }
        }
        else {
            self.stopCountDown = 0
        }
    }
    
    func reScan(afterSecond second: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + second) {
            self.startScan()
        }
    }
    
    private func isDeviceAvaiable(name: String) -> Bool {
        for device in successList {
            if device.name == name {
                return false
            }
        }
        
        for task in unusedList {
            if task.name == name {
                return false
            }
        }
        
        return true
    }
    
    private func deviceConnected(device: BLEDevice) {
        weak var weakSelf = self
        let _ = BLECenter.shared.resetDevice(boolCallback: { (success, error) in
            if !success || (error != nil) {
                weakSelf!.unusedList.append(device)
                self.printLog("重置设备失败")
            }
            else {
                self.printLog("重置设备成功")
                weakSelf!.successList.append(device)
            }
            
            let _ = BLECenter.shared.disconnect(device: device, callback: nil)
            
        }, toDeviceName: device.name)
    }
    
    private func printLog(_ message:String!) {
        
        if delegate != nil {
            delegate?.resetHelperPrintLog(helper: self, message: message)
        }
        
    }
    
}
