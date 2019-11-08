//
//  UserModel.swift
//  MoyaPractice
//
//  Created by Civel Xu on 2019/10/24.
//  Copyright © 2019 Civel Xu. All rights reserved.
//

import ObjectMapper

struct UserModel: Mappable {

    var email: String?
    var inType: Int?
    var orgList: [OrgList]?
    var outUid: String?
    var sessionKey: String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        email <- map["email"]
        inType <- map["in_type"]
        orgList <- map["org_list"]
        outUid <- map["out_uid"]
        sessionKey <- map["session_key"]

    }
}
