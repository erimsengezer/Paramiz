//
//  Person.swift
//  RealmTest
//
//  Created by Erim on 5.03.2020.
//  Copyright © 2020 Erim. All rights reserved.
//

import Foundation
import RealmSwift

class Person : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var surname : String = ""
    @objc dynamic var age : Int = 1
}
