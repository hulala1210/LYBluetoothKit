//
//  FactoryTestCase.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/2/18.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

public enum FinishedProductTestCaseType:Int , Codable {
    case unknown = -1
    case normal = 0
    case movement
    case calibration
    case reset
    case scanCarveQR
}

class FactoryTestCase: NSObject {
    var type:FinishedProductTestCaseType = FinishedProductTestCaseType.normal
    
    
    
}
