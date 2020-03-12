//
//  FactoryTestUtil.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/3/12.
//  Copyright © 2020 ss. All rights reserved.
//

import Foundation
import SwiftScanner

public func parseVersion(versionString:String!) -> Dictionary<String,Double> {
    
    var version:String! = versionString
    
    var scanner = StringScanner(version)
    
    var result = Dictionary<String,Double>.init()
    
    while version.count > 0 {
        do {
            
            let partialString = try scanner.scan(upTo: CharacterSet.decimalDigits)
            let versionCode = try scanner.scanFloat()
            
            result[partialString!] = Double(versionCode)
            
            version = String(version.suffix(version.count - scanner.consumed))
            scanner = StringScanner(version)
            
        } catch let error {
            print(error)
        }
    }
 
    return result
}
