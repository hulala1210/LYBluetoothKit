//
//  BmobFactoryOTAInfoModel.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/1/13.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class BmobFactoryOTAInfoModel: NSObject {
    var firmwareVersion:String?
    var needReset:Bool?
    var blePrefixAfterOTA:String?
    var otaNamePrefix:String?
    var otaName:String?
    var bleNamePrefix:String?
    var secretCode:String?
    var fileFTPPath:String?
    var platform:String?
    
    var otaSerialNumber:Int?
    var customerName:String?
    var productName:String?
    var deviceType:String?
    
    public init(bmobObj:BmobObject) {
        self.firmwareVersion = bmobObj.object(forKey: "firmwareVersion") as? String
        self.needReset = bmobObj.object(forKey: "needReset") as? Bool
        
        if self.needReset == nil {
            self.needReset = false
        }
        
        self.blePrefixAfterOTA = bmobObj.object(forKey: "blePrefixAfterOTA") as? String
        self.otaNamePrefix = bmobObj.object(forKey: "otaNamePrefix") as? String
        self.otaName = bmobObj.object(forKey: "otaName") as? String
        self.bleNamePrefix = (bmobObj.object(forKey: "bleNamePrefix") as? String)
        self.secretCode = bmobObj.object(forKey: "secretCode") as? String
        self.fileFTPPath = (bmobObj.object(forKey: "fileFTPPath") as? String)
        self.platform = (bmobObj.object(forKey: "platform") as? String)
        
        let serial = (bmobObj.object(forKey: "otaSerialNumber") as? Double)
        if serial != nil {
            self.otaSerialNumber = Int(serial!)
        }
        
        self.customerName = (bmobObj.object(forKey: "customerName") as? String)
        self.productName = (bmobObj.object(forKey: "productName") as? String)
        self.deviceType = (bmobObj.object(forKey: "deviceType") as? String)

    }
    
}
