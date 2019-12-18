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

public struct NetworkResponse<T: Mappable>: Mappable {

    var data: T?
    var datas: [T]?
    var resultCode: Int = 0
    var resultMsg: String = ""
    var errorMessage: String?

    public init?(map: Map) { }

    mutating public func mapping(map: Map) {

        if let context = map.context as? NestedMapContext {
            let key = context.key
            var dataKey = Configuration.Response.default.data
            if !key.isEmpty { dataKey = dataKey + "." + key }
            if context.mapArray {
                datas <- map[dataKey]
            } else {
                data <- map[dataKey]
            }
        }

        errorMessage <- map[Configuration.Response.default.errorMessage]
        resultCode <- map[Configuration.Response.default.resultCode]
        resultMsg <- map[Configuration.Response.default.resultMsg]
    }

}

public extension NetworkResponse {

    var isSuccess: Bool {
        return resultCode == Configuration.Response.default.successResultCode
    }

    var errorMsg: String {
        if let string = errorMessage, !string.isEmpty {
            return string
        } else {
            return Configuration.Response.default.defaultErrorMessage
        }
    }

}
