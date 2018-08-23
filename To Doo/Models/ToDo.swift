//
//  ToDo.swift
//  To Doo
//
//  Created by MacBook on 8/23/18.
//  Copyright © 2018 tps. All rights reserved.
//

import Foundation

class ToDo : Codable{
    //MARK: Props
    var title:String=""
    var done:Bool=false
    
    init(title:String,isDone:Bool) {
        self.title=title
        self.done=isDone
    }
}
