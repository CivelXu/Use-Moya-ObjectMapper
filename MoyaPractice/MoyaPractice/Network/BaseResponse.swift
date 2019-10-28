//
//  BaseResponse.swift
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

struct BaseResponse: Mappable {

    var data: Any?
    var resultCode: Int = 0
    var resultMsg: String = ""
    var errorMessage: String?

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        data <- map["data"]
        errorMessage <- map["error_message"]
        resultCode <- map["result_code"]
        resultMsg <- map["result_msg"]
    }

}

extension  BaseResponse {

    var isSuccess: Bool {
        return resultCode == NetworkSuccessCode
    }

    var errorMsg: String {
        if let string = errorMessage, !string.isEmpty {
            return string
        } else {
            return NetworkEmptyError
        }
    }

}
