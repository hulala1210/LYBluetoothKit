//
//  FactoryTestCaseListVC.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/2/18.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit
import PopupDialog

class FactoryTestCaseListVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let factoryTestCaseCellIdentifier:String = "FactoryTestCaseCellMark"
    
    var testCaseSuit:Array<FactoryTestGroup> = []
    
    var testConfig:FactoryTestConfig? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: factoryTestCaseCellIdentifier)
        self.tableView.tableFooterView = UIView.init()
        
        self.setNavRightButton(text: "Setting", sel: #selector(settingButtonAction))

    }

    @objc private func settingButtonAction() {

        let settingVC = FactoryTestSettingVC(nibName: "FactoryTestSettingVC", bundle: nil)

        let popup = PopupDialog(viewController: settingVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceUp,
                                preferredWidth: 340,
                                tapGestureDismissal: false,
                                panGestureDismissal: true,
                                hideStatusBar: true) {
        }
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
//            self.label.text = "You canceled the rating dialog"
        }

        // Create second button
        let buttonTwo = DefaultButton(title: "SAVE", height: 60) {
//            self.label.text = "You rated \(ratingVC.cosmosStarRating.rating) stars"
            settingVC.saveVersionStandard()
        }

        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])

        // Present dialog
        present(popup, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testCaseSuit.count;
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: factoryTestCaseCellIdentifier, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let testGroup = testCaseSuit[indexPath.row]

        cell.textLabel?.text = String(indexPath.row + 1) + " " + testGroup.groupName!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let testGroup = testCaseSuit[indexPath.row]
        
        if testGroup.serialNumber == 3 {
            let vc = FactoryCollateVC.init()
            vc.testConfig = self.testConfig
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        self.startLoading(nil)
        
        BmobFactoryTestHelper.queryTestCases(casesSerial: testGroup.testCasesSerial) { (testCases, error) in
            self.stopLoading()
            if error != nil {
                self.showError(error?.localizedDescription)
            }
            else {
                
                if testCases != nil {
                    let vc = FactoryTestBaseVC.init()
                    vc.testCases = testCases!
                    vc.testConfig = self.testConfig
                    self.navigationController?.pushViewController(vc, animated: true)
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
