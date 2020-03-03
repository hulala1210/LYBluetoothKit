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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "选择测试套装"
        self.setNavRightButton(text: "手动校验", sel: #selector(navRightButtonAction))
        secretCodeTextField.text = "123456"
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
        let vc = FactoryTestCaseListVC()
        
        for _ in 0...6 {
            
            let testCase = FactoryTestCase.init()
            vc.testCaseSuit.append(testCase)
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
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
