//
//  Utils.swift
//  Decred Wallet
//
//  Created by Philipp Maluta on 19.04.18.
//  Copyright © 2018 Macsleven. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let NeedAuth =   Notification.Name("NeedAuthorize")
    static let NeedLogout = Notification.Name("NeedDeauthorize")
}

func isWalletCreated() -> Bool{
        let fm = FileManager()
        do{
            let result = try fm.contentsOfDirectory(atPath: NSHomeDirectory()+"/Documents").count > 0
            return result
        }catch{
            return false
    }
}
