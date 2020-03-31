//
//  FactoryCollateVC.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/3/13.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

class FactoryCollateVC: FactoryTestBaseVC {

    @IBOutlet weak var segment: UISegmentedControl!
    
    var pointerType:LYBCClockPointer = .pointerHour
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        switch pointerType {
        case .pointerHour:
            segment.selectedSegmentIndex = 0
        case .pointerMin:
            segment.selectedSegmentIndex = 1
        case .pointerSecond:
            break
        }
    }
    
    override func showResultAlert(device:BLEDevice) {
        
    }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        pointerType = LYBCClockPointer(rawValue: UInt8(sender.selectedSegmentIndex))!
    }
    
    @IBAction func antiClockwiseButtonClick(_ sender: UIButton) {
        
        
        let _ = BLECenter.shared.pointerRotation(pointer: pointerType, direction: .antiClockwise, angle: 1, callback: { (success, error) in
            
            if success {
                self.queue.message = self.queue.message + "\n命令发送成功"
            }
            else {
                self.queue.message = self.queue.message + "\n命令发送失败"
            }
            
        }, toDeviceName: queue.device!.name)
    }
    
    @IBAction func clockwiseButtonClick(_ sender: Any) {
        let _ = BLECenter.shared.pointerRotation(pointer: pointerType, direction: .clockwise, angle: 1, callback: { (success, error) in
            if success {
                self.queue.message = self.queue.message + "\n命令发送成功"
            }
            else {
                self.queue.message = self.queue.message + "\n命令发送失败"
            }
            
        }, toDeviceName: queue.device!.name)
    }
    
    @IBAction func antiClockwiseButtonTouchIn(_ sender: UIButton) {
        let _ = BLECenter.shared.sendClockEvent(pointer: pointerType, direction: .antiClockwise, event: .move, callback: { (success, error) in
            if success {
                self.queue.message = self.queue.message + "\n命令发送成功"
            }
            else {
                self.queue.message = self.queue.message + "\n命令发送失败"
            }
        }, toDeviceName: queue.device!.name)
    }
    
    @IBAction func antiClockwiseButtonTouchOut(_ sender: UIButton) {
        let _ = BLECenter.shared.sendClockEvent(pointer: pointerType, direction: .antiClockwise, event: .stop, callback: { (success, error) in
            if success {
                self.queue.message = self.queue.message + "\n命令发送成功"
            }
            else {
                self.queue.message = self.queue.message + "\n命令发送失败"
            }
        }, toDeviceName: queue.device!.name)
    }
    
    @IBAction func clockwiseButtonTouchIn(_ sender: UIButton) {
         let _ = BLECenter.shared.sendClockEvent(pointer: pointerType, direction: .clockwise, event: .move, callback: { (success, error) in
           if success {
               self.queue.message = self.queue.message + "\n命令发送成功"
           }
           else {
               self.queue.message = self.queue.message + "\n命令发送失败"
           }
       }, toDeviceName: queue.device!.name)
    }
    
    @IBAction func clockwiseButtonTouchOut(_ sender: UIButton) {
        let _ = BLECenter.shared.sendClockEvent(pointer: pointerType, direction: .clockwise, event: .stop, callback: { (success, error) in
            if success {
                self.queue.message = self.queue.message + "\n命令发送成功"
            }
            else {
                self.queue.message = self.queue.message + "\n命令发送失败"
            }
        }, toDeviceName: queue.device!.name)
    }
    
    @IBAction func clockwiseRotateAction(_ sender: Any) {
        let _ = BLECenter.shared.pointerRotation(pointer: pointerType, direction: .clockwise, angle: 360, callback: { (success, error) in
            if success {
                self.queue.message = self.queue.message + "\n命令发送成功"
            }
            else {
                self.queue.message = self.queue.message + "\n命令发送失败"
            }
            
        }, toDeviceName: queue.device!.name)
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
