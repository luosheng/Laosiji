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
    var id: Int?
    var shortName: String?
    var name: String?
    var picName: String?
    var iconName: String?
    var picURL: NSURL?
    var iconURL: NSURL?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- (map["tag_id"], TransformOf<Int, String>(fromJSON: { Int($0!) }, toJSON: { $0.map { String($0) } }))
        shortName <- map["short_name"]
        name <- map["tag_name"]
        picName <- map["pic_name"]
        iconName <- map["icon_name"]
        picURL <- (map["pic_url"], URLTransform())
        iconURL <- (map["icon_url"], URLTransform())
    }
}