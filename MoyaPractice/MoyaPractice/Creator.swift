//
//  Creator.swift
//  MoyaPractice
//
//  Created by Civel Xu on 2019/10/24.
//  Copyright © 2019 Civel Xu. All rights reserved.
//

import ObjectMapper

struct Creator: Mappable {
    var `_` : Int?
    var activatedMedal: String?
    var backImg: AnyObject?
    var createdAt: Int?
    var domain: String?
    var email: String?
    var headImg: AnyObject?
    var highlight: AnyObject?
    var inType: Int?
    var isActive: Int?
    var isCreator: Int?
    var isManage: Int?
    var joinStatus: Int?
    var name: String?
    var outUid: String?
    var updatedAt: Int?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        `_` <- map["_"]
        activatedMedal <- map["activated_medal"]
        backImg <- map["back_img"]
        createdAt <- map["created_at"]
        domain <- map["domain"]
        email <- map["email"]
        headImg <- map["head_img"]
        highlight <- map["highlight"]
        inType <- map["in_type"]
        isActive <- map["is_active"]
        isCreator <- map["is_creator"]
        isManage <- map["is_manage"]
        joinStatus <- map["join_status"]
        name <- map["name"]
        outUid <- map["out_uid"]
        updatedAt <- map["updated_at"]
    }

}
