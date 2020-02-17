//
//  UnzipFileUtils.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/1/11.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

public typealias UnzipFileProgress = (Progress) -> ()
public typealias UnzipFileCompletion = (Bool, NSError?) -> ()

class UnzipFileUtils: NSObject {
//    let shared = UnzipFileUtils.init()
    
    var progress:Progress? = nil
    
    var isUnziping = false
    
    override init() {
        super.init()
    }
    
    public func asyncUnzipFile(zipFilePath:String!, destinationDir:String!, progress:UnzipFileProgress?, completion:UnzipFileCompletion?) {
        
        if isUnziping {
            
            DispatchQueue.main.async {
                if completion != nil {
                    completion!(false, nil)
                }
            }
            
            return
        }
        
        isUnziping = true
        
        DispatchQueue.global().async {
            if zipFilePath.hasSuffix(".zip") {
                self.syncUnzipZIPFile(zipFilePath: zipFilePath, destinationDir: destinationDir, progress: { (pro) in
                    DispatchQueue.main.async {
                        if progress != nil {
                            progress!(pro)
                        }
                    }
                }) { (success, error) in
                    self.isUnziping = false

                    DispatchQueue.main.async {
                        if completion != nil {
                            completion!(success, error)
                        }
                    }
                }
            }
            else if zipFilePath.hasSuffix(".rar") {
                self.syncUnzipRARFile(rarFilePath: zipFilePath, destinationDir: destinationDir, progress: { (pro) in
                    DispatchQueue.main.async {
                        if progress != nil {
                            progress!(pro)
                        }
                    }
                }) { (success, error) in
                    self.isUnziping = false

                    DispatchQueue.main.async {
                        if completion != nil {
                            completion!(success, error)
                        }
                    }
                }
            }
        }
    }
    
    private func syncUnzipZIPFile(zipFilePath:String!, destinationDir:String!, progress:UnzipFileProgress?, completion:UnzipFileCompletion?) {
        
        SSZipArchive.unzipFile(atPath: zipFilePath, toDestination: destinationDir, progressHandler: { (entry, zipInfo, entryNumber, total) in
            
            if (self.progress == nil) {
                self.progress = Progress.init(totalUnitCount: Int64(total))
            }
            
            self.progress?.completedUnitCount = Int64(entryNumber)
            
            if progress != nil {
                progress!(self.progress!)
            }
            
        }) { (path, success, error) in
            
            if completion != nil {
                completion!(success, error as NSError?)
            }
        }
    }
    
    private func syncUnzipRARFile(rarFilePath:String!, destinationDir:String!, progress:UnzipFileProgress?, completion:UnzipFileCompletion?) {
        
        var error:NSError? = nil

        var archive:URKArchive? = nil;
        do {
            archive = try URKArchive.init(path: rarFilePath)
            
        } catch let err as NSError {
            error = err
            print(err)
        }
        
        if (error != nil) {
            if (completion != nil) {
                completion!(false, error!)
            }
            return;
        }
        
        let pro = Progress.init(totalUnitCount: 1)
        self.progress = pro
        archive?.progress = pro
        
        pro.addObserverBlock(forKeyPath: "localizedDescription") { (obj, oldValue, newValue) in
            if (progress != nil) {
                progress!(pro)
            }
        }
        
        var success:Bool = true
        do {
            success = ((try archive?.extractFiles(to: destinationDir, overwrite: true)) != nil)
        } catch let err as NSError {
            print(err)
            error = err;
        }
        
        if (completion != nil) {
            if (error != nil) {
                completion!(false, error!)
            }
            else {
                completion!(true, nil)
            }
        }
        
    }
}
