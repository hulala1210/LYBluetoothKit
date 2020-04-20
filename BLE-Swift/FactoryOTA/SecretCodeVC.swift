//
//  SecretCodeVC.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/1/7.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit
import AVKit

extension String {

    func sliceInToVersion(from: String, to: String) -> String? {

        return (range(of: from, options: String.CompareOptions.backwards)?.upperBound).flatMap { substringFrom in
            (range(of: to, options: String.CompareOptions.backwards, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

class SecretCodeVC: BaseViewController {
    
    var otaExecuter:FactoryOTAExecuter? = nil
    
    var otaInfoConfig:BmobFactoryOTAInfoModel? = nil
    
    @IBOutlet weak var nextStepButton: UIButton!
    @IBOutlet weak var otaSuitInfoTextView: UITextView!
    @IBOutlet weak var secretCodeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "选择升级套装"
        nextStepButton.isHidden = true
        nextStepButton.layer.borderWidth = 1
        nextStepButton.layer.cornerRadius = 8
        nextStepButton.clipsToBounds = true
        nextStepButton.layer.borderColor = nextStepButton.tintColor.cgColor
        
        // Do any additional setup after loading the view.
        self.setNavRightButton(text: "手动校验", sel: #selector(navRightButtonAction))
//        secretCodeTextField.text = "SlimTesH"

    }
    
    @objc func navRightButtonAction() {
        queryOTAInfo()
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
//        let otaInfoConfig = results![0]
        
        if (otaInfoConfig == nil) {
            return
        }
        
        self.startLoading(nil)
        let ftpPath = otaInfoConfig!.fileFTPPath
        let localPath = StorageUtils.getTempPath().stringByAppending(pathComponent: ftpPath!.lastPathComponent)
        
//        let ftpHelper = FTPHelper.shared
        
        let suffix1 = ".zip"
        let suffix2 = ".ZIP"
        let suffix3 = ".RAR"
        let suffix4 = ".rar"
        if (ftpPath!.hasSuffix(suffix1) ||
            ftpPath!.hasSuffix(suffix2) ||
            ftpPath!.hasSuffix(suffix3) ||
            ftpPath!.hasSuffix(suffix4) ) {
            
            self.downloadAction(localPath: localPath, ftpPath: ftpPath, progress: { (pro) in
                print(pro.fractionCompleted)
                self.showProgress(progress: Float(pro.fractionCompleted), status: "正在下载固件" + pro.localizedDescription);
            }) { (success, error) in
                self.stopLoading()
                if success {
                    self.unZipAction(localPath: localPath, ftpPath: ftpPath, progress: { (unZipProgress) in
                        self.showProgress(progress: Float(unZipProgress.fractionCompleted), status: "正在解压固件" + unZipProgress.localizedDescription);

                    }) { (unzipSuccess, unzipErr) in
                        self.stopLoading()
                        if unzipSuccess {
                            
                        }
                        else {
                            self.showError(unzipErr?.localizedDescription)
                        }
                    }
                }
                else {
                    
                    self.showError(self.ftpErrorReport(error: error!))
                    
                }
            }
        }
        else {
            self.stopLoading()
            self.alert(msg: "该路径不符合规范，请联系余美来" ,confirmText:"知道了", confirmSel: nil, cancelText: nil, cancelSel: nil)
        }
        
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        
        nextStepButton.isHidden = true
        otaSuitInfoTextView.text = nil
        otaInfoConfig = nil
        if sender.text?.count == 8 {
            queryOTAInfo()
        }
        
    }
    
    @IBAction func helpButtonAction(_ sender: UIButton) {
        
//        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//        CGFloat currentVol = audioSession.outputVolume;
//        let audioSession = AVAudioSession.sharedInstance()
//        let currentVol = audioSession.outputVolume
        
        self.alert(msg: "请确保手机侧面的静音拨片处于“非静音”状态，并且开启了铃声音量",confirmText:"知道了", confirmSel: #selector(avPlayerPush), cancelText: nil, cancelSel: nil)
        
    }
    
    @objc private func avPlayerPush() {
        let playerVC = AVPlayerViewController()
        let avURL = URL.init(fileURLWithPath: Bundle.main.path(forResource: "course", ofType: "mov")!)
        let player = AVPlayer.init(url: avURL)
        playerVC.player = player
        playerVC.showsPlaybackControls = true
        
        navigationController?.pushViewController(playerVC, animated: true)
        if (playerVC.isReadyForDisplay) {
            playerVC.player?.play();
        }
    }
    
    private func pushIntoAutoOTAVC(firmwaresDirectory:String!) {
        let otaVC = ZdOtaDisplayVC()
        let config = self.createConfig(otaInfoModel: self.otaInfoConfig!, firmwaresPath: firmwaresDirectory)
        otaVC.config = config
        self.navigationController?.pushViewController(otaVC, animated: true)
    }
    
    private func unSubZipActionIfNeeded(localDirectory:String, destinationDirectory:String!, progress:UnzipFileProgress?, completion:UnzipFileCompletion?) -> Bool {
        var needed:Bool = false
        
        let files = StorageUtils.getFiles(atDirectory: localDirectory)
        if files != nil {
            for file in files! {
                
                let filePath = localDirectory.stringByAppending(pathComponent: file)
                
                if file.hasSuffix(".zip") || file.hasSuffix(".rar") {
                    let unzipUtil:UnzipFileUtils = UnzipFileUtils.init()
                    unzipUtil.asyncUnzipFile(zipFilePath: filePath, destinationDir: localDirectory, progress: progress) { (succcess, error) in
                        
                        if succcess {
                            _ = StorageUtils.moveItem(fromPath: localDirectory, toPath: destinationDirectory)
                            self.pushIntoAutoOTAVC(firmwaresDirectory: destinationDirectory)
                        }
                        
                        if completion != nil {
                            completion!(succcess ,error)
                        }
                        
                    }

                    needed = true
                    break
                }
                else {
                    
                }
            }
        }
        
        return needed
    }
    
    private func unZipAction(localPath:String, ftpPath:String!, progress:UnzipFileProgress?, completion:UnzipFileCompletion?) {
            self.stopLoading()
            let fileName = ftpPath!.lastPathComponent
                                            
            let zipFileTempPath = localPath
            let unzipDestinationDir = StorageUtils.getTempPath().stringByAppending(pathComponent: "otaUnZipFilePath")
            let destinationDirectory = StorageUtils.getCahcePath().stringByAppending(pathComponent: "otaFW")

            _ = StorageUtils.deleteFile(atPath: unzipDestinationDir)
            _ = StorageUtils.deleteFile(atPath: destinationDirectory)

            let suffix1 = ".zip"
            let suffix2 = ".ZIP"
            let suffix3 = ".RAR"
            let suffix4 = ".rar"
            
            if (zipFileTempPath.hasSuffix(suffix1) ||
                zipFileTempPath.hasSuffix(suffix2) ||
                zipFileTempPath.hasSuffix(suffix3) ||
                zipFileTempPath.hasSuffix(suffix4) ) {
                
                let unzipUtil:UnzipFileUtils = UnzipFileUtils.init()
                unzipUtil.asyncUnzipFile(zipFilePath: zipFileTempPath, destinationDir: unzipDestinationDir, progress: progress) { (unZipSuccess, unZipError) in
                    if unZipSuccess {
                        self.stopLoading()
                        
                        let endIndex =  fileName.index(fileName.startIndex, offsetBy: (fileName.count - 4))
                        let unZipComponent = String(fileName[..<endIndex])
                        
                        let fwUpdatingDir = unzipDestinationDir.stringByAppending(pathComponent: unZipComponent).stringByAppending(pathComponent: "Update")
                        
                        if !StorageUtils.isFileExits(atPath: fwUpdatingDir) {
                            self.alert(msg: "检测到固件压缩包内文件结构不符合规范，无法进行后面的步骤，请联系发版人员规范发版文件结构。",confirmText:"知道了", confirmSel: nil, cancelText: nil, cancelSel: nil)
                            return
                        }
                        
                        let needUnzipSubFile = self.unSubZipActionIfNeeded(localDirectory: fwUpdatingDir, destinationDirectory: destinationDirectory, progress: progress, completion: completion)
                        
                        if needUnzipSubFile {
                            
                        }
                        else {
                            _ = StorageUtils.moveItem(fromPath: fwUpdatingDir, toPath: destinationDirectory)
                            self.pushIntoAutoOTAVC(firmwaresDirectory: destinationDirectory)

                        }
                        
                        if completion != nil {
                            completion!(unZipSuccess, nil)
                        }

                    }
                    else {
                        self.showTip("解压错误");
                    }
                }
            }
            // 如果不是压缩包，而是一个文件夹，则需要遍历这个文件夹下的Update这个子文件夹下的所有文件，这些文件都是固件包，然后下载
            else {
                let fwUpdatingDir = zipFileTempPath.stringByAppending(pathComponent: "Update")
                StorageUtils.moveItem(fromPath: fwUpdatingDir, toPath: destinationDirectory)
                print("移动完成")
                
                let otaVC = ZdOtaDisplayVC()
                let config = self.createConfig(otaInfoModel: self.otaInfoConfig!, firmwaresPath: destinationDirectory)
                otaVC.config = config
                self.navigationController?.pushViewController(otaVC, animated: true)

            }
    }
    
    private func downloadAction(localPath:String, ftpPath:String!
        , progress:FTPProgressCallBack?, callback:FTPDownloadCallBack?) {
        let ftpHelper = FTPHelper.shared

        ftpHelper.asynDownloadFile(localPath: localPath, ftpPath: ftpPath!, progress: progress, callback: callback)
    }
    
    private func queryOTAInfo() {
        // 查找
        self.startLoading("正在校验")
        secretCodeTextField.resignFirstResponder()
        self.nextStepButton.isHidden = true
        BmobFactoryOTAHelper.queryOTAConfig(secretCode: secretCodeTextField.text!) { (results:Array<BmobFactoryOTAInfoModel>?, error:Error?) in
            
            self.stopLoading()
            
            if error != nil {
                self.showError(error?.localizedDescription)
                return
            }
            
            if (results != nil) {
                if results!.count == 1 {
                    // 正常
    //                        let ftpPath = "ftp://172.16.0.5/研发专用/3.3plus/P03A/Testing/APP/2019/1.0.6(23)/P03A_AT1.0.6(23).txt"
                    
                    self.otaInfoConfig = results![0]
                    
                    let errorMessage = self.checkConfigError(config: self.otaInfoConfig)
                    if errorMessage == nil {
                        self.nextStepButton.isHidden = false
                        let suitInfoString = "客户名:\(self.otaInfoConfig!.customerName!) \n产品名:\(self.otaInfoConfig!.productName!) \n序号:\(self.otaInfoConfig!.otaSerialNumber!) \n固件版本:\(self.otaInfoConfig!.firmwareVersion ?? "未填写")"
                        self.otaSuitInfoTextView.text = suitInfoString
                    }
                    else {
                        self.alert(msg: errorMessage!, confirmText:"知道了", confirmSel: nil, cancelText: nil, cancelSel: nil)
                    }
                    
                    
                }
                else if results!.count > 1 {
                    // 有多个结果
    //                        self.showTip("查出了多个结果，不知道选择哪一个。请联系配置员确认信息。")
                    self.alert(msg: "查出了多个结果，不知道选择哪一个。请联系配置员确认信息。",confirmText:"知道了", confirmSel: nil, cancelText: nil, cancelSel: nil)
                }
                else if results!.count == 0 {
                    // 没找到结果
                    self.alert(msg: "没有找到升级任务。",confirmText:"知道了", confirmSel: nil, cancelText: nil, cancelSel: nil)
                }
            }
            else {
                self.alert(msg: "没有找到升级任务。",confirmText:"知道了", confirmSel: nil, cancelText: nil, cancelSel: nil)

            }
        }
    }
    
    private func checkConfigError(config: BmobFactoryOTAInfoModel!) -> String? {
        
        var errorMessage:String? = ""
        
        if config.firmwareVersion == nil || config.firmwareVersion!.count == 0 {
            errorMessage = errorMessage! + "请检查配置“版本信息(firmwareVersion)”" + "\n"
        }
        if config.needReset == nil {
            errorMessage = errorMessage! +  "请检查配置“是否需要重置(needReset)”" + "\n"
        }
        
        if config.otaName == nil || config.otaName!.count == 0 {
            if (config.otaNamePrefix == nil || config.otaNamePrefix!.count == 0) {
                errorMessage = errorMessage! +  "请检查配置“ota前缀(otaNamePrefix)”" + "\n"
            }
        }
        
        if config.bleNamePrefix == nil || config.bleNamePrefix!.count == 0 {
            errorMessage = errorMessage! +  "请检查配置“蓝牙名前缀(bleNamePrefix)”" + "\n"
        }
        if config.secretCode == nil || config.secretCode!.count < 6 {
            errorMessage = errorMessage! +  "请检查配置“口令(secretCode)”" + "\n"
        }
        if config.fileFTPPath == nil || config.fileFTPPath!.count == 0 {
            errorMessage = errorMessage! +  "请检查配置“固件FTP路径(fileFTPPath)”" + "\n"
        }
        if config.otaSerialNumber == nil {
            errorMessage = errorMessage! +  "请检查配置“顺序号(otaSerialNumber)”" + "\n"
        }
        if config.customerName == nil || config.customerName!.count == 0 {
            errorMessage = errorMessage! +  "请检查配置“客户名(customName)”" + "\n"
        }
        if config.productName == nil || config.productName!.count == 0 {
            errorMessage = errorMessage! +  "请检查配置“产品名(productName)”" + "\n"
        }
        if config.platform == nil || config.platform!.count == 0 {
            errorMessage = errorMessage! +  "请检查配置“平台(platform)”" + "\n"
        }
        
        if errorMessage?.count == 0 {
            return nil
        }
        return errorMessage
    }
    
    private func createConfig(otaInfoModel:BmobFactoryOTAInfoModel, firmwaresPath:String!) -> OtaConfig {
        
        var config = OtaConfig()
        config.deviceNamePrefix = otaInfoModel.bleNamePrefix!
        
        config.otaBleName = otaInfoModel.otaName
        
        if otaInfoModel.otaNamePrefix != nil {
            config.prefix = otaInfoModel.otaNamePrefix!
        }
        
        config.blePrefixAfterOTA = otaInfoModel.blePrefixAfterOTA
        
        config.needReset = otaInfoModel.needReset!
        
        config.targetDeviceType = otaInfoModel.deviceType
        
        if (otaInfoModel.platform!.lowercased().hasPrefix("apollo")) {
            config.platform = .apollo
        }
        else if (otaInfoModel.platform!.lowercased().hasPrefix("nordic")) {
            config.platform = .nordic
        }
        else if (otaInfoModel.platform!.lowercased().hasPrefix("tlsr")) {
            config.platform = .tlsr
        }
        
        config.signalMin = Int(-70)
        config.upgradeCountMax = Int(2)
        
        let manager = FileManager.default
        let directoryEnumerator = manager.enumerator(atPath: firmwaresPath)
        let allFirmwares:Array<Any> = directoryEnumerator!.allObjects
        
        var picPathArr = Array< Firmware>.init()
        var touchPathArr = Array<Firmware>.init()
        var platformPathArr = Array<Firmware>.init()
        var otherPathArr = Array<Firmware>.init()

        for (index,fileName) in allFirmwares.enumerated() {
            
            if fileName is String {
                let firmwareName = String(fileName as! String)
                
                if (!firmwareName.hasSuffix(".dat")) && (!firmwareName.hasSuffix(".bin")) {
                    continue
                }
                
                let pathString = firmwaresPath.stringByAppending(pathComponent: fileName as! String)

                let fw = Firmware.init()
                                
                fw.id = index
                
                var suffixLength = 0
                if pathString.hasPrefix(StorageUtils.getCahcePath()) {
                    fw.baseURLPathType = .Cache
                    suffixLength = pathString.count - StorageUtils.getCahcePath().count
                }
                else if pathString.hasPrefix(StorageUtils.getTempPath()) {
                    fw.baseURLPathType = .Tmp
                    suffixLength = pathString.count - StorageUtils.getTempPath().count
                }
                else if pathString.hasPrefix(StorageUtils.getDocPath()) {
                    fw.baseURLPathType = .Doc
                    suffixLength = pathString.count - StorageUtils.getDocPath().count
                }
                else {
                    fw.baseURLPathType = .Cache
                    suffixLength = pathString.count - StorageUtils.getCahcePath().count
                }
                
                let relativePath = pathString.suffix(suffixLength)
                
                fw.relativeURLPath = String(relativePath)
                let type = Firmware.getOtaType(withFileName: firmwareName)
                fw.type = type
                
                if fw.type == OtaDataType.picture {
                    let versionCodeStr = firmwareName.sliceInToVersion(from: "_", to: ".")
                    
                    if versionCodeStr != nil && versionCodeStr!.count > 0 {
                        let versionCode = Double(versionCodeStr!)
                        
                        if versionCode != nil {
                            fw.versionCode = versionCode!
                        }
                        else {
                            fw.versionCode = Double(MAXFLOAT)
                        }
                    }
                    else {
                        fw.versionCode = Double(MAXFLOAT)
                    }
                    
                }
                
                switch type {
                case .platform:
                    platformPathArr.append(fw)
                case .picture:
                    picPathArr.append(fw)
                case .touchPanel:
                    touchPathArr.append(fw)
                default:
                    otherPathArr.append(fw)
                }
                
            }
        }
        
        // 因为字库是增量升级的，所以顺序一定要正确，按照版本号从小到大排列
        picPathArr.sort { (fw1, fw2) -> Bool in
            if fw1.versionCode > fw2.versionCode {
                return false
            }
            else {
                return true
            }
        }
        
        config.firmwares = config.firmwares + picPathArr + touchPathArr + otherPathArr + platformPathArr 
        
        return config
    }
    
    private func ftpErrorReport(error:NSError?) -> String {
        
        if error == nil {
            return ""
        }
        
        switch error!.code {
        case 54:
            return "Connect failed (Maybe network is unavailable).";
        default:
            return error!.localizedDescription
        }
        
//        switch (error.code) {
//            case 110:
//                return "Restart marker reply. In this case, the text is exact and not left to the particular implementation; it must read: MARK yyyy = mmmm where yyyy is User-process data stream marker, and mmmm server's equivalent marker (note the spaces between markers and \"=\").";
//
//            case 120:
//                return "Service ready in nnn minutes.";
//
//            case 125:
//                return "Data connection already open; transfer starting.";
////                  return "数据连接已经打开; 传输开始.";
//
//            case 150:
//                return "File status okay; about to open data connection.";
////                return "文件状态OK; 即将打开数据连接.";
//
//            case 200:
//                return "Command okay.";
////                return "指令OK.";
//
//            case 202:
//                return "Command not implemented, superfluous at this site.";
////                return "命令未被执行，此站点不支持此命令。";
//
//            case 211:
//                return "System status, or system help reply.";
////                return "系统状态，或者系统帮助响应。 "
//
//            case 212:
//                return "Directory status.";
////                return "目录状态。";
//
//            case 213:
//                return "File status.";
////                return "文件状态";
//
//            case 214:
//                return "Help message.On how to use the server or the meaning of a particular non-standard command. This reply is useful only to the human user.";
////                return "帮助信息。如何使用服务器或特殊的非标准命令的意思。这个回应只对人类用户有用。";
//
//            case 215:
//                return "NAME system type. Where NAME is an official system name from the list in the Assigned Numbers document.";
////                return "系统类型名称。名称是一个官方的系统名称从分配的数字文档的列表中。";
//
//            case 220:
//                return "Service ready for new user.";
////                return "已经为新用户准备好服务";
//
//            case 221:
//                return "Service closing control connection.";
////                return "服务关闭控制连接。";
//
//            case 225:
//                return "Data connection open; no transfer in progress.";
////                return "数据连接打开，当前没有传输数据.";
//
//            case 226:
//                return "Closing data connection. Requested file action successful (for example, file transfer or file abort).";
////                return "关闭数据连接. 文件请求成功 (例如文件传输或者文件取消传输).";
//
//            case 227:
//                return "Entering Passive Mode.";
////                return "进入被动模式。";
//
//            case 230:
//                return "User logged in, proceed. Logged out if appropriate.";
////                return "用户登录,继续。记录是否合适。";
//
//            case 250:
//                return "Requested file action okay, completed.";
//            case 257:
//                return "\"PATHNAME\" created.";
//            case 331:
//                return "User name okay, need password.";
//            case 332:
//                return "Need account for login.";
//            case 350:
//                return "Requested file action pending further information.";
//            case 421:
//                return "Service not available, closing control connection.This may be a reply to any command if the service knows it must shut down.";
//            case 425:
//                return "Can't open data connection.";
//            case 426:
//                return "Connection closed; transfer aborted.";
//            case 450:
//                return "Requested file action not taken.";
//            case 451:
//                return "Requested action aborted. Local error in processing.";
//            case 452:
//                return "Requested action not taken. Insufficient storage space in system.File unavailable (e.g., file busy).";
//            case 500:
//                return "Syntax error, command unrecognized. This may include errors such as command line too long.";
//            case 501:
//                return "Syntax error in parameters or arguments.";
//            case 502:
//                return "Command not implemented.";
//            case 503:
//                return "Bad sequence of commands.";
//            case 504:
//                return "Command not implemented for that parameter.";
//            case 530:
//                return "Not logged in.";
//            case 532:
//                return "Need account for storing files.";
//            case 550:
//                return "Requested action not taken. File unavailable (e.g., file not found, no access).";
//            case 551:
//                return "Requested action aborted. Page type unknown.";
//            case 552:
//                return "Requested file action aborted. Exceeded storage allocation (for current directory or dataset).";
//            case 553:
//                return "Requested action not taken. File name not allowed.";
//            case 54:
//                return "Connect failed (Maybe network is unavailable).";
//            default:
//                return "Unknown";
//        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
