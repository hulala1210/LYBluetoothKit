//
//  ProtocolExcuteVC.swift
//  BLE-Swift
//
//  Created by SuJiang on 2019/1/26.
//  Copyright © 2019 ss. All rights reserved.
//

import UIKit

class ProtocolExcuteVC: BaseViewController {

    var proto: Protocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = proto.name
        // Do any additional setup after loading the view.
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
