//
//  FactoryTestCase.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/2/18.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

//public enum FinishedProductTestCaseType:Int , Codable {
//    case unknown = -1
//    case normal = 0
//    case movement
//    case calibration
//    case reset
//    case scanCarveQR
//}

public enum FactoryTestCaseType:Int , Codable {
    case firmware = 1
    case hardware = 2
    case deviceNum = 3
    case gesensor = 4
    case motor = 5
    case flash = 6
    case heartRate = 7
    case bleName = 8
    case buzzer = 9
    case minutePointerAntiClockwise = 10
    case minutePointerClockwise = 11
    case hourPointerAntiClockwise = 12
    case hourPointerClockwise = 13
    case resetDevice = 14
    case scanGrave = 15

}

class FactoryTestCase {
    
    var serialNumber:Int! = 0
    var caseName:String! = ""
    var remark:String? = ""
    
    public static func testCase(bmobObj:BmobObject!) -> FactoryTestCase? {
        let serialNumber = bmobObj.object(forKey: "serialNumber") as? Int
        let caseName = bmobObj.object(forKey: "caseName") as? String
        let remark = bmobObj.object(forKey: "remark") as? String
        
        if serialNumber == nil || caseName == nil {
            return nil
        }
        else {
            let testCase = FactoryTestCase()
            testCase.serialNumber = serialNumber!
            testCase.caseName = caseName!
            testCase.remark = remark

            return testCase
        }
    }
    
}
