//
//  FactoryTestGroup.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/3/3.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class FactoryTestGroup {
    var serialNumber:Int! = 0
    var testCasesSerial:Array<Int>! = []
    var groupName:String? = ""
    var remark:String? = ""
    
//    public init(bmobObj:BmobObject) {
//        self.testCasesSerial = bmobObj.object(forKey: "testCasesSerial") as! Array<Int>
//        self.groupName = bmobObj.object(forKey: "groupName") as! String
//        self.remark = bmobObj.object(forKey: "remark") as? String
//        self.serialNumber = bmobObj.object(forKey: "serialNumber") as! Int
//    }
    
    public static func testGroup(bmobObj:BmobObject!) -> FactoryTestGroup? {
        let testCasesSerial = bmobObj.object(forKey: "testCasesSerial") as? Array<Int>
        let groupName = bmobObj.object(forKey: "groupName") as? String
        let remark = bmobObj.object(forKey: "remark") as? String
        let serialNumber = bmobObj.object(forKey: "serialNumber") as? Int
        
        if testCasesSerial == nil || groupName == nil || serialNumber == nil {
            return nil
        }
        else {
            let group = FactoryTestGroup()
            group.testCasesSerial = testCasesSerial!
            group.groupName = groupName!
            group.remark = remark
            group.serialNumber = serialNumber!
            
            return group
        }
    }
    
}
