//
//  OtaTlsrTask.swift
//  BLE-Swift
//
//  Created by SuJiang on 2019/2/13.
//  Copyright © 2019 ss. All rights reserved.
//

import UIKit

class OtaTlsrTask: OtaTask {
    
    private var isSingleOTAFinish = false

    private let serial = DispatchQueue(label: "serialQueue1")
    
    private let heartbeatObserver = BLEDeviceHeartbeatObserver.init()
    
    override init(device: BLEDevice, otaBleName: String, otaDatas: [OtaDataModel], readyCallback: EmptyBlock?, progressCallback: FloatCallback?, finishCallback: BoolCallback?) {
        super.init(device: device, otaBleName: otaBleName, otaDatas: otaDatas, readyCallback: readyCallback, progressCallback: progressCallback, finishCallback: finishCallback);
        self.device.delegate = self
    }
    
    private func otaDeviceDataComes(data: Data) {
        
    }
    
    override func start() {
        
        if device.state == .disconnected {
            otaFailed(error: BLEError.deviceError(reason: .disconnected))
            return
        }
        
        if otaDatas.count == 0 {
            otaFailed(error: BLEError.taskError(reason: .paramsError))
            return
        }
        
        heartbeatObserver.operation = {
//            DispatchQueue.global().async {
                print("回复心跳")
                let _ = BLECenter.shared.responseToHeatbeat(boolCallback: nil, toDeviceName: self.device.name)
//            }
        }
        
        var tmpArr = [OtaDataModel]()
        for dm in otaDatas
        {
            if !dm.getTlsrDataReady() {
                let err = BLEError.taskError(reason: .paramsError)
                self.otaFailed(error: err)
                return
            }
            tmpArr.append(dm)
        }
        otaDatas = tmpArr
        enterUpgradeMode()
        
    }
    
    private func enterUpgradeMode() {
        let buf = Data(bytes: [0x01, 0xff])
        writeData(data: buf)
        // 芯片提供商的demo就是延迟0.01秒
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.startOta()
        }
    }
    
    private func startOta() {
        otaReady()
         
        let dm = otaDatas[0]
        startSendOtaData(dataModel: dm)
    }
    
    private func startSendOtaData(dataModel: OtaDataModel) {
        
        if self.state == .failed {
            return
        }
        
        serial.async {
            self.totalLength = dataModel.tlsrOtaDataPackages.count
            
            // 发64个包校验一次
            let sendCountPerRead:Int = 1024 / 16
            
            for _ in 0 ..< sendCountPerRead {
                
                self.sendLength = dataModel.tlsrOtaDataIndex + 1
                print("index:\(dataModel.tlsrOtaDataIndex), count:\(dataModel.tlsrOtaDataPackages.count), progress:\(self.progress)")
                 
                let sd = dataModel.tlsrOtaDataPackages[dataModel.tlsrOtaDataIndex]
                self.writeData(data: sd)
                
                Thread.sleep(forTimeInterval: 0.01)
                
                // 最后一包
                if dataModel.tlsrOtaDataIndex + 1 == self.totalLength {
                    self.isSingleOTAFinish = true
                    
                    self.readData()
                    
                    // 进度回调
                    self.sendLength = self.totalLength
                    DispatchQueue.main.async {
                        self.progressCallback?(1)
                        NotificationCenter.default.post(name: kOtaTaskProgressUpdateNotification, object: nil, userInfo: [BLEKey.task: self])
                    }
                    return
                }
                else {
                    print("----- index:\(dataModel.tlsrOtaDataIndex) sendCountPerRead:\(sendCountPerRead)")

                    DispatchQueue.main.async {
                        
                        self.progressCallback?(self.progress)
                        NotificationCenter.default.post(name: kOtaTaskProgressUpdateNotification, object: nil, userInfo: [BLEKey.task: self])
                    }
                                        
                    if dataModel.tlsrOtaDataIndex%sendCountPerRead == sendCountPerRead - 1 {
                        self.readData()
                    }
                    else {

                    }
                }
                
                dataModel.tlsrOtaDataIndex = dataModel.tlsrOtaDataIndex + 1

            }
            
            self.addTimer(timeout: 10, action: 2)

        }
    }
    
    
    private func endOta(dataModel: OtaDataModel) {
        
        var adr_index:Int = Int(ceil(Double(dataModel.data.count)/16.0));
        adr_index = adr_index - 1;
        let lengthLowByte = adr_index % 0x100
        let lengthHighByte = (adr_index - lengthLowByte) / 0x100 % 0x100
        
        var buf = Data(bytes: [0x02, 0xff])
        buf.append(lengthLowByte.data(byteCount: 1))
        buf.append(lengthHighByte.data(byteCount: 1))
        buf.append((~lengthLowByte).data(byteCount: 1))
        buf.append((~lengthHighByte).data(byteCount: 1))
        writeData(data: buf)
        otaFinish()
    }
    
    
    func writeData(data: Data) {
        if checkIsCancel() {
            return
        }
        print("发送数据：\(data.hexEncodedString())")
        _ = self.device.write(data, characteristicUUID: UUID.tlsrOtaUuid)
    }
    
    func readData() {
        print("readData Check CRC")

        if checkIsCancel() {
            return
        }
        _ = self.device.read(characteristicUUID: UUID.tlsrOtaUuid)
    }
    
    override func deviceDataUpdate(notification: Notification?) {
        guard let de = notification?.userInfo?[BLEKey.device] as? BLEDevice, de == self.device else {
            return
        }

        guard let uuid = notification?.userInfo?[BLEKey.uuid] as? String, (uuid == UUID.c8002 || uuid == UUID.tlsrOtaUuid) else {
            return
        }

        guard let data = notification?.userInfo?[BLEKey.data] as? Data, data.count >= 1 else {
            return
        }
        deviceDidUpdateData(data: data, deviceName: de.name, uuid: uuid)
    }
    
    // MARK: - 接收数据
    override func deviceDidUpdateData(data: Data, deviceName: String, uuid: String) {
        print("设备回传：\(data.hexEncodedString())")
        
        if deviceName != self.device.name || uuid != UUID.tlsrOtaUuid {
            return
        }
        
        if !self.isSingleOTAFinish && otaDatas.count > 0 {
            startSendOtaData(dataModel: otaDatas[0])
        }
        else {
            endOta(dataModel: otaDatas[0]);
        }
    }
    
}
