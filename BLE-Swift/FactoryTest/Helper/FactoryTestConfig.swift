//
//  FactoryTestTask.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/3/3.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class FactoryTestConfig: NSObject {
    var testGroupsSerial:Array<Int> = []
//    var name = ""
//    var remark = ""
    var secretCode = ""
    var bleName = ""
    
    public init(bmobObj:BmobObject) {
        self.testGroupsSerial = bmobObj.object(forKey: "testCaseGroupsSerial") as! Array<Int>
        self.secretCode = bmobObj.object(forKey: "secretCode") as! String
        self.bleName = bmobObj.object(forKey: "testCaseGroupsSerial") as! String

    }
}
