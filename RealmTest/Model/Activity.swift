//
//  Activity.swift
//  RealmTest
//
//  Created by Erim on 5.03.2020.
//  Copyright © 2020 Erim. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Activity : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var isFinish : Bool = false
    let payments = List<Payment>()
} 
