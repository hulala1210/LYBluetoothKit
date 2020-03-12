//
//  BaseOperation.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/2/18.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

typealias TestOpFailedBlock = (BLEError?)->Void

class BaseOperation: Operation {
    
    private let _lock = NSLock()
    
    public weak var queue:BaseOperationQueue?
    
    public var failedBlock:TestOpFailedBlock?
    
    public var isTaskExecuting: Bool {
        willSet { willChangeValue(forKey: "isExecuting") }
        didSet { didChangeValue(forKey: "isExecuting") }
    }
    
    public var isTaskFinished: Bool {
        willSet { willChangeValue(forKey: "isFinished") }
        didSet { didChangeValue(forKey: "isFinished") }
    }
    
    override init() {
        isTaskFinished = false
        isTaskExecuting = false
        super.init()
        
    }

    override var isExecuting: Bool {
        return isTaskExecuting
    }
    override var isFinished: Bool {
        return isTaskFinished
    }
    override var isAsynchronous: Bool {
        return true
    }
    
    override func start() {
        _lock.lock()
        mainAction()
        _lock.unlock()
    }
    
    // MARK: - For Override 
    open func mainAction() {
        
        print("\(self) begin" )
        
    }
    
    @objc open func done() {
        
        print("\(self) done" )
        
        isTaskExecuting = false
        isTaskFinished = true
    }
}
