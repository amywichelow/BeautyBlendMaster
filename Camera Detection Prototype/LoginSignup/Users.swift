//
//  Users.swift
//  Camera Detection Prototype
//
//  Created by Amy Wichelow on 30/04/2018.
//  Copyright © 2018 Amy Wichelow. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Users {
    
    var uuid: String?
    let username: String?
    
    init?(snapshot: DataSnapshot) {
        if let snapshotData = snapshot.value as? [String: Any] {
            uuid = snapshot.key
            username = snapshotData["username"] as? String
        } else {
            return nil
        }
    }
}

