//
//  BLECenterSportExtension.swift
//  BLE-Swift
//
//  Created by SuJiang on 2019/3/25.
//  Copyright © 2019 ss. All rights reserved.
//

import Foundation

extension BLECenter {
    //(Array<Data>?, BLEError?)->Void
    public func getSportSleepDataNum(callback:((UInt16, UInt16, BLEError?)->Void)?, toDeviceName deviceName:String? = nil)->BLETask? {
        let data = Data(bytes: [0x6f,0x52,0x70,0x01,0x00,0x00,0x8f])
        return send(data: data, dataArrayCallback: { (datas, err) in
            if let error = err {
                callback?(0, 0, error)
            } else {
                guard let ds = datas, ds.count > 0, ds[0].count >= 4 else {
                    callback?(0, 0, BLEError.taskError(reason: .dataError))
                    return
                }
//                let bytes = ds[0].bytes
//                let sportNum = UInt(bytes[0]) + UInt((bytes[1] << 8))
//                let sleepNum = UInt(bytes[2]) + UInt((bytes[3] << 8))
                let sportNum = ds[0][0...1].uint16
                let sleepNum = ds[0][2...3].uint16

                callback?(sportNum, sleepNum, nil)
            }
        }, toDeviceName: deviceName)
    }
    
    public func getSportDetail(num: UInt16, callback:((Array<Sport>?, BLEError?)->Void)?, toDeviceName deviceName:String? = nil)->BLETask? {
        if num == 0 {
            callback?(nil, BLEError.taskError(reason: .paramsError))
            return nil
        }
        
        let data = Data(bytes: [0x6f,0x54,0x70,0x02,0x00,0x00,0x00,0x8f])
        return send(data: data, recvCount: Int(num), dataArrayCallback: { (datas, err) in
            if let error = err {
                callback?(nil, error)
            } else {
                guard let ds = datas, ds.count > 0, ds[0].count >= 22 else {
                    callback?(nil, BLEError.taskError(reason: .dataError))
                    return
                }
                
                var sports = Array<Sport>()
                for d in ds {
                    if d.count < 22 {
                        callback?(nil, BLEError.taskError(reason: .dataError))
                        return
                    }
                    let bytes = d.bytes
                    
                    let index = d[0...1].uint
                    let time = d[2...5].uint
                    let step = d[6...9].uint
                    let cal = d[10...13].uint
                    let dis = d[14...24].uint
                    let du = d[18...21].uint
                    
                    let sport = Sport(index: index, time: TimeInterval(time), step: step, calorie: cal, distance: dis, duration: du)
                    
                    if d.count >= 24 {
                        let avgHr = UInt(bytes[22])
                        let type = SportType(rawValue: UInt(bytes[23]))
                        sport.avgBpm = avgHr
                        sport.type = type!
                    }
                    
                    sports.append(sport)
                }
            
                callback?(sports, nil)
            }
        }, toDeviceName: deviceName)
    }
    
    public func deleteSportDatas(callback:BoolCallback?, toDeviceName deviceName:String? = nil)->BLETask? {
        let data = Data(bytes: [0x6f,0x53,0x71,0x01,0x00,0x00,0x8F])
        return send(data: data, boolCallback: callback, toDeviceName: deviceName)
    }
    
}
