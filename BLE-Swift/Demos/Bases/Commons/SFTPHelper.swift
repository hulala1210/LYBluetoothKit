//
//  SFTPHelper.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/1/7.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

public typealias ConnectCallBack = (Bool, Error?)->()
public typealias DownloadCallBack = (Bool, Error?)->()
public typealias ProgressCallBack = (Progress)->()

class SFTPHelper: NSObject, NMSSHSessionDelegate {
    static let shared = SFTPHelper()
    
//    private let session = NMSSHSession.init(host: "ftp://172.16.0.5/", andUsername: "chenyanlin")

    private let session = NMSSHSession.connect(toHost: "ftp://172.16.0.5/", withUsername: "chenyanlin")

    var isConnecting = false
    
    var connectCallbacks = Array<ConnectCallBack>()
    
    override init() {
        super.init()
        session.delegate = self
    }
    
    public func asynDownloadFile(localPath:String, sftpPath:String, progress:ProgressCallBack?, callback:DownloadCallBack?) -> Void {
        
        DispatchQueue.global().async {
            if self.sftpIsConnected() {
                let file:NMSFTPFile? = self.session.sftp.infoForFile(atPath: sftpPath)
                if (file == nil) {
                    if (callback != nil) {
                        callback!(false, nil);
                    }
                    return
                }
                else {
                    let success = self.syncDownloadFile(localPath: localPath, sftpPath: sftpPath) { (pro) in
                        DispatchQueue.main.async {
                            if progress != nil {
                                progress!(pro)
                            }
                            
                        }
                    }
                    
                    if (callback != nil) {
                        callback!(success, nil)
                    }
                    
                }
            }
            else {
                self.syncConnect { (connectSuccess, error) in
                    if connectSuccess {
                        let success = self.syncDownloadFile(localPath: localPath, sftpPath: sftpPath) { (pro) in
                            DispatchQueue.main.async {
                                if progress != nil {
                                    progress!(pro)
                                }
                            }
                        }
                        
                        if (callback != nil) {
                            callback!(success, nil)
                        }
                    }
                    else {
                        if (callback != nil) {
                            callback!(connectSuccess, nil)
                        }
                    }
                }
            }
        }
        
        
    }
    
    private func sftpIsConnected() -> Bool {
        if (!session.sftp.isConnected) {
            return false;
        }
        return true;
    }
    
    private func syncConnect(callBack:ConnectCallBack?) -> Void {
        
        if (callBack != nil) {
            connectCallbacks.append(callBack!)
        }
        
        var success = false
        if sftpIsConnected() == false {
            
            if isConnecting {
                return
            }
            
            isConnecting = true
            
//            let connectSuccess = self.session.connect()
//            let session1 = NMSSHSession.connect(toHost: "172.16.0.5:21", withUsername: "chenyanlin")
            let session1 = NMSSHSession.connect(toHost: "172.16.0.5:21", port: 21, withUsername: "chenyanlin")

            let connectSuccess = session1.isConnected
            
            if connectSuccess {
                let authenticateSuccess = self.session.authenticate(byPassword: "cyl551")
                success = authenticateSuccess
            }
            else {
                success = connectSuccess
            }
        }
        else {
            success = true
        }
        
        if success {
            for cb:ConnectCallBack in self.connectCallbacks {
                cb(true, nil)
            }
            
        }
        else {
            for cb:ConnectCallBack in self.connectCallbacks {
                cb(false, nil)
            }
        }
        
        self.connectCallbacks.removeAll()
        isConnecting = false
    }
    
    private func syncDownloadFile(localPath:String, sftpPath:String, progressCallback:ProgressCallBack?) -> Bool {
        let stream:OutputStream = OutputStream.init(toFileAtPath: localPath, append: true)!
        var pro:Progress? = nil
        let success = session.sftp.contents(atPath: sftpPath, to: stream) { (received, total) -> Bool in
            if pro == nil {
                pro = Progress.init(totalUnitCount: Int64(total))
            }
            pro!.completedUnitCount = Int64(received)
            
            if progressCallback != nil {
                progressCallback!(pro!)
            }
            return true
        }
        
        return success
        
    }
    
    // MARK: - NMSSHSessionDelegate
    func session(_ session: NMSSHSession, keyboardInteractiveRequest request: String) -> String {
        return ""
    }
    
    func session(_ session: NMSSHSession, didDisconnectWithError error: Error) {
        print("error = \(error)")
    }
    
    func session(_ session: NMSSHSession, shouldConnectToHostWithFingerprint fingerprint: String) -> Bool {
        return true
    }
}
