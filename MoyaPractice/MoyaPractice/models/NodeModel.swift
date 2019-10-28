//
//  NodeModel.swift
//  MoyaPractice
//
//  Created by Civel Xu on 2019/10/24.
//  Copyright © 2019 Civel Xu. All rights reserved.
//

import ObjectMapper

struct NodeModel: Mappable {

    var miksAbstract: String?
    var miksAvatar: String?
    var miksCreatedAt: Int?
    var miksDomain: String?
    var miksIp: String?
    var miksName: String?
    var miksUpdatedAt: Int?
    var nodeAddress: String?
    var update: Int?
    init?(map: Map) { }

    mutating func mapping(map: Map) {
        miksAbstract <- map["miks_abstract"]
        miksAvatar <- map["miks_avatar"]
        miksCreatedAt <- map["miks_created_at"]
        miksDomain <- map["miks_domain"]
        miksIp <- map["miks_ip"]
        miksName <- map["miks_name"]
        miksUpdatedAt <- map["miks_updated_at"]
        nodeAddress <- map["node_address"]
        update <- map["update"]
    }

}
