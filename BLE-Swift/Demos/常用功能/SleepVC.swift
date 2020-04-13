//
//  SleepVC.swift
//  BLE-Swift
//
//  Created by SuJiang on 2019/3/22.
//  Copyright © 2019 ss. All rights reserved.
//

import UIKit

class SleepVC: BaseViewController {

    @IBOutlet weak var summaryLbl: UILabel!
    
    @IBOutlet weak var numLbl: UILabel!
    
    var num: UInt16 = 0
    var sleeps: Array<Sleep>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showConnectState()
        // Do any additional setup after loading the view.
    }

    @IBAction func numBtnClick(_ sender: Any) {
        self.summaryLbl.text = ""
        self.sleeps = nil
        
        startLoading(nil)
        weak var weakSelf = self
        _ = BLECenter.shared.getSportSleepDataNum(callback: { (sportNum, sleepNum, err) in
            weakSelf?.stopLoading()
            
            if let error = err {
                weakSelf?.handleBleError(error: error)
                return
            }
            
            weakSelf?.num = sleepNum
            
            weakSelf?.numLbl.text = "\(sleepNum)个"
        })
    }
    
    @IBAction func detailbtnClick(_ sender: Any) {
        if num == 0 {
            self.showError("个数为0，不能获取详情")
            return
        }
        
        startLoading(nil)
        weak var weakSelf = self
        _ = BLECenter.shared.getSleepDetail(num: num, callback: { (sleeps, error) in
            
        })
    }
    
    
    @IBAction func seeDetailBtnClick(_ sender: Any) {
    }
    
    @IBAction func delBtnClick(_ sender: Any) {
    }
    
}
