//
//  BmobFactoryTestHelper.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/3/3.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

typealias QueryFactoryTestResultBlock = (FactoryTestConfig?, Error?) -> ()
typealias QueryFactoryTestGroupBlock = (Array<FactoryTestGroup>?, Error?) -> ()
typealias QueryFactoryTestCaseBlock = (Array<FactoryTestCase>?, Error?) -> ()

class BmobFactoryTestHelper {
        
    static public func queryTestConfig(secretCode:String, callback:QueryFactoryTestResultBlock?) {
        let query = BmobQuery.init(className: "FactoryTestConfig")
        query?.whereKey("secretCode", equalTo: secretCode)
        query?.findObjectsInBackground({ (results, error) in
            
            DispatchQueue.main.async {
                if ((error) != nil) {
                    if callback != nil {
                        callback!(nil, error)
                    }
                }
                else if (results?.count == 0) {
                    if callback != nil {
                        callback!(nil, nil)
                    }
                }
                else {
                    if callback != nil {
                        var finalResult:FactoryTestConfig? = nil
                        for obj:BmobObject in results as! Array<BmobObject> {
                            finalResult = FactoryTestConfig.testConfig(bmobObj: obj)
                        }
                        
                        callback!(finalResult, nil)
                    }
                }
            }
            
        })
    }
    
    static public func queryTestGroups(groupSerial:Array<Int>, callback:QueryFactoryTestGroupBlock?) {
        let query = BmobQuery.init(className: "TestCaseGroup")
        query?.whereKey("serialNumber", containedIn: groupSerial)
        query?.findObjectsInBackground({ (results, error) in
            
            DispatchQueue.main.async {
                if ((error) != nil) {
                    if callback != nil {
                        callback!(nil, error)
                    }
                }
                else if (results?.count == 0) {
                    if callback != nil {
                        callback!(nil, nil)
                    }
                }
                else {
                    if callback != nil {
                        
                        var finalResult = Array<FactoryTestGroup>()
                        
                        for obj:BmobObject in results as! Array<BmobObject> {
                            let group = FactoryTestGroup.testGroup(bmobObj: obj)
                            if group != nil {
                                finalResult.append(group!)
                            }
                        }
                        
                        callback!(finalResult, nil)
                    }
                }
            }
            
        })
    }
    
    static public func queryTestCases(casesSerial:Array<Int>, callback:QueryFactoryTestCaseBlock?) {
        let query = BmobQuery.init(className: "TestCase")
        query?.whereKey("serialNumber", containedIn: casesSerial)
        query?.findObjectsInBackground({ (results, error) in
            
            DispatchQueue.main.async {
                if ((error) != nil) {
                    if callback != nil {
                        callback!(nil, error)
                    }
                }
                else if (results?.count == 0) {
                    if callback != nil {
                        callback!(nil, nil)
                    }
                }
                else {
                    if callback != nil {
                        
                        var finalResult = Array<FactoryTestCase>()
                        
                        for obj:BmobObject in results as! Array<BmobObject> {
                            
                            let testCase = FactoryTestCase.testCase(bmobObj: obj)
                            if testCase != nil {
                                finalResult.append(testCase!)
                            }
                        }
                        
                        callback!(finalResult, nil)
                    }
                }
            }
            
        })
    }
    
}
