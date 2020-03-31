//
//  OtaConfig.swift
//  BLE-Swift
//
//  Created by SuJiang on 2019/1/8.
//  Copyright © 2019 ss. All rights reserved.
//

import UIKit

enum OtaPlatform: Int, Codable {
    case apollo
    case nordic
    case tlsr
}

struct OtaConfig: Codable {

    var id = 0
    var platform: OtaPlatform = .apollo
    var createTime: TimeInterval = Date().timeIntervalSince1970
    var name = ""
    var type = ""
    var batchId = ""
    var prefix = ""
    var deviceName = ""
    var deviceNamePrefix = ""
    var signalMin = -100
    var upgradeCountMax = 5
    var otaCount = 0
    var needReset = false
    var firmwares: [Firmware] = []
    
    var otaBleName: String?
    var targetDeviceType: String?
    
    var blePrefixAfterOTA: String?
    
    func getFirmwares(byType type: OtaDataType) -> [Firmware] {
        var arr = [Firmware]()
        for fm in firmwares {
            if fm.type == type {
                arr.append(fm)
            }
        }
        return arr
    }
    
    func copyConfig() -> OtaConfig {
        var newConfig = OtaConfig()
        
        newConfig.id = self.id
        newConfig.platform = self.platform
        newConfig.createTime = self.createTime
        newConfig.name = self.name
        newConfig.type = self.type
        newConfig.batchId = self.batchId
        newConfig.prefix = self.prefix
        newConfig.deviceName = self.deviceName
        newConfig.deviceNamePrefix = self.deviceNamePrefix
        newConfig.signalMin = self.signalMin
        newConfig.upgradeCountMax = self.upgradeCountMax
        newConfig.otaCount = self.otaCount
        newConfig.needReset = self.needReset
        newConfig.firmwares = self.firmwares
        newConfig.otaBleName = self.otaBleName
        newConfig.targetDeviceType = self.targetDeviceType

        return newConfig
    }
    
}
