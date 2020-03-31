//
//  Firmware.swift
//  BLE-Swift
//
//  Created by SuJiang on 2019/1/8.
//  Copyright © 2019 ss. All rights reserved.
//

import UIKit

enum FirmwareBaseURLPathType:Int, Codable {
    case Doc = 1
    case Cache = 2
    case Tmp = 3
}

class Firmware: Codable, Equatable {
    
    var id = 0
    var name = ""
    
    var baseURLPathType:FirmwareBaseURLPathType = .Doc
    
    var baseURLPath:String {
        switch self.baseURLPathType {
            case .Doc:
                return StorageUtils.getDocPath()
            case .Tmp:
                return StorageUtils.getTempPath()
            case .Cache:
                return StorageUtils.getCahcePath()
        }
    }
        
    var relativeURLPath = ""
    var path:String {
        if relativeURLPath.count == 0 {
            return ""
        }
        else {
            return baseURLPath.stringByAppending(pathComponent: relativeURLPath)
        }
    }
    
    var versionName = ""
    var versionCode = 0.0
    var type: OtaDataType = .platform
    var createTime: TimeInterval = Date().timeIntervalSince1970
    
    var description:String {
        return "FW_Path" + self.path
    }
    
    static func getOtaType(withFileName fileName: String) -> OtaDataType {
        let tmp = fileName.lowercased()
        if tmp.hasPrefix("apollo") {
            return .platform
        }
        else if tmp.hasPrefix("appollo") {
            return .platform
        }
        else if tmp.hasPrefix("appllo") {
            return .platform
        }
        else if tmp.hasPrefix("apollo3") {
            return .platform
        }
        else if tmp.hasPrefix("application") {
            return .platform
        }
        else if tmp.hasPrefix("heartrate") {
            return .heartRate
        }
        else if tmp.hasPrefix("picture") {
            return .picture
        }
        else if tmp.hasPrefix("language") {
            return .picture
        }
        else if tmp.hasPrefix("resmap") {
            return .picture
        }
        else if tmp.hasPrefix("touchpanel") {
            return .touchPanel
        }
        else if tmp.hasPrefix("kl17") {
            return .freeScale
        }
        else if tmp.hasPrefix("mg") {
            return .agps
        }
        else {
            return .platform
        }
    }
    
    static func getTypeName(withType type: OtaDataType) -> String {
        switch type {
        case .platform:
            return TR("FW")
        case .picture:
            return TR("PIC")
        case .heartRate:
            return TR("HR")
        case .touchPanel:
            return TR("TP")
        case .freeScale:
            return TR("FS")
        case .agps:
            return TR("GPS")
        }
    }
    
    
    static func == (lhs: Firmware, rhs: Firmware) -> Bool {
        return lhs.name == rhs.name
    }
    
    
}
