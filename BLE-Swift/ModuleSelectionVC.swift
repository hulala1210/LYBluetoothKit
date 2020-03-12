//
//  ModuleSelectionVC.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/1/7.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class ModuleSelectionVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Bmob.register(withAppKey: "5cde76787542587a7ce90b2b54ef1f97")
    }
    
    @IBAction func autoTestToolButtonAction(_ sender: Any) {
        let vc = FactoryTestSecretCodeVC()
        let nav = LYNavigationController.init(rootViewController: vc)
        
        let window:UIWindow = (UIApplication.shared.delegate?.window ?? nil)!
        window.rootViewController = nav
    }
    
    @IBAction func factoryTestButtonAction(_ sender: UIButton) {
        let vc = SecretCodeVC()
        let nav = LYNavigationController.init(rootViewController: vc)
        
        let window:UIWindow = (UIApplication.shared.delegate?.window ?? nil)!
        window.rootViewController = nav
    }
    
    @IBAction func bleToolButtonAction(_ sender: UIButton) {
        SlideMenuOptions.leftViewWidth = UIScreen.main.bounds.width - 80;
        SlideMenuOptions.panGesturesEnabled = false
        
        let homeVC = HomeViewController()
        
        let slideVC = SlideMenuController(mainViewController: homeVC, leftMenuViewController: LeftViewController())

        let window:UIWindow = (UIApplication.shared.delegate?.window ?? nil)!
        window.rootViewController = slideVC

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
