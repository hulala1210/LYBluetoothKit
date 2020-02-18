//
//  LxFTPRequestExtension.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/1/9.
//  Copyright © 2020 ss. All rights reserved.
//

import Foundation

struct associatedKey {
     static var key = "LxProgressKey"
}

extension LxFTPRequest {
    
    public var progress:Progress? {
        set {
            if let newValue = newValue {
                    objc_setAssociatedObject(self, &(associatedKey.key), newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
            }
            
            get {
                return objc_getAssociatedObject(self, &(associatedKey.key)) as? Progress
            }
//        ————————————————
//        版权声明：本文为CSDN博主「Understand_XZ」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
//        原文链接：https://blog.csdn.net/understand_XZ/article/details/89673078
    }
    
}
