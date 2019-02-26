//
//  KFKeyChain.swift
//  SmallSheep
//
//  Created by kfzs on 2018/10/11.
//  Copyright © 2018年 KFZS. All rights reserved.
//

import UIKit

class KFKeyChain: NSObject {
    static let share:KFKeyChain = KFKeyChain()
    
    private override init() {
        super.init()
        self.saveUUID()
    }
    let uuidKey:String = "com.kuaifazs.smallSheep"
    let uuidAccount:String = "kuaifazhushouAccount"
    private func saveUUID()
    {
        let uuidTag:String? = SSKeychain.password(forService: uuidKey, account: uuidAccount)
        guard (uuidTag?.count == 0 || uuidTag == nil) else {return}
        let uuid:String = NSUUID().uuidString
        SSKeychain.setPassword(uuid, forService: uuidKey, account: uuidAccount)
    }
    func getUUIDOnly() -> String {//获取uuid
        return SSKeychain.password(forService: uuidKey, account: uuidAccount)
    }
}
