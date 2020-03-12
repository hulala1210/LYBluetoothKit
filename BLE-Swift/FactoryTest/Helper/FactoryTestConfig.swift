//
//  FactoryTestTask.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/3/3.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class FactoryTestConfig {
    var testGroupsSerial:Array<Int>! = []
    var secretCode:String! = ""
    var bleNamePrefix:String! = ""
    
    public static func testConfig(bmobObj:BmobObject!) -> FactoryTestConfig? {
        let testGroupsSerial = bmobObj.object(forKey: "testCaseGroupsSerial") as? Array<Int>
        let secretCode = bmobObj.object(forKey: "secretCode") as? String
        let bleNamePrefix = bmobObj.object(forKey: "bleNamePrefix") as? String
        
        if testGroupsSerial == nil || secretCode == nil || bleNamePrefix == nil {
            return nil
        }
        else {
            let config = FactoryTestConfig()
            config.testGroupsSerial = testGroupsSerial!
            config.secretCode = secretCode!
            config.bleNamePrefix = bleNamePrefix
            
            return config
        }
    }
}
