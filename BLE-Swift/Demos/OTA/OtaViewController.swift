//
//  OtaViewController.swift
//  BLE-Swift
//
//  Created by SuJiang on 2019/1/2.
//  Copyright © 2019 ss. All rights reserved.
//

import UIKit

class OtaViewController: ConnectBaseVC, OtaTaskTipViewDelegate {

    @IBOutlet weak var otaTipView: OtaTaskTipView!
    
    var showDetailBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        otaTipView.delegate = self
        
        let btn = UIButton(type: .custom)
        btn.backgroundColor = rgb(200, 30, 30)
        btn.setTitle(TR(""), for: .normal)
        btn.titleLabel?.font = font(14)
        btn.addTarget(self, action: #selector(showOtaListBtnClick), for: .touchUpInside)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.layer.cornerRadius = btn.bounds.height / 2
        showDetailBtn = btn
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(otaTaskAddNotification(notification:)), name: kOtaManagerAddTaskNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(otaTaskRemoveNotification(notification:)), name: kOtaManagerRemoveTaskNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(otaTasksRemoveAllNotification(notification:)), name: kOtaManagerRemoveAllTasksNotification, object: nil)
        
        updateUI()
    }

    func didClickShowDetailBtn() {
        let vc = OtaTaskDetailVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - 事件处理
    @IBAction func autoOtaBtnClick () {
        
    }

    @IBAction func sdBtnClick() {
        let vc = OtaConfigVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showOtaListBtnClick() {
        didClickShowDetailBtn()
    }
    
    func updateUI() {
        showDetailBtn.setTitle("\(OtaManager.shared.taskList.count)", for: .normal)
    }
    
    @objc func otaTaskAddNotification(notification: Notification) {
        updateUI()
    }
    
    @objc func otaTaskRemoveNotification(notification: Notification) {
        updateUI()
    }
    
    @objc func otaTasksRemoveAllNotification(notification: Notification) {
        updateUI()
    }
}
