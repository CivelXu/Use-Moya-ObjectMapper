//
//  OrgList.swift
//  MoyaPractice
//
//  Created by Civel Xu on 2019/10/24.
//  Copyright © 2019 Civel Xu. All rights reserved.
//

import ObjectMapper

struct OrgList: Mappable {

    var companyDomain: String?
    var companyType: Int?
    var createdAt: Int?
    var deleteAt: Int?
    var desc: String?
    var dtcpDna: String?
    var dtcpId: String?
    var dtcpParentDna: String?
    var headImgId: String?
    var id: Int?
    var name: String?
    var nodeAddress: String?
    var orgDna: String?
    var orgId: String?
    var publicType: Int?
    var signature: String?
    var status: Int?
    var updatedAt: Int?
    var version: Int?

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        companyDomain <- map["company_domain"]
        companyType <- map["company_type"]
        createdAt <- map["created_at"]
        deleteAt <- map["delete_at"]
        desc <- map["desc"]
        dtcpDna <- map["dtcp_dna"]
        dtcpId <- map["dtcp_id"]
        dtcpParentDna <- map["dtcp_parent_dna"]
        headImgId <- map["head_img_id"]
        id <- map["id"]
        name <- map["name"]
        nodeAddress <- map["node_address"]
        orgDna <- map["org_dna"]
        orgId <- map["org_id"]
        publicType <- map["public_type"]
        signature <- map["signature"]
        status <- map["status"]
        updatedAt <- map["updated_at"]
        version <- map["version"]
    }

}
