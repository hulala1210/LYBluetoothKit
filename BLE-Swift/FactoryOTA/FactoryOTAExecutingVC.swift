//
//  FactoryOTAExecutingVC.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/1/14.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class FactoryOTAExecutingVC: BaseViewController {

    public var firmwaresPath:String?
    public var otaConfig:BmobFactoryOTAInfoModel?

    @IBOutlet weak var logTextView: UITextView!
    
    var successDevices:Set<BLEDevice>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "正在升级"
        self.setNavLeftButton(text: "退出升级", sel: #selector(leftButtonItemAction))
        
        let otaExecuter = FactoryOTAExecuter()
        otaExecuter.firmwaresPath = self.firmwaresPath
        otaExecuter.otaConfig = self.otaConfig
    }

    @objc private func leftButtonItemAction() -> Void {
        alert(msg: "你确定要停止升级吗？", confirmText: "停止升级", confirmSel: #selector(stopOTAAction), cancelText: "继续升级", cancelSel: nil )
    }

    @objc private func stopOTAAction() {
        self.navigationController?.popViewController(animated: true)
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
