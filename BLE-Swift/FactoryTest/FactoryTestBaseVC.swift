//
//  FactoryTestBaseVC.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/2/18.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit
import PopupDialog

class FactoryTestBaseVC: BaseViewController {

    
    var testCases:Array<FactoryTestCase> = []
    var testConfig:FactoryTestConfig? = nil

    @objc let queue = TestOpQueue.init()
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    deinit {
        print("没有循环引用")
        queue.cancelAllOperations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        queue.maxConcurrentOperationCount = 1
        
        weak var weakSelf = self
        self.addObserverBlock(forKeyPath: "queue.message") { (obj, oldValue, newValue) in
            DispatchQueue.main.async {
                weakSelf!.textView.text = (newValue as! String)
            }
        }
        
        createConnectCase()
        createTestCase(cases: testCases)
    }
    
    @objc func navRightSelector() {
        showResultAlert(device: queue.device!)
    }
    
    @objc func settingButtonAction() {
        
    }
    
    func createConnectCase() -> Void {
        weak var weakSelf = self

        let failureBlock:TestOpFailedBlock = {(error) in
            
            if error != nil {
                weakSelf!.queue.message = "\n" + weakSelf!.queue.message + error!.localizedDescription
            }
            
            weakSelf!.queue.cancelAllOperations()
        }
        
        let searchTask = BLESearchOp.init()
        searchTask.bleNamePrefix = testConfig!.bleNamePrefix
        let connectTask = BLEConnectOp.init()

        searchTask.failedBlock = failureBlock
        connectTask.failedBlock = failureBlock

        queue.addOperation(searchTask)
        queue.addOperation(connectTask)
    }
    
    func createTestCase(cases:Array<FactoryTestCase>) -> Void {

        weak var weakSelf = self

        for cs in cases {
            let type = FactoryTestCaseType(rawValue: cs.serialNumber)!
            let op = createOperation(testType: type)
            
            if op != nil {
                queue.addOperation(op!)
            }
        }
        
        queue.addOperation {
            DispatchQueue.main.async {
                weakSelf!.showResultAlert(device: weakSelf!.queue.device!)
                weakSelf!.setNavRightButton(text: "显示结果", sel: #selector(weakSelf!.navRightSelector))
            }
        }
        
    }
        
    private func showSettingAlert() {
        
    }
    
    public func showResultAlert(device:BLEDevice) {
        
        weak var weakSelf = self
        // Prepare the popup assets
        var title = ""
        
        if queue.badMessage.count > 0 {
            title = "NG"
        }
        else {
            title = "Success"
        }
        
        let message = queue.badMessage
//        let image = UIImage(named: "pexels-photo-103290")

        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: queue.image)

        // Create buttons
        let buttonOne = CancelButton(title: "恢复出厂设置") {
            print("You canceled the car dialog.")
            let _ = BLECenter.shared.resetDevice(boolCallback: { (success, error) in
                
                if success == false {
                    if error != nil {
                        weakSelf!.showError(error!.localizedDescription)
                    }
                    else {
                        weakSelf!.showError("设备重置失败")
                    }
                }
                else {
                    weakSelf!.showSuccess("设备重置成功")
                    
                    BLECenter.shared.disconnect(device: weakSelf!.queue.device!, callback: { (dev, error) in
                        weakSelf!.navigationController?.popViewController(animated: true)
                    })

                }
                
            }, toDeviceName: device.name)
        }

        // This button will not the dismiss the dialog
        let buttonTwo = DefaultButton(title: "确认并返回") {
//            print("What a beauty!")
            BLECenter.shared.disconnect(device: self.queue.device!, callback: { (dev, error) in
                weakSelf!.navigationController?.popViewController(animated: true)
            })
        }

        let buttonThree = DefaultButton(title: "返回查看日志") {
            
        }

        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonOne, buttonTwo, buttonThree])

        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    private func createOperation(testType:FactoryTestCaseType) -> BaseOperation? {
        weak var weakSelf = self

        let failureBlock:TestOpFailedBlock = {(error) in
            
            if error != nil {
                weakSelf!.queue.message = "\n" + weakSelf!.queue.message + error!.localizedDescription
            }
            
            weakSelf!.queue.cancelAllOperations()
        }
        
        switch testType {
            case FactoryTestCaseType.firmware:
        
                let versionTask = BLEVersionTestOp.init()
                versionTask.failedBlock = failureBlock
                return versionTask
        
            case FactoryTestCaseType.hardware:
        
                let hardVersionTask = BLEHardVersionTestOp.init()
                hardVersionTask.failedBlock = failureBlock
                return hardVersionTask
        
            case FactoryTestCaseType.deviceNum:
        
                let deviceNumTask = BLEDeviceNumTestOp.init()
                deviceNumTask.failedBlock = failureBlock
                return deviceNumTask
        
            case FactoryTestCaseType.gesensor:
        
                let gesensorTask = BLEGesensorTestOp.init()
                gesensorTask.failedBlock = failureBlock
                return gesensorTask
        
            case FactoryTestCaseType.motor:
        
                let motorTask = BLEMotorTestOp.init()
                motorTask.failedBlock = failureBlock
                return motorTask
        
            case FactoryTestCaseType.flash:
        
                let flashTask = BLEFlashTestOp.init()
                flashTask.failedBlock = failureBlock
                return flashTask
        
            case FactoryTestCaseType.heartRate:
        
                let heartRateTask = BLEHeartRateTestOp.init()
                heartRateTask.failedBlock = failureBlock
                return heartRateTask
        
            case FactoryTestCaseType.bleName:
        
                let bleNameTask = BLENameTestOp.init()
                bleNameTask.failedBlock = failureBlock
                return bleNameTask
            
            case FactoryTestCaseType.buzzer:
            
                let buzzerTask = BLEBuzzerTestOp.init()
                buzzerTask.failedBlock = failureBlock
                return buzzerTask
            
            case FactoryTestCaseType.minutePointerAntiClockwise:
            
                let minuteAntiTask = BLEAntiMinuteRotationOp.init()
                minuteAntiTask.failedBlock = failureBlock
                return minuteAntiTask
            
            case FactoryTestCaseType.minutePointerClockwise:
            
                let minuteTask = BLEMinuteRotationOp.init()
                minuteTask.failedBlock = failureBlock
                return minuteTask
            
            case FactoryTestCaseType.hourPointerAntiClockwise:
            
                let hourAntiTask = BLEAntiHourRotationOp.init()
                hourAntiTask.failedBlock = failureBlock
                return hourAntiTask
            
            case FactoryTestCaseType.hourPointerClockwise:
            
                let hourTask = BLEHourRotationOp.init()
                hourTask.failedBlock = failureBlock
                return hourTask
            
            case FactoryTestCaseType.resetDevice:
            
                let resetTask = BLEResetDeviceOp.init()
                resetTask.failedBlock = failureBlock
                return resetTask
            
            case FactoryTestCaseType.scanGrave:
            
                let scanGraveTask = BLEScanGraveOp.init()
                scanGraveTask.failedBlock = failureBlock
                return scanGraveTask
        
        }
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
