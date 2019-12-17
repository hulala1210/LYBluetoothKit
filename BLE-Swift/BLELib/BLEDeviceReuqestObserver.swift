//
//  BLEDeviceReuqestObserver.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2019/12/12.
//  Copyright © 2019 ss. All rights reserved.
//

import UIKit

//protocol BLEDeviceReuqestObserverDelegate : NSObjectProtocol {
//    func didReceiveDeviceRequest(data:Data, type:Data)
//}

class BLEDeviceReuqestObserver: NSObject {

//    private static var maps = Dictionary<Data, Array<BLEDeviceReuqestObserverDelegate>>()
    
//    public static let shared = BLEDeviceReuqestObserver()
//    public var delegate:BLEDeviceReuqestObserverDelegate? = nil

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(receiveCMD(note:)), name: BLEInnerNotification.deviceDataUpdate, object: nil)
    }
    
//    public func registerResponder(responder:BLEDeviceReuqestObserverDelegate!, for cmd:Data) {
//
//        var responders:Array<BLEDeviceReuqestObserverDelegate>? = BLEDeviceReuqestObserver.maps[cmd] ?? nil
//        if (responders == nil) {
//            responders = Array<BLEDeviceReuqestObserverDelegate>()
//        }
//
//        if (responders?.contains(where: { (item:BLEDeviceReuqestObserverDelegate) -> Bool in
//            return !item.isEqual(responder)
//        }))! {
//            responders!.append(responder)
//        }
//    }
//
//    public func removeResponder(responder:BLEDeviceReuqestObserverDelegate!, for cmd:Data) {
//        let responders:Array<BLEDeviceReuqestObserverDelegate>? = BLEDeviceReuqestObserver.maps[cmd] ?? nil
//
//        if (responders == nil) {
//            return
//        }
//
//        let resultResponders = responders?.filter({ (item:BLEDeviceReuqestObserverDelegate) -> Bool in
//            return !item.isEqual(responder)
//        })
//        BLEDeviceReuqestObserver.maps[cmd] = resultResponders
//    }
    
    var receivedData : Data? = nil
    var receivedDataLength : Int = 0;
    var type : Data? = nil
    
    @objc private func receiveCMD(note:Notification!) {
        let characterID:String = note.userInfo?[BLEKey.uuid] as! String
        let data:Data = note.userInfo?[BLEKey.data] as! Data
        
        if characterID != UUID.c8004 {
            return
        }
        
        if data.count > 6 && data[0] == 0x6f && data[5] == 0xD5 && data[6] == 0 {
            return
        }
        
        // 进行数据处理
        if data[0] == 0x6f && data.count >= 5 {
            receivedData = data
            receivedDataLength = data[3...4].int + 6
            type = data[2...2]
        }
        else {
            receivedData = receivedData! + data
        }
        
        // 接收数据总长度正确，并且接收的数据也真的是到尾部了
        if receivedData?.count == receivedDataLength && receivedDataLength > 6 && (data.last == 0x8f) {
            let result = receivedData![5...(receivedDataLength - 1 - 1)];
//            BLEDeviceReuqestObserver.maps[data[1...1]]?.forEach({ (item:BLEDeviceReuqestObserverDelegate?) in
//                item?.didReceiveDeviceRequest(data: result, type: type!)
//            })
//
//            delegate?.didReceiveDeviceRequest(data: result, type: type!)
            
            self .didReceiveDeviceRequest(data: result, cmd: data[1...1], type: type!)
            
            type = nil
            receivedData = nil
            receivedDataLength = 0
        }
        
    }
    
    // For override
    func didReceiveDeviceRequest(data:Data, cmd:Data, type:Data) {
        
    }
}
