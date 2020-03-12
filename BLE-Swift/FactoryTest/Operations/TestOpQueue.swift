//
//  TestOpQueue.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/2/25.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class TestOpQueue: BaseOperationQueue {
    
    public var device:BLEDevice?
    @objc dynamic public var message:String! = ""
    public var badMessage:String! = ""
    public var image:UIImage?
}
