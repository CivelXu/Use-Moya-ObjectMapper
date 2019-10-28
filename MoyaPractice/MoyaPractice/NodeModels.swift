//
//  NodeModels.swift
//  MoyaPractice
//
//  Created by Civel Xu on 2019/10/24.
//  Copyright © 2019 Civel Xu. All rights reserved.
//

import ObjectMapper

struct NodeModels: Mappable {

    var datas: [NodeModel]?
    var total: Int = 0

    init?(map: Map) {  }

    mutating func mapping(map: Map) {
        datas <- map["datas"]
        total <- map["total"]
    }

}

struct TestNum: Mappable {

    var num: Int = 0

    init?(map: Map) {  }

    mutating func mapping(map: Map) {
        num <- map["article_num"]
    }

}
