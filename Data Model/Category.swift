//
//  Category.swift
//  Todoey
//
//  Created by Raj  on 28/06/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category:Object{
    @objc dynamic var name:String = ""
    @objc dynamic var color:String = ""
    let items = List<Item>()
}
