//
//  Payment.swift
//  RealmTest
//
//  Created by Erim on 5.03.2020.
//  Copyright © 2020 Erim. All rights reserved.
//

import Foundation
import RealmSwift

class Payment : Object {
    
    @objc dynamic var payerName : String = ""
    @objc dynamic var payDescription : String = ""
    @objc dynamic var price : Int = -1
    var activity = LinkingObjects(fromType: Activity.self, property: "payments")
}
