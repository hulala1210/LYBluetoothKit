//
//  BaseOperationQueue.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/2/25.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class BaseOperationQueue: OperationQueue {
    override func addOperation(_ op: Operation) {
        if op is BaseOperation {
            let baseOp = op as! BaseOperation
            baseOp.queue = self
        }
        
        super.addOperation(op)
    }
    
    override func addOperations(_ ops: [Operation], waitUntilFinished wait: Bool) {
        for op in ops {
            if op is BaseOperation {
                let baseOp = op as! BaseOperation
                baseOp.queue = self
            }
        }
        super.addOperations(ops, waitUntilFinished: wait)
    }
    
}
