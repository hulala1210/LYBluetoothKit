//
//  FTPHelper.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/1/9.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

public typealias FTPFindSourceCallBack = (Bool, Any?, NSError?)->()
public typealias FTPDownloadCallBack = (Bool, NSError?)->()
public typealias FTPBulkDownloadCallBack = (_ allSuccess:Bool, _ successFiles:Array<String>, _ failedFiles:Array<String>)->()

public typealias FTPProgressCallBack = (Progress)->()

let FTPHelperErrorDomain = "FTPHelperErrorDomain"

enum FTPHelperErrorCode:Int {
    case serverURLError = -1000
    case localURLError = -1001

}

class FTPHelper {
    
    static let shared = FTPHelper()
    
    private func verifyURL(_ URLString:String) -> Bool {
//        if URLString.contains("\n") || URLString.contains("\r") || URLString.contains("\t") {
//            return false
//        }
//        return true
        
        if URLString.count > 0 {
            return NSPredicate.init(format: "SELF MATCHES %@", "^[Ff][Tt][Pp]://(\\w*(:[=_0-9a-zA-Z\\$\\(\\)\\*\\+\\-\\.\\[\\]\\?\\\\\\^\\{\\}\\|`~!#%&\'\",<>/]*)?@)?([0-9a-zA-Z\\-\\.]+\\.)+[0-9a-zA-Z\\.]+(:(6553[0-5]|655[0-2]\\d|654\\d\\d|64\\d\\d\\d|[0-5]?\\d?\\d?\\d?\\d))?(/?|((/[=_0-9a-zA-Z\\-%\\.]+)+(/|\\.[_0-9a-zA-Z\\.]+)?))$").evaluate(with: URLString)
        }
        
        return false
    }
    
    public func asynBulkDownloadFiles(localDirectory:String, ftpPaths:Array<String>, progress:FTPProgressCallBack?, callback:FTPBulkDownloadCallBack?) -> Void {
        let group = DispatchGroup.init()
        
        // 保证最大并发量
        let semaphore = DispatchSemaphore.init(value: 2)
        
        for _ in ftpPaths {
            group.enter()
        }
        
        let totalProgress:Progress = Progress.init(totalUnitCount: Int64(ftpPaths.count))

        var successArr:Array<String> = []
        var failedArr:Array<String> = []

        DispatchQueue.global().async {
            for path in ftpPaths {
                semaphore.wait()
                
                let lastComponent = path.lastPathComponent
                let localFilePath = localDirectory.stringByAppending(pathComponent: lastComponent)
                
                self.asynDownloadFile(localPath: localFilePath, ftpPath: path, progress: { (singleProgress) in
                                        
                }) { (success, error) in
                    
                    totalProgress.completedUnitCount = totalProgress.completedUnitCount + 1
                    
                    if success {
                        successArr.append(path)
                    }
                    else {
                        failedArr.append(path)
                    }
                    
                    group.leave()
                }
                
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            
            var allSuccess:Bool = false
            
            if successArr.count > 0 && failedArr.count == 0 {
                allSuccess = true
            }
            
            if callback != nil {
                callback!(allSuccess, successArr, failedArr)
            }
        }
        
    }
    
    public func asynDownloadFile(localPath:String, ftpPath:String, progress:FTPProgressCallBack?, callback:FTPDownloadCallBack?) -> Void {
        
        
        let request = LxFTPRequest.download()
        
        if verifyURL(ftpPath) == false {
            if callback != nil {
                let error = NSError.init(domain: FTPHelperErrorDomain, code: FTPHelperErrorCode.serverURLError.rawValue, userInfo: [NSLocalizedDescriptionKey:"服务端路径配置不合法"])

                callback!(false, error)
            }
            return
        }
        
        let encodeURL:String = GBKEncodingUtil.gbkTransCoding(ftpPath)
        
        let serverURL = URL.init(string: encodeURL)
        // 通过KVC绕过set方法里的验证合法性，直接设置。
        request?.setValue(serverURL, forKey: "_serverURL");
//        request?.serverURL = serverURL
        
        let localeURL = URL.init(fileURLWithPath: localPath)
        
        request?.setValue(localeURL, forKey: "_localFileURL");

//        request?.localFileURL = URL.init(fileURLWithPath: localPath)
        
        
        request?.username = "chenyanlin"
        request?.password = "cyl551"

        let progressBlock = {(total:Int, finish:Int, percent:CGFloat) -> Void in
            if request?.progress == nil {
                request?.progress = Progress.init(totalUnitCount: Int64(total))
            }
            request?.progress!.completedUnitCount = Int64(finish)
            
            if progress != nil {
                progress!(request!.progress!)
            }
        }
        
        request?.progressAction = progressBlock
        
        let successBlock = {(cls:AnyClass?, obj:Any?) -> Void in
            if callback != nil {
                callback!(true, nil)
            }
        }
        
        request?.successAction = successBlock
        
        let failedBlock = {(errorDomain:CFStreamErrorDomain, errorCode:Int, errorDescrption:String?) -> Void in
            if callback != nil {
                let error = NSError.init(domain: "FTPHelper", code: errorCode, userInfo: [NSLocalizedDescriptionKey:errorDescrption ?? ""])
                
                callback!(false, error)
            }
        }
        
        request?.failAction = failedBlock
        
        request?.start()
    }
    
    public func asyncFindSource(ftpPath:String!, progress:FTPProgressCallBack?, callback:FTPFindSourceCallBack?) -> Void {

        if verifyURL(ftpPath) == false {
            if callback != nil {
                let error = NSError.init(domain: FTPHelperErrorDomain, code: FTPHelperErrorCode.serverURLError.rawValue, userInfo: [NSLocalizedDescriptionKey:"服务端路径配置不合法"])
                
                callback!(false, nil, error)
            }
            return
        }
        
        let request = LxFTPRequest.resourceList()
                
        let encodeURL:String = GBKEncodingUtil.gbkTransCoding(ftpPath)

        let ftpURL:URL? = URL.init(string: encodeURL)
        
        // 通过KVC绕过set方法里的验证合法性，直接设置。
        request?.setValue(ftpURL, forKey: "_serverURL");
        
        request?.username = "chenyanlin"
        request?.password = "cyl551"

        let progressBlock = {(total:Int, finish:Int, percent:CGFloat) -> Void in
            if request?.progress == nil {
                request?.progress = Progress.init(totalUnitCount: Int64(total))
            }
            request?.progress!.completedUnitCount = Int64(finish)
            
            if progress != nil {
                progress!(request!.progress!)
            }
        }
        
        request?.progressAction = progressBlock
        
        let successBlock = {(cls:AnyClass?, obj:Any?) -> Void in
            if callback != nil {
                callback!(true, obj, nil)
            }
        }
        
        request?.successAction = successBlock
        
        let failedBlock = {(errorDomain:CFStreamErrorDomain, errorCode:Int, errorDescrption:String?) -> Void in
            if callback != nil {
                let error = NSError.init(domain: FTPHelperErrorDomain, code: errorCode, userInfo: [NSLocalizedDescriptionKey:errorDescrption ?? ""])
                
                callback!(false, nil, error)
            }
        }
        
        request?.failAction = failedBlock
        
        request?.start()
    }
    
}
