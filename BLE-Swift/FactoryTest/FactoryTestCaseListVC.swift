//
//  FactoryTestCaseListVC.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/2/18.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class FactoryTestCaseListVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let factoryTestCaseCellIdentifier:String = "FactoryTestCaseCellMark"
    
    @IBOutlet weak var tableView: UITableView!

    var testCaseSuit:Array<FactoryTestCase> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: factoryTestCaseCellIdentifier)
        self.tableView.tableFooterView = UIView.init()
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
        cell.textLabel?.text = String(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let testCase = testCaseSuit[indexPath.row]
        
        switch testCase.type {
        case FinishedProductTestCaseType.normal: break
            
        default: break
            
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
