//
//  Column.swift
//  Laosiji
//
//  Created by Luo Sheng on 16/6/4.
//  Copyright © 2016年 Luo Sheng. All rights reserved.
//

import Foundation
import ObjectMapper

class Tag: Mappable {
    var id: String?
    var shortName: String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["tag_id"]
        shortName <- map["short_name"]
    }
}