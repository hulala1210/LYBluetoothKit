//
//  BmobHelper.swift
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/1/13.
//  Copyright © 2020 ss. All rights reserved.
//

import UIKit

typealias QueryResultBlock = (Array<BmobFactoryOTAInfoModel>?, Error?) -> ()

class BmobFactoryOTAHelper: NSObject {
    
    static public func queryOTAConfig(secretCode:String, callback:QueryResultBlock?) {
        let query = BmobQuery.init(className: "FactoryOTAConfig")
        query?.whereKey("secretCode", equalTo: secretCode)
        query?.findObjectsInBackground({ (results, error) in
            
            DispatchQueue.main.async {
                if ((error) != nil) {
                    if callback != nil {
                        callback!(nil, error)
                    }
                }
                else if (results?.count == 0) {
                    if callback != nil {
                        callback!(nil, nil)
                    }
                }
                else {
                    if callback != nil {
                        var otaInfoModels = Array<BmobFactoryOTAInfoModel>()
                        
                        for obj:BmobObject in results as! Array<BmobObject> {
                            otaInfoModels.append(BmobFactoryOTAInfoModel(bmobObj: obj))
                        }
                        
                        callback!(otaInfoModels, nil)
                    }
                }
            }
            
        })
    }
    
    private func convertToOTAInfoModel(bmobObj:BmobObject) -> BmobFactoryOTAInfoModel {
        let otaInfoModel = BmobFactoryOTAInfoModel(bmobObj: bmobObj)
        return otaInfoModel
    }
    
}
