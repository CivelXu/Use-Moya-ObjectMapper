//
//  NetworkResponse.swift
//  MoyaPractice
//
//  Created by Civel Xu on 2019/10/24.
//  Copyright © 2019 Civel Xu. All rights reserved.
//

import ObjectMapper

/*
{
  "data" :  Any,
  "result_code" : 600,
  "result_msg" : "success",
  "error_message" : null
}
*/

struct NetworkResponse: Mappable {

    var data: Any?
    var resultCode: Int = 0
    var resultMsg: String = ""
    var errorMessage: String?

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        data <- map[Configuration.default.data]
        errorMessage <- map[Configuration.default.errorMessage]
        resultCode <- map[Configuration.default.resultCode]
        resultMsg <- map[Configuration.default.resultMsg]
    }

}

extension NetworkResponse {

    var isSuccess: Bool {
        return resultCode == Configuration.default.successResultCode
    }

    var errorMsg: String {
        if let string = errorMessage, !string.isEmpty {
            return string
        } else {
            return Configuration.default.defaultErrorMessage
        }
    }

}
