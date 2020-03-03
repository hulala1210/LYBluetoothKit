//
//  FactoryTestGroup.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/3/3.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class FactoryTestGroup: NSObject {
    var testCasesSerial:Array<Int> = []
    var groupName = ""
    var remark = ""
    
    public init(bmobObj:BmobObject) {
        self.testCasesSerial = bmobObj.object(forKey: "testCasesSerial") as! Array<Int>
        self.groupName = bmobObj.object(forKey: "groupName") as! String
        self.remark = bmobObj.object(forKey: "remark") as! String

    }
}
