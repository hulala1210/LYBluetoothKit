//
//  FactoryTestBaseVC.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/2/18.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class FactoryTestBaseVC: BaseViewController {

    var testType:FinishedProductTestCaseType = .unknown
    
    let queue = TestOpQueue.init()
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setNavRightButton(text: "Start Right Now", sel: #selector(navRightSelector))
        
        let settingButton = UIButton(type: .custom)
        settingButton.setTitle("Setting", for: .normal)
        settingButton.setTitleColor(kMainColor, for: .normal)
        let f = font(14)
        let textSize = settingButton.title(for: .normal)!.size(withFont: f)
        settingButton.titleLabel?.font = f
        settingButton.frame = CGRect(x: 0, y: 0, width: textSize.width, height: 44)
        settingButton.addTarget(self, action: #selector(settingButtonAction), for: .touchUpInside)
        let settingNavItem = UIBarButtonItem.init(customView: settingButton)
        self.navigationItem.rightBarButtonItems = [self.navigationItem.rightBarButtonItem!, settingNavItem];
        
        queue.maxConcurrentOperationCount = 1
        createTestCase()
    }
    
    @objc func navRightSelector() {
        
    }
    
    @objc func settingButtonAction() {
        
    }
    
    func createTestCase() -> Void {
        
        let failureBlock:TestOpFailedBlock = {(error) in
            self.queue.cancelAllOperations()
        }
        
        let searchTask = BLESearchOp.init()
        let connectTask = BLEConnectOp.init()
        let hidePairTask = BLEHidePairOp.init()
        let versionTask = BLEVersionTestOp.init()
        let hardVersionTask = BLEHardVersionTestOp.init()
        let deviceNumTask = BLEDeviceNumTestOp.init()
        let gesensorTask = BLEGesensorTestOp.init()
        let motorTask = BLEMotorTestOp.init()
        let flashTask = BLEFlashTestOp.init()
        let heartRateTask = BLEHeartRateTestOp.init()
        let bleNameTask = BLENameTestOp.init()

        searchTask.failedBlock = failureBlock
        connectTask.failedBlock = failureBlock
        hidePairTask.failedBlock = failureBlock
        versionTask.failedBlock = failureBlock
        hardVersionTask.failedBlock = failureBlock
        deviceNumTask.failedBlock = failureBlock
        gesensorTask.failedBlock = failureBlock
        motorTask.failedBlock = failureBlock
        flashTask.failedBlock = failureBlock
        heartRateTask.failedBlock = failureBlock
        bleNameTask.failedBlock = failureBlock
        
        queue.addOperation(searchTask)
        queue.addOperation(connectTask)
        queue.addOperation(hidePairTask)
        queue.addOperation(versionTask)
        queue.addOperation(hardVersionTask)
        queue.addOperation(deviceNumTask)
        queue.addOperation(gesensorTask)
        queue.addOperation(motorTask)
        queue.addOperation(flashTask)
        queue.addOperation(heartRateTask)
        queue.addOperation(bleNameTask)

        
        
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
