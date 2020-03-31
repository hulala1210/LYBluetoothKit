//
//  BLEScanGraveOp.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/3/10.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit
import EFQRCode

class BLEScanGraveOp: BaseOperation {
    override func mainAction() {
        super.mainAction()
    
        if self.isCancelled {
            return
        }
    
        self.isTaskExecuting = true
        let queue:TestOpQueue = self.queue as! TestOpQueue
        
        if let tryImage = EFQRCode.generate(
            content: queue.device!.name,
            watermark: nil
        ) {
            print("Create QRCode image success: \(tryImage)")
            queue.message = queue.message + "\n创建二维码成功"
            queue.image = UIImage.init(cgImage: tryImage)
            self.done()

        } else {
            print("Create QRCode image failed!")
            queue.message = queue.message + "\n创建二维码失败"
            queue.badMessage = queue.badMessage + "\n创建二维码失败"
            self.done()

        }
        
    }
}
