//
//  Todo.swift
//  iosTodoApp
//
//  Created by Rafael Rodrigues Ghossi on 4/4/17.
//  Copyright © 2017 Rafael Rodrigues Ghossi. All rights reserved.
//

import Foundation
import RealmSwift

class Todo: Object {
    dynamic var title = ""
    dynamic var dueDate = Date()
    dynamic var priority = 50
}
