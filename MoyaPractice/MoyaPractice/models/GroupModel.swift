//
//  GroupModel.swift
//  MoyaPractice
//
//  Created by Civel Xu on 2019/10/24.
//  Copyright © 2019 Civel Xu. All rights reserved.
//

import ObjectMapper

struct GroupModel: Mappable {

   var activeTime: Int?
    var article: AnyObject?
    var articleCount: Int?
    var backImg: AnyObject?
    var companyDomain: String?
    var companyType: Int?
    var createdAt: Int?
    var creator: Creator?
    var groupDesc: String?
    var groupId: String?
    var groupType: Int?
    var headImg: HeadImg?
    var highlight: AnyObject?
    var inviter: AnyObject?
    var isAvailable: Int?
    var isCreator: Int?
    var isSubscribe: Int?
    var joinArticleType: Int?
    var joinStatus: Int?
    var joinUserType: Int?
    var memberCount: Int?
    var members: AnyObject?
    var name: String?
    var nodeAddress: String?
    var nodeStatus: Int?
    var orgId: String?
    var publicType: Int?
    var status: Int?
    var subscribe: Int?
    var unRead: Int?
    var updatedAt: Int?

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        activeTime <- map["active_time"]
        article <- map["article"]
        articleCount <- map["article_count"]
        backImg <- map["back_img"]
        companyDomain <- map["company_domain"]
        companyType <- map["company_type"]
        createdAt <- map["created_at"]
        creator <- map["creator"]
        groupDesc <- map["group_desc"]
        groupId <- map["group_id"]
        groupType <- map["group_type"]
        headImg <- map["head_img"]
        highlight <- map["highlight"]
        inviter <- map["inviter"]
        isAvailable <- map["is_available"]
        isCreator <- map["is_creator"]
        isSubscribe <- map["is_subscribe"]
        joinArticleType <- map["join_article_type"]
        joinStatus <- map["join_status"]
        joinUserType <- map["join_user_type"]
        memberCount <- map["member_count"]
        members <- map["members"]
        name <- map["name"]
        nodeAddress <- map["node_address"]
        nodeStatus <- map["node_status"]
        orgId <- map["org_id"]
        publicType <- map["public_type"]
        status <- map["status"]
        subscribe <- map["subscribe"]
        unRead <- map["un_read"]
        updatedAt <- map["updated_at"]

    }

}
