//
//  FactoryTestSecretCodeVC.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/2/18.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class FactoryTestSecretCodeVC: BaseViewController {
    
    @IBOutlet weak var secretCodeTextField: UITextField!
    
    var testGroupList:Array<FactoryTestGroup> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "选择测试套装"
        self.setNavRightButton(text: "手动校验", sel: #selector(navRightButtonAction))
        secretCodeTextField.text = "SlimTest"
    }

    @objc func navRightButtonAction() {
        queryTestInfo()
    }
    
    @IBAction func secretCodeTextChanged(_ sender: UITextField) {
        if secretCodeTextField.text?.count == 6 {
            queryTestInfo()
        }
    }
    
    private func queryTestInfo() {
        
        if secretCodeTextField.text == nil || (secretCodeTextField.text!.count) == 0 {
            return
        }
        
        self.startLoading(nil)
        
        BmobFactoryTestHelper.queryTestConfig(secretCode: secretCodeTextField.text!) { (config, error) in
            self.stopLoading()
            if error != nil {
                self.showError(error?.localizedDescription)
            }
            else {
                if config == nil {
                    self.alert(msg: "没有找到测试任务。",confirmText:"知道了", confirmSel: nil, cancelText: nil, cancelSel: nil)
                }
                else {
                    BmobFactoryTestHelper.queryTestGroups(groupSerial: config!.testGroupsSerial) { (testGroups, groupError) in
                        if groupError != nil || testGroups?.count == 0 {
                            self.showError(groupError?.localizedDescription)
                        }
                        else {
                            let vc = FactoryTestCaseListVC()
                            vc.testCaseSuit = testGroups!
                            vc.testConfig = config
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
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
