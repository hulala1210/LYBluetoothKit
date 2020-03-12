//
//  FactoryTestSettingVC.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/3/10.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

let FactoryFirmwareVersionCodeCacheKey:String = "FactoryFirmwareVersionCodeCacheKey"
let FactoryBuildVersionCodeCacheKey:String = "FactoryBuildVersionCodeCacheKey"
let FactoryHardwareVersionCodeCacheKey:String = "FactoryHardwareVersionCodeCacheKey"

class FactoryTestSettingVC: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var firmwareVersionPick: UIPickerView!
    @IBOutlet weak var buildPick: UIPickerView!
    @IBOutlet weak var hardwareVersionPick: UIPickerView!
    
    var firmwareVersion:Double? = nil
    var buildVersion:Int? = nil
    var hardwareVersion:Double? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        firmwareVersion = UserDefaults.standard.double(forKey: FactoryFirmwareVersionCodeCacheKey)
        buildVersion = UserDefaults.standard.integer(forKey: FactoryBuildVersionCodeCacheKey)
        hardwareVersion = UserDefaults.standard.double(forKey: FactoryHardwareVersionCodeCacheKey)

        if firmwareVersion == nil || firmwareVersion == 0 {
            firmwareVersion = 1.0
            UserDefaults.standard.set(firmwareVersion, forKey: FactoryFirmwareVersionCodeCacheKey)
        }
        
        if buildVersion == nil || buildVersion == 0 {
            buildVersion = 1
            UserDefaults.standard.set(buildVersion, forKey: FactoryBuildVersionCodeCacheKey)
        }
        
        if hardwareVersion == nil || hardwareVersion == 0 {
            hardwareVersion = 1.0
            UserDefaults.standard.set(hardwareVersion, forKey: FactoryHardwareVersionCodeCacheKey)
        }
        
        firmwareVersionPick.selectRow(Int(firmwareVersion!), inComponent: 0, animated: true)
        firmwareVersionPick.selectRow(Int(firmwareVersion! * 10) % 10, inComponent: 1, animated: true)

        buildPick.selectRow(Int(buildVersion!), inComponent: 0, animated: true)
        
        hardwareVersionPick.selectRow(Int(hardwareVersion!), inComponent: 0, animated: true)
        hardwareVersionPick.selectRow(Int(hardwareVersion! * 10) % 10, inComponent: 1, animated: true)

    }

    public func saveVersionStandard() {
        UserDefaults.standard.set(firmwareVersion, forKey: FactoryFirmwareVersionCodeCacheKey)
        UserDefaults.standard.set(buildVersion, forKey: FactoryBuildVersionCodeCacheKey)
        UserDefaults.standard.set(hardwareVersion, forKey: FactoryHardwareVersionCodeCacheKey)

    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == firmwareVersionPick || pickerView == hardwareVersionPick {
            return 2
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == buildPick {
            return 99
        }
        return 10
    }
    
    // MARK: - UIPickerViewDelegate
    // returns width of column and height of row for each component.
//    @available(iOS 2.0, *)
//    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat

    @available(iOS 2.0, *)
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }

    
    // these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
    // for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
    // If you return back a different object, the old one will be released. the view will be centered in the row rect
    @available(iOS 2.0, *)
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 1 {
            return "." + String(row)
        }
        
        return String(row)
    }

//    @available(iOS 6.0, *)
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//
//    } // attributed title is favored if both methods are implemented

//    @available(iOS 2.0, *)
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView

    
    @available(iOS 2.0, *)
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == firmwareVersionPick {
            let value:Int = pickerView.selectedRow(inComponent: 0) * 10 + pickerView.selectedRow(inComponent: 1)
            let doubleValue = Double(value) / 10
            firmwareVersion = doubleValue
        }
        else if pickerView == buildPick {
            let value:Int = pickerView.selectedRow(inComponent: 0)
            buildVersion = value
        }
        else if pickerView == hardwareVersionPick {
            let value:Int = pickerView.selectedRow(inComponent: 0) * 10 + pickerView.selectedRow(inComponent: 1)
            let doubleValue = Double(value) / 10
            hardwareVersion = doubleValue
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
