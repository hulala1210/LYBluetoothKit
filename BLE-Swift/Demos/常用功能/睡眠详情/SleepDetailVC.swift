//
//  SleepDetailVC.swift
//  
//
//  Created by Kevin Chen on 2020/4/15.
//

import UIKit

class SleepDetailVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    public var sleeps: Array<Sleep>!
    private let sleepDetailCellIdentifier = "sleepDetailCellIdentifier"
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib.init(nibName: "SleepDetailTCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: sleepDetailCellIdentifier)
        self.tableView.estimatedRowHeight = 100;

    }

    // MARK: -UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sleeps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sleepCell:SleepDetailTCell = tableView.dequeueReusableCell(withIdentifier: sleepDetailCellIdentifier, for: indexPath) as! SleepDetailTCell
        
        let s:Sleep = sleeps[indexPath.row]
        
//        var str = ""
//
//        do {
//            let propertyInfo = try s.allProperties().description
//
//            str = str + propertyInfo
//            str = str + "\n"
//
//        } catch let error {
//            print(error)
//        }
        
        sleepCell.contentLabel.text = displaySleepDetail(sleep: s)
        
        return sleepCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func displaySleepDetail(sleep:Sleep!)  -> String {
        var display = "index:\(sleep.index)\ntime:\(Date.init(timeIntervalSince1970: TimeInterval(sleep.time)))\n"
        
        switch sleep.type {
        case .deep:
            display = display + "type:深睡"
        case .shallow:
            display = display + "type:浅睡"
        case .wake:
            display = display + "type:清醒"
        case .prepare:
            display = display + "type:准备"
        case .enter:
            display = display + "type:进入"
        case .exit:
            display = display + "type:退出"
        
        return display
        }
        
        return display
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
