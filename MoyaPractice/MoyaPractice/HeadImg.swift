//
//  HeadImg.swift
//  MoyaPractice
//
//  Created by Civel Xu on 2019/10/24.
//  Copyright © 2019 Civel Xu. All rights reserved.
//

import ObjectMapper

struct HeadImg: Mappable {

    var category: String?
    var ext: String?
    var height: Int?
    var imageDesc: String?
    var imageId: String?
    var size: Int?
    var storageUrl: String?
    var title: String?
    var width: Int?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        category <- map["category"]
        ext <- map["ext"]
        height <- map["height"]
        imageDesc <- map["image_desc"]
        imageId <- map["image_id"]
        size <- map["size"]
        storageUrl <- map["storage_url"]
        title <- map["title"]
        width <- map["width"]
    }
}
